import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owner_app/constants/url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChattingScreen extends StatefulWidget {
  final String receiverId; // Add receiverId as a parameter

  ChattingScreen({required this.receiverId});

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController _controller = TextEditingController();
  late IO.Socket socket;
  List<String> messages = [];
  String? userId; // Variable to store the user's ID
  String? roomId; // Variable to store the room ID
  final String baseUrl =
      AppConstants.APIURL; // Use AppConstants for the base URL

  @override
  void initState() {
    super.initState();
    initializeSocket();
    getUserInfo();
  }

  // Function to initialize Socket.IO connection
  void initializeSocket() {
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    // Listen for incoming messages
    socket.on('private message', (data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  // Function to retrieve user information from storage
  Future<void> getUserInfo() async {
    final storage = FlutterSecureStorage();
    final String? userData = await storage.read(key: 'user');

    if (userData != null) {
      final user = jsonDecode(userData);
      userId = user['_id'];
    }

    // Join chat room after getting user ID
    if (userId != null && widget.receiverId != null) {
      socket.emit(
          'join room', {'senderId': userId, 'receiverId': widget.receiverId});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatting'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: messages[index].startsWith('You: ')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: messages[index].startsWith('You: ')
                            ? Colors.blue
                            : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        messages[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Send message when the send button is pressed
                    if (_controller.text.isNotEmpty && userId != null) {
                      socket.emit('private message', {
                        'text': 'You: ${_controller.text}',
                        'senderId': userId,
                        'receiverId': widget.receiverId,
                        'roomId': roomId,
                      });
                      setState(() {
                        messages.add('You: ${_controller.text}');
                      });
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
