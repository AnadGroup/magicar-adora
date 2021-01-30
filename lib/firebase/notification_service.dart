import 'dart:async';

import 'package:anad_magicar/firebase/firebase/firebase_cloud_messaging_interop.dart';


class NotificationService {
  NotificationService() {
    
    // Direct init
    fcm = FirebaseMessagingWeb(
        publicVapidKey:
            'BGLG5dhijRhC4bh091jcnjyrn9vG21oRelLJwCrLtX38FS2O-8CqWy5wPSr84hXwlTP0f-yMAl4BrdgKF4kqNZY');

    // Deferred init
    // fcm = FirebaseMessagingWeb();
    // fcm.init('YourPublicVapidKey');

    /// Setup callback for whenever a notification is received.
    /// The app must be open inside the navigator for this callback to fire.
    fcm.onMessage((Map notificationData) {
      // do something with notification data
      // final msg = notificationData;
      _controller.add(notificationData);
    });

    /// Whenever the token is refreshed,
    fcm.onTokenRefresh(() async {
      final String token = await fcm.getToken();
      print(token);
      // push token to server
    });
  }
  void close() {
    _controller?.close();
  }

  FirebaseMessagingWeb fcm;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;
  String currentToken;

  /// Ask user for permission
  Future<bool> getPermission() => fcm.requestNotificationPermissions();
  

  /// Delete current user token
  void deleteCurrentToken() => fcm.deleteToken(currentToken);
}
