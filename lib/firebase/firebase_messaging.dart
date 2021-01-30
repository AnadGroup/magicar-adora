// import 'dart:async';
// import 'package:anad_magicar/data/rest_ds.dart';
// import 'package:anad_magicar/model/send_command_model.dart';
// import 'package:anad_magicar/repository/pref_repository.dart';
// import 'package:firebase/firebase.dart' as fb;

// class FBMessaging {
//   FBMessaging._();
//   static FBMessaging _instance = FBMessaging._();
//   static FBMessaging get instance => _instance;
//   var _mc;
//   String _token;

//   final _controller = StreamController<Map<String, dynamic>>.broadcast();
//   Stream<Map<String, dynamic>> get stream => _controller.stream;
//   Map<String, dynamic> message = Map();
//   void close() {
//     _controller?.close();
//   }

//   Future<void> init() async {
//     _mc = fb.messaging();
//     // ..usePublicVapidKey(
//     //     'AAAAjlWm8Cw:APA91bGRhf8Hcy3at8VRm2oWGcpqoqukpYGeJNA8ec480rlqsLSZkoSNiiyV4RIduJ6tX0WLNDaF3sJMrAcSOkJQDTy1HC9VEz1gfGVsyu8O3axonX9ZpX7TL5aRVuY3yOa2Ty8auXgh');

//     _token = await getToken();
//     // _mc.onMessage.listen((event) {
//     //   _controller.add(event?.data);
//     // });
//   }

//   static Stream<Map<String, dynamic>> get onMessage =>
//       fb.messaging().onMessage.asyncMap(
//             (payload) => {
//               'notification': {
//                 'title': 'title',
//                 'body': 'payload.notification.body'
//               },
              
//             },
//           );

//   Future requestPermission() {
//     return _mc.requestPermission();
//   }

//   Future<String> getToken([bool force = false]) async {
//     if (force || _token == null) {
//       await requestPermission();
//       _token = await _mc.getToken();
//     }
//     if (_token != null) {
//       prefRepository.setFCMToken(
//         _token,
//       );
//       int userId = await prefRepository.getLoginedUserId();
//       restDatasource.sendFCMToken(userId, _token);
//     }
//     return _token;
//   }
// }
