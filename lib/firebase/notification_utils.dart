// import 'package:firebase/firebase.dart' as fb;

// abstract class NotificationConfigUtils {
//   static requestNotificationPermissions(
//       {String webVapidKey, Function(String) onToken}) async {
//     final messaging = fb.messaging();
//    // messaging.usePublicVapidKey(webVapidKey);
//     try {
//       await messaging.requestPermission();
//       onToken(await messaging.getToken());
//     } catch (e) {
//       print("error");
//       print(e.toString());
//     }
//   }

//   static Stream<Map<String, dynamic>>  get onMessage => fb.messaging().onMessage.asyncMap(
//         (payload) => {
//       'notification': {
//         'title': payload.notification.title,
//         'body': payload..notification.body
//       },
//     },
//   );

//   static Stream<String> get onTokenRefresh =>
//       fb.messaging().onTokenRefresh.asyncMap((event) async {
//         return await fb.messaging().getToken();
//       });
// }