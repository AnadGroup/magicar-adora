import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';

class MessageExpandPanel extends StatefulWidget {

  ApiMessage message;
  int carId;
  Map<int,List<Map<String,dynamic>>> messages;
  MessageExpandPanel({Key key, this.message,this.messages,this.carId}) : super(key: key);

  @override
  MessageExpandPanelState createState() {
    // TODO: implement createState
    return new MessageExpandPanelState();
  }
}

class MessageExpandPanelState extends State<MessageExpandPanel> {

  bool isRead=false;
  List<ApiMessage> groupedMessages=new List();
  List<int> recIds=new List();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate=false;
  ApiMessage newMessage;
  String messageBody='';
  String messageSubject='';


  Widget createCollapsed(ApiMessage message,int msgCount) {
  return  new Padding(padding: EdgeInsets.only(right: 10.0),
      child:
          Column(
            children: <Widget>[
              createHeader(message),
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(DartHelper.isNullOrEmptyString( msgCount.toString()),style: TextStyle(fontSize: 16.0),)

        ],
      ),
  ],
          ),);

  }

  Widget createExpanded(List<ApiMessage> msgs) {
          return  Container(
            height: 300.0,
            child:
            ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: msgs.length,
              itemBuilder: (context, index) {
                return Card(
            margin: new EdgeInsets.only(
                left: 5.0, right: 5.0, top: 8.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 0.0),
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 0.0,
            child:
                GestureDetector(
                  onTap: () {
                      changeSmsStatus(msgs[index]);
                  },
                  child:
            new Container(
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                color: Color(0xffe0e0e0),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(5.0)),
              ),
              child:
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(right: 10.0),
                    child:
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(Translations.current.messageDate(),
                          style: TextStyle(fontSize: 16.0),),
                        new Padding(
                          padding: EdgeInsets.only(right: 10.0, left: 5.0),
                          child: Text(msgs[index].MessageDate.toString(),
                            style: TextStyle(fontSize: 16.0),
                            overflow: TextOverflow.fade, softWrap: true,),),
                      ],),),
                  new Padding(padding: EdgeInsets.only(right: 10.0),
                    child:
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(right: 10.0, left: 20.0),
                          child:
                          Text(msgs[index].MessageBody, style: TextStyle(
                              fontSize: 16.0),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,),),
                      ],
                    ),),
                  new Padding(padding: EdgeInsets.only(right: 10.0),
                    child:
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          DartHelper.isNullOrEmptyString(msgs[index].Description),
                          style: TextStyle(fontSize: 16.0),),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            ),
            );
                },
            ),
    );
  }

 Widget createHeader(ApiMessage message) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[


      new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
    new Padding(padding: EdgeInsets.only(right: 10.0,left: 10.0),
        child: Text(message.SenderUserTitle ),),
                  new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                    child: Container(
                      width: 22.0,
                      height: 22.0,
                      child:
   ( message.MessageStatusConstId!=ApiMessage.MESSAGE_STATUS_AS_READ_TAG  || !isRead) ?
                      Image.asset('assets/images/unread.png',color: Colors.pinkAccent,) :
                      Image.asset('assets/images/read.png',color: Colors.blueAccent,) ,),),
        new Padding(padding: EdgeInsets.only(right: 10.0,left: 10.0),
          child:
        Text( /*message.MessageStatusConstId!=ApiMessage.MESSAGE_STATUS_AS_READ_TAG ?*/
        message.MessageStatusConstTitle /*: Translations.current.messageRead()*/ ),),

      ],
    ),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                FlatButton(
                  child: Text(Translations.current.replyMessage(),style: TextStyle(color: Colors.white,fontSize: 12.0),),
                  onPressed: (){
                    _showBottomSheetNewMessage(context, message, message.SenderUserId);
                  },),),
            ],
          ),
        ),
      ],
    );

  }

  changeSmsStatus(ApiMessage message) async {
    var result=await restDatasource.changeMessageStatus(message.MessageId, ApiMessage.MESSAGE_STATUS_AS_READ_TAG);
    if(result!=null){
      if(result.IsSuccessful){
        CenterRepository.messageCounts=CenterRepository.messageCounts-1;
        messageCountNoty.updateValue(new Message(index: CenterRepository.messageCounts));
        setState(() {
          isRead=true;
        });
      }
      else
        {
          setState(() {
            isRead=false;
          });
        }
    }
  }

  loadGroupedMessages(Map<int,List<Map<String,dynamic>>> gMsgs) {
    widget.messages.forEach((k,v) {
        recIds..add(k);
    });
  }

  _onMessageSubjectChanged(String value){
    messageSubject=value;
  }

  _onMessageBodyChanged(String value){
    messageBody=value;
  }
  sendMessage(BuildContext context,ApiMessage msg,int recId) async {
    await animated_dialog_box.showScaleAlertBox(
      title:Center(child: Text(Translations.current.sendMessage())) ,
      context: context,
      firstButton: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: Colors.white,
        child: Text(Translations.current.send()),
        onPressed: () {
          sendNewMessage(msg,recId);
        },
      ),
      secondButton: MaterialButton(
        // OPTIONAL BUTTON
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: Colors.white,
        child: Text(Translations.current.cancel()),
        onPressed: () {

          Navigator.of(context).pop();
        },
      ),
      icon: Icon(Icons.message,color: Colors.indigoAccent,),
      yourWidget: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:0),
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height*0.30,
            width: MediaQuery.of(context).size.width,
            child:
            new ListView (
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  //margin: EdgeInsets.symmetric(horizontal: 20.0),
                  children: <Widget>[
                    SizedBox(
                      height: 0,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      width:MediaQuery.of(context).size.width*0.90,
                      child:
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child:
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          child: new Column(
                            children: <Widget>[
                              Container(
                                //height: 45,
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 2.0),
                                child:
                                FormBuilderTextField(
                                  initialValue: '',
                                  attribute: "MessageSubject",
                                  decoration: InputDecoration(
                                    labelText: Translations.current.messageSubject(),
                                  ),
                                  onChanged: (value) => _onMessageSubjectChanged(value),
                                  valueTransformer: (text) => text,
                                  validators: [
                                    FormBuilderValidators.required(),
                                  ],
                                  keyboardType: TextInputType.text,
                                ),

                              ),
                              Container(
                                // height: 45,
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 2.0),
                                child:
                                FormBuilderTextField(
                                  initialValue: '',
                                  attribute: "MessageBody",
                                  decoration: InputDecoration(
                                    labelText: Translations.current.messageBody(),
                                  ),
                                  onChanged: (value) => _onMessageBodyChanged(value),
                                  valueTransformer: (text) => text,
                                  validators: [
                                    FormBuilderValidators.required(),
                                  ],
                                  keyboardType: TextInputType.text,
                                ),
                              ),



                              new GestureDetector(
                                onTap: () {
                                  sendNewMessage(msg,recId);
                                },
                                child:
                                Container(

                                  child:
                                  new SendData(),
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child:
                                Container(
                                  width: 120.0,
                                  height: 40.0,
                                  child:
                                  new Button(title: Translations.current.cancel(),
                                    color: Colors.white.value,
                                    clr: Colors.amber,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheetNewMessage(BuildContext cntext,ApiMessage msg,int recId)
  {
    showModalBottomSheetCustom(context: cntext ,
        mHeight: 0.90,
        builder: (BuildContext context) {
          return Container(
            width: 350.0,
            height: MediaQuery.of(context).size.height*0.90,
            child:
            Stack(
              children: <Widget>[
                new ListView (
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      //margin: EdgeInsets.symmetric(horizontal: 20.0),
                      children: <Widget>[
                        SizedBox(
                          height: 0,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.0),
                          width:MediaQuery.of(context).size.width*0.60,
                          child:
                          Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child:
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              child: new Column(
                                children: <Widget>[

                                  Container(
                                    //height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child:
                                    FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "MessageSubject",
                                      decoration: InputDecoration(
                                        labelText: Translations.current.messageSubject(),
                                      ),
                                      onChanged: (value) => _onMessageSubjectChanged(value),
                                      valueTransformer: (text) => text,
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
                                      keyboardType: TextInputType.text,
                                    ),

                                  ),
                                  Container(
                                    // height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child:
                                    FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "MessageBody",
                                      decoration: InputDecoration(
                                        labelText: Translations.current.messageBody(),
                                      ),
                                      onChanged: (value) => _onMessageBodyChanged(value),
                                      valueTransformer: (text) => text,
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),



                                  new GestureDetector(
                                    onTap: () {
                                      sendNewMessage(msg,recId);
                                    },
                                    child:
                                    Container(

                                      child:
                                      new SendData(),
                                    ),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child:
                                    Container(
                                      width: 130.0,
                                      height: 40.0,
                                      child:
                                      new Button(title: Translations.current.cancel(),
                                        color: Colors.white.value,
                                        clr: Colors.amber,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),


              ],
            ),
          );
        });
  }
  sendNewMessage(ApiMessage bMsg, int recId) async{
   ApiMessage newMessage=new ApiMessage(MessageId: null, MessageBody: messageBody,
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
  void initState() {
    loadGroupedMessages(widget.messages);
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  ListView.builder(
        physics: BouncingScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemCount: widget.messages.length,
    itemBuilder: (context, index) {
          int senderId=recIds[index];
          int unReadItems=0;
          List<Map<String,dynamic>> newList=widget.messages[senderId];
          ApiMessage apiMessage=ApiMessage.fromMap( newList[0]);
          List<ApiMessage> apiMsgs=newList.map<ApiMessage>((m)=>ApiMessage.fromMap(m)).toList();
          var uri=apiMsgs.where((m)=>m.MessageStatusConstId==ApiMessage.MESSAGE_STATUS_AS_READ_TAG).toList();
          unReadItems=uri==null  ? 0 : uri.length;
      return
        ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ScrollOnExpand(
              child: Card(
                color: Colors.blueAccent.withOpacity(0.2),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expandable(
                      collapsed: createCollapsed(apiMessage,newList.length),
                      expanded: createExpanded(apiMsgs),
                    ),

                    Divider(height: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            var controller = ExpandableController.of(context);

                            return FlatButton(
                              child: controller.expanded ? Icon(
                                  Icons.arrow_drop_up) :
                              Icon(Icons.arrow_drop_down_circle),
                              onPressed: () {
                                controller.toggle();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    },
    );
  }
}
