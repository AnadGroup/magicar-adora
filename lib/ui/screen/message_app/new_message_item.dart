import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_form.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_item.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import '../../../translation_strings.dart';
import 'package:anad_magicar/components/no_data_widget.dart';

class NewMessageItem extends StatefulWidget {
  MessageDetailVM detailVM;
  NewMessageItem({Key key, this.detailVM}) : super(key: key);

  @override
  _NewMessageItemState createState() {
    return _NewMessageItemState();
  }
}

class _NewMessageItemState extends State<NewMessageItem> {
  String messageBody = '';
  String messageSubject = '';
  Color readColors = Colors.pinkAccent.withOpacity(0.5);
  int msgRead = 0;
  int msgCount;
  NotyBloc<Message> statusMessageNoty;
  NotyBloc<Message> deleteMessageNoty;

  List<int> selectedIds = new List();
  String tick_url = 'assets/images/tick.png';
  @override
  void initState() {
    super.initState();
    statusMessageNoty = new NotyBloc<Message>();
    deleteMessageNoty = new NotyBloc<Message>();

    msgCount = widget.detailVM.messages.length;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.detailVM.messages != null &&
          widget.detailVM.messages.isNotEmpty) {
        int index = 0;
        for (ApiMessage msg in widget.detailVM.messages) {
          if (msg.MessageStatusConstId !=
              ApiMessage.MESSAGE_STATUS_AS_READ_TAG) {
            changeSmsStatus(msg, index);
          }
          index++;
        }
      }
    });
  }

  @override
  void dispose() {
    statusMessageNoty.dispose();
    super.dispose();
  }

  changeSmsStatus(ApiMessage message, int index) async {
    if (message.MessageStatusConstId != ApiMessage.MESSAGE_STATUS_AS_READ_TAG) {
      var result = await restDatasource.changeMessageStatus(
          message.MessageId, ApiMessage.MESSAGE_STATUS_AS_READ_TAG);
      if (result != null) {
        if (result.IsSuccessful) {
          widget.detailVM.changeStatusNoty.updateValue(Message(
              type: 'STATUS_CHANGED_AS_READ', index: message.MessageId));
          statusMessageNoty
              .updateValue(new Message(type: 'MSG_READ', index: index));
          CenterRepository.messageCounts = CenterRepository.messageCounts - 1;
          messageCountNoty
              .updateValue(new Message(index: CenterRepository.messageCounts));
        } else {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder<Message>(
          stream: deleteMessageNoty.noty,
          builder: (context, snapshot) {
            bool hasSelected = false;
            if (snapshot.hasData && snapshot.data != null) {
              var msg = snapshot.data;
              if (msg.type == 'ITEM_SELECTED') {
                if (msg.status) {
                  hasSelected = true;
                } else {
                  hasSelected = false;
                }
              }
              if (msg.type == 'DELETED_SUCCEED') {}
            }
            return Padding(
              padding: EdgeInsets.only(top: 5.0, right: 1.0, left: 1.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 70.0,
                    child: AppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: true,
                      iconTheme: IconThemeData(color: Colors.indigoAccent),
                      title: null,
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      actions: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                                width: 32.0,
                                height: 32.0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.indigoAccent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ))),
                        hasSelected
                            ? Container(
                                width: 28,
                                height: 28.0,
                                child: FlatButton(
                                  onPressed: () async {
                                    var result = await restDatasource
                                        .deleteUserMessage(selectedIds);
                                    if (result != null && result.IsSuccessful) {
                                      centerRepository.showFancyToast(
                                          'عملیات حذف با موفقیت انجام شد',
                                          true);
                                      for (var i = 0;
                                          i < selectedIds.length;
                                          i++)
                                        widget.detailVM.messages.removeWhere(
                                            (e) =>
                                                e.MessageId == selectedIds[i]);

                                      deleteMessageNoty.updateValue(Message(
                                        type: 'DELETED_SUCCEED',
                                      ));
                                      if (widget.detailVM.messages == null ||
                                          widget.detailVM.messages.isEmpty) {
                                        updateListMessageNoty.updateValue(
                                            Message(
                                                type:
                                                    'DELETED_SUCCEED_EMPTY_LIST',
                                                id: widget.detailVM.senderId));
                                      } else {
                                        Message msg = Message(
                                            type: 'DELETED_SUCCEED',
                                            id: widget.detailVM.senderId);
                                        msg.Ids = List()..addAll(selectedIds);
                                        updateListMessageNoty.updateValue(msg);
                                      }
                                      selectedIds..clear();
                                    } else {
                                      centerRepository.showFancyToast(
                                          'عملیات حذف با موفقیت انجام نشد',
                                          false);
                                    }
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  widget.detailVM.messages == null ||
                          widget.detailVM.messages.isEmpty
                      ? NoDataWidget(
                          noCarCount: false,
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.80,
                          width: MediaQuery.of(context).size.width * 0.99,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: widget.detailVM.messages.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<Message>(
                                stream: statusMessageNoty.noty,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    if (snapshot.data.type == 'MSG_READ') {
                                      msgCount > 1 ? msgCount-- : msgCount = 0;
                                      readColors = Colors.green;
                                      msgRead = snapshot.data.index;
                                      tick_url = 'assets/images/d_tick.png';

                                      widget.detailVM.messages[msgRead]
                                              .MessageStatusConstId =
                                          ApiMessage.MESSAGE_STATUS_AS_READ_TAG;
                                    }
                                  } else {
                                    if (widget.detailVM.messages[index]
                                            .MessageStatusConstId ==
                                        ApiMessage.MESSAGE_STATUS_AS_READ_TAG) {
                                      readColors = Colors.green;
                                      tick_url = 'assets/images/d_tick.png';
                                    } else {
                                      readColors = Colors.grey;
                                      tick_url = 'assets/images/tick.png';
                                    }
                                  }
                                  return Card(
                                    margin: new EdgeInsets.only(
                                        left: 1.0,
                                        right: 1.0,
                                        top: 8.0,
                                        bottom: 5.0),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white, width: 0.0),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    elevation: 0.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        changeSmsStatus(
                                            widget.detailVM.messages[index],
                                            index);
                                      },
                                      child: new Container(
                                        alignment: Alignment.center,
                                        decoration: new BoxDecoration(
                                          //color: ,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(5.0)),
                                        ),
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Padding(
                                              padding:
                                                  EdgeInsets.only(right: 0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0,
                                                        left: 20.0),
                                                    child: Checkbox(
                                                      onChanged: (value) {
                                                        widget
                                                            .detailVM
                                                            .messages[index]
                                                            .selected = value;
                                                        if (value) {
                                                          if (!selectedIds
                                                              .contains(widget
                                                                  .detailVM
                                                                  .messages[
                                                                      index]
                                                                  .MessageId)) {
                                                            selectedIds
                                                              ..add(widget
                                                                  .detailVM
                                                                  .messages[
                                                                      index]
                                                                  .MessageId);
                                                            if (selectedIds !=
                                                                    null &&
                                                                selectedIds
                                                                    .isNotEmpty) {
                                                              deleteMessageNoty
                                                                  .updateValue(Message(
                                                                      type:
                                                                          'ITEM_SELECTED',
                                                                      status:
                                                                          true));
                                                            }
                                                          }
                                                        } else {
                                                          if (selectedIds !=
                                                                  null &&
                                                              selectedIds
                                                                  .isNotEmpty) {
                                                            if (selectedIds
                                                                .contains(widget
                                                                    .detailVM
                                                                    .messages[
                                                                        index]
                                                                    .MessageId)) {
                                                              selectedIds
                                                                  .remove(widget
                                                                      .detailVM
                                                                      .messages[
                                                                          index]
                                                                      .MessageId);
                                                              if (selectedIds ==
                                                                      null ||
                                                                  selectedIds
                                                                      .isEmpty) {
                                                                deleteMessageNoty
                                                                    .updateValue(Message(
                                                                        type:
                                                                            'ITEM_SELECTED',
                                                                        status:
                                                                            false));
                                                              } else {
                                                                deleteMessageNoty
                                                                    .updateValue(Message(
                                                                        type:
                                                                            'ITEM_SELECTED',
                                                                        status:
                                                                            true));
                                                              }
                                                            }
                                                          }
                                                        }
                                                      },
                                                      value: widget
                                                          .detailVM
                                                          .messages[index]
                                                          .selected,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        Translations.current
                                                            .messageDate(),
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      new Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 30,
                                                                left: 0.0),
                                                        child: Text(
                                                          DartHelper
                                                              .isNullOrEmptyString(
                                                                  widget
                                                                      .detailVM
                                                                      .messages[
                                                                          index]
                                                                      .MessageDate),
                                                          style: TextStyle(
                                                              fontSize: 14.0),
                                                          overflow:
                                                              TextOverflow.fade,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Padding(
                                              padding:
                                                  EdgeInsets.only(right: 0.0),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  new Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 0.0, left: 0.0),
                                                    child: Text(
                                                      DartHelper
                                                          .isNullOrEmptyString(
                                                              widget
                                                                  .detailVM
                                                                  .messages[
                                                                      index]
                                                                  .MessageBody),
                                                      style: TextStyle(
                                                          fontSize: 14.0),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Padding(
                                              padding:
                                                  EdgeInsets.only(right: 0.0),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    DartHelper
                                                        .isNullOrEmptyString(
                                                            widget
                                                                .detailVM
                                                                .messages[index]
                                                                .Description),
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Padding(
                                              padding:
                                                  EdgeInsets.only(right: 0.0),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      child: (widget
                                                                  .detailVM
                                                                  .messages[
                                                                      index]
                                                                  .MessageStatusConstId ==
                                                              ApiMessage
                                                                  .MESSAGE_STATUS_AS_READ_TAG)
                                                          ? Image.asset(
                                                              'assets/images/d_tick.png',
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          : Image.asset(
                                                              'assets/images/tick.png',
                                                              color:
                                                                  Colors.grey,
                                                            )),
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
                        ),
                ],
              ),
            );
          }),
    );
  }
}
