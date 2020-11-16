import 'package:flutter/material.dart';

class SendCommandModel {
  int UserId;
  int ActionId;
  int CarId;
  String Command;

  SendCommandModel({
    @required this.UserId,
    @required this.ActionId,
    @required this.CarId,
    @required this.Command,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': this.UserId,
      'ActionId': this.ActionId,
      'CarId': this.CarId,
      'Command': this.Command,
    };
  }

  factory SendCommandModel.fromMap(Map<String, dynamic> map) {
    return new SendCommandModel(
      UserId: map['UserId'] ,
      ActionId: map['ActionId'] ,
      CarId: map['CarId'] ,
      Command: map['Command'] ,
    );
  }

  factory SendCommandModel.fromJson(Map<String, dynamic> json) {
    return SendCommandModel(UserId: json["UserId"],
      ActionId: json["ActionId"],
      CarId: json["CarId"],
      Command: json["Command"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserId": this.UserId,
      "ActionId": this.ActionId,
      "CarId": this.CarId,
      "Command": this.Command,
    };
  }


}