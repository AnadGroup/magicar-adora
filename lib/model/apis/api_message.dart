import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/date/helper/src/jalali/jalali_date.dart';
import 'package:flutter/material.dart';

class ApiMessage {

  static final int MESSAGE_STATUS_AS_READ_TAG=152373;
  static final int MESSAGE_STATUS_AS_INSERT_TAG=152360;
  static final int MESSAGE_TYPE_CONST_ID_TAG=152355;

  int MessageId;
  String MessageBody;
  String MessageDate;
  String Description;
  String MessageSubject;
  int MessageStatusConstId;
  int MessageTypeConstId;
  int CarId;
  int ReceiverUserId;
  int SenderUserId;
  String SenderUserTitle;
  String MessageStatusConstTitle;
  bool IsActive;
  int RowStateType;
  bool selected;
  ApiMessage({
    @required this.MessageId,
    @required this.MessageBody,
    @required this.MessageDate,
    @required this.Description,
    @required this.MessageSubject,
    @required this.MessageStatusConstId,
    @required this.ReceiverUserId,
    @required this.CarId,
    @required this.MessageTypeConstId,
    @required this.RowStateType,
    @required this.IsActive,
    @required this.SenderUserId,
    @required this.SenderUserTitle,
    @required this.MessageStatusConstTitle,
    this.selected=false,
  });




  factory ApiMessage.fromJson(Map<String, dynamic> json) {
    return ApiMessage(
        MessageBody: json["MessageBody"],
      MessageDate: json["MessageDate"],
      Description: json["Description"],
      MessageSubject: json["MessageSubject"],
      MessageStatusConstId: json["MessageStatusConstId"],
      MessageId: json["MessageId"],
      ReceiverUserId:json["ReceiverUserId"],
      MessageTypeConstId: json["MessageTypeConstId"],
      IsActive: json["IsActive"],
        SenderUserId: json["SenderUserId"],
      SenderUserTitle: json["SenderUserTitle"],
      MessageStatusConstTitle: json["MessageStatusConstTitle"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "MessageBody": this.MessageBody,
      "MessageDate": this.MessageDate,
      "Description": this.Description,
      "MessageSubject": this.MessageSubject,
      "MessageStatusConstId": this.MessageStatusConstId,
      "MessageTypeConstId":this.MessageTypeConstId,
      "ReceiverUserId": this.ReceiverUserId,
      "MessageId":this.MessageId,
      "SenderUserId": this.SenderUserId,
      "SenderUserTitle":this.SenderUserTitle,
      "MessageStatusConstTitle":this.MessageStatusConstTitle
    };


  }


  Map<String, dynamic> toJsonForSendMessage() {
    return {
      "MessageBody": this.MessageBody,
      "MessageDate": this.MessageDate,
      "Description": this.Description,
      "MessageSubject": this.MessageSubject,
      "MessageStatusConstId": this.MessageStatusConstId,
      "ReceiverUserId":this.ReceiverUserId,
      "MessageTypeConstId":this.MessageTypeConstId,
      "IsActive": this.IsActive,
      "RowStateType" : Constants.ROWSTATE_TYPE_INSERT
    };


  }


  Map<String, dynamic> toJsonForEdit() {
    return {
      "MessageId": this.MessageId,
      //"MessageBody": this.MessageBody,
      //"MessageDate": this.MessageDate,
      //"Description": this.Description,
      //"MessageSubject": this.MessageSubject,
      "MessageStatusConstId": this.MessageStatusConstId,
    };

  }

  @override
  String toString() {
    DateTime messageDate=DateTime.parse(MessageDate);
    Jalali date=Jalali.fromDateTime(messageDate);
    return date.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'MessageId': this.MessageId,
      'MessageBody': this.MessageBody,
      'MessageDate': this.MessageDate,
      'Description': this.Description,
      'MessageSubject': this.MessageSubject,
      'MessageStatusConstId': this.MessageStatusConstId,
      'MessageStatusConstTitle':this.MessageStatusConstTitle,
      'MessageTypeConstId': this.MessageTypeConstId,
      'CarId': this.CarId,
      'ReceiverUserId': this.ReceiverUserId,
      'SenderUserId': this.SenderUserId,
      'SenderUserTitle': this.SenderUserTitle,
      'IsActive': this.IsActive,
      'RowStateType': this.RowStateType,
    };
  }

  factory ApiMessage.fromMap(Map<String, dynamic> map) {
    return new ApiMessage(
      MessageId: map['MessageId'] ,
      MessageBody: map['MessageBody'] ,
      MessageDate: map['MessageDate'] ,
      Description: map['Description'] ,
      MessageSubject: map['MessageSubject'] ,
      MessageStatusConstId: map['MessageStatusConstId'] ,
      MessageTypeConstId: map['MessageTypeConstId'] ,
      CarId: map['CarId'] ,
      ReceiverUserId: map['ReceiverUserId'] ,
      SenderUserId: map['SenderUserId'] ,
      SenderUserTitle: map['SenderUserTitle'] ,
      IsActive: map['IsActive'] ,
      RowStateType: map['RowStateType'] ,
      MessageStatusConstTitle: map['MessageStatusConstTitle']
    );
  }

}
