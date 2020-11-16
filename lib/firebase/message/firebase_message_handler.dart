import 'dart:async';

import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
// print('AppPushs myBackgroundMessageHandler : $message');
  if (message != null && message.length > 0) {
    String title = message['notification']['title'];
    String messageBody = message['notification']['body'];
    messageBody += '\n' + title;
    String data_title = message['data']['title'];
    String data = message['data']['body'];
    if (data != null && data.isNotEmpty) {
      if (data_title == 'command') {
        if (Constants.carCommandsInTitlesMap.containsKey(data)) {
          RxBus.post(new ChangeEvent(
              type: 'FCM', message: Constants.carCommandsInTitlesMap[data]));
          _showNotificationWithDefaultSound(
              title, Constants.carCommandsInTitlesMap[data]);
        } else {
          String carid = message['data']['carId'];
          RxBus.post(new ChangeEvent(
              type: 'FCM_STATUS', message: data, id: int.tryParse(carid)));
        }
      }
    } else {
      RxBus.post(new ChangeEvent(type: 'FCM', message: messageBody));
      _showNotificationWithDefaultSound(title, messageBody);
    }
  }
  return null; /*Future<void>.value();*/
}

Future _showNotificationWithDefaultSound(String title, String message) async {
  //  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'anad_60', 'anad_channel', 'channel_description',
  //     importance: Importance.None, priority: Priority.Low);
  //  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  // var platformChannelSpecifics = NotificationDetails(
  //     androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //  await flutterLocalNotificationsPlugin.show(
  //   0,
  //   '$title',
  //   '$message',
  //   platformChannelSpecifics,
  //   payload: 'Default_Sound',
  // );
}

abstract class FireBaseMessageHandler<T> {
  showMessage(Map<String, dynamic> message);
  onLaunch(Map<String, dynamic> message);
  onResume(Map<String, dynamic> message);
  hasToken(bool hasToken, String token);

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  Future<String> getClientToken() async {
    String fcmToken = await _fcm.getToken();
    hasToken((fcmToken != null && fcmToken.isNotEmpty), fcmToken);
    return fcmToken;
  }

  void initMessageHandler(theme) {
    Constants.createCarCommandInTitlesMap();
    getClientToken();
    // if (theme.platform == TargetPlatform.iOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});

    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showMessage(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        onLaunch(message);
      },
      onResume: (Map<String, dynamic> message) async {
        onResume(message);
      },
    );
  }
}
