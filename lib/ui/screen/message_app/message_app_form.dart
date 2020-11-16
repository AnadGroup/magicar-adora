import 'dart:collection';

import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/pull_refresh/pull_to_refresh.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_item.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";
class MessageAppForm extends StatefulWidget {
  int carId;
  MessageAppForm({Key key,this.carId}) : super(key: key);

  @override
  _MessageAppFormState createState() {
    return _MessageAppFormState();
  }
}

class _MessageAppFormState extends State<MessageAppForm> {


  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<int> senderIds=new List();
  Future<List<ApiMessage>> fMessages;
  List<ApiMessage> messages=new List();
  List<Map<String,dynamic>> mapList=new List();

  HashMap<int,List<ApiMessage>> recMessages=new HashMap();

  Future<List<ApiMessage>> getMessages() {
    var result=restDatasource.getUserMessage();
    if(result!=null ) {
      return result;
    }
    return null;
  }


  Future<List<ApiMessage>> refreshMessageApp() async{
   getMessages();
  }


  loadGroupedMessages(Map<int,List<Map<String,dynamic>>> gMsgs) {
    gMsgs.forEach((k,v) {
      senderIds..add(k);
    });
  }

  @override
  void initState() {
    super.initState();

    fMessages=getMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Padding(padding: EdgeInsets.only(top: 70.0),
    child:
      Container(
      child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          enablePullDown: true,
          physics: BouncingScrollPhysics(),
          footer: MaterialClassicHeader(
            color: Theme.of(context).indicatorColor,
            height: 10.0,
            backgroundColor: Theme.of(context).backgroundColor,
            //loadStyle: LoadStyle.ShowWhenLoading,
            //completeDuration: Duration(milliseconds: 500),
          ),
          header: WaterDropMaterialHeader(),
          onRefresh: () async {
            //monitor fetch data from network
            await Future.delayed(Duration(milliseconds: 1000));

            var result=   await refreshMessageApp();
            if (mounted) setState(() {});
            if(result==null)
              _refreshController.refreshFailed();
            else
              _refreshController.refreshCompleted();
          },
          onLoading:() async {
            await Future.delayed(Duration(milliseconds: 1000));
            var result= await refreshMessageApp();
            if (mounted) setState(() {});
            if(result==null)
              _refreshController.loadFailed();
            else
              _refreshController.loadComplete();
          },
          child: ListView.builder(
          padding: EdgeInsets.only(top:1.0), //kMaterialListPadding,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index)
      {
        return FutureBuilder<List<ApiMessage>>(
      future: fMessages,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null) {
          messages = snapshot.data;
          mapList=messages.map((m)=>m.toMap()).toList();
         Map<int,List<Map<String,dynamic>>> recIds=groupBy(mapList,(o)=>o['SenderUserId']);
          loadGroupedMessages(recIds);
    return new Padding(
              padding: EdgeInsets.only(top: 0.0,right: 10.0,left: 10.0),
        child:
    Container(
      height: MediaQuery.of(context).size.height*0.95,
      child:
      ListView.builder(
    physics: BouncingScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemCount: recIds.length,
    itemBuilder: (context, index) {

        int senderId=senderIds[index];
        int unReadItems=0;
        //پیامهای فرستنده
        List<Map<String,dynamic>> newList=recIds[senderId];
        ApiMessage apiMessage=ApiMessage.fromMap( newList[0]);
        List<ApiMessage> apiMsgs=newList.map<ApiMessage>((m)=>ApiMessage.fromMap(m)).toList();
        var uri=apiMsgs.where((m)=>m.MessageStatusConstId!=ApiMessage.MESSAGE_STATUS_AS_READ_TAG).toList();
        unReadItems=uri==null ? 0 : uri.length;

        return
            MessageAppItem(carId: widget.carId,
              message: apiMessage,
              messagesCount: unReadItems,
              messageList: apiMsgs,
              senderId: senderId,);
        },
    ),
    ),
        );
        } else {
          return NoDataWidget(noCarCount: false,);
        }
      },
    );
    },
          ),
      ),
      ),
      );
  }
}



