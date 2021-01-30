import 'package:anad_magicar/firebase/message/firebase_message_handler.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/widgets/dialog/android_alert_dialog.dart';
import 'package:anad_magicar/widgets/dialog/base_dialog.dart';
import 'package:anad_magicar/widgets/dialog/ios_alert_dialog.dart';
import 'package:flutter/material.dart';

class MessageHandler extends FireBaseMessageHandler<dynamic> {
  BuildContext context;
  Function sendMessage;

  MessageHandler({ this.context, @required this.sendMessage});

  final List<CustomDialog> customDialogList = [
    AndroidAlertDialog(),
    IosAlertDialog(),
  ];

  CustomDialog customDialog;
  int _selectedDialogIndex = 0;

  @override
  hasToken(bool hasToken, String token) {
    if (hasToken) {
      prefRepository.setFCMToken(
        token,
      );
    }
    return hasToken;
  }

  @override
  onLaunch(Map<String, dynamic> message) {
   
    /*if(message!=null && message.length>0) {
      if (message['data'] != null) {
        String title = message['data']['title'];
        String messageBody = message['data']['body'];
        //_showNotificationWithDefaultSound(title, messageBody);
      }
    }*/
    return null;
  }

  @override
  onResume(Map<String, dynamic> message) {
   
    /* if(message!=null && message.length>0) {
      if (message['data'] != null) {
        String title = message['data']['title'];
        String messageBody = message['data']['body'];
        // _showNotificationWithDefaultSound(title, messageBody);
      }
    }*/
    return null;
  }

  @override
  showMessage(Map<String, dynamic> message) {

    String title = message['data']['title'];
    String messageBody = message['data']['body'];
    sendMessage(message);
   
    return null;
  }
}
