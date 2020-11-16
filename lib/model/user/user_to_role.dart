import 'package:flutter/material.dart';

class UserToRole {
  int userToRoleId;
  int userId;
  int roleId;
  int businessUnitId;

  UserToRole({
    @required this.userToRoleId,
    @required this.userId,
    @required this.roleId,
    @required this.businessUnitId,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserToRoleId': this.userToRoleId,
      'UserId': this.userId,
      'RoleId': this.roleId,
      'BusinessUnitId': this.businessUnitId,
    };
  }

  factory UserToRole.fromMap(Map<String, dynamic> map) {
    return new UserToRole(
      userToRoleId: map['UserToRoleId'] ,
      userId: map['UserId'] ,
      roleId: map['RoleId'] ,
      businessUnitId: map['BusinessUnitId'] ,
    );
  }

  factory UserToRole.fromJson(Map<String, dynamic> json) {
    return UserToRole(userToRoleId: json["UserToRoleId"],
      userId: json["UserId"],
      roleId: json["RoleId"],
      businessUnitId: json["BusinessUnitId"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserToRoleId": this.userToRoleId,
      "UserId": this.userId,
      "RoleId": this.roleId,
      "BusinessUnitId": this.businessUnitId,
    };
  }


}
