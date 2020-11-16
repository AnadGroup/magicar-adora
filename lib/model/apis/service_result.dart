import 'dart:convert';

import 'package:anad_magicar/model/apis/api_returnvalue_model.dart';
import 'package:flutter/material.dart';

class ServiceResult {


  bool IsSuccessful;
  String Message;
  String Title;
  ReturnValue returnValue;
  bool IsConfirmMessage;
  String ConfirmKey;
  List IdentityManppingInfo;
  ServiceResult({
    @required this.IsSuccessful,
    @required this.Message,
    @required this.Title,
    @required this.returnValue,
    @required this.IsConfirmMessage,
    @required this.ConfirmKey,
    @required this.IdentityManppingInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'IsSuccessful': this.IsSuccessful,
      'Message': this.Message,
      'Title': this.Title,
      'ReturnValue': this.returnValue!=null ? this.returnValue.toMap() : null,
      'IsConfirmMessage': this.IsConfirmMessage,
      'ConfirmKey': this.ConfirmKey,
      'IdentityManppingInfo': this.IdentityManppingInfo,
    };
  }

  factory ServiceResult.fromMap(Map<String, dynamic> map) {
    ReturnValue returnValue;
      if(map['ReturnValue']!=null)
     returnValue=ReturnValue.fromMap(map['ReturnValue']);
    return new ServiceResult(
      IsSuccessful: map['IsSuccessful'] ,
      Message: map['Message'],
      Title: map['Title'] ,
      returnValue: returnValue!=null ? ReturnValue.fromMap( map['ReturnValue']) : null ,
      IsConfirmMessage: map['IsConfirmMessage'] ,
      ConfirmKey: map['ConfirmKey'] ,
      IdentityManppingInfo: map['IdentityManppingInfo'] ,
    );
  }

  factory ServiceResult.fromJson(Map<String, dynamic> json) {
    ReturnValue returnValue;
    if(json["ReturnValue"]!=null)
       returnValue=ReturnValue.fromJson(json["ReturnValue"]);
    return ServiceResult(
      IsSuccessful: json["IsSuccessful"],
      Message: json["Message"],
      Title: json["Title"],
      returnValue: returnValue!=null ? ReturnValue.fromJson( json["ReturnValue"]) : null,
      IsConfirmMessage: json["IsConfirmMessage"],
      ConfirmKey: json["ConfirmKey"],
      IdentityManppingInfo: null,);
  }
  factory ServiceResult.fromJsonParitalInvoice(Map<String, dynamic> json) {
    ReturnValue returnValue;
    if(json["ReturnValue"]!=null)
      returnValue=ReturnValue.fromJsonPartialInvoice(json["ReturnValue"]);
    return ServiceResult(
      IsSuccessful: json["IsSuccessful"],
      Message: json["Message"],
      Title: json["Title"],
      returnValue: returnValue!=null ? ReturnValue.fromJsonPartialInvoice( json["ReturnValue"]) : null,
      IsConfirmMessage: json["IsConfirmMessage"],
      ConfirmKey: json["ConfirmKey"],
      IdentityManppingInfo: null,);
  }
  Map<String, dynamic> toJson() {
    return {
      "IsSuccessful": this.IsSuccessful,
      "Message": this.Message,
      "Title": this.Title,
      "ReturnValue": this.returnValue!=null ? this.returnValue?.toJson() : null,
      "IsConfirmMessage": this.IsConfirmMessage,
      "ConfirmKey": this.ConfirmKey,
      "IdentityManppingInfo": null,
    };
  }


}
