import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late IO.Socket socket;
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get messagesStream => _streamController.stream;
  TextEditingController controller = TextEditingController();

  //This will give platofrm specific url for ios and android emulator
  String socketUrl() {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    } else {
      return "http://localhost:3000";
    }
  }

  @override
  void initState() {
    super.initState();
    print('init state triggered');
    // Connect to the Socket.IO server
    socket = IO.io(socketUrl(), <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('connect_error', (data) {
      print('Connection error: $data');
    });
    socket.on('disconnect', (_) => print('Disconnected'));
  }

  @override
  void dispose() {
    // Disconnect from the Socket.IO server when the app is disposed
    socket.disconnect();

    //close stream
    _streamController.close();
    super.dispose();
  }

  void sendMessage(String message) {
    // Send a message to the server
    socket.emit('sendMessage', message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket.IO Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                onChanged: (value) {
                  if (socket.connected) {
                    sendMessage(value);
                  }
                },
                controller: controller,
                decoration: const InputDecoration(hintText: "Enter Message"),
              ),
            ),
            const SizedBox(height: 40),
            StreamBuilder<String>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    title: Text("Received Message: ${snapshot.data ?? ""}"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
