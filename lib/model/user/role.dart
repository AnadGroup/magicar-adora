import 'package:anad_magicar/ui/screen/car/fancy_car/src/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Role {
  int roleId;
  String roleName;
  String roleCode;
  bool isActive;
  String description;
  int businessUnitId;
  int owner;
  String version;
  String createdDate;

  Role({
    @required this.roleId,
    @required this.roleName,
    @required this.roleCode,
    @required this.description,

    @required this.isActive,
    @required this.businessUnitId,
    @required this.owner,
    @required this.version,
    @required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'RoleId': this.roleId,
      'RoleTitle': this.roleName,
      'IsActive': this.isActive,
      'Description': this.description,
      'RoleCode':this.roleCode,
      'BusinessUnitId': this.businessUnitId,
      'Owner': this.owner,
      'Version': this.version,
      'CreatedDate': this.createdDate,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return new Role(
      roleId: map['RoleId'],
      roleName: map['RoleTitle'] ,
      roleCode: map['RoleCode'],
      description: map['Description'],
      isActive: map['IsActive'] ,
      businessUnitId: map['BusinessUnitId'] ,
      owner: map['Owner'] ,
      version: map['Version'] ,
      createdDate: map['CreatedDate'] ,
    );
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(roleId: json["RoleId"],
      roleName: json["RoleTitle"],
      description: json["Description"],
      isActive: json["IsActive"],
      roleCode: json["RoleCode"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["Version"],
      createdDate:json["CreatedDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "RoleId": this.roleId,
      "RoleTitle": this.roleName,
      "RoleCode": this.roleCode,
      "IsActive": this.isActive,
      "BusinessUnitId": this.businessUnitId,
      "Owner": this.owner,
      "Version": this.version,
      "Description": this.description,
      "CreatedDate": this.createdDate,
    };

  }


}
