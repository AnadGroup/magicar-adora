import 'package:flutter/material.dart';

class SaveCarModel {


  int carId;
 int brandId;
 int modelId;
 int tip;
 String pelak;
 int colorId;
 int distance;
int userId;
 int ConstantId;
 String DisplayName;

 SaveCarModel({
   @required this.userId,
   @required this.carId,
   @required this.brandId,
   @required this.modelId,
   @required this.tip,
   @required this.pelak,
   @required this.colorId,
   @required this.distance,
   @required this.ConstantId,
   @required this.DisplayName,

 });

 factory SaveCarModel.fromJson(Map<String, dynamic> json) {
   return SaveCarModel(
     carId: json["CarId"],
     brandId: json["BrandId"],
     modelId:json["ModelId"],
     tip: json["Tip"],
     pelak: json["Pelak"],
     colorId: json["ColorId"],
     distance: json["Distance"],);
 }

 Map<String, dynamic> toJson() {
   return {
     "CarId": this.carId,
     "BrandId": this.brandId,
     "ModelId": this.modelId,
     "Tip": this.tip,
     "Pelak": this.pelak,
     "ColorId": this.colorId,
     "Distance": this.distance,
   };
 }

  Map<String, dynamic> toJsonForEdit() {
    return {
      "CarId": this.carId,
      //"BrandId": this.brandId,
      //"ModelId": this.modelId,
      "Tip": this.tip,
      "Pelak": this.pelak,
      "ColorId": this.colorId,
      "Distance": this.distance,
    };
  }


  Map<String, dynamic> toMapForColor() {
   return {
     'ConstantId': this.ConstantId,
     'DisplayName': this.DisplayName,
   };
 }

 factory SaveCarModel.fromMapForColor(Map<String, dynamic> map) {
   return new SaveCarModel(
     ConstantId: map['ConstantId'] ,
     DisplayName: map['DisplayName'] ,
   );
 }

 factory SaveCarModel.fromJsonForColor(Map<String, dynamic> json) {
   return SaveCarModel(ConstantId: json["ConstantId"],
     DisplayName: json["DisplayName"],);
 }

 Map<String, dynamic> toJsonForColor() {
   return {"ConstantId": this.ConstantId, "DisplayName": this.DisplayName,};
 }

 Map<String, dynamic> toMap() {
   return {
     'CarId': this.carId,
     'BrandId': this.brandId,
     'ModelId': this.modelId,
     'Tip': this.tip,
     'Pelak': this.pelak,
     'ColorId': this.colorId,
     'Distance': this.distance,
   };
 }

 factory SaveCarModel.fromMap(Map<String, dynamic> map) {
   return new SaveCarModel(
     brandId: map['BrandId'] ,
     modelId: map['ModelId'] ,
     tip: map['Tip'] ,
     pelak: map['Pelak'] ,
     colorId: map['ColorId'] ,
     distance: map['Distance'] ,
   );
 }

}
