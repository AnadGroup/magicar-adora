import 'dart:async';
import 'dart:core';

import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:flutter/material.dart';

class UserRepository {
  Future<String> authenticate(
      {@required String username,
      @required String password,
      @required String token}) async {
    await databaseHelper.saveUser(
        new User(userName: username, passWord: password, mobile: username));
    //await Future.delayed(Duration(seconds: 1));
    return token;
  }

  Future<ServiceResult> login({@required username, @required password}) {
    RestDatasource restDatasource = RestDatasource();
    return restDatasource.login(username, password);
  }

  Future<String> sendSMS(String mobile) {
    RestDatasource restDatasource = new RestDatasource();
    return restDatasource.sendSMSCode(mobile, 0);
  }

  Future register({@required SaveUserModel user}) {
    RestDatasource restDatasource = new RestDatasource();
    return restDatasource.register(body: user.toJson());
  }

  Future<String> getUserName() async {
    User user = await databaseHelper.getUserInfo();
    if (user != null) {
      return user.userName;
    }
    return '';
  }

  Future<bool> getUserType() async {
    User user = await databaseHelper.getUserInfo();
    if (user != null) {
      return user.owner <= 0;
    }
    return false;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    //await Future.delayed(Duration(seconds: 1));
    User user = await databaseHelper.getUserInfo();
    if (user != null) {
      //await databaseHelper.saveUser(user);
      await databaseHelper.deleteUsers();
    }
    return;
  }

  Future<void> persistToken(String token) async {
    User user = await databaseHelper.getUserInfo();
    if (user != null) {
      //user.;
      //user.password=
      await databaseHelper.saveUser(user);
    }
    return;
  }

  Future<bool> hasToken() async {
    bool result = await databaseHelper.isLoggedIn();
    return result;
  }

  Future<bool> persistCookie(String token, String clientId) async {
    return await prefRepository.setLoginedToken(token, clientId);
  }

  Future<String> getCookie() async {
    return await prefRepository.getLoginedToken();
  }

  Future<String> getCookieClientId() async {
    return await prefRepository.getLoginedClientID();
  }

  static convertArabicToEnglish(String arabicText) {
    if (arabicText != null && arabicText.isNotEmpty) {
      String temp = arabicText
          .replaceAll("١", "1")
          .replaceAll("٢", "2")
          .replaceAll("٣", "3")
          .replaceAll("٤", "4")
          .replaceAll("٥", "5")
          .replaceAll("٦", "6")
          .replaceAll("٧", "7")
          .replaceAll("٨", "8")
          .replaceAll("٩", "9")
          .replaceAll("٠", "0")
          .replaceAll("۱", "1")
          .replaceAll("۲", "2")
          .replaceAll("۳", "3")
          .replaceAll("۴", "4")
          .replaceAll("۵", "5")
          .replaceAll("۶", "6")
          .replaceAll("۷", "7")
          .replaceAll("۸", "8")
          .replaceAll("۹", "9")
          .replaceAll("۰", "0");
      return temp;
    }
    return arabicText;
  }
}
