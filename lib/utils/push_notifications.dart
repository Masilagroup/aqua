// // @dart=2.9
// import 'package:aqua/global.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class PushNotificationsManager {
//   PushNotificationsManager._();
//
//   factory PushNotificationsManager() => _instance;
//
//   static final PushNotificationsManager _instance =
//       PushNotificationsManager._();
//
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;
//
//   Future<void> init() async {
//     if (!_initialized) {
//       // For iOS request permission first.
//       firebaseMessaging.requestNotificationPermissions(
//           const IosNotificationSettings(sound: true, badge: true, alert: true));
//       firebaseMessaging.onIosSettingsRegistered
//           .listen((IosNotificationSettings settings) {
//         print("Settings registered: $settings");
//       });
//
//       print("push notifications Initialized");
//       firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print(firebaseMessaging.getToken().toString());
//           print('AQUA - on message $message');
// //          if(isIosPlatform == true) {
// //            Utils.sharedUtils.onTap(title: message["aps"]["alert"]["title"],
// //                message: message["aps"]["alert"]["body"]);
// //          }else{
// //            Utils.sharedUtils.onTap(title: message["notification"]["title"],
// //                message: message["notification"]["body"]);
// //          }
//         },
//         onResume: (Map<String, dynamic> message) async {
//           print('AQUA - on resume $message');
//         },
//         onLaunch: (Map<String, dynamic> message) async {
//           print('AQUA - on launch $message');
//         },
//       );
//
//       // For testing purposes print the Firebase Messaging token
//       await firebaseMessaging.getToken().then((String token) {
//         assert(token != null);
//         pushToken = token;
//         print("FirebaseMessaging token: $token");
//       });
//       print(firebaseMessaging.getToken());
//       firebaseMessaging.subscribeToTopic("updates");
//       _initialized = true;
//     }
//   }
// }
//
// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//   }
//
//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//   }
//
//   // Or do other work.
// }
