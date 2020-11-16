import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';

class PlanModel {

  static final int PLAN_TYPE_CONST_ID_FUNCTIONAL=152336;
  static final int PLAN_TYPE_CONST_ID_DURATIONAL=152335;
  static final int PLAN_TYPE_CONST_ID_DURATIONAL_FUNCTIONAL=152334;


  int PlanId;
  String PlanCode;
  String PlanTitle;
  String TypeName;
  String FromDate;
  String ToDate ;
  double Cost;
  int DayCount;
  String CreatedDate;
  String Description;
  int PlanTypeConstId;
  PlanModel({
    this.PlanId,
    @required this.PlanCode,
    @required this.PlanTitle,
    @required this.TypeName,
    @required this.FromDate,
    @required this.ToDate,
    @required this.Cost,
    @required this.DayCount,
    @required this.CreatedDate,
    @required this.Description,
    @required this.PlanTypeConstId
  });

  Map<String, dynamic> toMap() {
    return {
      //'PlanId': this.PlanId,
      'PlanCode': this.PlanCode,
      'PlanTitle': this.PlanTitle,
      'TypeName': this.TypeName,
      'FromDate': this.FromDate,
      'ToDate': this.ToDate,
      'Cost': this.Cost,
      'DayCount': this.DayCount,
      'CreatedDate': this.CreatedDate,
      'Description': this.Description,
      'PlanTypeConstId':this.PlanTypeConstId
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return new PlanModel(
      PlanId: map['PlanId'],
      PlanCode: map['PlanCode'] ,
      PlanTitle: map['PlanTitle'] ,
      TypeName: map['TypeName'] ,
      FromDate: map['FromDate'] ,
      ToDate: map['ToDate'] ,
      Cost: map['Cost'] ,
      DayCount: map['DayCount'] ,
      CreatedDate: map['CreatedDate'] ,
      Description: map['Description'] ,
      PlanTypeConstId: map['PlanTypeConstId']
    );
  }

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      PlanId: json["PlanId"],
      PlanCode: json["PlanCode"],
      PlanTitle:json["PlanTitle"],
      TypeName:json["TypeName"],
      FromDate: json["FromDate"],
      ToDate: json["ToDate"],
      Cost: json["Cost"],
      DayCount: json["DayCount"],
      CreatedDate: json["CreatedDate"],
      PlanTypeConstId: json["PlanTypeConstId"],
      Description: DartHelper.isNullOrEmptyString( json["Description"]) ,);
  }

  Map<String, dynamic> toJson() {
    return {
      "PlanId": this.PlanId,
      "PlanCode": this.PlanCode,
      "PlanTitle": this.PlanTitle,
      "TypeName": this.TypeName,
      "FromDate": this.FromDate,
      "ToDate": this.ToDate,
      "Cost": this.Cost,
      "DayCount": this.DayCount,
      "CreatedDate": this.CreatedDate,
      "Description": this.Description,
      "PlanTypeConstId": this.PlanTypeConstId
    };
  }


}
