import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Brand {
  int brandId;
  String brandCode;
  String brandTitle;
  String imageUrl;
  String description;
  bool isActive;
  int businessUnitId;
  int owner;
  Timestamped version;
  DateTime createdDate;

  Brand({
    @required this.brandId,
    @required this.brandCode,
    @required this.brandTitle,
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

  factory Brand.fromMap(Map<String, dynamic> map) {
    return new Brand(
      brandId: map['BrandId'] ,
      brandCode: map['BrandCode'] ,
      brandTitle: map['BrandTitle'] as String,
      imageUrl: map['ImageUrl'] as String,
      description: map['Description'] as String,
      isActive: map['IsActive'] as bool,
      businessUnitId: map['BusinessUnitId'] as int,
      owner: map['Owner'] as int,
      version: map['Version'] as Timestamped,
      createdDate: map['CreatedDate'] as DateTime,
    );
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(brandId: json["BrandId"],
      brandCode: json["BrandCode"],
      brandTitle: json["BrandTitle"],
      imageUrl: json["ImageUrl"],
      description: json["Description"],
      isActive: json["IsActive"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["version"],
      createdDate: json["createdDate"],);
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
      "CreatedDate": this.createdDate.toIso8601String(),
    };
  }


}