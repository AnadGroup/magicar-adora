import 'package:flutter/material.dart';

class ReturnValue {
  int CarId;
  int UserId;
  String UserName;
  String PartyAssignCode;
  String PartyAssignTitle;
  int PartyId;
  int CurrentBusinessUnitId;
  int CurrentCultureId;
  int ReturnInvoiceId;

  ReturnValue({
    @required this.CarId,
    @required this.UserId,
    @required this.UserName,
    @required this.PartyAssignCode,
    @required this.PartyAssignTitle,
    @required this.PartyId,
    @required this.CurrentBusinessUnitId,
    @required this.CurrentCultureId,
    @required this.ReturnInvoiceId
  });

  Map<String, dynamic> toMap() {
    return {
      'CarId': this.CarId,
      'UserId': this.UserId,
      'UserName': this.UserName,
      'PartyAssignCode': this.PartyAssignCode,
      'PartyAssignTitle': this.PartyAssignTitle,
      'PartyId': this.PartyId,
      'CurrentBusinessUnitId': this.CurrentBusinessUnitId,
      'CurrentCultureId': this.CurrentCultureId,
    };
  }
  Map<String, dynamic> toMapForSaveCar() {
    return {
      'CarId': this.CarId,
     /* 'UserId': this.UserId,
      'UserName': this.UserName,
      'PartyAssignCode': this.PartyAssignCode,
      'PartyAssignTitle': this.PartyAssignTitle,
      'PartyId': this.PartyId,
      'CurrentBusinessUnitId': this.CurrentBusinessUnitId,
      'CurrentCultureId': this.CurrentCultureId,*/
    };
  }
  factory ReturnValue.fromMap(Map<String, dynamic> map) {
    return new ReturnValue(
      CarId: map['CarId'],
      UserId: map['UserId'] ,
      UserName: map['UserName'] ,
      PartyAssignCode: map['PartyAssignCode'] ,
      PartyAssignTitle: map['PartyAssignTitle'] ,
      PartyId: map['PartyId'] ,
      CurrentBusinessUnitId: map['CurrentBusinessUnitId'] ,
      CurrentCultureId: map['CurrentCultureId'] ,
    );
  }
  factory ReturnValue.fromMapForSaveCar(Map<String, dynamic> map) {
    return new ReturnValue(
      CarId: map['CarId'],
     /* UserId: map['UserId'] ,
      UserName: map['UserName'] ,
      PartyAssignCode: map['PartyAssignCode'] ,
      PartyAssignTitle: map['PartyAssignTitle'] ,
      PartyId: map['PartyId'] ,
      CurrentBusinessUnitId: map['CurrentBusinessUnitId'] ,
      CurrentCultureId: map['CurrentCultureId'] ,*/
    );
  }
  factory ReturnValue.fromJson(Map<String, dynamic> json) {
    return ReturnValue(UserId: json["UserId"],
      CarId: json["CarId"],
      UserName: json["UserName"],
      PartyAssignCode: json["PartyAssignCode"],
      PartyAssignTitle: json["PartyAssignTitle"],
      PartyId: json["PartyId"],
      CurrentBusinessUnitId: json["CurrentBusinessUnitId"],
      CurrentCultureId: json["CurrentCultureId"],);
  }

  factory ReturnValue.fromJsonPartialInvoice(Map<String, dynamic> json) {
    return ReturnValue(ReturnInvoiceId: json["ReturnInvoiceId"],
      );
  }

  factory ReturnValue.fromJsonForSaveCarResult(Map<String, dynamic> json) {
    return ReturnValue(
      CarId: json["CarId"],);
  }
  Map<String, dynamic> toJsonForSaveCarResult() {
    return {
      "CarId": this.CarId,
    /*  "UserId": this.UserId,
      "UserName": this.UserName,
      "PartyAssignCode": this.PartyAssignCode,
      "PartyAssignTitle": this.PartyAssignTitle,
      "PartyId": this.PartyId,
      "CurrentBusinessUnitId": this.CurrentBusinessUnitId,
      "CurrentCultureId": this.CurrentCultureId,*/
    };
  }
  Map<String, dynamic> toJson() {
    return {
      "CarId": this.CarId,
      "UserId": this.UserId,
      "UserName": this.UserName,
      "PartyAssignCode": this.PartyAssignCode,
      "PartyAssignTitle": this.PartyAssignTitle,
      "PartyId": this.PartyId,
      "CurrentBusinessUnitId": this.CurrentBusinessUnitId,
      "CurrentCultureId": this.CurrentCultureId,
    };
  }


}
