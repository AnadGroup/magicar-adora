import 'package:flutter/material.dart';

class DeviceModel {

  String DisplayName;
  int ConstantId;

  DeviceModel({
    @required this.DisplayName,
    @required this.ConstantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'DisplayName': this.DisplayName,
      'ConstantId': this.ConstantId,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return new DeviceModel(
      DisplayName: map['DisplayName'] ,
      ConstantId: map['ConstantId'] ,
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(DisplayName: json["DisplayName"],
      ConstantId: json["ConstantId"]);
  }

  Map<String, dynamic> toJson() {
    return {"DisplayName": this.DisplayName, "ConstantId": this.ConstantId,};
  }


}