

import 'package:flutter/material.dart';

class Roles {
  int RoleId;
  String RoleTitle;

  Roles({@required this.RoleId,
     @required this.RoleTitle});

  Map<String, dynamic> toMap() {
    return {
      'RoleId': this.RoleId,
      'RoleTitle': this.RoleTitle,
    };
  }

  factory Roles.fromMap(Map<String, dynamic> map) {
    return new Roles(
      RoleId: map['RoleId'] ,
      RoleTitle: map['RoleTitle'] ,
    );
  }

  factory Roles.fromJson(Map<String, dynamic> json) {
    return Roles(
      RoleId: json["RoleId"], RoleTitle: json["RoleTitle"],);
  }

  Map<String, dynamic> toJson() {
    return {"RoleId": this.RoleId, "RoleTitle": this.RoleTitle,};
  }

}