import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';

class SocketProvider extends ChangeNotifier {
  Socket _socket;

  get socket => _socket;

  set socket(value) {
    return socket = value;
  }

  Future<String> getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    return userData['_id'];
  }

  Future<Socket> createSocketConnection() async {
    var userId = await getCurrentUserId();
    Socket client;
    if (userId != null) {
      client = io('http://192.168.43.77:3001',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders({'userId': userId})
              .build()
      );
      client.connect();
    }
    return client;
  }

  Future connectToSocket() async {
    Socket client = await createSocketConnection();
    socket = client;
    client.on('connect', (_) => {print('connected')});
    client.on('disconnect', (_) => {print('disconnected')});
  }
}
