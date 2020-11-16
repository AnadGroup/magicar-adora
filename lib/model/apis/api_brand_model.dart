import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BrandModel {
  int brandId;
  String brandTitle;
  String brandCode;
  String decription;
  String imageUrl;
  String description;
  bool isActive;
  int businessUnitId;
  int owner;
  String version;
  String createdDate;


  BrandModel({
    @required this.brandId,
    @required this.brandTitle,
    @required this.brandCode,
    @required this.decription,
    @required this.imageUrl,
    @required this.description,
    @required this.isActive,
    @required this.businessUnitId,
    @required this.owner,
    @required this.version,
    @required this.createdDate,
  });


  Map<String, dynamic> toMap() {
    return {
      'BrandId': this.brandId,
      'BrandCode': this.brandCode,
      'BrandTitle': this.brandTitle,
      'ImageUrl': this.imageUrl,
      'Description': this.description,
      'IsActive': this.isActive,
      'BusinessUnitId': this.businessUnitId,
      'Owner': this.owner,
      'Version': this.version,
      'CreatedDate': this.createdDate,
    };
  }


  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return new BrandModel(
      brandId: map['BrandId'] ,
      brandCode: map['BrandCode'] ,
      brandTitle: map['BrandTitle'] ,
      imageUrl: map['ImageUrl'] ,
      description: map['Description'] ,
      isActive: map['IsActive'] as bool,
      businessUnitId: map['BusinessUnitId'] ,
      owner: map['Owner'] ,
      version: map['Version'] ,
      createdDate: map['CreatedDate'] ,
    );
  }

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(brandId: json["BrandId"],
      brandCode: json["BrandCode"],
      brandTitle: json["BrandTitle"],
      imageUrl: json["ImageUrl"],
      description: DartHelper.isNullOrEmptyString(json["Description"]),
      isActive: json["IsActive"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["Version"],
      createdDate: json["CreatedDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "BrandId": this.brandId,
      "BrandCode": this.brandCode,
      "BrandTitle": this.brandTitle,
      "ImageUrl": this.imageUrl,
      "Description": this.description,
      "IsActive": this.isActive,
      "BusinessUnitId": this.businessUnitId,
      "Owner": this.owner,
      "Version": this.version,
      "CreatedDate": this.createdDate,
    };
  }

  Map<String, dynamic> toJsonForGetBrand() {
    return {
      "brandId": this.brandId,
      //"BrandTitle": this.BrandTitle,
      //"Decription": this.Decription,
    };
  }



}
