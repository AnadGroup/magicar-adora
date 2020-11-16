import 'package:flutter/material.dart';

class UserLoginedInfo {
  static final USERNAME_TAG='USERNAME_LOGINED_TAG';
  static final CARCOUNTS_TAG='CARCOUNTS_LOGINED_TAG';
  static final USERCOUNTS_TAG='USERCOUNTS_LOGINED_TAG';
  static final AUTH_TOKEN_TAG='AUTH_TOKEN_LOGINED_TAG';
  static final LOGINED_DATE_TAG='LOGINED_DATE_LOGINED_TAG';
  static final USERID_TAG='USERID_LOGINED_TAG';


  String userName;
  int userCounts;
  int carCounts;
  String auth_token;
  String logined_date;
  int userId;

  UserLoginedInfo({
    @required this.userName,
    @required this.userCounts,
    @required this.carCounts,
    @required this.auth_token,
    @required this.logined_date,
    @required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': this.userName,
      'userCounts': this.userCounts,
      'carCounts': this.carCounts,
      'auth_token': this.auth_token,
      'logined_date': this.logined_date,
      'userId': this.userId,
    };
  }

  factory UserLoginedInfo.fromMap(Map<String, dynamic> map) {
    return new UserLoginedInfo(
      userName: map['userName'] ,
      userCounts: map['userCounts'] ,
      carCounts: map['carCounts'] ,
      auth_token: map['auth_token'] ,
      logined_date: map['logined_date'] ,
      userId: map['userId'] ,
    );
  }

  factory UserLoginedInfo.fromJson(Map<String, dynamic> json) {
    return UserLoginedInfo(userName: json["userName"],
      userCounts: json["userCounts"],
      carCounts: json["carCounts"],
      auth_token: json["auth_token"],
      logined_date: json["logined_date"],
      userId: json["userId"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": this.userName,
      "userCounts": this.userCounts,
      "carCounts": this.carCounts,
      "auth_token": this.auth_token,
      "logined_date": this.logined_date,
      "userId": this.userId,
    };
  }


}
