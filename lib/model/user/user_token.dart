import 'package:flutter/material.dart';

class UserToken {
  int userTokenId;
  int userId;
  DateTime createdDate;
  DateTime expirationDate;
  String loginInfo;
  String clientId;
  bool isActive;

  UserToken({
    @required this.userTokenId,
    @required this.userId,
    @required this.createdDate,
    @required this.expirationDate,
    @required this.loginInfo,
    @required this.clientId,
    @required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserTokenId': this.userTokenId,
      'UserId': this.userId,
      'CreatedDate': this.createdDate,
      'ExpirationDate': this.expirationDate,
      'LoginInfo': this.loginInfo,
      'ClientId': this.clientId,
      'IsActive': this.isActive,
    };
  }

  factory UserToken.fromMap(Map<String, dynamic> map) {
    return new UserToken(
      userTokenId: map['UserTokenId'] ,
      userId: map['UserId'] ,
      createdDate: map['CreatedDate'] ,
      expirationDate: map['ExpirationDate'],
      loginInfo: map['LoginInfo'] ,
      clientId: map['ClientId'],
      isActive: map['IsActive'] ,
    );
  }

  factory UserToken.fromJson(Map<String, dynamic> json) {
    return UserToken(userTokenId: json["UserTokenId"],
      userId: json["UserId"],
      createdDate: json["CreatedDate"],
      expirationDate: json["ExpirationDate"],
      loginInfo: json["LoginInfo"],
      clientId: json["ClientId"],
      isActive: json["IsActive"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserTokenId": this.userTokenId,
      "UserId": this.userId,
      "CreatedDate": this.createdDate.toIso8601String(),
      "ExpirationDate": this.expirationDate.toIso8601String(),
      "LoginInfo": this.loginInfo,
      "ClientId": this.clientId,
      "IsActive": this.isActive,
    };
  }


}
