import 'package:anad_magicar/model/apis/alarm_type_to_user.dart';
import 'package:flutter/material.dart';

class AlarmType {
  int AlarmTypeId;
  String AlarmTypeCode;
  String AlarmTypeTitle;
  bool IsDefault;
  int ActionId;
  String Description;
  String CreatedDate;
  String LastUpdateDate;
  bool SendSMS;
  bool Call;
  bool MissedCall;
  bool SendToAdmin;
  int RowStateType;
  List<AlarmTypeToUser> alarmTypeToUser;

  AlarmType({
    @required this.AlarmTypeId,
    @required this.AlarmTypeCode,
    @required this.AlarmTypeTitle,
    @required this.IsDefault,
    @required this.ActionId,
    @required this.Description,
    @required this.CreatedDate,
    @required this.LastUpdateDate,
    @required this.SendSMS,
    @required this.Call,
    @required this.MissedCall,
    @required this.SendToAdmin,
    @required this.alarmTypeToUser
  });

  Map<String, dynamic> toMap() {
    return {
      'AlarmTypeId': this.AlarmTypeId,
      'AlarmTypeCode': this.AlarmTypeCode,
      'AlarmTypeTitle': this.AlarmTypeTitle,
      'IsDefault': this.IsDefault,
      'ActionId': this.ActionId,
      'Description': this.Description,
      'CreatedDate': this.CreatedDate,
      'LastUpdateDate': this.LastUpdateDate,
    };
  }

  factory AlarmType.fromMap(Map<String, dynamic> map) {
    return new AlarmType(
      AlarmTypeId: map['AlarmTypeId'] ,
      AlarmTypeCode: map['AlarmTypeCode'] ,
      AlarmTypeTitle: map['AlarmTypeTitle'] ,
      IsDefault: map['IsDefault'] ,
      ActionId: map['ActionId'] ,
      Description: map['Description'] ,
      CreatedDate: map['CreatedDate'] ,
      LastUpdateDate: map['LastUpdateDate'] ,
      Call: map['Call'],
      MissedCall: map['MissedCall'],
      SendSMS: map['SendSMS'],
      SendToAdmin: map['SendToAdmin']
    );
  }

  factory AlarmType.fromJson(Map<String, dynamic> json) {
    return AlarmType(AlarmTypeId: json["AlarmTypeId"],
      AlarmTypeCode: json["AlarmTypeCode"],
      AlarmTypeTitle: json["AlarmTypeTitle"],
      IsDefault: json["IsDefault"],
      ActionId: json["ActionId"],
      Description: json["Description"],
      CreatedDate: json["CreatedDate"],
      LastUpdateDate: json["LastUpdateDate"],
        Call: json["Call"],
        MissedCall: json["MissedCall"],
        SendSMS: json["SendSMS"],
        SendToAdmin: json["SendToAdmin"]);
  }

  factory AlarmType.fromJsonForUser(Map<String, dynamic> json) {
    var typeToUser=json["AlarmTypeToUser"];
    List<AlarmTypeToUser> types=new List();
    if(typeToUser!=null && typeToUser.length>0) {
        types=typeToUser.map<AlarmTypeToUser>((t)=>AlarmTypeToUser.fromJson(t)).toList();
    }
    return AlarmType(AlarmTypeId: json["AlarmTypeId"],
      AlarmTypeTitle: json["AlarmTypeTitle"],
        Call: json["Call"],
        MissedCall: json["MissedCall"],
        SendSMS: json["SendSMS"],
        SendToAdmin: json["SendToAdmin"],
    alarmTypeToUser: types);
  }
  Map<String, dynamic> toJson() {
    return {
      "AlarmTypeId": this.AlarmTypeId,
      "AlarmTypeCode": this.AlarmTypeCode,
      "AlarmTypeTitle": this.AlarmTypeTitle,
      "IsDefault": this.IsDefault,
      "ActionId": this.ActionId,
      "Description": this.Description,
      "CreatedDate": this.CreatedDate,
      "LastUpdateDate": this.LastUpdateDate,
      "Call": this.Call,
      "MissedCall": this.MissedCall,
      "SendSMS": this.SendSMS,
      "RowStateType": this.RowStateType
    };
  }


}
