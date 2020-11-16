import 'package:anad_magicar/model/invoice/invoice.dart';
import 'package:anad_magicar/model/plan_model.dart';
import 'package:flutter/material.dart';

class InvoiceDetailModel {

  int InvoiceDetailId;
  int InvoiceId;
  int PlanId;
  int ActionId;
  int RemainCount;
  double RemainAmount;
  String Description;
  InvoiceModel Invoice;
  String SpecificationJson;
  /*Spec: null,
  StringSpec: null,*/
  String CreatedDate;
  String LastUpdateDate;
  int BusinessUnitId;
  int Owner;
  String Version;

  bool IsActive;
/*  Property1: null,
  Property2: null,*/
  //AttachmentFile1: null,
  //EntityTableId: 81524,
  String BusinessUnitName;
  PlanModel planModel;
  InvoiceDetailModel({
    @required this.InvoiceDetailId,
    @required this.InvoiceId,
    @required this.PlanId,
    @required this.ActionId,
    @required this.RemainCount,
    @required this.RemainAmount,
    @required this.Description,
    @required this.Invoice,
    @required this.SpecificationJson,
    @required this.CreatedDate,
    @required this.LastUpdateDate,
    @required this.BusinessUnitId,
    @required this.Owner,
    @required this.Version,
    @required this.IsActive,
    @required this.BusinessUnitName,
     this.planModel,
  });

  Map<String, dynamic> toMap() {
    return {
      'InvoiceDetailId': this.InvoiceDetailId,
      'InvoiceId': this.InvoiceId,
      'PlanId': this.PlanId,
      'ActionId': this.ActionId,
      'RemainCount': this.RemainCount,
      'RemainAmount': this.RemainAmount,
      'Description': this.Description,
      'Invoice': this.Invoice,
      'SpecificationJson': this.SpecificationJson,
      'CreatedDate': this.CreatedDate,
      'LastUpdateDate': this.LastUpdateDate,
      'BusinessUnitId': this.BusinessUnitId,
      'Owner': this.Owner,
      'Version': this.Version,
      'IsActive': this.IsActive,
      'BusinessUnitName': this.BusinessUnitName,

    };
  }

  factory InvoiceDetailModel.fromMap(Map<String, dynamic> map) {
    return new InvoiceDetailModel(
      InvoiceDetailId: map['InvoiceDetailId'] ,
      InvoiceId: map['InvoiceId'] ,
      PlanId: map['PlanId'] ,
      ActionId: map['ActionId'] ,
      RemainCount: map['RemainCount'] ,
      RemainAmount: map['RemainAmount'] ,
      Description: map['Description'] ,
     // Invoice: map['Invoice'] ,
      SpecificationJson: map['SpecificationJson'] ,
      CreatedDate: map['CreatedDate'] ,
      LastUpdateDate: map['LastUpdateDate'] ,
      BusinessUnitId: map['BusinessUnitId'] ,
      Owner: map['Owner'] ,
      Version: map['Version'] ,
      IsActive: map['IsActive'] ,
      BusinessUnitName: map['BusinessUnitName'] ,
    );
  }

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailModel(
      InvoiceDetailId: json["InvoiceDetailId"],
      InvoiceId: json["InvoiceId"],
      PlanId: json["PlanId"],
      ActionId: json["ActionId"],
      RemainCount: json["RemainCount"],
      RemainAmount: json["RemainAmount"],
      Description: json["Description"],
     // Invoice: InvoiceModel.fromJson(json["Invoice"]),
      SpecificationJson: json["SpecificationJson"],
      CreatedDate: json["CreatedDate"],
      LastUpdateDate: json["LastUpdateDate"],
      BusinessUnitId: json["BusinessUnitId"],
      Owner: json["Owner"],
      Version: json["Version"],
      IsActive: json["IsActive"],
      BusinessUnitName: json["BusinessUnitName"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "InvoiceDetailId": this.InvoiceDetailId,
      "InvoiceId": this.InvoiceId,
      "PlanId": this.PlanId,
      "ActionId": this.ActionId,
      "RemainCount": this.RemainCount,
      "RemainAmount": this.RemainAmount,
      "Description": this.Description,
      "Invoice": this.Invoice,
      "SpecificationJson": this.SpecificationJson,
      "CreatedDate": this.CreatedDate,
      "LastUpdateDate": this.LastUpdateDate,
      "BusinessUnitId": this.BusinessUnitId,
      "Owner": this.Owner,
      "Version": this.Version,
      "IsActive": this.IsActive,
      "BusinessUnitName": this.BusinessUnitName,
    };
  }


}
