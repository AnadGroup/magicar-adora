import 'package:flutter/material.dart';

class ActionToRoleModel {

  int ActionToRoleId ;
  int ActionId;
  int RoleId;
  String Description;
  bool IsActive;
  int BusinessUnitId;
  int Owner;
  String Version;
  String CreatedDate;

  ActionToRoleModel({
    @required this.ActionToRoleId,
    @required this.ActionId,
    @required this.RoleId,
    @required this.Description,
    @required this.IsActive,
    @required this.BusinessUnitId,
    @required this.Owner,
    @required this.Version,
    @required this.CreatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'ActionToRoleId': this.ActionToRoleId,
      'ActionId': this.ActionId,
      'RoleId': this.RoleId,
      'Description': this.Description,
      'IsActive': this.IsActive,
      'BusinessUnitId': this.BusinessUnitId,
      'Owner': this.Owner,
      'Version': this.Version,
      'CreatedDate': this.CreatedDate,
    };
  }

  factory ActionToRoleModel.fromMap(Map<String, dynamic> map) {
    return new ActionToRoleModel(
      ActionToRoleId: map['ActionToRoleId'] ,
      ActionId: map['ActionId'] ,
      RoleId: map['RoleId'] ,
      Description: map['Description'] ,
      IsActive: map['IsActive'] ,
      BusinessUnitId: map['BusinessUnitId'] ,
      Owner: map['Owner'] ,
      Version: map['Version'] ,
      CreatedDate: map['CreatedDate'] ,
    );
  }

  factory ActionToRoleModel.fromJson(Map<String, dynamic> json) {
    return ActionToRoleModel(ActionToRoleId: json["ActionToRoleId"],
      ActionId: json["ActionId"],
      RoleId: json["RoleId"],
      Description: json["Description"],
      IsActive: json["IsActive"],
      BusinessUnitId: json["BusinessUnitId"],
      Owner: json["Owner"],
      Version: json["Version"],
      CreatedDate: json["CreatedDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "ActionToRoleId": this.ActionToRoleId,
      "ActionId": this.ActionId,
      "RoleId": this.RoleId,
      "Description": this.Description,
      "IsActive": this.IsActive,
      "BusinessUnitId": this.BusinessUnitId,
      "Owner": this.Owner,
      "Version": this.Version,
      "CreatedDate": this.CreatedDate,
    };
  }


}