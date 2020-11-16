import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';

class ActionModel {

  int ActionId;
 String ActionCode;
  String ActionTitle;
  String KeyString;
  int CarId;
  String Description;
  bool IsActive;
  int  BusinessUnitId;
  int Owner;
  String Version;
  String CreatedDate;

  bool selected=false;

  ActionModel({
    @required this.ActionId,
    @required this.ActionCode,
    @required this.ActionTitle,
    @required this.KeyString,
    @required this.CarId,
    @required this.Description,
    @required this.IsActive,
    @required this.BusinessUnitId,
    @required this.Owner,
    @required this.Version,
    @required this.CreatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'ActionId': this.ActionId,
      'ActionCode': this.ActionCode,
      'ActionTitle': this.ActionTitle,
      'KeyString': this.KeyString,
      'CarId': this.CarId,
      'Description': this.Description,
      'IsActive': this.IsActive,
      'BusinessUnitId': this.BusinessUnitId,
      'Owner': this.Owner,
      'Version': this.Version,
      'CreatedDate': this.CreatedDate,
    };
  }

  factory ActionModel.fromMap(Map<String, dynamic> map) {
    return new ActionModel(
      ActionId: map['ActionId'] ,
      ActionCode: map['ActionCode'] ,
      ActionTitle: map['ActionTitle'] ,
      KeyString: map['KeyString'] ,
      CarId: map['CarId'] ,
      Description: map['Description'] ,
      IsActive: map['IsActive'] as bool,
      BusinessUnitId: map['BusinessUnitId'] ,
      Owner: map['Owner'] ,
      Version: map['Version'] ,
      CreatedDate: map['CreatedDate'] ,
    );
  }

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(ActionId: json["ActionId"],
      ActionCode: json["ActionCode"],
      ActionTitle: json["ActionTitle"],
      KeyString: json["KeyString"],
      CarId: json["CarId"],
      Description: DartHelper.isNullOrEmptyString(json["Description"]),
      IsActive: json["IsActive"],
      BusinessUnitId: json["BusinessUnitId"],
      Owner: json["Owner"],
      Version: json["Version"],
      CreatedDate: json["CreatedDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "ActionId": this.ActionId,
      "ActionCode": this.ActionCode,
      "ActionTitle": this.ActionTitle,
      "KeyString": this.KeyString,
      "CarId": this.CarId,
      "Description": this.Description,
      "IsActive": this.IsActive,
      "BusinessUnitId": this.BusinessUnitId,
      "Owner": this.Owner,
      "Version": this.Version,
      "CreatedDate": this.CreatedDate,
    };
  }


}
