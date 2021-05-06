import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';

class SocketService {
  final locationService = new Location();

  Future<String> getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    return userData['_id'];
  }

  Future<Socket> createSocketConnection() async {
    var userId = await getCurrentUserId();
    Socket socket;
    if (userId != null) {
      socket = io('https://c82da11f199e.ngrok.io', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'extraHeaders': {
          'user': jsonEncode({
            'id': '$userId',
          })
        }
      });
      socket.connect();
    }
    return socket;
  }

  Future connectToSocket() async {
    Socket socket = await createSocketConnection();
    socket.on('connect', (_) => {print('connected')});
    socket.on('disconnect', (_) => {print('disconnected')});
  }
}
