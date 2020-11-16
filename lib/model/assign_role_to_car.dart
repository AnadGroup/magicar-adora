import 'package:flutter/material.dart';

class AssignRoleToCar {
  int  UserId;
  int  CarId;
  int RoleId;

  AssignRoleToCar({
    @required this.UserId,
    @required this.CarId,
    @required this.RoleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': this.UserId,
      'CarId': this.CarId,
      'RoleId': this.RoleId,
    };
  }

  factory AssignRoleToCar.fromMap(Map<String, dynamic> map) {
    return new AssignRoleToCar(
      UserId: map['UserId'] ,
      CarId: map['CarId'] ,
      RoleId: map['RoleId'] ,
    );
  }

  factory AssignRoleToCar.fromJson(Map<String, dynamic> json) {
    return AssignRoleToCar(UserId: json["UserId"],
      CarId: json["CarId"],
      RoleId: json["RoleId"],);
  }

  Map<String, dynamic> toJson() {
    return {"UserId": this.UserId, "CarId": this.CarId, "RoleId": this.RoleId,};
  }


}