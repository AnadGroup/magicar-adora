import 'package:flutter/material.dart';
import 'app.dart';
import 'flavors.dart';
import 'package:anad_magicar/Routes.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/firebase/message/firebase_message_handler.dart';
import 'package:anad_magicar/firebase/message/message_handler.dart' as msgHdlr;
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/service/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/*Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async{
   if(message!=null && message.length > 0) {
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
}*/

showMessage(Map<String, dynamic> message) {
  if (message != null && message.length > 0) {
    String title = message['notification']['title'];
    String messageBody = message['notification']['body'];
    messageBody += '\n' + title;
    String data_title = message['data']['title'];
    String data = message['data']['body'];
    if (data != null && data.isNotEmpty) {
      if (data_title == 'command') {
        if (Constants.carCommandsInTitlesMap.containsKey(data)) {
          RxBus.post(ChangeEvent(
              type: 'FCM', message: Constants.carCommandsInTitlesMap[data]));
          _showNotificationWithDefaultSound(
              title, Constants.carCommandsInTitlesMap[data]);
        } else {
          String carid = message['data']['carId'];
          RxBus.post(ChangeEvent(
              type: 'FCM_STATUS', message: data, id: int.tryParse(carid)));
        }
      }
    } else {
      RxBus.post(ChangeEvent(type: 'FCM', message: messageBody));
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
  F.appFlavor = Flavor.ADORA;
   WidgetsFlutterBinding.ensureInitialized();
  FireBaseMessageHandler messageHandler;
  setupLocator();
  /*ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();*/

  messageHandler = msgHdlr.MessageHandler(
    sendMessage: (message) {
      showMessage(message);
    },
  );
  messageHandler.initMessageHandler(MyAppState.theme);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Routes();
}
