import 'package:flutter/material.dart';

class UserRoleModel {

  int userId;
  int roleId;

  UserRoleModel({
    @required this.userId,
    @required this.roleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'roleId': this.roleId,
    };
  }

  factory UserRoleModel.fromMap(Map<String, dynamic> map) {
    return new UserRoleModel(
      userId: map['userId'] ,
      roleId: map['roleId'] ,
    );
  }

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      userId: json["userId"], roleId: json["roleId"],);
  }

  Map<String, dynamic> toJson() {
    return {"userId": this.userId, "roleId": this.roleId,};
  }


}