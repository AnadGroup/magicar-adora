import 'package:flutter/material.dart';

class AlarmTypeToUser {

  String AlarmTypeId;
  String AlarmTypeTitle;
  int UserId;
  bool SendSMS;
  bool Call;
  bool SendNotification;
 bool MissedCall;
  bool SendToAdmin;
  String Description;
  String CreatedDate;
  String LastUpdateDate;
  int RowStateType;
  bool IsActive;

  AlarmTypeToUser({
    @required this.AlarmTypeId,
    @required this.AlarmTypeTitle,
    @required this.UserId,
    @required this.SendSMS,
    @required this.Call,
    @required this.SendNotification,
    @required this.MissedCall,
    @required this.SendToAdmin,
    @required this.Description,
    @required this.CreatedDate,
    @required this.LastUpdateDate,
    @required this.RowStateType,
    @required this.IsActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'AlarmTypeId': this.AlarmTypeId,
      'AlarmTypeTitle': this.AlarmTypeTitle,
      'UserId': this.UserId,
      'SendSMS': this.SendSMS,
      'Call': this.Call,
      'SendNotification': this.SendNotification,
      'MissedCall': this.MissedCall,
      'SendToAdmin': this.SendToAdmin,
      'Description': this.Description,
      'CreatedDate': this.CreatedDate,
      'LastUpdateDate': this.LastUpdateDate,
      'RowStateType': this.RowStateType,
      'IsActive': this.IsActive,
    };
  }

  factory AlarmTypeToUser.fromMap(Map<String, dynamic> map) {
    return new AlarmTypeToUser(
      AlarmTypeId: map['AlarmTypeId'] ,
      AlarmTypeTitle: map['AlarmTypeTitle'] ,
      UserId: map['UserId'] ,
      SendSMS: map['SendSMS'] ,
      Call: map['Call'] ,
      SendNotification: map['SendNotification'] ,
      MissedCall: map['MissedCall'] ,
      SendToAdmin: map['SendToAdmin'] ,
      Description: map['Description'] ,
      CreatedDate: map['CreatedDate'] ,
      LastUpdateDate: map['LastUpdateDate'] ,
      RowStateType: map['RowStateType'] ,
      IsActive: map['IsActive'] ,
    );
  }

  factory AlarmTypeToUser.fromJson(Map<String, dynamic> json) {
    return AlarmTypeToUser(AlarmTypeId: json["AlarmTypeId"],
      AlarmTypeTitle: json["AlarmTypeTitle"],
      UserId: json["UserId"],
      SendSMS: json["SendSMS"],
      Call: json["Call"],
      SendNotification: json["SendNotification"],
      MissedCall: json["MissedCall"],
      SendToAdmin: json["SendToAdmin"],
      Description: json["Description"],
      CreatedDate: json["CreatedDate"],
      LastUpdateDate: json["LastUpdateDate"],
      RowStateType: json["RowStateType"],
      IsActive: json["IsActive"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "AlarmTypeId": this.AlarmTypeId,
      "AlarmTypeTitle": this.AlarmTypeTitle,
      "UserId": this.UserId,
      "SendSMS": this.SendSMS,
      "Call": this.Call,
      "SendNotification": this.SendNotification,
      "MissedCall": this.MissedCall,
      "SendToAdmin": this.SendToAdmin,
      "Description": this.Description,
      "CreatedDate": this.CreatedDate,
      "LastUpdateDate": this.LastUpdateDate,
      "RowStateType": this.RowStateType,
      "IsActive": this.IsActive,
    };
  }


}
