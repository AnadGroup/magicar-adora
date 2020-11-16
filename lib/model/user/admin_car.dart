import 'package:flutter/material.dart';

class AdminCarModel {
  int CarId;
  String CreatedDate;
  String Description;
  String FromDate;
  String ToDate;
  bool IsActive;
  bool IsAdmin;
  int UserId;
  String CarModelDetailTitle;
  String CarModelTitle;
  String BrandTitle;
  String colorTitle;
  int colorId;
  int carModelId;
  int carModelDetailId;
  int CarToUserStatusConstId;
  String CarToUserStatusConstTitle;

  AdminCarModel({
    @required this.CarId,
    @required this.CreatedDate,
    @required this.Description,
    @required this.FromDate,
    @required this.ToDate,
    @required this.IsActive,
    @required this.IsAdmin,
    @required this.UserId,
    @required this.CarModelDetailTitle,
    @required this.CarModelTitle,
    @required this.BrandTitle,
    @required this.CarToUserStatusConstId,
    @required this.CarToUserStatusConstTitle,
    @required this.carModelId,
    @required this.carModelDetailId,
    this.colorTitle,
    this.colorId
  });

  Map<String, dynamic> toMap() {
    return {
      'CarId': this.CarId,
      'CreatedDate': this.CreatedDate,
      'Description': this.Description,
      'FromDate': this.FromDate,
      'ToDate': this.ToDate,
      'IsActive': this.IsActive,
      'IsAdmin': this.IsAdmin,
      'UserId': this.UserId,
      'CarModelDetailTitle': this.CarModelDetailTitle,
      'CarModelTitle': this.CarModelTitle,
      'BrandTitle': this.BrandTitle,
    };
  }

  factory AdminCarModel.fromMap(Map<String, dynamic> map) {
    return new AdminCarModel(
      CarId: map['CarId'] ,
      CreatedDate: map['CreatedDate'] ,
      Description: map['Description'] ,
      FromDate: map['FromDate'] ,
      ToDate: map['ToDate'] ,
      IsActive: map['IsActive'] ,
      IsAdmin: map['IsAdmin'] ,
      UserId: map['UserId'] ,
      CarModelDetailTitle: map['CarModelDetailTitle'] ,
      CarModelTitle: map['CarModelTitle'] ,
      BrandTitle: map['BrandTitle'] ,
    );
  }
  factory AdminCarModel.fromMapForCarJoint(Map<String, dynamic> map) {
    return new AdminCarModel(
      CarId: map['CarId'] ,
      //CreatedDate: map['CreatedDate'] ,
      //Description: map['Description'] ,
      //FromDate: map['FromDate'] ,
      //ToDate: map['ToDate'] ,
      IsActive: map['IsActive'] ,
      IsAdmin: map['IsAdmin'] ,
      UserId: map['UserId'] ,
      CarModelDetailTitle: map['CarModelDetailTitle'] ,
      CarModelTitle: map['CarModelTitle'] ,
      BrandTitle: map['BrandTitle'] ,
    );
  }
  factory AdminCarModel.fromJson(Map<String, dynamic> json) {
    return AdminCarModel(CarId: json["CarId"],
      CreatedDate: json["CreatedDate"],
      Description: json["Description"],
      FromDate:json["FromDate"],
      ToDate: json["ToDate"],
      IsActive: json["IsActive"],
      IsAdmin: json["IsAdmin"],
      UserId: json["UserId"],
      CarModelDetailTitle: json["CarModelDetailTitle"],
      CarModelTitle: json["CarModelTitle"],
      BrandTitle: json["BrandTitle"],


    );
  }

  factory AdminCarModel.fromJsonForUser(Map<String, dynamic> json) {
    return AdminCarModel(CarId: json["CarId"],
      CreatedDate: json["CreatedDate"],
      Description: json["Description"],
      FromDate:json["FromDate"],
      ToDate: json["ToDate"],
      IsActive: json["IsActive"],
      IsAdmin: json["IsAdmin"],
      UserId: json["UserId"],
      CarModelDetailTitle: json["CarModelDetailTitle"],
     // CarModelTitle: json["CarModelTitle"],
     // BrandTitle: json["BrandTitle"],
      carModelId: json["CarModelId"],
      carModelDetailId: json["CarModelDetailId"],
      CarToUserStatusConstTitle: json["CarToUserStatusConstTitle"],
      CarToUserStatusConstId: json["CarToUserStatusConstId"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "CarId": this.CarId,
      "CreatedDate": this.CreatedDate,
      "Description": this.Description,
      "FromDate": this.FromDate,
      "ToDate": this.ToDate,
      "IsActive": this.IsActive,
      "IsAdmin": this.IsAdmin,
      "UserId": this.UserId,
      "CarModelDetailTitle": this.CarModelDetailTitle,
      "CarModelTitle": this.CarModelTitle,
      "BrandTitle": this.BrandTitle,
    };
  }

  Map<String, dynamic> toJsonForCarJson() {
    return {
      "CarId": this.CarId,
      "CreatedDate": this.CreatedDate,
      "Description": this.Description,
      "FromDate": this.FromDate,
      "ToDate": this.ToDate,
      "IsActive": this.IsActive,
      "IsAdmin": this.IsAdmin,
      "UserId": this.UserId,
      "CarModelDetailTitle": this.CarModelDetailTitle,
      "CarModelTitle": this.CarModelTitle,
      "BrandTitle": this.BrandTitle,
    };
  }

}
