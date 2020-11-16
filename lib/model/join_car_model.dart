import 'package:flutter/material.dart';

class JoinCarModel {

  String carBrandTitle;
  String carModelTitle;
  String carModelDetailTitle;
  int userId;
  int carId;
  String  userName;
  bool isActive;
  String mobile;
  String password;
  int admin;

  JoinCarModel({
    @required this.carBrandTitle,
    @required this.carModelTitle,
    @required this.carId,
    @required this.userName,
    @required this.isActive,
    @required this.mobile,
    @required this.password,
    @required this.admin,
    @required this.userId,
    @required this.carModelDetailTitle
  });

  Map<String, dynamic> toMap() {
    return {
      'CarBrandTitle': this.carBrandTitle,
      'CarModelTitle': this.carModelTitle,
      'CarModelDetailTitle':this.carModelDetailTitle,
      'UserId':this.userId,
      'CarId': this.carId,
      'UserName': this.userName,
      'IsActive': this.isActive,
      'Mobile': this.mobile,
      'Password': this.password,
      'Admin': this.admin,
    };
  }

  factory JoinCarModel.fromMap(Map<String, dynamic> map) {
    return new JoinCarModel(
      carBrandTitle: map['CarBrandTitle'] ,
      carModelTitle: map['CarModelTitle'] ,
      carId: map['CarId'] ,
      userId: map['UserId'],
      carModelDetailTitle: map['CarModelDetailTitle'],
      userName: map['UserName'] ,
      isActive: map['IsActive'] ,
      mobile: map['Mobile'] ,
      password: map['Password'] ,
      admin: map['Admin'] ,
    );
  }

  factory JoinCarModel.fromJson(Map<String, dynamic> json) {
    return JoinCarModel(carBrandTitle: json["carBrandTitle"],
      carModelTitle: json["carModelTitle"],
      carId: json["carId"],
      userName: json["userName"],
      isActive: json["isActive"].toLowerCase() == 'true',
      mobile: json["mobile"],
      userId: json["UserId"],
      password: json["password"],
      admin: json["admin"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "carBrandTitle": this.carBrandTitle,
      "carModelTitle": this.carModelTitle,
      "carId": this.carId,
      "userName": this.userName,
      "isActive": this.isActive,
      "mobile": this.mobile,
      "password": this.password,
      "admin": this.admin,
    };
  }


}
