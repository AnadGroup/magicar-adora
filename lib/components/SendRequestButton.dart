/*
import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/widget_events/ButtonDefinition.dart';
import 'package:anad_magicar/components/BorderedButton.dart';
import 'package:anad_magicar/components/alert_dialog.dart';
import 'package:anad_magicar/components/alert_dialog.dart' as prefix0;
import 'package:anad_magicar/models/viewmodel/request_program_of_coach.dart';
import 'package:anad_magicar/models/viewmodel/send_request_vm.dart';
import 'package:anad_magicar/repository/request/request_repository.dart';
import 'package:anad_magicar/translation_strings.dart';

class SendRequest extends StatefulWidget {

  RequestVM sendModel;

  double w;
  double h;

  SendRequest({this.w, this.h, this.sendModel});

  @override
  SendRequestState createState() {
    return new SendRequestState();
  }
}

class SendRequestState extends State<SendRequest> {


  sendRequest(BuildContext context) {
    onSend(context);
  }

  Future<void> onSend(BuildContext context) async
  {
    if (widget.sendModel != null) {
      requestsRepository.requestVM = widget.sendModel;
      int result = await requestsRepository.update(
          widget.sendModel.requestProgramOfCoach);
      if (result != null && result > 0) {
        Navigator.of(context).popAndPushNamed('/home');
      }
      else {
        MyAlertDialog alertDialog = new MyAlertDialog(
            title: Translations.current.errorInSend(),
            negativeText: Translations.current.exit());
        alertDialog.showMyDialog(context);
      }
    }
  }

  onSelected(ButtonDefinition btnDefinition) {

  }

  @override
  Widget build(BuildContext context) {
    return new BorderedButton(
        widget.w,
        widget.h,
        20.0,
        10.0,
        Translations.current.send(),
        sendRequest(context),
        onSelected(new ButtonDefinition(selectedId: 3,
            selectedTitle: Translations.current.send(),
            taskId: 3,
            message: "SENDREQUEST"))); */
/*Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: const Color(0x883949ab),
        borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
      ),
      child: new Text(
        Translations.of(context).login(),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    )*//*

  }

  @override
  void initState() {
    super.initState();
  }

}*/
