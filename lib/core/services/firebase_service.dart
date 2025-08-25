// import 'dart:async';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get_it/get_it.dart';
// import 'package:go_router/go_router.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FireBaseService {
//   FireBaseService._privateConstructor();

//   /// STATIC FUNC
//   static final FireBaseService _instance =
//       FireBaseService._privateConstructor();

//   static FireBaseService get instance => _instance;

//   static Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     Log.d("FCM: _handleBackgroundMessage");
//     Log.d(message);
//   }

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final StreamController<String> _fcmTokenStreamController =
//       StreamController.broadcast();
//   Stream<String?> get fcmTokenStream => _fcmTokenStreamController.stream;

//   final StreamController<void> _permissionDenyStreamController =
//       StreamController.broadcast();
//   Stream<void> get permissionDenyStream =>
//       _permissionDenyStreamController.stream;

//   /// Instance FUNC
//   Future initialize() async {
//     await _requestPermission();
//     await getTokenDevice();
//     await _listenInBackgroundMode();
//     await _getInitialMessage();

//     /// setup Show alert when app in foreground
//     await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   }

//   Future<void> _requestPermission() async {
//     try {
//       final permission = await Permission.notification.request();

//       if (permission == PermissionStatus.denied ||
//           permission == PermissionStatus.restricted) {
//         final permission = await Permission.notification.request();

//         if (permission.isGranted) {
//           return;
//         }

//         if (permission == PermissionStatus.denied) {
//           _permissionDenyStreamController.sink.add(null);
//         }
//       }
//       var setting = await _firebaseMessaging.getNotificationSettings();

//       switch (setting.authorizationStatus) {
//         case AuthorizationStatus.authorized:
//         case AuthorizationStatus.provisional:
//           return;
//         case AuthorizationStatus.denied:
//         case AuthorizationStatus.notDetermined:
//           setting = await _firebaseMessaging.requestPermission(
//             alert: true,
//             badge: true,
//             provisional: false,
//             sound: true,
//           );
//           break;
//       }
//     } catch (error) {
//       Log.e("FCM: _requestPermission");
//       Log.e(error);
//     }
//   }

//   Future<void> _listenInBackgroundMode() async {
//     try {
//       FirebaseMessaging.onMessage.listen(_showFlutterNotification);
//       FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//     } catch (error) {
//       Log.e("FCM: _listenInBackgroundMode");
//       Log.e(error);
//     }
//   }

//   void _showFlutterNotification(RemoteMessage message) {
//     final context = GetIt.instance<NavigationService>().navigatorContext;
//     context.showSnackBarSuccess(
//         positionTop: true,
//         ontap: (flushbar) {
//           _handleMessage(message);
//         },
//         text:
//             "${message.notification?.title ?? ""} \n${message.notification?.body ?? ""}");
//   }

//   void _handleMessage(RemoteMessage message) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     final context = GetIt.instance<NavigationService>().navigatorContext;
//     if (!context.mounted) {
//       return;
//     }
//     final data = message.data;
//     final directScreen = data['directScreen'] as String?;
//     if (directScreen == null || directScreen.isEmpty) {
//       // GoRouter.of(context).push(RouteUri.historyNotification);
//       return;
//     }
//     GoRouter.of(context).push(directScreen);
//   }

//   Future<void> _getInitialMessage() async {
//     try {
//       RemoteMessage? message =
//           await FirebaseMessaging.instance.getInitialMessage();
//       if (message != null) {
//         Log.d("FirebaseMessaging.instance.getInitialMessage");
//         // HandleNavigateFromNotification.handleNavigate(message.data);
//       }
//     } catch (error) {
//       Log.e("FCM: _getInitialMessage");
//       Log.e(error);
//     }
//   }

//   Future<void> getTokenDevice() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       Log.d("FCM token $token");
//       if (token != null) {
//         final existToken = GetIt.instance
//             .get<SharedPreferencesManager>()
//             .getString(AppConfig.fcmDeviceTokenKey);
//         if (token == existToken) {
//           return;
//         }

//         GetIt.instance.get<SharedPreferencesManager>().putString(
//               AppConfig.fcmDeviceTokenKey,
//               token,
//             );
//         _fcmTokenStreamController.sink.add(token);
//       } else {
//         Log.e("FCM token is null");
//       }
//     } catch (error) {
//       Log.e("FCM token getToken error: $error");
//     }
//   }
// }
