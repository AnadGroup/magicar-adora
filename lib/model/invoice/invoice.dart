import 'package:anad_magicar/model/invoice/invoice_detail.dart';
import 'package:anad_magicar/model/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
class InvoiceModel {

  static final int InvoiceStatusConstId_Not_Paid=152338;
  static final int InvoiceStatusConstId_Paid=152340;

  int InvoiceId;
  int UserId;
  int PlanId;
  String InvoiceDate;
  String EndDate;
  String StartDate;
  String Description;
  bool IsActive;
  int SettlmentTypeConstId;
  int InvoiceStatusConstId;
  String DisplayName;
  double Amount;
  int Owner;
  int BusinessUnitId;
  List<InvoiceDetailModel> invoiceDetailModel;

  PlanModel planModel;
  InvoiceModel({
    @required this.InvoiceId,
    @required this.UserId,
    @required this.PlanId,
    @required this.InvoiceDate,
    @required this.EndDate,
    @required this.StartDate,
    @required this.Description,
    @required this.IsActive,
    @required this.SettlmentTypeConstId,
    @required this.InvoiceStatusConstId,
    @required this.DisplayName,
    @required this.Amount,
    @required this.Owner,
    @required this.BusinessUnitId,
    @required this.invoiceDetailModel,
  });

  Map<String, dynamic> toMap() {
    return {
      'InvoiceId': this.InvoiceId,
      'UserId': this.UserId,
      'PlanId': this.PlanId,
      'InvoiceDate': this.InvoiceDate,
      'EndDate': this.EndDate,
      'StartDate': this.StartDate,
      'Description': this.Description,
      'IsActive': this.IsActive,
      'SettlmentTypeConstId': this.SettlmentTypeConstId,
      'InvoiceStatusConstId': this.InvoiceStatusConstId,
      'DisplayName': this.DisplayName,
      'Amount': this.Amount,
      'Owner': this.Owner,
      'BusinessUnitId': this.BusinessUnitId,
      'InvoiceDetail': this.invoiceDetailModel!=null ? this.invoiceDetailModel.map((id)=> id.toMap() ).toList() : null,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> invoiceDetail=map['InvoiceDetail'];
    return new InvoiceModel(
      InvoiceId: map['InvoiceId'] ,
      UserId: map['UserId'] ,
      PlanId: map['PlanId'] ,
      InvoiceDate: map['InvoiceDate'] ,
      EndDate: map['EndDate'] ,
      StartDate: map['StartDate'] ,
      Description: map['Description'] ,
      IsActive: map['IsActive'] ,
      SettlmentTypeConstId: map['SettlmentTypeConstId'] ,
      InvoiceStatusConstId: map['InvoiceStatusConstId'] ,
      DisplayName: map['DisplayName'] ,
      Amount: map['Amount'] ,
      Owner: map['Owner'] ,
      BusinessUnitId: map['BusinessUnitId'] ,
      invoiceDetailModel: invoiceDetail!=null ?  invoiceDetail.map((id) => InvoiceDetailModel.fromMap( id)).toList() : null ,
    );
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> invoiceDetail=json["InvoiceDetail"] !=null ? json["InvoiceDetail"] : null;

    return InvoiceModel(InvoiceId:json["InvoiceId"],
      UserId:json["UserId"],
      PlanId:json["PlanId"],
      InvoiceDate: json["InvoiceDate"],
      EndDate: json["EndDate"],
      StartDate: json["StartDate"],
      Description: json["Description"],
      IsActive: json["IsActive"],
      SettlmentTypeConstId:json["SettlmentTypeConstId"],
      InvoiceStatusConstId:json["InvoiceStatusConstId"],
      DisplayName: json["DisplayName"],
      Amount: json["Amount"],
      Owner:json["Owner"],
      BusinessUnitId:json["BusinessUnitId"],
      invoiceDetailModel: invoiceDetail!=null ? invoiceDetail.map((id) => InvoiceDetailModel.fromJson(id)).toList() : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "InvoiceId": this.InvoiceId,
      "UserId": this.UserId,
      "PlanId": this.PlanId,
      "InvoiceDate": this.InvoiceDate,
      "EndDate": this.EndDate,
      "StartDate": this.StartDate,
      "Description": this.Description,
      "IsActive": this.IsActive,
      "SettlmentTypeConstId": this.SettlmentTypeConstId,
      "InvoiceStatusConstId": this.InvoiceStatusConstId,
      "DisplayName": this.DisplayName,
      "Amount": this.Amount,
      "Owner": this.Owner,
      "BusinessUnitId": this.BusinessUnitId,
      "InvoiceDetail": this.invoiceDetailModel!=null ?  this.invoiceDetailModel.map((id) => id.toJson()).toList() :
       null,
    };
  }

  @override
  String toString() {
    return DartHelper.isNullOrEmptyString(DisplayName);
  }


}
