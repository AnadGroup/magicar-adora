import 'dart:collection';

import 'package:anad_magicar/bloc/values/notify_value.dart';
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
import 'package:anad_magicar/ui/screen/message_app/message_expandable_panel.dart';
import 'package:anad_magicar/ui/screen/service/fancy_service/src/widgets/expandable_container.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/components/no_data_widget.dart';

class MessageAppItem extends StatefulWidget {
  ApiMessage message;
  int carId;
  int messagesCount;
  int senderId;
  Map<int, List<Map<String, dynamic>>> messages;
  List<ApiMessage> messageList;
  MessageAppItem(
      {Key key,
      this.message,
      this.messages,
      this.carId,
      this.senderId,
      this.messagesCount,
      this.messageList})
      : super(key: key);

  @override
  _MessageAppItemState createState() {
    return _MessageAppItemState();
  }
}

class _MessageAppItemState extends State<MessageAppItem>
    with TickerProviderStateMixin {
  int msgCount;
  AnimationController panelController;
  List<int> senderIds = new List();
  Future<List<ApiMessage>> fMessages;
  List<ApiMessage> messages = new List();
  List<Map<String, dynamic>> mapList = new List();

  HashMap<int, List<ApiMessage>> recMessages = new HashMap();
  Future<List<ApiMessage>> getMessages() {
    var result = restDatasource.getUserMessage();
    if (result != null) {
      return result;
    }
    return null;
  }

  Future<List<ApiMessage>> refreshMessageApp() async {
    getMessages();
  }

  loadGroupedMessages(Map<int, List<Map<String, dynamic>>> gMsgs) {
    gMsgs.forEach((k, v) {
      senderIds..add(k);
    });
  }

  @override
  void initState() {
    msgCount = widget.messagesCount;
    super.initState();

    panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return HorizontalListItem(
      messageList: widget.messageList,
      senderId: widget.senderId,
      item: widget.message,
      messageCount: widget.messagesCount,
      panelController: panelController,
    ); /*MessageExpandPanel(messages: widget.messages,carId: widget.carId,);*/
  }
}

class HorizontalListItem extends StatefulWidget {
  HorizontalListItem(
      {this.item,
      this.messageCount,
      this.panelController,
      this.messageList,
      this.senderId});
  final ApiMessage item;
  final int messageCount;
  final int senderId;
  AnimationController panelController;
  List<ApiMessage> messageList;
  @override
  HorizontalListItemState createState() {
    // TODO: implement createState
    return HorizontalListItemState();
  }
}

class HorizontalListItemState extends State<HorizontalListItem> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  bool isExpanded = false;
  String messageBody = '';
  String messageSubject = '';
  Color readColors = Colors.pinkAccent.withOpacity(0.5);
  int msgRead = 0;
  int msgCount;
  NotyBloc<Message> statusMessageNoty;
  NotyBloc<Message> changeStatusNoty;
  changeSmsStatus(ApiMessage message) async {
    var result = await restDatasource.changeMessageStatus(
        message.MessageId, ApiMessage.MESSAGE_STATUS_AS_READ_TAG);
    if (result != null) {
      if (result.IsSuccessful) {
        statusMessageNoty.updateValue(
            new Message(type: 'MSG_READ', index: message.MessageId));
        CenterRepository.messageCounts = CenterRepository.messageCounts - 1;
        messageCountNoty
            .updateValue(new Message(index: CenterRepository.messageCounts));
      } else {}
    }
  }

  @override
  void initState() {
    super.initState();
    statusMessageNoty = new NotyBloc<Message>();
    changeStatusNoty = new NotyBloc<Message>();
    msgCount = widget.messageCount;
  }

  _onMessageBodyChanged(String value) {
    messageBody = value;
  }

  _showBottomSheetNewMessage(BuildContext cntext, ApiMessage msg, int recId) {
    showModalBottomSheetCustom(
        context: cntext,
        mHeight: 0.90,
        builder: (BuildContext context) {
          return Container(
            width: 350.0,
            height: MediaQuery.of(context).size.height * 0.90,
            child: Stack(
              children: <Widget>[
                new ListView(
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
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              child: new Column(
                                children: <Widget>[
                                  Container(
                                    // height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child: FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "MessageBody",
                                      decoration: InputDecoration(
                                        labelText:
                                            Translations.current.messageBody(),
                                      ),
                                      onChanged: (value) =>
                                          _onMessageBodyChanged(value),
                                      valueTransformer: (text) => text,
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      sendNewMessage(msg, recId);
                                    },
                                    child: Container(
                                      child: new SendData(),
                                    ),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 130.0,
                                      height: 40.0,
                                      child: new Button(
                                        title: Translations.current.cancel(),
                                        color: Colors.white.value,
                                        clr: Colors.amber,
                                      ),
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

  _showBottomSheetListMessages(
      BuildContext context, List<ApiMessage> msgs, int recId) {
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.80,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: msgs.length,
              itemBuilder: (context, index) {
                return StreamBuilder<Message>(
                  stream: statusMessageNoty.noty,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data.type == 'MSG_READ') {
                        readColors = Colors.green.withOpacity(0.5);
                        msgRead = snapshot.data.index;
                        msgCount--;
                      }
                    }
                    return Card(
                      margin: new EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 8.0, bottom: 5.0),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 0.0),
                          borderRadius: BorderRadius.circular(8.0)),
                      elevation: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          changeSmsStatus(msgs[index]);
                        },
                        child: new Container(
                          alignment: Alignment.center,
                          decoration: new BoxDecoration(
                            color: readColors,
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(5.0)),
                          ),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      Translations.current.messageDate(),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.0, left: 5.0),
                                      child: Text(
                                        msgs[index].MessageDate.toString(),
                                        style: TextStyle(fontSize: 16.0),
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.0, left: 20.0),
                                      child: Text(
                                        msgs[index].MessageBody,
                                        style: TextStyle(fontSize: 16.0),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      DartHelper.isNullOrEmptyString(
                                          msgs[index].Description),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        });
  }

  sendNewMessage(ApiMessage bMsg, int recId) async {
    ApiMessage newMessage = new ApiMessage(
        MessageId: null,
        MessageBody: messageBody,
        MessageDate: DateTime.now().toString(),
        Description: null,
        MessageSubject: messageSubject,
        MessageTypeConstId: ApiMessage.MESSAGE_TYPE_CONST_ID_TAG,
        CarId: bMsg.CarId,
        ReceiverUserId: recId,
        MessageStatusConstId: ApiMessage.MESSAGE_STATUS_AS_INSERT_TAG);
    var result = await restDatasource.sendMessage(newMessage);
    if (result != null) {
      if (result.IsSuccessful) {
        Navigator.pop(context);
        centerRepository.showFancyToast(
            Translations.current.messageHasSentSuccessfull(), true);
      } else {
        Navigator.pop(context);
        centerRepository.showFancyToast(
            Translations.current.messageSentUnSuccessfull(), false);
      }
    }
  }

  Widget senderImage() {
    String renderUrl = 'assets/images/user_profile.png';
    var programAvatar = new Hero(
      tag: widget.item.SenderUserId,
      child: new Container(
        width: 50.0,
        height: 50.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage(renderUrl ?? ''),
          ),
        ),
      ),
    );

    var placeholder = new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          ),
        ),
        alignment: Alignment.center,
        child: new Text(
          'MYMESSAGE',
          textAlign: TextAlign.center,
        ));

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: programAvatar,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  Widget get messageCard {
    return new Positioned(
      right: 0.0,
      top: 0.0,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/messageappdetail',
              arguments: new MessageDetailVM(
                  senderId: widget.senderId,
                  messages: widget.messageList,
                  changeStatusNoty: changeStatusNoty));
          /*_showBottomSheetListMessages(context,  widget.messageList, widget.senderId);*/
        },
        child: new Container(
          margin: EdgeInsets.all(3.0),
          width: MediaQuery.of(context).size.width - 50.0,
          height: 90.0,
          child: new Card(
            margin: EdgeInsets.only(top: 10.0, bottom: 18.0),
            color: Color(0x100288D1),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)),
            ),
            child: new Padding(
              padding: const EdgeInsets.only(
                top: 2.0,
                bottom: 0.0,
                left: 2.0,
              ),
              child: new Container(
                constraints: new BoxConstraints.expand(
                  height: 50.0,
                ),
                padding:
                    new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
                decoration: new BoxDecoration(),
                child: new Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    new Positioned(
                      right: 40.0,
                      top: 5.0,
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(widget.item.SenderUserTitle),
                          ]),
                    ),
                    new Positioned(
                        right: 40.0,
                        top: 30.0,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                widget.item.MessageDate,
                                style: new TextStyle(
                                    color: Colors.blueAccent[100],
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ])),
                    new Positioned(
                        left: 0.0,
                        bottom: -30.0,
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            /* Padding(
                            padding: EdgeInsets.only(
                                left: 8.0,
                                bottom: 0.0,
                                right: 8.0,
                                top: 0.0
                            ),
                            child: new Icon(Icons.message,color: Colors.pinkAccent,size: 30.0,),
                          ),*/
                            /*  Padding(
                            padding: EdgeInsets.only(
                                left: 8.0,
                                bottom: 0.0,
                                right: 8.0,
                                top: 0.0
                            ),
                            child: new Icon(Icons.thumb_up,color: Colors.amber[200],size: 30.0,),
                          ),*/
                            FlatButton(
                              onPressed: () {
                                _showBottomSheetNewMessage(context, widget.item,
                                    widget.item.SenderUserId);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    bottom: 0.0,
                                    right: 2.0,
                                    top: 0.0),
                                child: new Icon(
                                  Icons.add_comment,
                                  color: Colors.black45,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            msgCount != null && msgCount > 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.0,
                                        bottom: 0.0,
                                        right: 2.0,
                                        top: 0.0),
                                    child: Container(
                                      width: 58.0,
                                      height: 58.0,
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                            top: 5.0,
                                            left: 12,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 18.0,
                                                  bottom: 10.0,
                                                  right: 0.0,
                                                  top: 0.0),
                                              child: CircleAvatar(
                                                minRadius: 10.0,
                                                maxRadius: 10.0,
                                                backgroundColor:
                                                    Colors.pinkAccent,
                                                child: new Text(
                                                  msgCount.toString(),
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10.0,
                                            left: 12,
                                            child: Container(
                                              width: 38.0,
                                              height: 38.0,
                                              child: new Image.asset(
                                                'assets/images/new_msg.png',
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                : Container(),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(top: 10.0, right: 0.0, left: 0.0),
      child: new Container(
        height: 100.0,
        child: StreamBuilder(
          stream: changeStatusNoty.noty,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              Message msg = snapshot.data;
              int messageId = msg.index;
              int itemFound = widget.messageList
                  .indexWhere((m) => m.MessageId == messageId);
              if (itemFound != null && itemFound > -1) {
                widget.messageList[itemFound].MessageStatusConstId =
                    ApiMessage.MESSAGE_STATUS_AS_READ_TAG;
                if (msgCount > 1) {
                  msgCount--;
                }
              }
            }
            return widget.messageList == null || widget.messageList.isEmpty
                ? NoDataWidget(
                    noCarCount: false,
                  )
                : new Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      messageCard,
                      new Positioned(
                        top: 10.0,
                        right: 5.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/messageappdetail',
                                arguments: new MessageDetailVM(
                                    messages: widget.messageList,
                                    senderId: widget.senderId,
                                    changeStatusNoty: changeStatusNoty));
                            /*_showBottomSheetListMessages(context,  widget.messageList, widget.senderId);*/
                          },
                          child: senderImage(),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class MessageDetailVM {
  List<ApiMessage> messages;
  NotyBloc<Message> changeStatusNoty;
  int senderId;
  List<int> deletedIds = List();
  MessageDetailVM({
    @required this.senderId,
    @required this.messages,
    @required this.deletedIds,
    @required this.changeStatusNoty,
  });
}
