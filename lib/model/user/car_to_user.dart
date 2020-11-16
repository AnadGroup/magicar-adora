import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CarToUser {

  int carToUserId;
  int carId;
  int userId;
  bool isAdmin;
  String fromdate;
  String toDate;
  String description;
  bool isActive;
  int businessUnitId;
  int owner;
  String version;
  String createdDate;
  String carModelTitle;
  int carModelId;
  int colorId;
  int carModelDetailId;
  int carStatusConstId;
  int carToUserStatusConstId;

  String carModelDetailTitle;
  String colorTitle;
  String pelaqueNumber;

  CarToUser({
    @required this.carToUserId,
    @required this.carId,
    @required this.userId,
    @required this.isAdmin,
    @required this.fromdate,
    @required this.toDate,
    @required this.description,
    @required this.isActive,
    @required this.businessUnitId,
    @required this.owner,
    @required this.version,
    @required this.createdDate,
    @required this.colorId,
    @required this.carModelDetailId,
    @required this.carModelDetailTitle,
    @required this.carModelId,
    @required this.carModelTitle,
    @required this.carStatusConstId,
    @required this.carToUserStatusConstId,
    @required this.colorTitle,
    @required this.pelaqueNumber,

  });


  Map<String, dynamic> toMap() {
    return {
      'CarToUserId': this.carToUserId,
      'CarId': this.carId,
      'UserId': this.userId,
      'IsAdmin': this.isAdmin,
      'FromDate': this.fromdate,
      'ToDate': this.toDate,
      'Description': this.description,
      'IsActive': this.isActive,
      'BusinessUnitId': this.businessUnitId,
      'Owner': this.owner,
      'Version': this.version,
      'CreatedDate': this.createdDate,
    };
  }

  factory CarToUser.fromMap(Map<String, dynamic> map) {
    return new CarToUser(
      carToUserId: map['CarToUserId'] ,
      carId: map['CarId'] ,
      userId: map['UserId'] ,
      isAdmin: map['IsAdmin'] ,
      fromdate: map['FromDate'] ,
      toDate: map['ToDate'] ,
      description: map['Description'] ,
      isActive: map['IsActive'] ,
      businessUnitId: map['BusinessUnitId'] ,
      owner: map['Owner'] ,
      version: map['Version'] ,
      createdDate: map['CreatedDate'] ,
    );
  }

  factory CarToUser.fromJson(Map<String, dynamic> json) {
    return CarToUser(carToUserId: json["CarToUserId"],
      carId: json["CarId"],
      userId: json["UserId"],
      isAdmin: json["IsAdmin"],
      fromdate: json["FromDate"],
      toDate: json["ToDate"],
      description: json["Description"],
      isActive: json["IsActive"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["Version"],
      createdDate: json["CreatedDate"],);
  }

  factory CarToUser.fromJsonForCarWaiting(Map<String, dynamic> json) {
    return CarToUser(carToUserId: json["CarToUserId"],
      carId: json["CarId"],
      userId: json["UserId"],
      isAdmin: json["IsAdmin"],
      fromdate: json["FromDate"],
      toDate: json["ToDate"],
      description: json["Description"],
      isActive: json["IsActive"],
      carModelDetailId: json["CarModelDetailId"],
    carModelDetailTitle: json["CarModelDetailTitle"],
    carModelId: json["CarModelId"],
      carModelTitle: json["CarModelTitle"],
      carStatusConstId: json["CarStatusConstId"],
      carToUserStatusConstId: json["CarToUserStatusConstId"],
      colorId: json["ColorTypeConstId"],
      pelaqueNumber: json["PlaqueNumber"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CarToUserId": this.carToUserId,
      "CarId": this.carId,
      "UserId": this.userId,
      "IsAdmin": this.isAdmin,
      "FromDate": this.fromdate,
      "ToDate": this.toDate,
      "Description": this.description,
      "IsActive": this.isActive,
      "BusinessUnitId": this.businessUnitId,
      "Owner": this.owner,
      "Version": this.version,
      "CreatedDate": this.createdDate,
    };
  }


}
