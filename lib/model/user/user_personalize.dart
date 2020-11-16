import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UserPersonalize {
 int userPersonalizeId;
 int userid;
 int  businessUnitId;
 String pKey;
 String pValue;
 Timestamped version;

 UserPersonalize({
   @required this.userPersonalizeId,
   @required this.userid,
   @required this.businessUnitId,
   @required this.pKey,
   @required this.pValue,
   @required this.version,
 });

 Map<String, dynamic> toMap() {
   return {
     'UserPersonalizeId': this.userPersonalizeId,
     'UserId': this.userid,
     'BusinessUnitId': this.businessUnitId,
     'PKey': this.pKey,
     'PValue': this.pValue,
     'Version': this.version,
   };
 }

 factory UserPersonalize.fromMap(Map<String, dynamic> map) {
   return new UserPersonalize(
     userPersonalizeId: map['UserPersonalizeId'],
     userid: map['UserId'] ,
     businessUnitId: map['BusinessUnitId'] ,
     pKey: map['PKey'],
     pValue: map['PValue'] ,
     version: map['Version'] ,
   );
 }

 factory UserPersonalize.fromJson(Map<String, dynamic> json) {
   return UserPersonalize(
     userPersonalizeId: json["UserPersonalizeId"],
     userid: json["UserId"],
     businessUnitId: json["BusinessUnitId"],
     pKey: json["PKey"],
     pValue: json["PValue"],
     version:json["Version"],);
 }

 Map<String, dynamic> toJson() {
   return {
     "UserPersonalizeId": this.userPersonalizeId,
     "UserId": this.userid,
     "BusinessUnitId": this.businessUnitId,
     "PKey": this.pKey,
     "PValue": this.pValue,
     "Version": this.version,
   };
 }


}
