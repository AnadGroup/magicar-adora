import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class User {
  int id;
  String userName;
  String passWord;
  String reTypePassword;
  String email;
  String personalizeData;
  int partyId;
  bool isActive;
  int businessUnitId;
  int owner;
  Timestamped version;
  DateTime createdDate;
  String oldCode;
  DateTime expireDate;
  String firstName;
  String lastName;
  String mobile;
  String imageUrl;
  User({
     this.id,
     this.userName,
     this.passWord,
     this.reTypePassword,
     this.email,
     this.personalizeData,
     this.partyId,
     this.businessUnitId,
     this.owner,
     this.version,
     this.createdDate,
     this.oldCode,
     this.expireDate,
     this.isActive,
    this.firstName,
    this.lastName,
    this.mobile,
    this.imageUrl
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json["UserId"],
      userName: json["UserName"],
      passWord: json["PassWord"],
      email: json["Email"],
      personalizeData: json["PersonalizeData"],
      partyId: json["PartyId"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["Version"],
      createdDate: json["CreatedDate"],
      oldCode: json["OldCode"],
      isActive: json['IsActive'],
      expireDate: json["ExpireDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserId": this.id,
      "UserName": this.userName,
      "PassWord": this.passWord,
      "Email": this.email,
      "PersonalizeData": this.personalizeData,
      "PartyId": this.partyId,
      "BusinessUnitId": this.businessUnitId,
      "Owner": this.owner,
      "Version": this.version,
      "CreatedDate": this.createdDate.toIso8601String(),
      "OldCode": this.oldCode,
      "ExpireDate": this.expireDate.toIso8601String(),
      "IsActive" :this.isActive
    };
  }

  Map<String, dynamic> toJsonForSave() {
    return {
      "UserName": this.userName,
      "Password": this.passWord,
      "FirstName": this.firstName,
      "LastName": this.lastName,
      "MobileNo": this.mobile,
    };
  }
  factory User.fromJsonForSave(Map<String, dynamic> json) {
    return User(id: json["UserId"],
      userName: json["UserName"],
      passWord: json["PassWord"],
      email: json["Email"],
      personalizeData: json["PersonalizeData"],
      partyId: json["PartyId"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],
      version: json["Version"],
      createdDate: json["CreatedDate"],
      oldCode: json["OldCode"],
      isActive: json['IsActive'],
      expireDate: json["ExpireDate"],);
  }

  Map<String, dynamic> toMapForSave() {
    return {
      'UserName': this.userName,
      'Password': this.passWord,
      'IsActive': this.isActive,
      'Owner': this.owner,
      'FirstName': this.firstName,
      'LastName': this.lastName,
      'Mobile': this.mobile,
    };
  }

  factory User.fromMapForSave(Map<String, dynamic> map) {
    return new User(
      userName: map['UserName'] ,
      passWord: map['Password'] ,
      isActive: map['IsActive'] ,
      owner: map['Owner'] ,
      firstName: map['FirstName'] ,
      lastName: map['LastName'] ,
      mobile: map['Mobile'] ,
    );
  }

}
