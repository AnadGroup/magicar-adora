import 'dart:async';

import 'package:anad_magicar/application.dart';
import 'package:anad_magicar/model/user/user_data.dart';
import 'package:anad_magicar/model/viewmodel/status_history_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginType { PASWWORD, FINGERPRINT, PATTERN }

class PrefRepository {
  static final PrefRepository prefRepository =  PrefRepository._internal();

  SharedPreferences prefs;

  PrefRepository._internal();

  Future<SharedPreferences> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    return Future.value(prefs);
  }

  factory PrefRepository() {
    return prefRepository;
  }

  Future<bool> setProfileImagePath(String path) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.ProfileImagePath_TAG, path);
      return true;
    }
    return false;
  }

  Future<String> getMobileLoggedIn() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String result = await prefs.getString(CenterRepository.USERNAME_TAG);
      return result == null ? result : result;
    }
    return null;
  }

  Future<String> getProfileImagePath() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String result =
          await prefs.getString(CenterRepository.ProfileImagePath_TAG);
      return result == null ? result : result;
    }
    return null;
  }

  Future<bool> setLoginedToken(String token, String clientId) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.VISION_AUTH_TAG, token);
      await prefs.setString(CenterRepository.ClientID_TAG, clientId);

      return true;
    }
    return false;
  }

  Future<bool> setFCMToken(
    String token,
  ) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.FCM_TOKEN_TAG, token);
      return true;
    }
    return false;
  }

  Future<String> getFCMToken() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String token = await prefs.getString(CenterRepository.FCM_TOKEN_TAG);
      if (token != null) return token;
    }
    return '';
  }

  Future<String> getLoginedToken() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String token = await prefs.getString(CenterRepository.VISION_AUTH_TAG);
      if (token != null) return token;
    }
    return '';
  }

  Future<String> getLoginedClientID() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String token = await prefs.getString(CenterRepository.ClientID_TAG);
      if (token != null) return token;
    }
    return '';
  }

  Future<bool> setMinMaxSpeed(String tag, int value) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt(tag, value);
      return true;
    }
    return false;
  }

  Future<bool> setRoutingType(String tag, int value) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt(tag, value);
      return true;
    }
    return false;
  }

  Future<bool> setPeriodicTime(String tag, int value) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt(tag, value);
      return true;
    }
    return false;
  }

  Future<bool> setPeriodicUpdate(String tag, int value) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt(tag, value);
      return true;
    }
    return false;
  }

  Future<bool> setLoginedUserName(String userName) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.USERNAME_TAG, userName);
      return true;
    }
    return false;
  }

  Future<bool> setLoginedFirstName(String userName) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.FIRSTNAME_TAG, userName);
      return true;
    }
    return false;
  }

  Future<bool> setLoginedLastName(String userName) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.LASTNAME_TAG, userName);
      return true;
    }
    return false;
  }

  Future<bool> setLoginedMobile(String userName) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.MOBILE_TAG, userName);
      return true;
    }
    return false;
  }

  Future<bool> setUserRoleId(int roleId) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt(CenterRepository.ROLEID_TAG, roleId);
      return true;
    }
    return false;
  }

  Future<bool> setLoginedPassword(String userName) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setString(CenterRepository.PASSWORD_TAG, userName);
      return true;
    }
    return false;
  }

  Future<bool> setLoginedIsAdmin(bool isAdmin) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setBool(CenterRepository.ISADMIN_TAG, isAdmin);
      return true;
    }
    return false;
  }

  Future<int> getMinMaxSpeed(String tag) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int minMax = await prefs.getInt(tag);
      if (minMax != null) return minMax;
    }
    return 0;
  }

  Future<int> getRoutingType(String tag) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int minMax = await prefs.getInt(tag);
      if (minMax != null) return minMax;
    }
    return 0;
  }

  Future<int> getPeriodicTime(String tag) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int periodic = await prefs.getInt(tag);
      if (periodic != null) return periodic;
    }
    return 0;
  }

  Future<int> getPeriodicUpdate(String tag) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int periodic = await prefs.getInt(tag);
      if (periodic != null) return periodic;
    }
    return 0;
  }

  Future<bool> getLoginedIsAdmin() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool isAdmin = await prefs.getBool(CenterRepository.ISADMIN_TAG);
      if (isAdmin != null) return isAdmin;
    }
    return false;
  }

  Future<int> getUserRoleId() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int roleId = await prefs.getInt(CenterRepository.ROLEID_TAG);
      if (roleId != null) return roleId;
    }
    return 0;
  }

  Future<String> getLoginedUserName() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String userName = await prefs.getString(CenterRepository.USERNAME_TAG);
      if (userName != null) return userName;
    }
    return '';
  }

  Future<String> getLoginedFirstName() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String userName = await prefs.getString(CenterRepository.FIRSTNAME_TAG);
      if (userName != null) return userName;
    }
    return '';
  }

  Future<String> getLoginedLastName() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String userName = await prefs.getString(CenterRepository.LASTNAME_TAG);
      if (userName != null) return userName;
    }
    return '';
  }

  Future<String> getLoginedMobile() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String userName = await prefs.getString(CenterRepository.MOBILE_TAG);
      if (userName != null) return userName;
    }
    return '';
  }

  Future<String> getLoginedPassword() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      String userName = await prefs.getString(CenterRepository.PASSWORD_TAG);
      if (userName != null) return userName;
    }
    return '';
  }

  Future<bool> setLoginedUserId(int id) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt(CenterRepository.USERID_TAG, id);
      // prefs.commit();
      return true;
    }
    return false;
  }

  Future<bool> setCarsCount(int count) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt(CenterRepository.CarsCount_TAG, count);
      return true;
    }
    return false;
  }

  Future<bool> setCarId(int carId) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setInt('CARID', carId);
      return true;
    }
    return false;
  }

  Future<int> getCarId() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int res = await prefs.getInt('CARID');
      return res != null ? res : 0;
    }
    return 0;
  }

  Future<bool> addCarsCount() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int count = await getCarsCount();
      await prefs.setInt(CenterRepository.CarsCount_TAG, (count + 1));
      return true;
    }
    return false;
  }

  Future<bool> setUserLoginedInfo(UserLoginedInfo data) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (data != null) {
        await prefs.setInt(UserLoginedInfo.CARCOUNTS_TAG, data.carCounts);
        await prefs.setInt(UserLoginedInfo.USERID_TAG, data.userId);
        await prefs.setInt(UserLoginedInfo.USERCOUNTS_TAG, data.userCounts);
        await prefs.setString(UserLoginedInfo.USERNAME_TAG, data.userName);
        await prefs.setString(UserLoginedInfo.AUTH_TOKEN_TAG, data.auth_token);
        await prefs.setString(
            UserLoginedInfo.LOGINED_DATE_TAG, data.logined_date);

        return true;
      }
    }
    return false;
  }

  Future<UserLoginedInfo> getUserLoginedInfo() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int carCounts = await prefs.getInt(UserLoginedInfo.CARCOUNTS_TAG);
      int userCounts = await prefs.getInt(UserLoginedInfo.USERCOUNTS_TAG);
      int userId = await prefs.getInt(UserLoginedInfo.USERID_TAG);
      String auth_token = await prefs.getString(UserLoginedInfo.AUTH_TOKEN_TAG);
      String logined_date =
          await prefs.getString(UserLoginedInfo.LOGINED_DATE_TAG);
      String userName = await prefs.getString(UserLoginedInfo.USERNAME_TAG);

      UserLoginedInfo data = UserLoginedInfo(
          userName: userName,
          userCounts: userCounts,
          carCounts: carCounts,
          auth_token: auth_token,
          logined_date: logined_date,
          userId: userId);

      return data;
    }
    return null;
  }

  Future<int> getCarsCount() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int id = await prefs.getInt(CenterRepository.CarsCount_TAG);
      if (id != null && id > 0) return id;
    }
    return 0;
  }

  Future<int> getLoginedUserId() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int id = await prefs.getInt(CenterRepository.USERID_TAG);
      if (id != null && id > 0) return id;
    }
    return 0;
  }

  Future<bool> isLoggined() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool result = await prefs.getBool('LOGINSTATUS');
      return result == null ? false : result;
    }
    return false;
  }

  Future<int> getLoginStatusTypeAtAppStarted() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      int result = await prefs.getInt('STATUS_LOGIN_TYPE_ON_APPSTARTED');
      return result == null ? 0 : result;
    }
    return 0;
  }

  Future<bool> getLoginStatusAtAppStarted() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool result = await prefs.getBool('STATUS_LOGIN_ON_APPSTARTED');
      return result == null ? null : result;
    }
    return null;
  }

  Future<bool> setLoggedOut() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setBool('LOGINSTATUS', false);
      return true;
    }
    return false;
  }

  Future<bool> setStartEngineStatus() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool status = await prefs.getBool('ENGINESTATUS');
      if (status != null) {
        if (status)
          status = false;
        else
          status = true;
      } else {
        status = true;
      }
      await prefs.setBool('ENGINESTATUS', status);
      return status;
    }
    return false;
  }

  Future<bool> setEngineStatus(bool status) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setBool('ENGINESTATUS', status);
      return status;
    }
    return false;
  }

  Future<bool> getStartEngineStatus() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool status = await prefs.getBool('ENGINESTATUS');
      if (status != null) {
        //prefs.setBool('ENGINESTATUS', status);
        return status;
      } else
        return false;
    }
    return false;
  }

  Future<bool> setLockStatus(bool status) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setBool('LOCKSTATUS', status);
      return status;
    }
    return false;
  }

  Future<bool> setPowerStatus(bool status) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setBool('POWERSTATUS', status);
      return status;
    }
    return false;
  }

  Future<bool> setTrunkStatus(bool status) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setBool('TRUNKSTATUS', status);
      return status;
    }
    return false;
  }

  Future<bool> getLockStatus() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool status = await prefs.getBool('LOCKSTATUS');
      if (status != null) {
        return status;
      } else
        return false;
    }
    return false;
  }

  Future<bool> getTrunkStatus() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool status = await prefs.getBool('TRUNKSTATUS');
      if (status != null) {
        return status;
      } else
        return false;
    }
    return false;
  }

  Future<bool> getPowerStatus() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      bool status = await prefs.getBool('POWERSTATUS');
      if (status != null) {
        return status;
      } else
        return false;
    }
    return false;
  }

  Future<bool> setLoggedIn(bool status) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs.setBool('LOGINSTATUS', true);
      await prefs.setBool('STATUS_LOGIN_ON_APPSTARTED', status);
      return true;
    }
    return false;
  }

  Future<bool> setLoginStatus(bool status) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      // prefs.setBool('LOGINSTATUS', true);
      await prefs.setBool('STATUS_LOGIN_ON_APPSTARTED', status);
      return true;
    }
    return false;
  }
/*  Future<bool> setLoginTypeStatus(bool status) async {
    prefs = await SharedPreferences.getInstance();
    if(prefs!=null) {
      // prefs.setBool('LOGINSTATUS', true);
      prefs.setBool('STATUS_LOGIN_TYPE_ON_APPSTARTED', status);
      return true;
    }
    return false;
  }*/

  Future<int> setLoginTypeStatus(LoginType loginType) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      // prefs.setBool('LOGINSTATUS', true);
      prefs.setInt('STATUS_LOGIN_TYPE_ON_APPSTARTED', loginType.index);
      return loginType.index;
    }
    return 0;
  }

  Future<Locale> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    String lang_code = '';
    String country_code = '';
    lang_code = prefs.getString('language_code');
    country_code = prefs.getString('country_code');
    if (lang_code == null || lang_code.isEmpty)
      lang_code = applic.LANG_FARSI_CODE_LOCAL;
    if (country_code == null || country_code.isEmpty)
      country_code = applic.COUNTRY_CODE_IRAN_LOCAL;

    centerRepository.setCachedLocal(lang_code);
    return Locale(lang_code, country_code);
  }

  setLocale(String lang_code, String contry_code) async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('language_code', lang_code);
    await prefs.setString('country_code', contry_code);
  }

  setStatusDateTime(String date, String time, bool status) async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('STATUS_DATE', date);
    await prefs.setString('STATUS_TIME', time);
    await prefs.setBool('STATUS_STATE', status);
  }

  Future<StatusHistoryVM> geteStatusDateTime() async {
    var prefs = await SharedPreferences.getInstance();

    String ddate = await prefs.getString('STATUS_DATE');
    String ttime = await prefs.getString('STATUS_TIME');
    bool sstate = await prefs.getBool('STATUS_STATE');

    if (ddate == null) ddate = '';
    if (ttime == null) ttime = '';
    if (sstate == null) sstate = false;
    StatusHistoryVM statusHistoryVM =
        StatusHistoryVM(date: ddate, time: ttime, state: sstate);
    return statusHistoryVM;
  }
}

PrefRepository prefRepository = PrefRepository();
