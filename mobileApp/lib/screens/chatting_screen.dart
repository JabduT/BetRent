import 'package:flutter/material.dart';
import 'package:owner_app/constants/url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChattingScreen extends StatefulWidget {
  final String recipientUserId;

  ChattingScreen({required this.recipientUserId});

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
 late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();

    // Connect to the server
    socket = IO.io(AppConstants.BASEURL, <String, dynamic>{
      'transports': ['websocket'],
    });

    // Listen for messages from the server
    socket.on('message', (data) {
      setState(() {
        messages.add({'sender': 'Server', 'message': data});
      });
    });
  }

  @override
  void dispose() {
    // Close the socket when the screen is disposed
    socket.dispose();
    super.dispose();
  }

  void sendMessage(String message) {
    // Send message to the server
    socket.emit('message', {'recipientUserId': '6628dbaa509f3d7b0e0e4cad', 'message': message});
    // Add the user's own message to the UI
    setState(() {
      messages.add({'sender': 'You', 'message': message});
    });
    // Clear the input field after sending the message
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with User 6628dbaa509f3d7b0e0e4cad'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['message']!),
                  subtitle: Text(message['sender']!),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = messageController.text;
                    if (message.isNotEmpty) {
                      sendMessage(message);
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
}
