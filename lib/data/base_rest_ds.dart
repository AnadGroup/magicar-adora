import 'dart:async';

import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/utils/check_status_connection.dart';
import 'package:anad_magicar/utils/network_util.dart';

abstract class BaseRestDS<T> extends RestDatasource {
  NetworkUtil netUtil = new NetworkUtil();
  static final BASE_URL = "https://ws1.anadgps.com:4433/main";
  static final BASE_URL_FOR_LOGIN = "ws1.anadgps.com:4433";

  static final BASE_USER_URL = "/user";
  static final BASE_CAR_URL = "/car";
  static final BASE_ADMIN_CAR_URL = "/CarToUser";
  static final BASE_BRAND_URL = "/brand";
  static final BASE_CARMODEL_URL = "/CarModel";
  static final BASE_CARMODEL_DETAIL_URL = "/CarModelDetail";
  static final BASE_DEVICE_URL = "/Device";
  static final BASE_PLAN_URL = "/plan";
  static final LOGIN_URL = BASE_URL + BASE_USER_URL + "/Login";
  static final LOGIN_URL2 = "" + "/visionAuth/login";
  static final GetUserInfo_URL = BASE_URL + BASE_USER_URL + "/GetUserInfo";
  static final ResetCurrentPassword_URL =
      BASE_URL + BASE_USER_URL + "/ResetCurrentPassword";
  static final ValidationSMSCode_URL =
      BASE_URL + BASE_USER_URL + "/ValidationSMSCode";

  static final SAVE_USER_MAGICAR_URL =
      BASE_URL + BASE_USER_URL + "/saveMagicarUser";
  static final SAVE_CAR_URL = BASE_URL + BASE_CAR_URL + "/SaveCarInfo";
  static final _API_KEY = "somerandomkey";
  static final GET_CAR_COLORS_URL = BASE_URL + BASE_CAR_URL + "/GetColors";
  static final GET_BRANDS_URL = BASE_URL + BASE_BRAND_URL + "/GetAll";
  static final GET_PLANS_URL = BASE_URL + BASE_PLAN_URL + "/GetAll";
  static final GET_PLAN_BY_PLANID_URL =
      BASE_URL + BASE_PLAN_URL + "/GetByPlanId";

  static final GET_BRANDS_BY_ID_URL = BASE_URL + BASE_BRAND_URL + "/GetById";
  static final GET_CAR_MODELS_URL = BASE_URL + BASE_CARMODEL_URL + "/GetAll";
  static final GET_CARMODEL_BY_ID_URL =
      BASE_URL + BASE_CARMODEL_URL + "/GetById";
  static final GET_CARMODEL_BY_BRANDID_URL =
      BASE_URL + BASE_CARMODEL_URL + "/GetByBrandId";
  static final GET_CAR_MODEL_DETAIL_URL =
      BASE_URL + BASE_CARMODEL_DETAIL_URL + "/GetAll";
  static final GET_CAR_MODEL_DETAIL_BY_ID_URL =
      BASE_URL + BASE_CARMODEL_DETAIL_URL + "/GetById";
  static final GET_CAR_MODEL_DETAIL_BY_CARMODEL_ID_URL =
      BASE_URL + BASE_CARMODEL_DETAIL_URL + "/GetByCarModelId";
  static final GET_ADMIN_CARS_BY_ID_URL =
      BASE_URL + BASE_ADMIN_CAR_URL + "/GetAdminCarByUserId";
  static final GET_DEVICE_INFO_URL =
      BASE_URL + BASE_DEVICE_URL + "/SaveDeviceInfo";
  static final GET_DEVICE_MODEL_URL =
      BASE_URL + BASE_DEVICE_URL + "/GetDeviceModel";
  static final GET_DEVICES_URL = BASE_URL + BASE_DEVICE_URL + "/GetAll";
  static final GET_DEVICE_BY_ID_URL = BASE_URL + BASE_DEVICE_URL + "/GetById";

  RestDatasource();

  StreamSubscription _connectionChangeStream;
  Map<String, String> getHeaders() {
    String content = "application/json";
    Map<String, String> headers = new Map();
    headers.putIfAbsent("Content-Type", () => content);
    return headers;
  }

  Future<ServiceResult> login(String username, String password) async {
    Map<String, String> params = {"UserName": username, "Password": password};
    try {
      //Uri uri = Uri.http(BASE_URL_FOR_LOGIN, LOGIN_URL2, params);
      String url = BASE_URL_FOR_LOGIN +
          LOGIN_URL2 +
          '?UserName=${username}'
              '&Password=${password}';
      return netUtil.get(url, theaders: getHeaders()).then((res) {
        return ServiceResult.fromJson(res);
      });
    } catch (ex) {
      print(ex.toString());
    }
    return null;
  }

  Future<bool> validateSMSCode(String username, String code) async {
    return netUtil.post(LOGIN_URL,
        body: {"userId": int.tryParse(username), "code": code}).then((res) {
      return res;
    });
  }

  Future<ServiceResult> resetPassword(
      String current, String newPassword, String confirmPassword) async {
    return netUtil.post(LOGIN_URL, body: {
      "currentPassword": current,
      "newPassword": newPassword,
      "confirmNewPassword": confirmPassword
    }).then((res) {
      return ServiceResult.fromJson(res);
    });
  }

  Future<List<T>> getAll(String url);
  Future<T> getById(String url, int id);

  Future<T> send(T model);
  Future<T> sendAll(List<T> models);

  Future<User> authenticate(String username, String password) async {
    return netUtil.post<User>('AUTHENTICATE_URL',
        body: {"username": username, "password": password}).then((User res) {
      //print(res.toString());
      //if(res["error"]) throw new Exception(res["error_msg"]);
      return res;
    });
  }

  Future<SaveMagicarResponeQuery> register({Map<String, dynamic> body}) async {
    String content = "application/json";
    Map<String, String> headers = new Map();
    headers.putIfAbsent("Content-Type", () => content);

    return netUtil
        .post<dynamic>(SAVE_USER_MAGICAR_URL, body: body, headers: headers)
        .then((dynamic res) {
      return SaveMagicarResponeQuery.fromJson(res);
    });
  }

  @override
  void checkConnectivity() {}

  @override
  void init() {
    netUtil = new NetworkUtil();
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    /* setState(() {
      isOffline = !hasConnection;
    });*/
  }
}
