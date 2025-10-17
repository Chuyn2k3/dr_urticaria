// // import 'package:dr_urticaria/screens/live/agora_config.dart';
// // import 'package:dr_urticaria/screens/live/chat_socket.dart';
// // import 'package:dr_urticaria/screens/live/live_cubit.dart';
// // import 'package:flutter/material.dart';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:flutter/scheduler.dart';
// // import 'package:retry/retry.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'dart:async';
// // import '../../cubits/profile/profile_cubit.dart';
// // import '../../di/locator.dart';
// //
// // class LiveDetailPage extends StatefulWidget {
// //   const LiveDetailPage({super.key});
// //
// //   @override
// //   State<LiveDetailPage> createState() => _LiveDetailPageState();
// // }
// //
// // class _LiveDetailPageState extends State<LiveDetailPage>
// //     with TickerProviderStateMixin {
// //   late final RtcEngine _engine;
// //   final ChatSocket chatSocket = ChatSocket();
// //   final TextEditingController _controller = TextEditingController();
// //   final ValueNotifier<List<CommentMessage>> _messagesNotifier =
// //       ValueNotifier([]);
// //   late AnimationController _pulseController;
// //   late AnimationController _slideController;
// //
// //   AgoraConfig? _cfg;
// //   bool _depsInited = false;
// //   bool _isJoined = false;
// //   bool _engineReady = false;
// //   bool _muted = false;
// //   bool _cameraOff = false;
// //   bool _chatExpanded = true;
// //   String _videoQuality = 'medium';
// //   bool _isNetworkConnected = true;
// //   StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pulseController = AnimationController(
// //       duration: const Duration(seconds: 2),
// //       vsync: this,
// //     )..repeat();
// //     _slideController = AnimationController(
// //       duration: const Duration(milliseconds: 300),
// //       vsync: this,
// //     );
// //     _checkNetworkStatus();
// //     _listenToNetworkChanges();
// //   }
// //
// //   // ... existing code ... (keeping all the existing methods unchanged)
// //
// //   Future<void> _checkNetworkStatus() async {
// //     final connectivityResults = await Connectivity().checkConnectivity();
// //     _updateNetworkStatus(connectivityResults);
// //   }
// //
// //   void _listenToNetworkChanges() {
// //     _connectivitySubscription = Connectivity()
// //         .onConnectivityChanged
// //         .listen((List<ConnectivityResult> results) {
// //       _updateNetworkStatus(results);
// //     });
// //   }
// //
// //   void _updateNetworkStatus(List<ConnectivityResult> results) {
// //     setState(() {
// //       _isNetworkConnected =
// //           results.any((result) => result != ConnectivityResult.none);
// //       if (!_isNetworkConnected) {
// //         _isJoined = false;
// //         _showSnackBar(
// //             "Mất kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
// //       }
// //     });
// //   }
// //
// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     if (_depsInited) return;
// //     final route = ModalRoute.of(context);
// //     final args = route?.settings.arguments;
// //
// //     if (args is! AgoraConfig) {
// //       _depsInited = true;
// //       setState(() {});
// //       _showSnackBar('Lỗi: Thiếu cấu hình Agora');
// //       return;
// //     }
// //
// //     _cfg = args;
// //     _depsInited = true;
// //     initSocket();
// //     WidgetsBinding.instance.addPostFrameCallback((_) => _initAgora());
// //   }
// //
// //   Future<void> _initAgora() async {
// //     if (_cfg == null) {
// //       _showSnackBar("Lỗi: Thiếu cấu hình Agora");
// //       return;
// //     }
// //
// //     final connectivityResults = await Connectivity().checkConnectivity();
// //     final hasConnection = connectivityResults.isNotEmpty &&
// //         connectivityResults.any((result) => result != ConnectivityResult.none);
// //
// //     if (!hasConnection) {
// //       _showSnackBar(
// //           "Không có kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
// //       setState(() => _isNetworkConnected = false);
// //       return;
// //     }
// //     await [Permission.camera, Permission.microphone].request();
// //
// //     try {
// //       await const RetryOptions(
// //               maxAttempts: 3, delayFactor: Duration(seconds: 2))
// //           .retry(
// //         () async {
// //           _engine = createAgoraRtcEngine();
// //           await _engine.initialize(RtcEngineContext(appId: _cfg!.appId!));
// //           await _engine.enableVideo();
// //           await _engine.enableAudio();
// //           await _engine.setClientRole(
// //               role: ClientRoleType.clientRoleBroadcaster);
// //           await _setVideoQuality(_videoQuality);
// //           if (!_cameraOff) await _engine.startPreview();
// //
// //           _engine.registerEventHandler(
// //             RtcEngineEventHandler(
// //               onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
// //                 if (!mounted) return;
// //                 setState(() => _isJoined = true);
// //               },
// //               onConnectionLost: (RtcConnection connection) async {
// //                 if (!mounted) return;
// //                 setState(() => _isJoined = false);
// //                 _showSnackBar("Mất kết nối Agora, đang thử reconnect...");
// //                 await _engine.leaveChannel();
// //                 _retryJoinChannel();
// //               },
// //               onRejoinChannelSuccess: (RtcConnection connection, int elapsed) {
// //                 _showSnackBar("Kết nối lại Agora thành công!");
// //                 setState(() => _isJoined = true);
// //               },
// //               onNetworkQuality: (RtcConnection connection, int remoteUid,
// //                   QualityType txQuality, QualityType rxQuality) {
// //                 if (txQuality.index > QualityType.qualityGood.index) {
// //                   _showSnackBar(
// //                       "Chất lượng mạng yếu, vui lòng kiểm tra kết nối.");
// //                 }
// //               },
// //               onError: (ErrorCodeType code, String msg) {
// //                 debugPrint("Agora onError: $code - $msg");
// //                 _showSnackBar("Lỗi Agora: $msg");
// //               },
// //             ),
// //           );
// //
// //           await _engine.joinChannel(
// //             token: _cfg!.rtcToken!,
// //             channelId: _cfg!.channelName!,
// //             uid: _cfg!.doctorId!,
// //             options: ChannelMediaOptions(
// //               clientRoleType: ClientRoleType.clientRoleBroadcaster,
// //               publishCameraTrack: !_cameraOff,
// //               publishMicrophoneTrack: !_muted,
// //               autoSubscribeAudio: true,
// //               autoSubscribeVideo: true,
// //             ),
// //           );
// //
// //           if (!mounted) return;
// //           setState(() => _engineReady = true);
// //         },
// //         onRetry: (e) => debugPrint("Retrying Agora initialization: $e"),
// //       );
// //     } catch (e) {
// //       debugPrint("Error initializing Agora: $e");
// //       _showSnackBar("Lỗi khởi tạo Agora: $e");
// //     }
// //   }
// //
// //   Future<void> _retryJoinChannel() async {
// //     try {
// //       final connectivityResults = await Connectivity().checkConnectivity();
// //       final hasConnection = connectivityResults.isNotEmpty &&
// //           connectivityResults
// //               .any((result) => result != ConnectivityResult.none);
// //
// //       if (!hasConnection) {
// //         _showSnackBar(
// //             "Không có kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
// //         setState(() => _isNetworkConnected = false);
// //         return;
// //       }
// //
// //       await _engine.joinChannel(
// //         token: _cfg!.rtcToken!,
// //         channelId: _cfg!.channelName!,
// //         uid: _cfg!.doctorId!,
// //         options: ChannelMediaOptions(
// //           clientRoleType: ClientRoleType.clientRoleBroadcaster,
// //           publishCameraTrack: !_cameraOff,
// //           publishMicrophoneTrack: !_muted,
// //           autoSubscribeAudio: true,
// //           autoSubscribeVideo: true,
// //         ),
// //       );
// //       setState(() => _isJoined = true);
// //       setState(() => _engineReady = true);
// //       _showSnackBar("Kết nối lại thành công!");
// //     } catch (e) {
// //       _showSnackBar("Không thể kết nối lại: $e");
// //     }
// //   }
// //
// //   Future<void> _setVideoQuality(String quality) async {
// //     try {
// //       final config = switch (quality) {
// //         'low' => const VideoEncoderConfiguration(
// //             dimensions: VideoDimensions(width: 640, height: 360),
// //             bitrate: 800,
// //             frameRate: 15,
// //           ),
// //         'high' => const VideoEncoderConfiguration(
// //             dimensions: VideoDimensions(width: 1920, height: 1080),
// //             bitrate: 2500,
// //             frameRate: 30,
// //           ),
// //         _ => const VideoEncoderConfiguration(
// //             dimensions: VideoDimensions(width: 1280, height: 720),
// //             bitrate: 1500,
// //             frameRate: 24,
// //           ),
// //       };
// //       await _engine.setVideoEncoderConfiguration(config);
// //       _showSnackBar("Đã thay đổi chất lượng video");
// //     } catch (e) {
// //       debugPrint("Error setting video quality: $e");
// //       _showSnackBar("Lỗi thay đổi chất lượng video: $e");
// //     }
// //   }
// //
// //   void initSocket() {
// //     final profileCubit = serviceLocator<ProfileUserCubit>();
// //     final user = profileCubit.inforUser();
// //     final userId = user?.id ?? 15;
// //     chatSocket.initSocket();
// //     chatSocket.socket?.on('connect', (_) {
// //       chatSocket.socket?.emit('join-live',
// //           {"channelName": _cfg?.channelName ?? '', "staffId": userId});
// //       _showSnackBar("Kết nối socket thành công");
// //     });
// //     chatSocket.socket?.on('disconnect', (_) {
// //       _showSnackBar("Mất kết nối socket, đang thử lại...");
// //     });
// //     chatSocket.socket?.on('reconnect', (_) {
// //       _showSnackBar("Kết nối lại socket thành công");
// //       chatSocket.socket?.emit('join-live',
// //           {"channelName": _cfg?.channelName ?? '', "staffId": userId});
// //     });
// //     chatSocket.socket?.on('comment', (data) {
// //       _messagesNotifier.value = [
// //         CommentMessage.fromJson(data),
// //         ..._messagesNotifier.value.take(49),
// //       ];
// //     });
// //   }
// //
// //   void _sendMessage() {
// //     final profileCubit = serviceLocator<ProfileUserCubit>();
// //     final user = profileCubit.inforUser();
// //     final userId = user?.id ?? 15;
// //     if (_controller.text.trim().isEmpty || _cfg == null) return;
// //     final text = _controller.text.trim();
// //     chatSocket.socket?.emit("comment", {
// //       'channelName': _cfg!.channelName!,
// //       'message': text,
// //       "userId": userId,
// //       "userType": "staff",
// //     });
// //     _controller.clear();
// //   }
// //
// //   void _toggleMute() async {
// //     try {
// //       setState(() => _muted = !_muted);
// //       await _engine.muteLocalAudioStream(_muted);
// //       _showSnackBar(_muted ? "Mic đã tắt" : "Mic đã bật");
// //     } catch (e) {
// //       debugPrint("Error toggling mic: $e");
// //       _showSnackBar("Lỗi khi bật/tắt mic: $e");
// //     }
// //   }
// //
// //   void _toggleCamera() async {
// //     try {
// //       setState(() => _cameraOff = !_cameraOff);
// //       await _engine.enableLocalVideo(!_cameraOff);
// //       await _engine.muteLocalVideoStream(_cameraOff);
// //       if (_cameraOff) {
// //         await _engine.stopPreview();
// //       } else {
// //         await _engine.startPreview();
// //       }
// //       _showSnackBar(_cameraOff ? "Camera đã tắt" : "Camera đã bật");
// //     } catch (e) {
// //       debugPrint("Error toggling camera: $e");
// //       _showSnackBar("Lỗi khi bật/tắt camera: $e");
// //     }
// //   }
// //
// //   void _switchCamera() async {
// //     try {
// //       await _engine.switchCamera();
// //     } catch (e) {
// //       debugPrint("Error switching camera: $e");
// //       _showSnackBar("Lỗi khi đổi camera: $e");
// //     }
// //   }
// //
// //   void _toggleChat() {
// //     setState(() => _chatExpanded = !_chatExpanded);
// //     if (_chatExpanded) {
// //       _slideController.forward();
// //     } else {
// //       _slideController.reverse();
// //     }
// //   }
// //
// //   Future<void> _cleanup() async {
// //     try {
// //       await _engine.leaveChannel();
// //       await _engine.stopPreview();
// //       await _engine.release();
// //       await LiveApi().endLive(_cfg!.liveId!);
// //       chatSocket.socket?.disconnect();
// //     } catch (e) {
// //       debugPrint("Error during cleanup: $e");
// //     }
// //   }
// //
// //   void _showSnackBar(String message) {
// //     if (!mounted) return;
// //     SchedulerBinding.instance.addPostFrameCallback((_) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(message),
// //           backgroundColor: Colors.black87,
// //           behavior: SnackBarBehavior.floating,
// //           shape:
// //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //           margin: const EdgeInsets.all(16),
// //         ),
// //       );
// //     });
// //   }
// //
// //   Widget _buildLiveIndicator() {
// //     return AnimatedBuilder(
// //       animation: _pulseController,
// //       builder: (context, child) {
// //         return Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [
// //                 Colors.red.withOpacity(0.8 + 0.2 * _pulseController.value),
// //                 Colors.redAccent
// //                     .withOpacity(0.8 + 0.2 * _pulseController.value),
// //               ],
// //             ),
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.red.withOpacity(0.3),
// //                 blurRadius: 8,
// //                 spreadRadius: _pulseController.value * 2,
// //               ),
// //             ],
// //           ),
// //           child: Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Container(
// //                 width: 8,
// //                 height: 8,
// //                 decoration: const BoxDecoration(
// //                   color: Colors.white,
// //                   shape: BoxShape.circle,
// //                 ),
// //               ),
// //               const SizedBox(width: 6),
// //               const Text(
// //                 "LIVE",
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.bold,
// //                   letterSpacing: 1.2,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildNetworkStatus() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [
// //             Colors.black.withOpacity(0.8),
// //             Colors.black.withOpacity(0.6),
// //           ],
// //         ),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(
// //           color: (_isNetworkConnected && _isJoined)
// //               ? Colors.green.withOpacity(0.5)
// //               : Colors.red.withOpacity(0.5),
// //           width: 1,
// //         ),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(
// //             _isNetworkConnected && _isJoined ? Icons.wifi : Icons.wifi_off,
// //             color: _isNetworkConnected && _isJoined ? Colors.green : Colors.red,
// //             size: 18,
// //           ),
// //           const SizedBox(width: 8),
// //           Text(
// //             _isNetworkConnected && _isJoined ? "Đã kết nối" : "Mất kết nối",
// //             style: TextStyle(
// //               color:
// //                   _isNetworkConnected && _isJoined ? Colors.green : Colors.red,
// //               fontSize: 12,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildChatPanel() {
// //     return AnimatedContainer(
// //       duration: const Duration(milliseconds: 500),
// //       curve: Curves.easeInOut,
// //       height: _chatExpanded ? MediaQuery.of(context).size.height * 0.45 : 60,
// //       width: MediaQuery.of(context).size.width * 0.75,
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //           colors: [
// //             Colors.black.withOpacity(0.85),
// //             Colors.black.withOpacity(0.75),
// //           ],
// //         ),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: Colors.white.withOpacity(0.2)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.3),
// //             blurRadius: 15,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           // Chat header
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Colors.blue.withOpacity(0.8),
// //                   Colors.blueAccent.withOpacity(0.6),
// //                 ],
// //               ),
// //               borderRadius: const BorderRadius.only(
// //                 topLeft: Radius.circular(20),
// //                 topRight: Radius.circular(20),
// //                 bottomLeft: Radius.circular(20),
// //                 bottomRight: Radius.circular(20),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(Icons.chat_bubble_outline,
// //                     color: Colors.white, size: 18),
// //                 const SizedBox(width: 8),
// //                 const Expanded(
// //                   child: Text(
// //                     "Trò chuyện",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //                 GestureDetector(
// //                   onTap: _toggleChat,
// //                   child: Container(
// //                     padding: const EdgeInsets.all(4),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.2),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: Icon(
// //                       _chatExpanded ? Icons.expand_less : Icons.expand_more,
// //                       color: Colors.white,
// //                       size: 20,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // Messages list
// //           Expanded(
// //             child: AnimatedBuilder(
// //               animation: _slideController,
// //               builder: (context, child) {
// //                 return Opacity(
// //                   opacity: _slideController.value,
// //                   child: child,
// //                 );
// //               },
// //               child: ListView.builder(
// //                 reverse: true,
// //                 physics: const BouncingScrollPhysics(),
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                 itemCount: _messagesNotifier.value.length,
// //                 itemBuilder: (context, index) {
// //                   final msg = _messagesNotifier.value[index];
// //                   return Container(
// //                     margin: const EdgeInsets.only(bottom: 8),
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(color: Colors.white.withOpacity(0.1)),
// //                     ),
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Container(
// //                           width: 32,
// //                           height: 32,
// //                           decoration: BoxDecoration(
// //                             gradient: const LinearGradient(
// //                               colors: [Colors.blue, Colors.blueAccent],
// //                             ),
// //                             shape: BoxShape.circle,
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.blue.withOpacity(0.3),
// //                                 blurRadius: 6,
// //                                 offset: const Offset(0, 2),
// //                               ),
// //                             ],
// //                           ),
// //                           child: Center(
// //                             child: Text(
// //                               msg.user.name.isNotEmpty
// //                                   ? msg.user.name[0].toUpperCase()
// //                                   : '?',
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 14,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 12),
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 msg.user.name.isNotEmpty
// //                                     ? msg.user.name
// //                                     : 'Unknown',
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.w600,
// //                                   fontSize: 13,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 4),
// //                               Text(
// //                                 msg.message,
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 12,
// //                                   height: 1.3,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 4),
// //                               Text(
// //                                 msg.timestamp.toString().substring(11, 16),
// //                                 style: TextStyle(
// //                                   color: Colors.grey[400],
// //                                   fontSize: 10,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //
// //           // Message input, only shown when animation is complete
// //           AnimatedBuilder(
// //             animation: _slideController,
// //             builder: (context, child) {
// //               return Visibility(
// //                 visible: _slideController.status == AnimationStatus.completed,
// //                 child: Container(
// //                   margin: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(25),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.1),
// //                         blurRadius: 10,
// //                         offset: const Offset(0, 2),
// //                       ),
// //                     ],
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextField(
// //                           controller: _controller,
// //                           decoration: const InputDecoration(
// //                             hintText: "Nhập tin nhắn...",
// //                             border: InputBorder.none,
// //                             contentPadding: EdgeInsets.symmetric(
// //                                 horizontal: 20, vertical: 12),
// //                             hintStyle: TextStyle(color: Colors.grey),
// //                           ),
// //                           style: const TextStyle(fontSize: 14),
// //                         ),
// //                       ),
// //                       Container(
// //                         margin: const EdgeInsets.only(right: 4),
// //                         decoration: const BoxDecoration(
// //                           gradient: LinearGradient(
// //                             colors: [Colors.blue, Colors.blueAccent],
// //                           ),
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: IconButton(
// //                           onPressed: _sendMessage,
// //                           icon: const Icon(Icons.send,
// //                               color: Colors.white, size: 20),
// //                           padding: const EdgeInsets.all(8),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildControlButton({
// //     required IconData icon,
// //     required VoidCallback onPressed,
// //     required bool isActive,
// //     required String tooltip,
// //     Color? activeColor,
// //     Color? inactiveColor,
// //   }) {
// //     return Tooltip(
// //       message: tooltip,
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: isActive
// //                 ? [
// //                     activeColor ?? Colors.red,
// //                     (activeColor ?? Colors.red).withOpacity(0.8)
// //                   ]
// //                 : [
// //                     inactiveColor ?? Colors.blue,
// //                     (inactiveColor ?? Colors.blue).withOpacity(0.8)
// //                   ],
// //           ),
// //           shape: BoxShape.circle,
// //           boxShadow: [
// //             BoxShadow(
// //               color: (isActive
// //                       ? activeColor ?? Colors.red
// //                       : inactiveColor ?? Colors.blue)
// //                   .withOpacity(0.3),
// //               blurRadius: 8,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Material(
// //           color: Colors.transparent,
// //           child: InkWell(
// //             onTap: onPressed,
// //             borderRadius: BorderRadius.circular(25),
// //             child: Container(
// //               width: 50,
// //               height: 50,
// //               decoration: const BoxDecoration(shape: BoxShape.circle),
// //               child: Icon(icon, color: Colors.white, size: 24),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildControlPanel() {
// //     return AnimatedOpacity(
// //       opacity: _engineReady && _isJoined && _isNetworkConnected ? 1.0 : 0.0,
// //       duration: const Duration(milliseconds: 300),
// //       child: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [
// //               Colors.black.withOpacity(0.85),
// //               Colors.black.withOpacity(0.75),
// //             ],
// //           ),
// //           borderRadius: BorderRadius.circular(25),
// //           border: Border.all(color: Colors.white.withOpacity(0.2)),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.3),
// //               blurRadius: 15,
// //               offset: const Offset(0, 5),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             _buildControlButton(
// //               icon: _muted ? Icons.mic_off : Icons.mic,
// //               onPressed: _toggleMute,
// //               isActive: _muted,
// //               tooltip: _muted ? "Bật mic" : "Tắt mic",
// //               activeColor: Colors.red,
// //               inactiveColor: Colors.green,
// //             ),
// //             const SizedBox(width: 16),
// //             _buildControlButton(
// //               icon: _cameraOff ? Icons.videocam_off : Icons.videocam,
// //               onPressed: _toggleCamera,
// //               isActive: _cameraOff,
// //               tooltip: _cameraOff ? "Bật camera" : "Tắt camera",
// //               activeColor: Colors.red,
// //               inactiveColor: Colors.green,
// //             ),
// //             const SizedBox(width: 16),
// //             _buildControlButton(
// //               icon: Icons.switch_camera,
// //               onPressed: _switchCamera,
// //               isActive: false,
// //               tooltip: "Đổi camera",
// //               inactiveColor: Colors.blue,
// //             ),
// //             const SizedBox(width: 20),
// //             Container(
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   colors: [Colors.red, Colors.redAccent],
// //                 ),
// //                 borderRadius: BorderRadius.circular(25),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.red.withOpacity(0.3),
// //                     blurRadius: 8,
// //                     offset: const Offset(0, 4),
// //                   ),
// //                 ],
// //               ),
// //               child: Material(
// //                 color: Colors.transparent,
// //                 child: InkWell(
// //                   onTap: () async {
// //                     bool? confirm = await showDialog(
// //                       context: context,
// //                       builder: (context) => AlertDialog(
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(20)),
// //                         title: const Text("Kết thúc phiên live?"),
// //                         content:
// //                             const Text("Nếu rời khỏi, phiên live sẽ kết thúc."),
// //                         actions: [
// //                           TextButton(
// //                             onPressed: () => Navigator.pop(context, false),
// //                             child: const Text("Hủy"),
// //                           ),
// //                           ElevatedButton(
// //                             onPressed: () => Navigator.pop(context, true),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.red,
// //                               shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12)),
// //                             ),
// //                             child: const Text("Kết thúc",
// //                                 style: TextStyle(color: Colors.white)),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                     if (confirm == true) {
// //                       await _cleanup();
// //                       if (mounted) Navigator.pop(context);
// //                     }
// //                   },
// //                   borderRadius: BorderRadius.circular(25),
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 20, vertical: 12),
// //                     child: const Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Icon(Icons.call_end, color: Colors.white, size: 20),
// //                         SizedBox(width: 8),
// //                         Text(
// //                           "Kết thúc",
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pulseController.dispose();
// //     _slideController.dispose();
// //     _connectivitySubscription?.cancel();
// //     _controller.dispose();
// //     _messagesNotifier.dispose();
// //     _cleanup();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (_cfg == null) {
// //       return const Scaffold(
// //         backgroundColor: Colors.black,
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.error_outline, color: Colors.red, size: 64),
// //               SizedBox(height: 16),
// //               Text(
// //                 'Missing AgoraConfig arguments',
// //                 style: TextStyle(color: Colors.white, fontSize: 18),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return WillPopScope(
// //       onWillPop: () async {
// //         bool? confirm = await showDialog(
// //           context: context,
// //           builder: (context) => AlertDialog(
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //             title: const Text("Kết thúc phiên live?"),
// //             content: const Text("Nếu rời khỏi, phiên live sẽ kết thúc."),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context, false),
// //                 child: const Text("Hủy"),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () => Navigator.pop(context, true),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.red,
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12)),
// //                 ),
// //                 child: const Text("Kết thúc",
// //                     style: TextStyle(color: Colors.white)),
// //               ),
// //             ],
// //           ),
// //         );
// //         if (confirm == true) {
// //           await _cleanup();
// //           return true;
// //         }
// //         return false;
// //       },
// //       child: Scaffold(
// //         backgroundColor: Colors.black,
// //         appBar: AppBar(
// //           backgroundColor: Colors.black,
// //           elevation: 0,
// //           leading: IconButton(
// //             icon: const Icon(Icons.arrow_back, color: Colors.white),
// //             onPressed: () async {
// //               bool? confirm = await showDialog(
// //                 context: context,
// //                 builder: (context) => AlertDialog(
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(20)),
// //                   title: const Text("Kết thúc phiên live?"),
// //                   content: const Text("Nếu rời khỏi, phiên live sẽ kết thúc."),
// //                   actions: [
// //                     TextButton(
// //                       onPressed: () => Navigator.pop(context, false),
// //                       child: const Text("Hủy"),
// //                     ),
// //                     ElevatedButton(
// //                       onPressed: () => Navigator.pop(context, true),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.red,
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12)),
// //                       ),
// //                       child: const Text("Kết thúc",
// //                           style: TextStyle(color: Colors.white)),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //               if (confirm == true) {
// //                 await _cleanup();
// //                 Navigator.pop(context);
// //               }
// //             },
// //           ),
// //           title: Row(
// //             children: [
// //               Expanded(
// //                 child: Text(
// //                   "Live: ${_cfg!.channelName}",
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(width: 12),
// //               _buildLiveIndicator(),
// //             ],
// //           ),
// //           actions: [
// //             Container(
// //               margin: const EdgeInsets.only(right: 16),
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [
// //                     Colors.blue.withOpacity(0.8),
// //                     Colors.blueAccent.withOpacity(0.6)
// //                   ],
// //                 ),
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: DropdownButton<String>(
// //                 value: _videoQuality,
// //                 underline: const SizedBox(),
// //                 dropdownColor: Colors.black87,
// //                 icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
// //                 style: const TextStyle(color: Colors.white, fontSize: 12),
// //                 items: const [
// //                   DropdownMenuItem(
// //                       value: 'low',
// //                       child: Text('Thấp (360p)',
// //                           style: TextStyle(color: Colors.white))),
// //                   DropdownMenuItem(
// //                       value: 'medium',
// //                       child: Text('Trung bình (720p)',
// //                           style: TextStyle(color: Colors.white))),
// //                   DropdownMenuItem(
// //                       value: 'high',
// //                       child: Text('Cao (1080p)',
// //                           style: TextStyle(color: Colors.white))),
// //                 ],
// //                 onChanged: (value) {
// //                   setState(() => _videoQuality = value!);
// //                   _setVideoQuality(value!);
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //         body: SafeArea(
// //           child: (_engineReady && _isJoined && _isNetworkConnected)
// //               ? Stack(
// //                   children: [
// //                     // Video view
// //                     _cameraOff
// //                         ? Container(
// //                             decoration: BoxDecoration(
// //                               gradient: LinearGradient(
// //                                 begin: Alignment.topCenter,
// //                                 end: Alignment.bottomCenter,
// //                                 colors: [
// //                                   Colors.grey[900]!,
// //                                   Colors.black,
// //                                 ],
// //                               ),
// //                             ),
// //                             child: const Center(
// //                               child: Column(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 children: [
// //                                   Icon(Icons.videocam_off,
// //                                       color: Colors.white, size: 64),
// //                                   SizedBox(height: 16),
// //                                   Text(
// //                                     "Camera đã tắt",
// //                                     style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.w500,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           )
// //                         : ClipRRect(
// //                             borderRadius: BorderRadius.circular(0),
// //                             child: AgoraVideoView(
// //                               controller: VideoViewController(
// //                                 rtcEngine: _engine,
// //                                 canvas: const VideoCanvas(uid: 0),
// //                               ),
// //                             ),
// //                           ),
// //
// //                     // Network status indicator
// //                     Positioned(
// //                       top: 20,
// //                       left: 20,
// //                       child: _buildNetworkStatus(),
// //                     ),
// //
// //                     // Chat panel
// //                     Positioned(
// //                       bottom: 120,
// //                       left: 20,
// //                       child: _buildChatPanel(),
// //                     ),
// //
// //                     // Control panel
// //                     Positioned(
// //                       bottom: 20,
// //                       right: 20,
// //                       child: _buildControlPanel(),
// //                     ),
// //                   ],
// //                 )
// //               : Container(
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       begin: Alignment.topCenter,
// //                       end: Alignment.bottomCenter,
// //                       colors: [Colors.grey[900]!, Colors.black],
// //                     ),
// //                   ),
// //                   child: const Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         CircularProgressIndicator(
// //                           valueColor:
// //                               AlwaysStoppedAnimation<Color>(Colors.blue),
// //                           strokeWidth: 3,
// //                         ),
// //                         SizedBox(height: 24),
// //                         Text(
// //                           "Đang kết nối...",
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class CommentMessage {
// //   final String message;
// //   final CommentUser user;
// //   final DateTime timestamp;
// //
// //   CommentMessage({
// //     required this.message,
// //     required this.user,
// //     required this.timestamp,
// //   });
// //
// //   factory CommentMessage.fromJson(Map<String, dynamic> json) {
// //     try {
// //       return CommentMessage(
// //         message: json['message']?.toString() ?? '',
// //         user: CommentUser.fromJson(json['user'] ?? {}),
// //         timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
// //             DateTime.now(),
// //       );
// //     } catch (e) {
// //       debugPrint("Error parsing CommentMessage: $e");
// //       return CommentMessage(
// //         message: '',
// //         user: CommentUser(id: 0, name: 'Unknown', email: ''),
// //         timestamp: DateTime.now(),
// //       );
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       "message": message,
// //       "user": user.toJson(),
// //       "timestamp": timestamp.toIso8601String(),
// //     };
// //   }
// // }
// //
// // class CommentUser {
// //   final int id;
// //   final String name;
// //   final String email;
// //
// //   CommentUser({
// //     required this.id,
// //     required this.name,
// //     required this.email,
// //   });
// //
// //   factory CommentUser.fromJson(Map<String, dynamic> json) {
// //     return CommentUser(
// //       id: json['id']?.toInt() ?? 0,
// //       name: json['name']?.toString() ?? 'Unknown',
// //       email: json['email']?.toString() ?? '',
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {"id": id, "name": name, "email": email};
// //   }
// // }
//
// import 'package:dr_urticaria/screens/live/agora_config.dart';
// import 'package:dr_urticaria/screens/live/chat_socket.dart';
// import 'package:dr_urticaria/screens/live/live_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:retry/retry.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:async';
// import '../../cubits/profile/profile_cubit.dart';
// import '../../di/locator.dart';
//
// class LiveDetailPage extends StatefulWidget {
//   const LiveDetailPage({super.key});
//
//   @override
//   State<LiveDetailPage> createState() => _LiveDetailPageState();
// }
//
// class _LiveDetailPageState extends State<LiveDetailPage>
//     with TickerProviderStateMixin {
//   late final RtcEngine _engine;
//   final ChatSocket chatSocket = ChatSocket();
//   final TextEditingController _controller = TextEditingController();
//   final ValueNotifier<List<CommentMessage>> _messagesNotifier =
//       ValueNotifier([]);
//   late AnimationController _pulseController;
//   late AnimationController _slideController;
//
//   AgoraConfig? _cfg;
//   bool _depsInited = false;
//   final ValueNotifier<bool> _isJoined = ValueNotifier(false);
//   final ValueNotifier<bool> _muted = ValueNotifier(false);
//   final ValueNotifier<bool> _cameraOff = ValueNotifier(false);
//   final ValueNotifier<bool> _chatExpanded = ValueNotifier(false);
//   final ValueNotifier<String> _videoQuality = ValueNotifier('medium');
//   final ValueNotifier<bool> _isNetworkConnected = ValueNotifier(true);
//   final ValueNotifier<bool> _engineReady = ValueNotifier(false);
//   StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
//
//   Timer? _debounceTimer;
//   Timer? _sendMessageDebounce;
//   Timer? _videoQualityDebounce;
//   Timer? _snackBarDebounce;
//
//   final Map<String, VideoEncoderConfiguration> _videoConfigs = {
//     'low': const VideoEncoderConfiguration(
//       dimensions: VideoDimensions(width: 640, height: 360),
//       bitrate: 800,
//       frameRate: 15,
//     ),
//     'medium': const VideoEncoderConfiguration(
//       dimensions: VideoDimensions(width: 1280, height: 720),
//       bitrate: 1500,
//       frameRate: 24,
//     ),
//     'high': const VideoEncoderConfiguration(
//       dimensions: VideoDimensions(width: 1920, height: 1080),
//       bitrate: 2500,
//       frameRate: 30,
//     ),
//   };
//
//   static const int maxMessages = 50;
//
//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..repeat();
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _checkNetworkStatus();
//     _listenToNetworkChanges();
//   }
//
//   Future<void> _checkNetworkStatus() async {
//     final connectivityResults = await Connectivity().checkConnectivity();
//     _updateNetworkStatus(connectivityResults);
//   }
//
//   void _listenToNetworkChanges() {
//     _connectivitySubscription = Connectivity()
//         .onConnectivityChanged
//         .listen((List<ConnectivityResult> results) {
//       _debounceTimer?.cancel();
//       _debounceTimer = Timer(const Duration(milliseconds: 500), () {
//         _updateNetworkStatus(results);
//       });
//     });
//   }
//
//   void _updateNetworkStatus(List<ConnectivityResult> results) {
//     _isNetworkConnected.value =
//         results.any((result) => result != ConnectivityResult.none);
//     if (!_isNetworkConnected.value) {
//       _isJoined.value = false;
//       _pulseController.stop();
//       _showSnackBar(
//           "Mất kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
//     } else if (_isJoined.value) {
//       _pulseController.repeat();
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_depsInited) return;
//     final route = ModalRoute.of(context);
//     final args = route?.settings.arguments;
//
//     if (args is! AgoraConfig) {
//       _depsInited = true;
//       setState(() {});
//       _showSnackBar('Lỗi: Thiếu cấu hình Agora');
//       return;
//     }
//
//     _cfg = args;
//     _depsInited = true;
//     initSocket();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _initAgora());
//   }
//
//   Future<bool> _checkPermissions() async {
//     final status = await [Permission.camera, Permission.microphone].request();
//     return status.values.every((s) => s.isGranted);
//   }
//
//   Future<void> _initAgora() async {
//     if (_cfg == null) {
//       _showSnackBar("Lỗi: Thiếu cấu hình Agora");
//       return;
//     }
//
//     final hasPermissions = await _checkPermissions();
//     if (!hasPermissions) {
//       _showSnackBar("Vui lòng cấp quyền camera và microphone.");
//       return;
//     }
//
//     final connectivityResults = await Connectivity().checkConnectivity();
//     final hasConnection = connectivityResults.isNotEmpty &&
//         connectivityResults.any((result) => result != ConnectivityResult.none);
//
//     if (!hasConnection) {
//       _showSnackBar(
//           "Không có kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
//       _isNetworkConnected.value = false;
//       return;
//     }
//
//     try {
//       await const RetryOptions(
//         maxAttempts: 3,
//         delayFactor: Duration(milliseconds: 500),
//         maxDelay: Duration(seconds: 2),
//       ).retry(
//         () async {
//           _engine = createAgoraRtcEngine();
//           await _engine.initialize(RtcEngineContext(appId: _cfg!.appId!));
//           await _engine.enableVideo();
//           await _engine.enableAudio();
//           await _engine.setClientRole(
//               role: ClientRoleType.clientRoleBroadcaster);
//           await _setVideoQuality(_videoQuality.value);
//           if (!_cameraOff.value) await _engine.startPreview();
//
//           _engine.registerEventHandler(
//             RtcEngineEventHandler(
//               onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//                 if (!mounted) return;
//                 _isJoined.value = true;
//                 _pulseController.repeat();
//               },
//               onConnectionLost: (RtcConnection connection) async {
//                 if (!mounted) return;
//                 _isJoined.value = false;
//                 _pulseController.stop();
//                 _showSnackBar("Mất kết nối Agora, đang thử reconnect...");
//                 await _engine.leaveChannel();
//                 _retryJoinChannel();
//               },
//               onRejoinChannelSuccess: (RtcConnection connection, int elapsed) {
//                 _showSnackBar("Kết nối lại Agora thành công!");
//                 _isJoined.value = true;
//               },
//               onNetworkQuality: (RtcConnection connection, int remoteUid,
//                   QualityType txQuality, QualityType rxQuality) {
//                 if (txQuality.index > QualityType.qualityGood.index) {
//                   _showSnackBar(
//                       "Chất lượng mạng yếu, vui lòng kiểm tra kết nối.");
//                 }
//               },
//               onError: (ErrorCodeType code, String msg) {
//                 debugPrint("Agora onError: $code - $msg");
//                 _showSnackBar("Lỗi Agora: $msg");
//               },
//             ),
//           );
//
//           await _engine.joinChannel(
//             token: _cfg!.rtcToken!,
//             channelId: _cfg!.channelName!,
//             uid: _cfg!.doctorId!,
//             options: ChannelMediaOptions(
//               clientRoleType: ClientRoleType.clientRoleBroadcaster,
//               publishCameraTrack: !_cameraOff.value,
//               publishMicrophoneTrack: !_muted.value,
//               autoSubscribeAudio: true,
//               autoSubscribeVideo: true,
//             ),
//           );
//
//           if (!mounted) return;
//           _engineReady.value = true;
//         },
//         onRetry: (e) => debugPrint("Retrying Agora initialization: $e"),
//       );
//     } catch (e) {
//       debugPrint("Error initializing Agora: $e");
//       _showSnackBar("Lỗi khởi tạo Agora: $e");
//     }
//   }
//
//   Future<void> _retryJoinChannel() async {
//     try {
//       final connectivityResults = await Connectivity().checkConnectivity();
//       final hasConnection = connectivityResults.isNotEmpty &&
//           connectivityResults
//               .any((result) => result != ConnectivityResult.none);
//
//       if (!hasConnection) {
//         _showSnackBar(
//             "Không có kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
//         _isNetworkConnected.value = false;
//         return;
//       }
//
//       await _engine.joinChannel(
//         token: _cfg!.rtcToken!,
//         channelId: _cfg!.channelName!,
//         uid: _cfg!.doctorId!,
//         options: ChannelMediaOptions(
//           clientRoleType: ClientRoleType.clientRoleBroadcaster,
//           publishCameraTrack: !_cameraOff.value,
//           publishMicrophoneTrack: !_muted.value,
//           autoSubscribeAudio: true,
//           autoSubscribeVideo: true,
//         ),
//       );
//       _isJoined.value = true;
//       _engineReady.value = true;
//       _showSnackBar("Kết nối lại thành công!");
//     } catch (e) {
//       _showSnackBar("Không thể kết nối lại: $e");
//     }
//   }
//
//   Future<void> _setVideoQuality(String quality) async {
//     _videoQualityDebounce?.cancel();
//     _videoQualityDebounce = Timer(const Duration(milliseconds: 500), () async {
//       try {
//         await _engine.setVideoEncoderConfiguration(_videoConfigs[quality]!);
//         _showSnackBar("Đã thay đổi chất lượng video");
//       } catch (e) {
//         debugPrint("Error setting video quality: $e");
//         _showSnackBar("Lỗi thay đổi chất lượng video: $e");
//       }
//     });
//   }
//
//   void initSocket() async {
//     final profileCubit = serviceLocator<ProfileUserCubit>();
//     final user = profileCubit.inforUser();
//     final userId = user?.id ?? 15;
//     await chatSocket.initSocket();
//     if (chatSocket.socket == null) {
//       debugPrint("Socket initialization failed: socket is null");
//       _showSnackBar("Lỗi: Không thể khởi tạo socket");
//       return;
//     }
//     debugPrint("Socket initialized, attempting to connect...");
//     chatSocket.socket?.off('connect');
//     chatSocket.socket?.off('disconnect');
//     chatSocket.socket?.off('reconnect');
//     chatSocket.socket?.off('comment');
//     chatSocket.socket?.on('connect', (_) {
//       chatSocket.socket?.emit('join-live',
//           {"channelName": _cfg?.channelName ?? '', "staffId": userId});
//       _showSnackBar("Kết nối socket thành công");
//     });
//     chatSocket.socket?.on('disconnect', (_) {
//       _showSnackBar("Mất kết nối socket, đang thử lại...");
//     });
//     chatSocket.socket?.on('reconnect', (_) {
//       _showSnackBar("Kết nối lại socket thành công");
//       chatSocket.socket?.emit('join-live',
//           {"channelName": _cfg?.channelName ?? '', "staffId": userId});
//     });
//     chatSocket.socket?.on('comment', (data) {
//       debugPrint("[SOCKET] Comment received: $data");
//       _messagesNotifier.value = [
//         CommentMessage.fromJson(data),
//         ..._messagesNotifier.value.take(maxMessages - 1),
//       ];
//     });
//   }
//
//   void _sendMessage() {
//     final profileCubit = serviceLocator<ProfileUserCubit>();
//     final user = profileCubit.inforUser();
//     final userId = user?.id ?? 15;
//     print("_cfg ${_cfg?.toJson()}");
//     print("${_controller.text.trim()}");
//     if (_controller.text.trim().isEmpty || _cfg == null) return;
//     _sendMessageDebounce?.cancel();
//     _sendMessageDebounce = Timer(const Duration(milliseconds: 300), () {
//       final text = _controller.text.trim();
//       debugPrint("[SOCKET] Sending message: $text");
//       chatSocket.socket?.emit("comment", {
//         'channelName': _cfg!.channelName!,
//         'message': text,
//         "userId": userId,
//         "userType": "staff",
//       });
//       _controller.clear();
//     });
//   }
//
//   void _toggleMute() async {
//     try {
//       _muted.value = !_muted.value;
//       await _engine.muteLocalAudioStream(_muted.value);
//       _showSnackBar(_muted.value ? "Mic đã tắt" : "Mic đã bật");
//     } catch (e) {
//       debugPrint("Error toggling mic: $e");
//       _showSnackBar("Lỗi khi bật/tắt mic: $e");
//     }
//   }
//
//   void _toggleCamera() async {
//     try {
//       _cameraOff.value = !_cameraOff.value;
//       await _engine.enableLocalVideo(!_cameraOff.value);
//       await _engine.muteLocalVideoStream(_cameraOff.value);
//       if (_cameraOff.value) {
//         await _engine.stopPreview();
//       } else {
//         await _engine.startPreview();
//       }
//       _showSnackBar(_cameraOff.value ? "Camera đã tắt" : "Camera đã bật");
//     } catch (e) {
//       debugPrint("Error toggling camera: $e");
//       _showSnackBar("Lỗi khi bật/tắt camera: $e");
//     }
//   }
//
//   void _switchCamera() async {
//     try {
//       await _engine.switchCamera();
//     } catch (e) {
//       debugPrint("Error switching camera: $e");
//       _showSnackBar("Lỗi khi đổi camera: $e");
//     }
//   }
//
//   void _toggleChat() {
//     _chatExpanded.value = !_chatExpanded.value;
//     if (_chatExpanded.value) {
//       _slideController.forward();
//     } else {
//       _slideController.reverse();
//     }
//   }
//
//   Future<void> _cleanup() async {
//     try {
//       await _engine.leaveChannel();
//       await _engine.stopPreview();
//       await _engine.release();
//       await LiveApi().endLive(_cfg!.liveId!);
//       chatSocket.socket?.disconnect();
//       chatSocket.socket?.dispose();
//     } catch (e) {
//       debugPrint("Error during cleanup: $e");
//     }
//   }
//
//   void _showSnackBar(String message) {
//     if (!mounted) return;
//     _snackBarDebounce?.cancel();
//     _snackBarDebounce = Timer(const Duration(milliseconds: 500), () {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message),
//             backgroundColor: Colors.black87,
//             behavior: SnackBarBehavior.floating,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     _sendMessageDebounce?.cancel();
//     _videoQualityDebounce?.cancel();
//     _snackBarDebounce?.cancel();
//     _pulseController.dispose();
//     _slideController.dispose();
//     _connectivitySubscription?.cancel();
//     _controller.dispose();
//     _messagesNotifier.dispose();
//     _isJoined.dispose();
//     _muted.dispose();
//     _cameraOff.dispose();
//     _isNetworkConnected.dispose();
//     _chatExpanded.dispose();
//     _videoQuality.dispose();
//     _engineReady.dispose();
//     _cleanup();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_cfg == null) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, color: Colors.red, size: 64),
//               SizedBox(height: 16),
//               Text(
//                 'Missing AgoraConfig arguments',
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return WillPopScope(
//       onWillPop: () async {
//         bool? confirm = await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             title: const Text("Kết thúc phiên live?"),
//             content: const Text("Nếu rời khỏi, phiên live sẽ kết thúc."),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text("Hủy"),
//               ),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text("Kết thúc",
//                     style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         );
//         if (confirm == true) {
//           await _cleanup();
//           return true;
//         }
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () async {
//               bool? confirm = await showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   title: const Text("Kết thúc phiên live?"),
//                   content: const Text("Nếu rời khỏi, phiên live sẽ kết thúc."),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: const Text("Hủy"),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: const Text("Kết thúc",
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ],
//                 ),
//               );
//               if (confirm == true) {
//                 await _cleanup();
//                 Navigator.pop(context);
//               }
//             },
//           ),
//           title: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   "Live: ${_cfg!.channelName}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               LiveIndicator(pulseController: _pulseController),
//             ],
//           ),
//           actions: [
//             Container(
//               margin: const EdgeInsets.only(right: 16),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.withOpacity(0.8),
//                     Colors.blueAccent.withOpacity(0.6)
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: ValueListenableBuilder<String>(
//                 valueListenable: _videoQuality,
//                 builder: (context, quality, child) {
//                   return DropdownButton<String>(
//                     value: quality,
//                     underline: const SizedBox(),
//                     dropdownColor: Colors.black87,
//                     icon:
//                         const Icon(Icons.arrow_drop_down, color: Colors.white),
//                     style: const TextStyle(color: Colors.white, fontSize: 12),
//                     items: const [
//                       DropdownMenuItem(
//                           value: 'low',
//                           child: Text('Thấp (360p)',
//                               style: TextStyle(color: Colors.white))),
//                       DropdownMenuItem(
//                           value: 'medium',
//                           child: Text('Trung bình (720p)',
//                               style: TextStyle(color: Colors.white))),
//                       DropdownMenuItem(
//                           value: 'high',
//                           child: Text('Cao (1080p)',
//                               style: TextStyle(color: Colors.white))),
//                     ],
//                     onChanged: (value) {
//                       _videoQuality.value = value!;
//                       _setVideoQuality(value!);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: ValueListenableBuilder<bool>(
//             valueListenable: _engineReady,
//             builder: (context, engineReady, child) {
//               return ValueListenableBuilder<bool>(
//                 valueListenable: _isJoined,
//                 builder: (context, isJoined, child) {
//                   return ValueListenableBuilder<bool>(
//                     valueListenable: _isNetworkConnected,
//                     builder: (context, isNetworkConnected, child) {
//                       return (engineReady && isJoined && isNetworkConnected)
//                           ? Stack(
//                               children: [
//                                 ValueListenableBuilder<bool>(
//                                   valueListenable: _cameraOff,
//                                   builder: (context, cameraOff, child) {
//                                     return VideoView(
//                                       cameraOff: cameraOff,
//                                       engine: _engine,
//                                     );
//                                   },
//                                 ),
//                                 Positioned(
//                                   top: 20,
//                                   left: 20,
//                                   child: ValueListenableBuilder<bool>(
//                                     valueListenable: _isNetworkConnected,
//                                     builder:
//                                         (context, isNetworkConnected, child) {
//                                       return ValueListenableBuilder<bool>(
//                                         valueListenable: _isJoined,
//                                         builder: (context, isJoined, child) {
//                                           return NetworkStatus(
//                                             isNetworkConnected:
//                                                 isNetworkConnected,
//                                             isJoined: isJoined,
//                                           );
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 120,
//                                   left: 20,
//                                   child: ValueListenableBuilder<bool>(
//                                     valueListenable: _chatExpanded,
//                                     builder: (context, chatExpanded, child) {
//                                       return ChatPanel(
//                                         chatExpanded: chatExpanded,
//                                         slideController: _slideController,
//                                         messagesNotifier: _messagesNotifier,
//                                         controller: _controller,
//                                         sendMessage: _sendMessage,
//                                         toggleChat: _toggleChat,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 20,
//                                   right: 20,
//                                   child: ValueListenableBuilder<bool>(
//                                     valueListenable: _engineReady,
//                                     builder: (context, engineReady, child) {
//                                       return ValueListenableBuilder<bool>(
//                                         valueListenable: _isJoined,
//                                         builder: (context, isJoined, child) {
//                                           return ValueListenableBuilder<bool>(
//                                             valueListenable:
//                                                 _isNetworkConnected,
//                                             builder: (context,
//                                                 isNetworkConnected, child) {
//                                               return ControlPanel(
//                                                 engineReady: engineReady,
//                                                 isJoined: isJoined,
//                                                 isNetworkConnected:
//                                                     isNetworkConnected,
//                                                 muted: _muted,
//                                                 cameraOff: _cameraOff,
//                                                 toggleMute: _toggleMute,
//                                                 toggleCamera: _toggleCamera,
//                                                 switchCamera: _switchCamera,
//                                                 cleanup: _cleanup,
//                                               );
//                                             },
//                                           );
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [Colors.grey[900]!, Colors.black],
//                                 ),
//                               ),
//                               child: const Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     CircularProgressIndicator(
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.blue),
//                                       strokeWidth: 3,
//                                     ),
//                                     SizedBox(height: 24),
//                                     Text(
//                                       "Đang kết nối...",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LiveIndicator extends StatelessWidget {
//   final AnimationController pulseController;
//
//   const LiveIndicator({super.key, required this.pulseController});
//
//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: AnimatedBuilder(
//         animation: pulseController,
//         builder: (context, child) {
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.red.withOpacity(0.8 + 0.2 * pulseController.value),
//                   Colors.redAccent
//                       .withOpacity(0.8 + 0.2 * pulseController.value),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.red.withOpacity(0.3),
//                   blurRadius: 8,
//                   spreadRadius: pulseController.value * 2,
//                 ),
//               ],
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 8,
//                   height: 8,
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 6),
//                 Text(
//                   "LIVE",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class NetworkStatus extends StatelessWidget {
//   final bool isNetworkConnected;
//   final bool isJoined;
//
//   const NetworkStatus({
//     super.key,
//     required this.isNetworkConnected,
//     required this.isJoined,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.black.withOpacity(0.8),
//             Colors.black.withOpacity(0.6),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: (isNetworkConnected && isJoined)
//               ? Colors.green.withOpacity(0.5)
//               : Colors.red.withOpacity(0.5),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isNetworkConnected && isJoined ? Icons.wifi : Icons.wifi_off,
//             color: isNetworkConnected && isJoined ? Colors.green : Colors.red,
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             isNetworkConnected && isJoined ? "Đã kết nối" : "Mất kết nối",
//             style: TextStyle(
//               color: isNetworkConnected && isJoined ? Colors.green : Colors.red,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatPanel extends StatelessWidget {
//   final bool chatExpanded;
//   final AnimationController slideController;
//   final ValueNotifier<List<CommentMessage>> messagesNotifier;
//   final TextEditingController controller;
//   final VoidCallback sendMessage;
//   final VoidCallback toggleChat;
//
//   const ChatPanel({
//     super.key,
//     required this.chatExpanded,
//     required this.slideController,
//     required this.messagesNotifier,
//     required this.controller,
//     required this.sendMessage,
//     required this.toggleChat,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//         height: chatExpanded ? MediaQuery.of(context).size.height * 0.45 : 60,
//         width: MediaQuery.of(context).size.width * 0.75,
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.8),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withOpacity(0.2)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.withOpacity(0.8),
//                     Colors.blueAccent.withOpacity(0.6),
//                   ],
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.chat_bubble_outline,
//                       color: Colors.white, size: 18),
//                   const SizedBox(width: 8),
//                   const Expanded(
//                     child: Text(
//                       "Trò chuyện",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: toggleChat,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         chatExpanded ? Icons.expand_less : Icons.expand_more,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: AnimatedBuilder(
//                 animation: slideController,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: slideController.value,
//                     child: child,
//                   );
//                 },
//                 child: ValueListenableBuilder<List<CommentMessage>>(
//                   valueListenable: messagesNotifier,
//                   builder: (context, messages, child) {
//                     return ListView.builder(
//                       reverse: true,
//                       physics: const BouncingScrollPhysics(),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       itemCount: messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = messages[index];
//                         print("msg $msg $index");
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 8),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.1)),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: 32,
//                                 height: 32,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [Colors.blue, Colors.blueAccent],
//                                   ),
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.blue.withOpacity(0.3),
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     msg.user.name.isNotEmpty
//                                         ? msg.user.name[0].toUpperCase()
//                                         : '?',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       msg.user.name.isNotEmpty
//                                           ? msg.user.name
//                                           : 'Unknown',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       msg.message,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                         height: 1.3,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       msg.timestamp
//                                           .toString()
//                                           .substring(11, 16),
//                                       style: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 10,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//             AnimatedBuilder(
//               animation: slideController,
//               builder: (context, child) {
//                 return Visibility(
//                   visible: slideController.status == AnimationStatus.completed,
//                   child: Container(
//                     margin: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: controller,
//                             decoration: const InputDecoration(
//                               hintText: "Nhập tin nhắn...",
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 12),
//                               hintStyle: TextStyle(color: Colors.grey),
//                             ),
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(right: 4),
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Colors.blue, Colors.blueAccent],
//                             ),
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             onPressed: sendMessage,
//                             icon: const Icon(Icons.send,
//                                 color: Colors.white, size: 20),
//                             padding: const EdgeInsets.all(8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ControlPanel extends StatelessWidget {
//   final bool engineReady;
//   final bool isJoined;
//   final bool isNetworkConnected;
//   final ValueNotifier<bool> muted;
//   final ValueNotifier<bool> cameraOff;
//   final VoidCallback toggleMute;
//   final VoidCallback toggleCamera;
//   final VoidCallback switchCamera;
//   final Future<void> Function() cleanup;
//
//   const ControlPanel({
//     super.key,
//     required this.engineReady,
//     required this.isJoined,
//     required this.isNetworkConnected,
//     required this.muted,
//     required this.cameraOff,
//     required this.toggleMute,
//     required this.toggleCamera,
//     required this.switchCamera,
//     required this.cleanup,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: engineReady && isJoined && isNetworkConnected ? 1.0 : 0.0,
//       duration: const Duration(milliseconds: 300),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.black.withOpacity(0.85),
//               Colors.black.withOpacity(0.75),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(color: Colors.white.withOpacity(0.2)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ValueListenableBuilder<bool>(
//               valueListenable: muted,
//               builder: (context, isMuted, child) {
//                 return ControlButton(
//                   icon: isMuted ? Icons.mic_off : Icons.mic,
//                   onPressed: toggleMute,
//                   isActive: isMuted,
//                   tooltip: isMuted ? "Bật mic" : "Tắt mic",
//                   activeColor: Colors.red,
//                   inactiveColor: Colors.green,
//                 );
//               },
//             ),
//             const SizedBox(width: 16),
//             ValueListenableBuilder<bool>(
//               valueListenable: cameraOff,
//               builder: (context, isCameraOff, child) {
//                 return ControlButton(
//                   icon: isCameraOff ? Icons.videocam_off : Icons.videocam,
//                   onPressed: toggleCamera,
//                   isActive: isCameraOff,
//                   tooltip: isCameraOff ? "Bật camera" : "Tắt camera",
//                   activeColor: Colors.red,
//                   inactiveColor: Colors.green,
//                 );
//               },
//             ),
//             const SizedBox(width: 16),
//             ControlButton(
//               icon: Icons.switch_camera,
//               onPressed: switchCamera,
//               isActive: false,
//               tooltip: "Đổi camera",
//               inactiveColor: Colors.blue,
//             ),
//             const SizedBox(width: 20),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Colors.red, Colors.redAccent],
//                 ),
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.red.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () async {
//                     bool? confirm = await showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         title: const Text("Kết thúc phiên live?"),
//                         content:
//                             const Text("Nếu rời khỏi, phiên live sẽ kết thúc."),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: const Text("Hủy"),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => Navigator.pop(context, true),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                             ),
//                             child: const Text("Kết thúc",
//                                 style: TextStyle(color: Colors.white)),
//                           ),
//                         ],
//                       ),
//                     );
//                     if (confirm == true) {
//                       await cleanup();
//                       if (context.mounted) Navigator.pop(context);
//                     }
//                   },
//                   borderRadius: BorderRadius.circular(25),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.call_end, color: Colors.white, size: 20),
//                         SizedBox(width: 8),
//                         Text(
//                           "Kết thúc",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ControlButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onPressed;
//   final bool isActive;
//   final String tooltip;
//   final Color? activeColor;
//   final Color? inactiveColor;
//
//   const ControlButton({
//     super.key,
//     required this.icon,
//     required this.onPressed,
//     required this.isActive,
//     required this.tooltip,
//     this.activeColor,
//     this.inactiveColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Tooltip(
//       message: tooltip,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isActive
//                 ? [
//                     activeColor ?? Colors.red,
//                     (activeColor ?? Colors.red).withOpacity(0.8)
//                   ]
//                 : [
//                     inactiveColor ?? Colors.blue,
//                     (inactiveColor ?? Colors.blue).withOpacity(0.8)
//                   ],
//           ),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: (isActive
//                       ? activeColor ?? Colors.red
//                       : inactiveColor ?? Colors.blue)
//                   .withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: onPressed,
//             borderRadius: BorderRadius.circular(25),
//             child: Container(
//               width: 50,
//               height: 50,
//               decoration: const BoxDecoration(shape: BoxShape.circle),
//               child: Icon(icon, color: Colors.white, size: 24),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class VideoView extends StatelessWidget {
//   final bool cameraOff;
//   final RtcEngine engine;
//
//   const VideoView({
//     super.key,
//     required this.cameraOff,
//     required this.engine,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return cameraOff
//         ? Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.grey[900]!, Colors.black],
//               ),
//             ),
//             child: const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.videocam_off, color: Colors.white, size: 64),
//                   SizedBox(height: 16),
//                   Text(
//                     "Camera đã tắt",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : ClipRRect(
//             borderRadius: BorderRadius.circular(0),
//             child: AgoraVideoView(
//               controller: VideoViewController(
//                 rtcEngine: engine,
//                 canvas: const VideoCanvas(uid: 0),
//               ),
//             ),
//           );
//   }
// }
//
// class CommentMessage {
//   final String message;
//   final CommentUser user;
//   final DateTime timestamp;
//
//   CommentMessage({
//     required this.message,
//     required this.user,
//     required this.timestamp,
//   });
//
//   factory CommentMessage.fromJson(Map<String, dynamic> json) {
//     try {
//       return CommentMessage(
//         message: json['message'] ?? '',
//         user: CommentUser.fromJson(json['user'] ?? {}),
//         timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
//             DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint("Error parsing CommentMessage: $e");
//       return CommentMessage(
//         message: '',
//         user: CommentUser(id: 0, name: 'Unknown', email: ''),
//         timestamp: DateTime.now(),
//       );
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "message": message,
//       "user": user.toJson(),
//       "timestamp": timestamp.toIso8601String(),
//     };
//   }
// }
//
// class CommentUser {
//   final int id;
//   final String name;
//   final String email;
//
//   CommentUser({
//     required this.id,
//     required this.name,
//     required this.email,
//   });
//
//   factory CommentUser.fromJson(Map<String, dynamic> json) {
//     return CommentUser(
//       id: json['id'] ?? 0,
//       name: json['name']?.toString() ?? 'Unknown',
//       email: json['email']?.toString() ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {"id": id, "name": name, "email": email};
//   }
// }
