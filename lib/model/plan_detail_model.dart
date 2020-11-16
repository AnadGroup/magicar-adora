import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';

class PlanDetailModel {
  int PlanDetailId;
  int PlanId;
  int ValidAmount;
  int ValidCount;
  int ActionId;
  String ActionTitle;
  String ActionCode ;
  bool IsActivev;
  String Description;
  String CreatedDate;

  PlanDetailModel({
    @required this.PlanDetailId,
    @required this.PlanId,
    @required this.ValidAmount,
    @required this.ValidCount,
    @required this.ActionId,
    @required this.ActionTitle,
    @required this.ActionCode,
    @required this.IsActivev,
    @required this.Description,
    @required this.CreatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'PlanDetailId': this.PlanDetailId,
      'PlanId': this.PlanId,
      'ValidAmount': this.ValidAmount,
      'ValidCount': this.ValidCount,
      'ActionId': this.ActionId,
      'ActionTitle': this.ActionTitle,
      'ActionCode': this.ActionCode,
      'IsActivev': this.IsActivev,
      'Description': this.Description,
      'CreatedDate': this.CreatedDate,
    };
  }

  factory PlanDetailModel.fromMap(Map<String, dynamic> map) {
    return new PlanDetailModel(
      PlanDetailId: map['PlanDetailId'] ,
      PlanId: map['PlanId'] ,
      ValidAmount: map['ValidAmount'] ,
      ValidCount: map['ValidCount'] ,
      ActionId: map['ActionId'] ,
      ActionTitle: map['ActionTitle'] ,
      ActionCode: map['ActionCode'] ,
      IsActivev: map['IsActivev'] ,
      Description: map['Description'] ,
      CreatedDate: map['CreatedDate'] ,
    );
  }

  factory PlanDetailModel.fromJson(Map<String, dynamic> json) {
    return PlanDetailModel(PlanDetailId: json["PlanDetailId"],
      PlanId: json["PlanId"],
      ValidAmount: json["ValidAmount"],
      ValidCount:json["ValidCount"],
      ActionId: json["ActionId"],
      ActionTitle: json["ActionTitle"],
      ActionCode: json["ActionCode"],
      IsActivev: json["IsActivev"],
      Description: DartHelper.isNullOrEmptyString(json["Description"]),
      CreatedDate: json["CreatedDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "PlanDetailId": this.PlanDetailId,
      "PlanId": this.PlanId,
      "ValidAmount": this.ValidAmount,
      "ValidCount": this.ValidCount,
      "ActionId": this.ActionId,
      "ActionTitle": this.ActionTitle,
      "ActionCode": this.ActionCode,
      "IsActivev": this.IsActivev,
      "Description": this.Description,
      "CreatedDate": this.CreatedDate,
    };
  }


}
