import 'package:flutter/material.dart';

class SlavedCar {
  int CarId;
  int masterId;
  String CarModelDetailTitle;
  String CarModelTitle;
  String BrandTitle;
  String Color;
  int index;
  SlavedCar({
    @required this.masterId,
    @required this.CarId,
    @required this.CarModelDetailTitle,
    @required this.CarModelTitle,
    @required this.BrandTitle,
    @required this.Color,
    @required this.index
  });

  Map<String, dynamic> toMap() {
    return {
      'CarId': this.CarId,
      'CarModelDetailTitle': this.CarModelDetailTitle,
      'CarModelTitle': this.CarModelTitle,
      'BrandTitle': this.BrandTitle,
      'Color': this.Color,
    };
  }

  factory SlavedCar.fromMap(Map<String, dynamic> map) {
    return new SlavedCar(
      CarId: map['CarId'] ,
      CarModelDetailTitle: map['CarModelDetailTitle'] ,
      CarModelTitle: map['CarModelTitle'] ,
      BrandTitle: map['BrandTitle'] ,
      Color: map['Color'] ,
    );
  }

  factory SlavedCar.fromJson(Map<String, dynamic> json) {
    return SlavedCar(CarId: json["CarId"],
      CarModelDetailTitle: json["CarModelDetailTitle"],
      CarModelTitle: json["CarModelTitle"],
      BrandTitle: json["BrandTitle"],
      Color: json["Color"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "CarId": this.CarId,
      "CarModelDetailTitle": this.CarModelDetailTitle,
      "CarModelTitle": this.CarModelTitle,
      "BrandTitle": this.BrandTitle,
      "Color": this.Color,
    };
  }


}
