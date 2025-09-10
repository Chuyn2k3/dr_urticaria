import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocket {
  IO.Socket? socket;

  void initSocket() {
    socket = IO.io(
      'https://hospital.huyit.lat/live', // namespace
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
