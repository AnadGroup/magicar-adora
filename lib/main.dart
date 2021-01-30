import 'package:anad_magicar/Routes.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/firebase/message/firebase_message_handler.dart';
import 'package:anad_magicar/firebase/message/message_handler.dart' as msgHdlr;
import 'package:anad_magicar/firebase/notification_service.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart' as msg;
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/service/locator.dart';
import 'package:anad_magicar/ui/screen/home/home.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/utils/check_status_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:google_maps/google_maps.dart' as gm;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fbm;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message != null && message.length > 0) {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];

      final title = data['title'];
      final body = data['body'];
      //  await _showNotificationWithDefaultSound(title, body);
      return null;
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
    }
  }

  return null;
}

showMessage(Map<String, dynamic> message) {
  if (message != null && message.length > 0) {
    String title = message['notification']['title'];
    String messageBody = message['notification']['body'];
    messageBody += '\n' + title;
    // centerRepository.showFancyToast(messageBody, true);
    String data_title = message['data']['title'];
    String data = message['data']['body'];
    if (data != null && data.isNotEmpty) {
      // centerRepository.showFancyToast(data, true);
      if (data_title == 'command') {
        if (Constants.carCommandsInTitlesMap.containsKey(data)) {
          RxBus.post(ChangeEvent(
              type: 'FCM', message: Constants.carCommandsInTitlesMap[data]));
          // if (kIsWeb) {
          //   fcmNoty.updateValue(msg.Message(
          //       text: Constants.carCommandsInTitlesMap[data],
          //       id: 0,
          //       type: 'FCM'));
          // }
          _showNotificationWithDefaultSound(
              title, Constants.carCommandsInTitlesMap[data]);
        } else {
          String carid = message['data']['carId'];
          RxBus.post(ChangeEvent(
              type: 'FCM_STATUS', message: data, id: int.tryParse(carid)));
          // if (kIsWeb) {
          //   fcmNoty.updateValue(msg.Message(
          //       text: data, id: int.tryParse(carid), type: 'FCM_STATUS'));
          // }
        }
      }
    } else {
      RxBus.post(ChangeEvent(type: 'FCM', message: messageBody));
      // if (kIsWeb) {
      //   fcmNoty.updateValue(msg.Message(text: messageBody, id: 0, type: 'FCM'));
      // }
      _showNotificationWithDefaultSound(title, messageBody);
    }
  }
}

Future _showNotificationWithDefaultSound(String title, String message) async {
  /*var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'anad_60', 'anad_channel', 'channel_description',
      importance: Importance.None, priority: Priority.Low);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);*/
  /*await flutterLocalNotificationsPlugin.show(
    0,
    '$title',
    '$message',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );*/
}

Future<void> main() async {
  //final int checkStatusAlarmID = 0;
  //final int checkParkGPSStatusAlarmID = 1;

  WidgetsFlutterBinding.ensureInitialized();
  FireBaseMessageHandler messageHandler;
  setupLocator();
  // ConnectionStatusSingleton connectionStatus =
  //     ConnectionStatusSingleton.getInstance();
  // connectionStatus.initialize();

  if (kIsWeb) {
    messageHandler = msgHdlr.MessageHandler(
      sendMessage: (message) {
        showMessage(message);
      },
    );
    messageHandler.initMessageHandler(MyAppState.theme);
  } else {
    await Firebase.initializeApp();
    messageHandler = msgHdlr.MessageHandler(
      sendMessage: (message) {
        showMessage(message);
      },
    );
    messageHandler.initMessageHandler(MyAppState.theme);
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Routes();
}
