import 'package:flutter/material.dart';

class ServiceType {


  static final int ServiceTypeConstId_Tag=152353;

  int ServiceTypeId;
  String ServiceTypeCode;
  String ServiceTypeTitle;
  int DurationTypeConstId;
  int ServiceTypeConstId;
  int DurationValue;
  int DurationCountValue;
  int AlarmDurationDay;
  int AlarmCount;
  int UserId;
  bool AutomaticInsert;
  String Description;
  int RowStateType;

  ServiceType({
    @required this.ServiceTypeId,
    @required this.ServiceTypeCode,
    @required this.ServiceTypeTitle,
    @required this.DurationTypeConstId,
    @required this.ServiceTypeConstId,
    @required this.DurationValue,
    @required this.DurationCountValue,
    @required this.AlarmDurationDay,
    @required this.AlarmCount,
    @required this.UserId,
    @required this.AutomaticInsert,
    @required this.Description,
    @required this.RowStateType
  });

  Map<String, dynamic> toMap() {
    return {
      'ServiceTypeId': this.ServiceTypeId,
      'ServiceTypeCode': this.ServiceTypeCode,
      'ServiceTypeTitle': this.ServiceTypeTitle,
      'DurationTypeConstId': this.DurationTypeConstId,
      'ServiceTypeConstId': this.ServiceTypeConstId,
      'DurationValue': this.DurationValue,
      'DurationCountValue': this.DurationCountValue,
      'AlarmDurationDay': this.AlarmDurationDay,
      'AlarmCount': this.AlarmCount,
      'UserId': this.UserId,
      'AutomaticInsert': this.AutomaticInsert,
      'Description': this.Description,
      'RowStateType':this.RowStateType,
    };
  }

  factory ServiceType.fromMap(Map<String, dynamic> map) {
    return new ServiceType(
      ServiceTypeId: map['ServiceTypeId'] ,
      ServiceTypeCode: map['ServiceTypeCode'] ,
      ServiceTypeTitle: map['ServiceTypeTitle'] ,
      DurationTypeConstId: map['DurationTypeConstId'] ,
      ServiceTypeConstId: map['ServiceTypeConstId'] ,
      DurationValue: map['DurationValue'] ,
      DurationCountValue: map['DurationCountValue'] ,
      AlarmDurationDay: map['AlarmDurationDay'] ,
      AlarmCount: map['AlarmCount'] ,
      UserId: map['UserId'] ,
      AutomaticInsert: map['AutomaticInsert'] ,
      Description: map['Description'] ,
      RowStateType: map['RowStateType']
    );
  }

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(ServiceTypeId: json["ServiceTypeId"],
      ServiceTypeCode: json["ServiceTypeCode"],
      ServiceTypeTitle: json["ServiceTypeTitle"],
      DurationTypeConstId: json["DurationTypeConstId"],
      ServiceTypeConstId: json["ServiceTypeConstId"],
      DurationValue: json["DurationValue"],
      DurationCountValue: json["DurationCountValue"],
      AlarmDurationDay: json["AlarmDurationDay"],
      AlarmCount: json["AlarmCount"],
      UserId: json["UserId"],
      AutomaticInsert: json["AutomaticInsert"],
      Description: json["Description"],
    RowStateType: json["RowStateType"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ServiceTypeId": this.ServiceTypeId,
      "ServiceTypeCode": this.ServiceTypeCode,
      "ServiceTypeTitle": this.ServiceTypeTitle,
      "DurationTypeConstId": this.DurationTypeConstId,
      "ServiceTypeConstId": this.ServiceTypeConstId,
      "DurationValue": this.DurationValue,
      "DurationCountValue": this.DurationCountValue,
      "AlarmDurationDay": this.AlarmDurationDay,
      "AlarmCount": this.AlarmCount,
      "UserId": this.UserId,
      "AutomaticInsert": this.AutomaticInsert,
      "Description": this.Description,
      "RowStateType":this.RowStateType,
    };
  }


}
