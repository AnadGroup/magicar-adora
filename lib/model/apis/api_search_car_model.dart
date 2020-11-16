import 'package:flutter/material.dart';

class SearchCarModel {
 int AdminUserId;
 int RequestFromThisUserId;
 int CarId;
 String Message;
 String UserName ;
 String Password ;
 String FirstName ;
 String LastName ;
 String SimCard ;
 String PlaqueNumber ;
 String CarModelDetailTitle ;
 String CarModelTitle ;
 String BrandTitle ;
 String ColorTitle ;
 bool IsActive;
 int userId;
 String pelak;
 String DecviceSerialNumber;


 SearchCarModel({
   @required this.AdminUserId,
   @required this.RequestFromThisUserId,
   @required this.CarId,
   @required this.Message,
   @required this.UserName,
   @required this.Password,
   @required this.FirstName,
   @required this.LastName,
   @required this.SimCard,
   @required this.PlaqueNumber,
   @required this.CarModelDetailTitle,
   @required this.CarModelTitle,
   @required this.BrandTitle,
   @required this.ColorTitle,
   @required this.IsActive,
   @required this.userId,
   @required this.pelak,
   @required this.DecviceSerialNumber,
 });



 Map<String, dynamic> toMap() {
   return {
     'AdminUserId': this.AdminUserId,
     'RequestFromThisUserId': this.RequestFromThisUserId,
     'CarId': this.CarId,
     'Message': this.Message,
   };
 }
 Map<String, dynamic> toMapForSendSearchModel() {
   return {
     'userId': this.userId,
     'DecviceSerialNumber': this.DecviceSerialNumber,
     'CarId': this.CarId,
     'pelak': this.pelak,
   };
 }

 factory SearchCarModel.fromMapForSendSearchModel(Map<String, dynamic> map) {
   return new SearchCarModel(
     userId: map['userId'] ,
     DecviceSerialNumber: map['DecviceSerialNumber'] ,
     CarId: map['CarId'] ,
     pelak: map['pelak'] ,
   );
 }
 factory SearchCarModel.fromMap(Map<String, dynamic> map) {
   return new SearchCarModel(
     AdminUserId: map['AdminUserId'] ,
     RequestFromThisUserId: map['RequestFromThisUserId'] ,
     CarId: map['CarId'] ,
     Message: map['Message'] ,
   );
 }



 factory SearchCarModel.fromJsonForSendSearchModel(Map<String, dynamic> json) {
   return SearchCarModel(AdminUserId: json["userId"],
     RequestFromThisUserId: json["DecviceSerialNumber"],
     CarId: json["CarId"],
     Message: json["pelak"],);
 }

 Map<String, dynamic> toJsonForSendSearchModel() {
   return {
     "userId": this.userId,
     "DecviceSerialNumber": this.DecviceSerialNumber,
     "CarId": this.CarId,
     "pelak": this.pelak,
   };
 }

 factory SearchCarModel.fromJson(Map<String, dynamic> json) {
   return SearchCarModel(AdminUserId: json["AdminUserId"],
     RequestFromThisUserId: json["RequestFromThisUserId"],
     CarId: json["CarId"],
     Message: json["Message"],
     UserName: json["UserName"],
     Password: json["Password"],
     FirstName: json["FirstName"],
     LastName: json["LastName"],
     SimCard: json["SimCard"],
     PlaqueNumber: json["PlaqueNumber"],
     CarModelDetailTitle: json["CarModelDetailTitle"],
     CarModelTitle: json["CarModelTitle"],
     BrandTitle: json["BrandTitle"],
     ColorTitle: json["ColorTitle"],
     IsActive: json["IsActive"].toLowerCase() == 'true',);
 }

 Map<String, dynamic> toJson() {
   return {
     "AdminUserId": this.AdminUserId,
     "RequestFromThisUserId": this.RequestFromThisUserId,
     "CarId": this.CarId,
     "Message": this.Message,
     "UserName": this.UserName,
     "Password": this.Password,
     "FirstName": this.FirstName,
     "LastName": this.LastName,
     "SimCard": this.SimCard,
     "PlaqueNumber": this.PlaqueNumber,
     "CarModelDetailTitle": this.CarModelDetailTitle,
     "CarModelTitle": this.CarModelTitle,
     "BrandTitle": this.BrandTitle,
     "ColorTitle": this.ColorTitle,
     "IsActive": this.IsActive,
     "userId": this.userId,
     "pelak": this.pelak,
     "DecviceSerialNumber": this.DecviceSerialNumber,
   };
 }


}
