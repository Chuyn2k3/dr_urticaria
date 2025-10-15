import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../core/services/firebase_service/remote_config_service.dart';

class ChatSocket {
  IO.Socket? socket;

  Future<void> initSocket() async {
    final url = await FireBaseRemoteConfigService.getSavedUrl();
    socket = IO.io(
      '${url ?? 'https://hospital.huyit.lat'}/live', // namespace
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io') // path mặc định
          .enableForceNewConnection()
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setTimeout(30000)
          .build(),
    );

    _registerEvents();
    socket?.connect();
  }

  void _registerEvents() {
    socket?.onConnect((_) {
      print("✅ Connected to namespace /live: ${socket?.id}");
      socket?.emit("join", {"msg": "hello from flutter"});
    });

    socket?.on("message", (data) {
      print("📩 Message: $data");
    });

    socket?.on("comment", (data) {
      print("📩 Message: $data");
    });

    socket?.onError((err) {
      print("❌ error: $err");
    });

    socket?.onDisconnect((_) {
      print("❌ Disconnected");
    });
  }
}
