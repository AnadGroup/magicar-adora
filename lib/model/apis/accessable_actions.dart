
import 'package:flutter/material.dart';

class AccessableActions {

  String ActionTitle;
  int ActionId;
  String ActionCode;
  bool IsActive;

  AccessableActions({
    @required this.ActionTitle,
    @required this.ActionId,
    @required this.ActionCode,
    @required this.IsActive,
    this.isExpanded
  });

  bool isExpanded=false;
  Map<String, dynamic> toMap() {
    return {
     // 'ActionTitle': this.ActionTitle,
      'ActionId': this.ActionId,
     // 'ActionCode': this.ActionCode,
      'IsActive': this.IsActive,
    };
  }

  factory AccessableActions.fromMap(Map<String, dynamic> map) {
    return new AccessableActions(
     // ActionTitle: map['ActionTitle'] ,
      ActionId: map['ActionId'] ,
     // ActionCode: map['ActionCode'] ,
      IsActive: map['IsActive'] ,
    );
  }

  factory AccessableActions.fromJson(Map<String, dynamic> json) {
    return AccessableActions(
     // ActionTitle: json["ActionTitle"],
      ActionId: json["ActionId"],
      //ActionCode: json["ActionCode"],
      IsActive: json["IsActive"],);
  }

  Map<String, dynamic> toJson() {

    return {
     // "ActionTitle": this.ActionTitle,
      "ActionId": this.ActionId,
     // "ActionCode": this.ActionCode,
      "IsActive": this.IsActive,
    };
  }

}
