import 'package:flutter/material.dart';

class ApiResultConstant {
  int ConstantId;
  String DisplayName;

  ApiResultConstant({
    @required this.ConstantId,
    @required this.DisplayName,
  });

  Map<String, dynamic> toMap() {
    return {
      'ConstantId': this.ConstantId,
      'DisplayName': this.DisplayName,
    };
  }

  factory ApiResultConstant.fromMap(Map<String, dynamic> map) {
    return new ApiResultConstant(
      ConstantId: map['ConstantId'] ,
      DisplayName: map['DisplayName'] ,
    );
  }

  factory ApiResultConstant.fromJson(Map<String, dynamic> json) {
    return ApiResultConstant(ConstantId: json["ConstantId"],
      DisplayName: json["DisplayName"],);
  }

  Map<String, dynamic> toJson() {
    return {"ConstantId": this.ConstantId, "DisplayName": this.DisplayName,};
  }


}