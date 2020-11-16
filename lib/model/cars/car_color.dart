import 'package:flutter/material.dart';

class CarColor {

  String carColorTitle;
  int colorId;

  CarColor({
    @required this.carColorTitle,
    @required this.colorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'CarColorTitle': this.carColorTitle,
      'ColorId': this.colorId,
    };
  }

  factory CarColor.fromMap(Map<String, dynamic> map) {
    return new CarColor(
      carColorTitle: map['CarColorTitle'] ,
      colorId: map['ColorId'] ,
    );
  }

  factory CarColor.fromJson(Map<String, dynamic> json) {
    return CarColor(carColorTitle: json["CarColorTitle"],
      colorId: json["ColorId"],);
  }

  Map<String, dynamic> toJson() {
    return {"CarColorTitle": this.carColorTitle, "ColorId": this.colorId,};
  }


}
