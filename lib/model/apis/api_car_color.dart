import 'package:flutter/material.dart';

class ApiCarColor {
  String carColorTitle;
  int colorId;
  int ConstantId;
  String DisplayName;

  ApiCarColor({
    @required this.carColorTitle,
    @required this.colorId,
    @required this.ConstantId,
    @required this.DisplayName
  });

  factory ApiCarColor.fromJson(Map<String, dynamic> json) {
    return ApiCarColor(carColorTitle: json["CarColorTitle"],
      colorId: json["ColorId"],);
  }


  Map<String, dynamic> toJson() {
    return {"CarColorTitle": this.carColorTitle, "ColorId": this.colorId,};
  }

  Map<String, dynamic> toMap() {
    return {
      'ConstantId': this.ConstantId,
      'DisplayName': this.DisplayName,
    };
  }

  factory ApiCarColor.fromMap(Map<String, dynamic> map) {
    return new ApiCarColor(
      ConstantId: map['ConstantId'] ,
      DisplayName: map['DisplayName'] ,
    );
  }

  factory ApiCarColor.fromJsonForColor(Map<String, dynamic> json) {
    return ApiCarColor(ConstantId: json["ConstantId"],
      DisplayName: json["DisplayName"],);
  }

  Map<String, dynamic> toJsonForColor() {
    return {"ConstantId": this.ConstantId, "DisplayName": this.DisplayName,};
  }


}
