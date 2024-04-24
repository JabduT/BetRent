import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController _controller = TextEditingController();
  late IO.Socket socket; // Use 'late' keyword to indicate initialization later
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    // Connect to the server
    socket = IO.io('YOUR_BACKEND_URL', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    // Listen for incoming messages
    socket.on('chat message', (data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your build method code...
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
