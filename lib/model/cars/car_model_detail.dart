import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CarModelDetail {

  int carModelDetailId;
  String carModelDetailTitle;
  String imageUrl;
  int carModelId;
  String description;
  bool isActive;
  int businessUnitId;
  int owner;
  String version;
  String createdDate;

  CarModelDetail({
    @required this.carModelDetailId,
    @required this.carModelDetailTitle,
    @required this.imageUrl,
    @required this.carModelId,
    @required this.description,
    @required this.isActive,
    @required this.businessUnitId,
    @required this.owner,
    @required this.version,
    @required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'CarModelDetailId': this.carModelDetailId,
      'CarModelDetailTitle': this.carModelDetailTitle,
      'ImageUrl': this.imageUrl,
      'CarModelId': this.carModelId,
      'Description': this.description,
      'IsActive': this.isActive,
      'BusinessUnitId': this.businessUnitId,
      'Owner': this.owner,
      'Version': this.version,
      'CreatedDate': this.createdDate,
    };
  }

  factory CarModelDetail.fromMap(Map<String, dynamic> map) {
    return new CarModelDetail(
      carModelDetailId: map['CarModelDetailId'] ,
      carModelDetailTitle: map['CarModelDetailTitle'] ,
      imageUrl: map['ImageUrl'] ,
      carModelId: map['CarModelId'] ,
      description: map['Description'] ,
      isActive: map['IsActive'] ,
      businessUnitId: map['BusinessUnitId'] ,
      owner: map['Owner'] ,
      version: map['Version'] ,
      createdDate: map['CreatedDate'] ,
    );
  }

  factory CarModelDetail.fromJson(Map<String, dynamic> json) {
    return CarModelDetail(carModelDetailId: json["CarModelDetailId"],
      carModelDetailTitle: json["CarModelDetailTitle"],
      imageUrl: json["ImageUrl"],
      carModelId: json["CarModelId"],
      description: json["Description"],
      isActive: json["IsActive"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["Version"],
      createdDate: json["CreatedDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "CarModelDetailId": this.carModelDetailId,
      "CarModelDetailTitle": this.carModelDetailTitle,
      "ImageUrl": this.imageUrl,
      "CarModelId": this.carModelId,
      "Description": this.description,
      "IsActive": this.isActive,
      "BusinessUnitId": this.businessUnitId,
      "Owner": this.owner,
      "Version": this.version,
      "CreatedDate": this.createdDate,
    };
  }


}
