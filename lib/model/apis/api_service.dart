import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart' as sh;
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/widgets/persian_datepicker/jalaali_js.dart';
import 'package:anad_magicar/widgets/persian_datepicker/persian_datetime.dart';
import 'package:flutter/material.dart';

class ApiService {

  static final int ServiceStatusConstId_Tag=152376;

  int ServiceId;
  int CarId;
  int ServiceTypeId;
  String ServiceDate;
  String ActionDate;
  String AlarmDate;
  int ServiceStatusConstId;
  double ServiceCost;
  int AlarmCount;
  String Description;
  String CreatedDate;
  int RowStateType;
  ServiceType serviceType;
  Car car;
  NotyBloc<Message> changedNotyBloc;

  ApiService({
    @required this.ServiceId,
    @required this.CarId,
    @required this.ServiceTypeId,
    @required this.ServiceDate,
    @required this.ActionDate,
    @required this.AlarmDate,
    @required this.ServiceStatusConstId,
    @required this.ServiceCost,
    @required this.AlarmCount,
    @required this.Description,
    @required this.CreatedDate,
    @required this.RowStateType,
    @required this.serviceType,
    @required this.changedNotyBloc,
    @required this.car
  });

  Map<String, dynamic> toMap() {
    return {
      'ServiceId': this.ServiceId,
      'CarId': this.CarId,
      'ServiceTypeId': this.ServiceTypeId,
      'ServiceDate': this.ServiceDate,
      'ActionDate': this.ActionDate,
      'AlarmDate': this.AlarmDate,
      'ServiceStatusConstId': this.ServiceStatusConstId,
      'ServiceCost': this.ServiceCost,
      'AlarmCount': this.AlarmCount,
      'Description': this.Description,
      'CreatedDate': this.CreatedDate,
      'RowStateType':this.RowStateType,
    };
  }

  factory ApiService.fromMap(Map<String, dynamic> map) {
    return new ApiService(
      ServiceId: map['ServiceId'] ,
      CarId: map['CarId'] ,
      ServiceTypeId: map['ServiceTypeId'] ,
      ServiceDate: map['ServiceDate'] ,
      ActionDate: map['ActionDate'] ,
      AlarmDate: map['AlarmDate'] ,
      ServiceStatusConstId: map['ServiceStatusConstId'] ,
      ServiceCost: map['ServiceCost'] ,
      AlarmCount: map['AlarmCount'] ,
      Description: map['Description'] ,
      CreatedDate: map['CreatedDate'] ,
      RowStateType: map['RowStateType']
    );
  }

  factory ApiService.fromJson(Map<String, dynamic> json) {
    return ApiService(ServiceId: json["ServiceId"],
      CarId: json["CarId"],
      ServiceTypeId: json["ServiceTypeId"],
      ServiceDate: json["ServiceDate"],
      ActionDate: json["ActionDate"],
      AlarmDate: json["AlarmDate"],
      ServiceStatusConstId: json["ServiceStatusConstId"],
      ServiceCost: json["ServiceCost"],
      AlarmCount: json["AlarmCount"],
      Description: json["Description"],
      CreatedDate: json["CreatedDate"],
    RowStateType: json["RowStateType"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ServiceId": this.ServiceId,
      "CarId": this.CarId,
      "ServiceTypeId": this.ServiceTypeId,
      "ServiceDate": this.ServiceDate,
      "ActionDate": this.ActionDate,
      "AlarmDate": this.AlarmDate,
      "ServiceStatusConstId": this.ServiceStatusConstId,
      "ServiceCost": this.ServiceCost,
      "AlarmCount": this.AlarmCount,
      "Description": this.Description,
      "CreatedDate": this.CreatedDate,
      "RowStateType":this.RowStateType,
    };
  }




}
