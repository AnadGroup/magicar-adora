import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/content_pager/page_container.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_form.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';


class MessageAppPage extends StatefulWidget {
  int carId;
  GlobalKey<ScaffoldState> scaffoldKey;
  MessageAppPage({Key key,this.carId,this.scaffoldKey}) : super(key: key);

  @override
  MessageAppPageState createState() {
    return MessageAppPageState();
  }
}

class MessageAppPageState extends MainPage<MessageAppPage> {

 static final String route='/messageapp';
 final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
 bool _autoValidate=false;
 ApiMessage newMessage;
 String messageBody='';
 String messageSubject='';


 _onMessageSubjectChanged(String value){
   messageSubject=value;
 }

 _onMessageBodyChanged(String value){
   messageBody=value;
 }



 sendNewMessage(int recId) async{
   newMessage=new ApiMessage(MessageId: null, MessageBody: messageBody,
       MessageDate: DateTime.now().toString(), Description: null, MessageSubject: messageSubject,
       MessageTypeConstId: ApiMessage.MESSAGE_TYPE_CONST_ID_TAG,
       CarId: widget.carId ,
       ReceiverUserId: recId,
       MessageStatusConstId: ApiMessage.MESSAGE_STATUS_AS_INSERT_TAG);
   var result=await restDatasource.sendMessage(newMessage);
   if(result!=null )
     {
       if(result.IsSuccessful){
         Navigator.pop(context);
         centerRepository.showFancyToast(Translations.current.messageHasSentSuccessfull(),true);
       }
       else{
         Navigator.pop(context);
         centerRepository.showFancyToast(Translations.current.messageSentUnSuccessfull(),false);
       }
     }
 }
  @override
  void dispose() {
    super.dispose();
  }

 @override
 getScafoldState(int action) {
   // TODO: implement getScafoldState
   if(action==1)
     widget.scaffoldKey.currentState.openDrawer();
   return null;
 }

  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    return null;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return null;
  }
 @override
 bool showMenu() {
   // TODO: implement showMenu
   return false;
 }
  @override
  initialize() {
    // TODO: implement initialize
    scaffoldKey=widget.scaffoldKey;
    return null;
  }
 @override
 bool doBack() {
   // TODO: implement doBack
   return true;
 }

 @override
  Widget pageContent() {
    // TODO: implement pageContent
    return new MessageAppForm(carId: widget.carId,);
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 2;
  }

  @override
  onBack() {
    // TODO: implement onBack
      Navigator.pushNamed(context, '/first');
    return null;
  }

  @override
  bool showBack() {
    // TODO: implement showBack
    return false;
  }

  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return null;
  }
}
