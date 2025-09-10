import 'package:dr_urticaria/screens/live/agora_config.dart';
import 'package:dr_urticaria/screens/live/chat_socket.dart';
import 'package:dr_urticaria/screens/live/live_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveDetailPage extends StatefulWidget {
  const LiveDetailPage({super.key});

  @override
  State<LiveDetailPage> createState() => _LiveDetailPageState();
}

class _LiveDetailPageState extends State<LiveDetailPage> {
  late final RtcEngine _engine;
  final ChatSocket chatSocket = ChatSocket();
  final TextEditingController _controller = TextEditingController();
  final List<CommentMessage> _messages = [];

  AgoraConfig? _cfg;
  bool _depsInited = false;
  bool _isJoined = false;
  bool _engineReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_depsInited) return;
    final route = ModalRoute.of(context);
    final args = route?.settings.arguments;

    if (args is AgoraConfig) {
      _cfg = args;
      _depsInited = true;
      initSocket();

      WidgetsBinding.instance.addPostFrameCallback((_) => _initAgora());
    } else {
      _depsInited = true;
      setState(() {});
    }

  }

  Future<void> _initAgora() async {
    if (_cfg == null) return;

    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: _cfg!.appId!));

    await _engine.enableVideo();
    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (!mounted) return;
          setState(() => _isJoined = true);
        },
        onError: (ErrorCodeType code, String msg) {
          debugPrint("Agora onError: $code - $msg");
        },
      ),
    );

    await _engine.joinChannel(
      token: _cfg!.rtcToken!,
      channelId: _cfg!.channelName!,
      uid: _cfg!.doctorId!,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );

    if (!mounted) return;
    setState(() => _engineReady = true);
  }

  void initSocket() {
    chatSocket.initSocket();
    chatSocket.socket?.emit('join-live', {
      "channelName": _cfg?.channelName ?? '',
      "staffId": 15
    });
    chatSocket.socket?.on('comment', (data) {
      setState(() {
        _messages.insert(
            0, CommentMessage.fromJson(data)); // thêm tin nhắn mới lên đầu
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty || _cfg == null) return;
    final text = _controller.text.trim();
    chatSocket.socket?.emit("comment", {
      'channelName': _cfg!.channelName!,
      'message': text,
      "userId": 15,
      "userType": "staff",
    });
    _controller.clear();
  }

  @override
  void dispose() {
    () async {
      try {
        await _engine.leaveChannel();
      } catch (_) {}
      try {
        await _engine.stopPreview();
      } catch (_) {}
      try {
        await _engine.release();
      } catch (_) {}
    }();
    _controller.dispose();
    LiveApi().endLive(_cfg!.liveId!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cfg == null) {
      return const Scaffold(
        body: Center(child: Text('Missing AgoraConfig arguments')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Live: ${_cfg!.channelName}")),
      body: (_engineReady && _isJoined)
          ? Stack(
              children: [
                AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
                // khung chat overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // list message chiếm 1/3 chiều cao
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: ListView.builder(
                          reverse: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Text(
                                msg.message,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            );
                          },
                        ),
                      ),
                      // input
                      Container(
                        height: 60,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: "Nhập nội dung",
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _sendMessage,
                              icon: const Icon(Icons.send,
                                  color: Colors.blue, size: 24),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// ======================= Models =======================

class CommentMessage {
  final String message;
  final CommentUser user;
  final DateTime timestamp;

  CommentMessage({
    required this.message,
    required this.user,
    required this.timestamp,
  });

  factory CommentMessage.fromJson(Map<String, dynamic> json) {
    return CommentMessage(
      message: json['message'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "user": user.toJson(),
      "timestamp": timestamp.toIso8601String(),
    };
  }
}

class CommentUser {
  final int id;
  final String name;
  final String email;

  CommentUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email};
  }
}
