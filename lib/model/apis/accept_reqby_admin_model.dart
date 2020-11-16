import 'package:flutter/material.dart';

class  AcceptReqByAdminModel {
  int UserId;
  int CarId;
  int RoleId;

  AcceptReqByAdminModel({
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

  factory AcceptReqByAdminModel.fromMap(Map<String, dynamic> map) {
    return new AcceptReqByAdminModel(
      UserId: map['UserId'] ,
      CarId: map['CarId'] ,
      RoleId: map['RoleId'] ,
    );
  }

  factory AcceptReqByAdminModel.fromJson(Map<String, dynamic> json) {
    return AcceptReqByAdminModel(UserId: json["UserId"],
      CarId: json["CarId"],
      RoleId: json["RoleId"],);
  }

  Map<String, dynamic> toJson() {
    return {"UserId": this.UserId, "CarId": this.CarId, "RoleId": this.RoleId,};
  }


}
