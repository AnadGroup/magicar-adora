import 'package:anad_magicar/model/apis/api_returnvalue_model.dart';
import 'package:flutter/material.dart';

class SaveMagicarResponeQuery {
  bool isSuccessful;
  String message;
  int userId;
  int carId;
  int roleId;
  ReturnValue returnValue;

  SaveMagicarResponeQuery({
    @required this.isSuccessful,
    @required this.message,
    @required this.userId,
    @required this.carId,
    @required this.roleId,
    @required this.returnValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'IsSuccessful': this.isSuccessful,
      'Message': this.message,
      'UserId': this.userId,
      'CarId': this.carId,
      'RoleId': this.roleId,
      'ReturnValue': null,
    };
  }

  factory SaveMagicarResponeQuery.fromMap(Map<String, dynamic> map) {
    return new SaveMagicarResponeQuery(
      isSuccessful: map['IsSuccessful'] ,
      message: map['Message'],
      userId: map['UserId'] ,
      carId: map['CarId'] ,
      roleId: map['RoleId'],
      returnValue:null,
    );
  }

  factory SaveMagicarResponeQuery.fromJson(Map<String, dynamic> json) {
    return SaveMagicarResponeQuery(
      isSuccessful: json["IsSuccessful"],
      message: json["Message"],
      userId: json["UserId"],
      roleId: json["RoleId"],
      carId: json["CarId"],
    returnValue: null);
  }
  factory SaveMagicarResponeQuery.fromJsonForSaveCarResult(Map<String, dynamic> json) {
    return SaveMagicarResponeQuery(
        isSuccessful: json["IsSuccessful"],
        message: json["Message"],
      /*  userId: json["UserId"],
        carId: json["CarId"],*/
        returnValue: ReturnValue.fromJsonForSaveCarResult(json["ReturnValue"]));
  }
  Map<String, dynamic> toJson() {
    return {
      "IsSuccessful": this.isSuccessful,
      "Message": this.message,
      "UserId": this.userId,
      "CarId": this.carId,
      "RoleId": this.roleId,
      "ReturnValue": null,
    };
  }


}
