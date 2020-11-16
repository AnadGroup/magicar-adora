import 'package:flutter/material.dart';

class ApiRelatedUserModel {
  int userId;
  String userName;
  String roleTitle;
  int roleId;

  ApiRelatedUserModel({
    @required this.userId,
    @required this.userName,
    @required this.roleTitle,
    @required this.roleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': this.userId,
      'UserName': this.userName,
      'RoleTitle': this.roleTitle,
      'RoleId': this.roleId,
    };
  }

  factory ApiRelatedUserModel.fromMap(Map<String, dynamic> map) {
    return new ApiRelatedUserModel(
      userId: map['UserId'] ,
      userName: map['UserName'],
      roleTitle: map['RoleTitle'] ,
      roleId: map['RoleId'],
    );
  }

  factory ApiRelatedUserModel.fromJson(Map<String, dynamic> json) {
    return ApiRelatedUserModel(userId: json["UserId"],
      userName: json["UserName"],
      roleTitle: json["RoleTitle"],
      roleId: json["RoleId"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserId": this.userId,
      "UserName": this.userName,
      "RoleTitle": this.roleTitle,
      "RoleId": this.roleId,
    };
  }


}