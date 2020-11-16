
import 'package:flutter/material.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyProgressDialog  {
  MyProgressDialog({this.context, this.message, this.showPercentage});

  bool showPercentage = true;
  String message;
 // String progressMessage;
  BuildContext context;
  /*@override
  ProgressDialogState createState() {
    return new ProgressDialogState();
  }

}
class ProgressDialogState extends State<MyProgressDialog>
{*/
  ProgressDialog pr;
  String updateMessage='';

  /*@override
  Widget build(BuildContext context) {

    return null;
  }*/

  setStyle()
  {
    pr.style(
        message: message,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
  }
  updateProgress(String progressMessage,double percentage) {
    pr.update(
      progress: percentage,
      message: progressMessage ,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }
 /* @override
  void initState() {
    super.initState();
*/

 init() {
    if(showPercentage) {
      pr = new ProgressDialog(context, type: ProgressDialogType.Download,
          isDismissible:   false,
          showLogs: true );
    }
    else
      {
        pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
      }

    RxBus.register<ChangeEvent>().listen((onData) {
      if(onData!=null ) {
        updateMessage = onData.message;
        updateProgress(updateMessage,onData.amount);
      }
    });
  }

  ProgressDialog getDialog()
  {
    return pr;
  }
   showProgressDialog() {
     if (pr == null ||
         !pr.isShowing())
       init();
     pr.show();
   }

   hideProgressDialog()
   {
     if(pr.isShowing())
      pr.hide();
   }
}
