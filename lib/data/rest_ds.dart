import 'dart:async';
import 'dart:convert';

import 'package:anad_magicar/data/base_rest.dart';
import 'package:anad_magicar/model/action_to_role_model.dart';
import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/apis/alarm_type.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/api_carmodel_model.dart';
import 'package:anad_magicar/model/apis/api_device_model.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/apis/api_result_constant.dart';
import 'package:anad_magicar/model/apis/api_route.dart';
import 'package:anad_magicar/model/apis/api_search_car_model.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/api_user_role.dart';
import 'package:anad_magicar/model/apis/car_action_log.dart';
import 'package:anad_magicar/model/apis/current_user_accessable_action.dart';
import 'package:anad_magicar/model/apis/device_model.dart';
import 'package:anad_magicar/model/apis/paired_car.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/assign_role_to_car.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/invoice/invoice.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/car_to_user.dart';
import 'package:anad_magicar/model/user/role.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/utils/check_status_connection.dart';
import 'package:anad_magicar/utils/network_util.dart';
import 'package:flutter/services.dart' show rootBundle;

class RestDatasource extends BaseRest {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://130.185.74.186:8083/main";
  static final BASE_URL_FOR_LOGIN = "http://130.185.74.186:8083";
  static final BASE_URL_NO_MAIN_PATH = "http://130.185.74.186:8083";
  static final BASE_URL_FOR_CAR_TO_ADMIN = "130.185.74.186:8083";
  static final BASE_URL_GET_WITH_URI = "130.185.74.186:8083";
  static final BASE_OPEN_ROUTE_SERVICE_URL =
      'https://api.openrouteservice.org/v2/directions/driving-car/geojson';
  static final BASE_USER_URL = "/user";
  static final BASE_CAR_URL = "/car";
  static final BASE_CARLOG_URL = "/caractionlog";

  static final BASE_ROUTE_URL = "/Route";
  static final BASE_LASTPOSITION_URL = "/LastPosition";

  static final BASE_BRAND_URL = "/brand";
  static final BASE_ACTIONS_URL = "/actions";
  static final BASE_ROLE_URL = "/AppRole";
  static final BASE_ACTION_TO_ROLE_URL = "/ActionToRole";
  static final BASE_INVOICE_URL = "/invoice";
  static final BASE_CARMODEL_URL = "/CarModel";
  static final BASE_CARMODEL_DETAIL_URL = "/CarModelDetail";
  static final BASE_DEVICE_URL = "/Device";
  static final BASE_COMMAND_URL = "/Command";
  static final BASE_SMS_URL = "/user";
  static final BASE_USER_POLICY_URL = "/UserPolicy";
  static final BASE_PAIREDCAR_URL = '/PairedCar';
  static final BASE_CARSERVICE_URL = '/service';
  static final BASE_MESSAGE_URL = '/MessageApp';

  static final BASE_ADMIN_CAR_URL = "/main/CarToUser";
  static final BASE_RELATED_USER_CAR_URL = "/CarToUser";
  static final BASE_CAR_TO_USER_URL = "/CarToUser";
  static final BASE_CAR_TO_USER_URI_URL = "/main/CarToUser";
  static final BASE_SERVICETYPE_URL = '/servicetype';
  static final BASE_ALARMTYPE_URL = '/alarmtype';
  static final BASE_ALARM_TYPE_TOUSER_URL = '/AlarmTypeToUser';

  static final LOGIN_URL = BASE_URL + BASE_USER_URL + "/Login";
  static final LOGIN_URL2 = "" + "/visionAuth/login";
  static final GET_ACTION_BY_ID = "/Actions";
  static final GetUserInfo_URL = BASE_URL + BASE_USER_URL + "/GetUserInfo";
  static final GetRelatedUser_URL =
      BASE_URL + BASE_RELATED_USER_CAR_URL + "/GetRelatedUsers";
  static final GetCurrentUserAccessableActions_URL =
      BASE_URL + BASE_USER_POLICY_URL + '/GetCurrentUserAccessableActions';
  static final ResetCurrentPassword_URL =
      BASE_URL + BASE_USER_URL + "/ResetCurrentPassword";
  static final ValidationSMSCode_URL =
      BASE_URL + BASE_USER_URL + "/ValidationSMSCode";
  static final Save_Car_To_User_URL = BASE_URL + BASE_CAR_TO_USER_URL + '/Save';
  static final SAVE_USER_MAGICAR_URL =
      BASE_URL + BASE_USER_URL + "/saveMagicarUser";
  static final SAVE_CAR_URL = BASE_URL + BASE_CAR_URL + "/SaveCarInfo";
  static final _API_KEY = "somerandomkey";
  static final SEND_COMMAND_URL = BASE_URL + BASE_COMMAND_URL + "/SendCommand";
  static final SEND_SMS_URL = BASE_URL + BASE_SMS_URL + "/sendsms";

  static final GET_CAR_COLORS_URL = BASE_URL + BASE_CAR_URL + "/GetColors";
  static final GET_BRANDS_URL = BASE_URL + BASE_BRAND_URL + "/GetAll";
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
  static final GET_DEVICE_INFO_URL =
      BASE_URL + BASE_DEVICE_URL + "/SaveDeviceInfo";
  static final GET_DEVICE_MODEL_URL =
      BASE_URL + BASE_DEVICE_URL + "/GetDeviceModel";
  static final GET_DEVICES_URL = BASE_URL + BASE_DEVICE_URL + "/GetAll";
  static final GET_ACTIONS_URL = BASE_URL + BASE_ACTIONS_URL + "/GetAll";
  static final GET_ACTIONS_TO_ROLE_URL =
      BASE_URL + BASE_ACTION_TO_ROLE_URL + "/GetAll";
  static final GET_CARS_URL = BASE_URL + BASE_CAR_URL + '/GetAll';
  static final GET_APPROLES_URL = BASE_URL + BASE_ROLE_URL + "/GetAll";
  static final GET_ACTIONS_TYPES_URL =
      BASE_URL + BASE_ACTIONS_URL + "/GetActionTypes";
  static final GET_ACTIONS_BY_ID_URL =
      BASE_URL + GET_ACTION_BY_ID + "/GetByActionId";
  static final GET_DEVICE_BY_ID_URL = BASE_URL + BASE_DEVICE_URL + "/GetById";
  static final GET_ACTIONTOROLE_BY_ROLEID_URL =
      BASE_URL + BASE_ACTION_TO_ROLE_URL + "/GetByRoleId";

  static final GET_ADMIN_CARS_BY_USERID_URL =
      BASE_ADMIN_CAR_URL + "/GetAdminCarByUserId";
  static final GET_CARS_BY_USERID_URL = BASE_ADMIN_CAR_URL + "/GetByUserId";
  static final GET_INVOICE_PRIMARY_SAVE_URL =
      BASE_URL + BASE_INVOICE_URL + '/PrimarySaveInvoice';
  static final GET_INVOICE_PARTIAL_SAVE_URL =
      BASE_URL + BASE_INVOICE_URL + '/PartialSaveInvoice';
  static final GET_INVOICE_PLAN_ACTIVATION_SAVE_URL =
      BASE_URL + BASE_INVOICE_URL + '/InvoicePlanActivation';
  static final GET_INVOICE_BY_USERID_URL =
      BASE_URL + BASE_INVOICE_URL + '/getByUserId';
  static final GET_INVOICE_ALL_URL = BASE_URL + BASE_INVOICE_URL + '/GetAll';

  static final CHECK_DEVICE_AVAILABLE_URL =
      BASE_URL + BASE_DEVICE_URL + "/CheckDeviceAvalable";
  static final ASSIGN_ROLE_TO_CAR_URL =
      BASE_URL + BASE_ACTION_TO_ROLE_URL + "/AssignRoleToCar";
  static final SEARCH_CAR_URL = BASE_URL + BASE_CAR_URL + '/SerachCarToRequest';
  static final SEARCH_CARS_URL = BASE_URL + BASE_CAR_URL + '/SearchCars';

  static final DeleteCarToUser_URL =
      BASE_URL + BASE_CAR_TO_USER_URL + '/DeleteCarToUser';
  static final DeleteCars_URL = BASE_URL + BASE_CAR_URL + '/DeleteCars';
  static final DeleteCarToUser_URI_URL =
      BASE_CAR_TO_USER_URL + '/DeleteCarToUser';
  static final ChangeCarToUserStatus_URL =
      BASE_URL + BASE_CAR_TO_USER_URL + '/ChangeCarToUserStatus';
  static final AcceptRequestByAdmin_URL =
      BASE_URL + BASE_USER_POLICY_URL + '/ConfirmCarToUser';
  static final GET_CARWAITING_FOR_CONFIRM_CAR_URL =
      BASE_URL + BASE_CAR_TO_USER_URL + '/GetWaitingForConfirmCar';

  static final LogoutUser_URL = BASE_URL + BASE_USER_URL + '/Logout';
  static final ChangeUserRole_URL =
      BASE_URL + BASE_USER_POLICY_URL + '/ChangeUserRole';
  static final SetUserNotificationToken_URL =
      BASE_URL + BASE_USER_URL + '/SetUserNotificationToken';
  static final EditMagicarUser_URL =
      BASE_URL + BASE_USER_URL + '/EditMagicarUser';
  static final EditCarInfo_URL = BASE_URL + BASE_CAR_URL + '/EditCarInfo';
  static final GetROUTE_URL = BASE_URL + BASE_ROUTE_URL + '/GetRoute';
  static final Get_LASTPOSITION_URL =
      BASE_URL + BASE_LASTPOSITION_URL + '/GetLastPosition';
  static final PairedCar_URL =
      BASE_URL + BASE_PAIREDCAR_URL + '/GetAllPairedCar';
  static final DeletePairedCar_URL =
      BASE_URL + BASE_PAIREDCAR_URL + '/DeletePairedCar';
  static final SavePairedCar_URL = BASE_URL + BASE_PAIREDCAR_URL + '/Save';
  static final GetPairedCars_URL =
      BASE_URL + BASE_PAIREDCAR_URL + '/GetPairedCars';

  static final GetCarLog_URL = BASE_URL + BASE_CARLOG_URL + '/GetCarLog';
  static final GetAlarmType_URL =
      BASE_URL + BASE_ALARMTYPE_URL + '/GetAlarmType';
  static final SaveServiceType_URL =
      BASE_URL + BASE_SERVICETYPE_URL + '/SaveServiceType';
  static final SaveService_URL =
      BASE_URL + BASE_CARSERVICE_URL + '/SaveService';
  static final GetCarService_URL =
      BASE_URL + BASE_CARSERVICE_URL + '/GetCarService';
  static final GetServiceTypes_URL =
      BASE_URL + BASE_SERVICETYPE_URL + '/GetServiceTypes';
  static final GetUserMessage_URL =
      BASE_URL + BASE_MESSAGE_URL + '/GetUserMessage';
  static final DeleteUserMessage_URL =
      BASE_URL + BASE_MESSAGE_URL + '/DeleteMessages';

  static final ChanegMessageStatus_URL =
      BASE_URL + BASE_MESSAGE_URL + '/ChanegMessageStatus';
  static final SendMessage_URL = BASE_URL + BASE_MESSAGE_URL + '/SendMessage';
  static final ForgetPassword_URL =
      BASE_URL + BASE_USER_URL + '/ForgotPassword';
  static final BUY_REQUEST_URL =
      'http://anadgps.com/payline/api/invoices/request';
  static final Get_Alalrm_Type_URL =
      BASE_URL + BASE_ALARMTYPE_URL + '/GetAlarmType';
  static final GetUserAlarmAssign_URL =
      BASE_URL + BASE_ALARM_TYPE_TOUSER_URL + '/GetUserAlarmAssign';
  static final SaveUser_ALARM_URL =
      BASE_URL + BASE_ALARM_TYPE_TOUSER_URL + '/SaveUserAlarm';

  RestDatasource();

  static bool hasInternet = true;
  StreamSubscription _connectionChangeStream;
  Map<String, String> getHeaders() {
    String content = "application/json; charset=UTF-8";
    String content2 = "utf-8, iso-8859-1;q=0.5, *;q=0.1";
    Map<String, String> headers = Map();
    // headers.putIfAbsent("Content-Type", () => content);
    //headers.putIfAbsent("Accept-Charset", () => content2);
    //headers.putIfAbsent("accept", () => "*/*");
    return headers;
  }

  Future<ServiceResult> login(String username, String password) async {
    Map<String, String> userParams = {
      "UserName": username,
      "Password": password
    };
    String url = BASE_URL_FOR_LOGIN +
        LOGIN_URL2 +
        '?UserName=' +
        username +
        '&Password=' +
        password;
    try {
      // Uri uri = Uri.http( BASE_URL_FOR_LOGIN,LOGIN_URL2, params);
      return _netUtil
          .get(
        //BASE_URL_FOR_LOGIN + LOGIN_URL2,
        url,
        // params: userParams,
        body: jsonEncode(userParams),
        theaders: getHeaders(),
      )
          .then((res) {
        String tt = res.toString();
        return ServiceResult.fromJson(res);
      });
    } catch (ex) {
      print(ex.toString());
    }
    return null;
  }

  Future<String> sendSMSCode(String mobile, int userId) async {
    Map<String, String> params = {"MobileNumber": mobile};
    try {
      return _netUtil.postNoCookie(SEND_SMS_URL, body: params).then((res) {
        return res.toString();
      });
    } catch (error) {
      return '123456';
    }
  }

  Future<bool> validateSMSCode(String username, String code) async {
    return _netUtil.post(LOGIN_URL,
        body: {"userId": int.tryParse(username), "code": code}).then((res) {
      return res;
    });
  }

  Future<ServiceResult> resetPassword(
      String current, String newPassword, String confirmPassword) async {
    return _netUtil.post(ResetCurrentPassword_URL, body: {
      "currentPassword": current,
      "newPassword": newPassword,
      "confirmNewPassword": confirmPassword
    }).then((res) {
      return ServiceResult.fromJson(res);
    });
  }

  Future<List<SaveUserModel>> getUserInfo(String userId) async {
    Map<String, int> params = {"userId": int.tryParse(userId)};

    return _netUtil.post(GetUserInfo_URL, body: params).then((res) {
      return res
          .map<SaveUserModel>((u) => SaveUserModel.fromJsonForResultUserInfo(u))
          .toList();
    });
  }

  Future<List<ApiRelatedUserModel>> getRelatedUser(String userId) async {
    Map<String, String> params = {"UserId": userId};

    return _netUtil.post(GetRelatedUser_URL, body: params).then((res) {
      if (res != null && res.length > 0)
        return res
            .map<ApiRelatedUserModel>((u) => ApiRelatedUserModel.fromJson(u))
            .toList();
      else
        return null;
    });
  }

  Future<ServiceResult> changeCarToUserStatus(
      int userId, int carId, int statusId) async {
    Map<String, int> params = {
      "UserId": userId,
      "CarId": carId,
      "TargetStatusConstId": statusId
    };

    return _netUtil.post(ChangeCarToUserStatus_URL, body: params).then((res) {
      if (res != null)
        return ServiceResult.fromJson(res);
      else
        return null;
    });
  }

  Future<List<CurrentUserAccessableActionModel>>
      getGetCurrentUserAccessableActions(int userId) async {
    Map<String, int> params = {
      "UserId": userId,
    };
    return _netUtil
        .post(
      GetCurrentUserAccessableActions_URL, /*body: params*/
    )
        .then((res) {
      if (res != null && res.length > 0)
        return res
            .map<CurrentUserAccessableActionModel>(
                (u) => CurrentUserAccessableActionModel.fromJson(u))
            .toList();
      else
        return null;
    });
  }

  Future<ServiceResult> forgotPassword(SaveUserModel userModel) async {
    return _netUtil
        .post(ForgetPassword_URL, body: userModel.toJsonForForgotPassword())
        .then((res) {
      if (res != null)
        return ServiceResult.fromJson(res);
      else
        return null;
    });
  }

  Future<ServiceResult> editUserProfile(SaveUserModel userModel) async {
    return _netUtil
        .post(EditMagicarUser_URL, body: userModel.toJsonForEdit())
        .then((res) {
      if (res != null)
        return ServiceResult.fromJson(res);
      else
        return null;
    });
  }

  Future<ServiceResult> editCarInfo(SaveCarModel carModel) async {
    return _netUtil
        .post(EditCarInfo_URL, body: carModel.toJsonForEdit())
        .then((res) {
      if (res != null)
        return ServiceResult.fromJson(res);
      else
        return null;
    });
  }

  Future<ServiceResult> changeUserRole(UserRoleModel userRoleModel) async {
    return _netUtil
        .post(ChangeUserRole_URL, body: userRoleModel.toJson())
        .then((res) {
      if (res != null)
        return ServiceResult.fromJson(res);
      else
        return null;
    });
  }

  Future<ServiceResult> acceptRequestByAdmin(
      int userId, int carId, int roleId, int targetStatusConstId) async {
    Map<String, int> params = {
      "userId": userId,
      "carId": carId,
      // "RoleId": roleId,
      "isConfirm": targetStatusConstId,
    };
    return _netUtil.post(AcceptRequestByAdmin_URL, body: params).then((res) {
      if (res != null)
        return ServiceResult.fromJson(res);
      else
        return null;
    });
  }

  Future<List<CarToUser>> getCarWiatingforConfirm(
      int userId, int targetStatusConstId) async {
    Map<String, int> params = {
      "userId": userId,
    };
    return _netUtil
        .post(GET_CARWAITING_FOR_CONFIRM_CAR_URL, body: params)
        .then((res) {
      if (res != null)
        return res
            .map<CarToUser>((cu) => CarToUser.fromJsonForCarWaiting(cu))
            .toList();
      else
        return null;
    });
  }

  Future<ServiceResult> confirmRequestByAdmin(
      int userId, int carId, int roleId, int targetStatusConstId) async {
    Map<String, int> params = {
      "userId": userId,
      "carId": carId,
      // "RoleId": roleId,
      // "TargetStatusConstId": targetStatusConstId,
    };
    return _netUtil.post(AcceptRequestByAdmin_URL, body: params).then((res) {
      if (res != null)
        return ServiceResult.fromJson(res);
      else
        return null;
    });
  }

  Future<ServiceResult> sendCommand(SendCommandModel model) async {
    return _netUtil.post(SEND_COMMAND_URL, body: model.toJson()).then((res) {
      return ServiceResult.fromJson(res);
    });
  }

  Future<ServiceResult> saveCarToUser(int userid, int carId) async {
    Map<String, dynamic> params = {"UserId": userid, "CarId": carId};
    return _netUtil.post(Save_Car_To_User_URL, body: params).then((res) {
      return ServiceResult.fromJson(res);
    });
  }

  Future<ServiceResult> checkDeviceAvailable(ApiDeviceModel model) async {
    return _netUtil
        .post(CHECK_DEVICE_AVAILABLE_URL, body: model.toJsonForCheckAvailable())
        .then((res) {
      return ServiceResult.fromJson(res);
    });
  }

  Future<BrandModel> getAllBrands() async {
    return _netUtil
        .post(
      GET_BRANDS_URL,
    )
        .then((res) {
      return BrandModel.fromJson(res);
    });
  }

  Future<SaveCarModel> getAllColors() async {
    return _netUtil
        .post(
      GET_CAR_COLORS_URL,
    )
        .then((res) {
      return SaveCarModel.fromJsonForColor(res);
    });
  }

  Future<SearchCarModel> searchCar(SearchCarModel searchModel) async {
    return _netUtil
        .post(SEARCH_CAR_URL, body: searchModel.toJsonForSendSearchModel())
        .then((res) {
      return SearchCarModel.fromJson(res);
    });
  }

  Future<List<CarActionLog>> GetCarLog(
      int CarId, String FromDate, String ToDate) {
    var bdy = {"CarId": CarId, "FromDate": FromDate, "ToDate": ToDate};
    return _netUtil.post(GetCarLog_URL, body: bdy).then((res) {
      if (res != null)
        return res.map<CarActionLog>((r) => CarActionLog.fromJson(r)).toList();
      else
        return null;
    });
  }

  /*Future<List<Service>> GetCarService(int CarId) {

  }*/
  final JsonDecoder _decoder = new JsonDecoder();
  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/points.txt');
  }

  Future<List<ApiRoute>> getRouteList(ApiRoute route) async {
    // String res2= await loadAsset();

    // dynamic res3 = _decoder.convert(res2);
    // return res3.map<ApiRoute>((r) => ApiRoute.fromJsonResult(r)).toList();
    return _netUtil.post(GetROUTE_URL, body: route.toJson()).then((res) {
      if (res != null)
        return res.map<ApiRoute>((r) => ApiRoute.fromJsonResult(r)).toList();
      else
        return null;
    });
  }

  Future<List<AlarmType>> GetAlarmType() {
    return _netUtil
        .post(
      Get_Alalrm_Type_URL,
    )
        .then((res) {
      if (res != null)
        return res.map<AlarmType>((r) => AlarmType.fromJson(r)).toList();
      else
        return null;
    });
  }

  Future<List<AlarmType>> GetAlarmTypeByUser() {
    return _netUtil
        .post(
      GetUserAlarmAssign_URL,
    )
        .then((res) {
      if (res != null)
        return res.map<AlarmType>((r) => AlarmType.fromJson(r)).toList();
      else
        return null;
    });
  }

  Future<List<AlarmType>> SaveUserAlarm(AlarmType model) {
    return _netUtil.post(SaveUser_ALARM_URL, body: model.toJson()).then((res) {
      if (res != null)
        return res.map<AlarmType>((r) => AlarmType.fromJson(r)).toList();
      else
        return null;
    });
  }

  Future<List<ApiRoute>> getLastPositionRoute(ApiRoute route) async {
    return _netUtil
        .post(Get_LASTPOSITION_URL, body: route.toJsonLastPosition())
        .then((res) {
      if (res != null)
        return res
            .map<ApiRoute>((r) => ApiRoute.fromJsonLastPositionResult(r))
            .toList();
      else
        return null;
    });
  }

  Future<List<AdminCarModel>> getAllCarsToAdmin(int userId) async {
    Map<String, String> params = {
      "userId": userId.toString(),
    };
    /*Uri uri =
        Uri.http(BASE_URL_GET_WITH_URI, GET_ADMIN_CARS_BY_USERID_URL, params);
    */
    String uri = BASE_URL_GET_WITH_URI +
        GET_ADMIN_CARS_BY_USERID_URL +
        '?userId=${userId}';
    return _netUtil
        .get(
      uri,
    )
        .then((res) {
      try {
        if (res != null && res.length > 0)
          return res
              .map<AdminCarModel>((c) => AdminCarModel.fromJson(c))
              .toList();
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<List<AdminCarModel>> getAllCarsByUserId(int userId) async {
    Map<String, String> params = {
      "UserId": userId.toString(),
    };
    //Uri uri = Uri.http(BASE_URL_GET_WITH_URI, GET_CARS_BY_USERID_URL, params);
    String uri = BASE_URL_NO_MAIN_PATH +
        GET_CARS_BY_USERID_URL +
        '?UserId=' +
        userId.toString();
    return _netUtil.get(uri).then((res) {
      try {
        if (res != null) {
          return res
              .map<AdminCarModel>((c) => AdminCarModel.fromJsonForUser(c))
              .toList();
          /*List<AdminCarModel> result=new List();
          result..add(AdminCarModel.fromJson(res));
          return  result*/
        } else {
          List<AdminCarModel> result = List();
          result..add(AdminCarModel.fromJson(res));
          return result;
        }
      } catch (error) {
        return null;
      }
    });
  }

  Future<List<ApiPairedCar>> getPairedCars() async {
    return _netUtil
        .get(
      GetPairedCars_URL,
    )
        .then((res) {
      try {
        if (res != null) {
          return res
              .map<ApiPairedCar>((r) => ApiPairedCar.fromJsonForPairedCars(r))
              .toList();
        }
        return null;
      } catch (error) {
        return null;
      }
    });
  }

  Future<List<ApiPairedCar>> getAllPairedCars() async {
    return _netUtil
        .post(
      PairedCar_URL,
    )
        .then((res) {
      try {
        if (res != null) {
          return res
              .map<ApiPairedCar>((r) => ApiPairedCar.fromJsonForGetAllPaired(r))
              .toList();
        }
        return null;
      } catch (error) {
        return null;
      }
    });
  }

  Future<ServiceResult> deletePairedCars(
      int masterCarId, List<int> carIds) async {
    ApiPairedCar pairedCar =
        new ApiPairedCar(MasterCarId: masterCarId, CarIds: carIds);
    return _netUtil
        .post(DeletePairedCar_URL, body: pairedCar.toJsonForDeletePairedCars())
        .then((res) {
      try {
        if (res != null) {
          return ServiceResult.fromJson(res);
        }
        return null;
      } catch (error) {
        return null;
      }
    });
  }

  Future<ServiceResult> deletecarToUser(int userId, int carId) async {
    Map<String, String> params = {
      "userId": userId.toString(),
      "carId": carId.toString()
    };
    //Uri uri = Uri.http(BASE_URL_GET_WITH_URI, DeleteCarToUser_URI_URL, params);
    String uri = BASE_URL_NO_MAIN_PATH +
        DeleteCarToUser_URI_URL +
        '?userId=' +
        userId.toString() +
        '&carId=' +
        carId.toString();
    return _netUtil.get(uri).then((res) {
      try {
        if (res != null) {
          return ServiceResult.fromJson(res);
        }
        return null;
      } catch (error) {
        return null;
      }
    });
  }

  Future<List<InvoiceModel>> getInvoiceByUserId(int userId) async {
    Map<String, String> params = {
      "userId": userId.toString(),
    };

    return _netUtil.post(GET_INVOICE_BY_USERID_URL, body: params).then((res) {
      try {
        if (res != null && res.length > 0)
          return res
              .map<InvoiceModel>((c) => InvoiceModel.fromJson(c))
              .toList();
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> sendFCMToken(int userId, String token) async {
    Map<String, String> params = {
      "UserId": userId.toString(),
      "TokenId": token,
    };

    return _netUtil
        .post(SetUserNotificationToken_URL, body: params)
        .then((res) {
      try {
        if (res != null) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> deleteCars(List<int> carIds) async {
    Map<String, List<int>> params = {
      "CarIds": carIds.map<int>((c) => c).toList(),
    };

    return _netUtil.post(DeleteCars_URL, body: params).then((res) {
      try {
        if (res != null && res.length > 0) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> primarySaveInvoice(int invoiceId) async {
    Map<String, int> params = {
      "InvoiceId": invoiceId,
    };

    return _netUtil
        .post(GET_INVOICE_PRIMARY_SAVE_URL, body: params)
        .then((res) {
      try {
        if (res != null && res.length > 0) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<List<ApiService>> getCarService(int carId) async {
    Map<String, String> params = {
      "CarId": carId.toString(),
    };

    String url = GetCarService_URL + '?' + "CarId=" + carId.toString();
    return _netUtil.postWithParams(url, body: null).then((res) {
      try {
        if (res != null && res.length > 0)
          return res.map<ApiService>((s) => ApiService.fromJson(s)).toList();
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<List<ApiMessage>> getUserMessage() async {
    return _netUtil
        .post(
      GetUserMessage_URL,
    )
        .then((res) {
      try {
        if (res != null && res.length > 0)
          return res.map<ApiMessage>((s) => ApiMessage.fromJson(s)).toList();
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> deleteUserMessage(List<int> Ids) async {
    Map<String, dynamic> body = {
      "messageIds": Ids.map<int>((i) => i).toList(),
    };
    return _netUtil.post(DeleteUserMessage_URL, body: body).then((res) {
      try {
        if (res != null && res.length > 0) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<List<Car>> searchCars(
      int carId, String pelak, String serialNumber) async {
    Map<String, dynamic> body = {
      "CarId": carId,
      "pelak": pelak,
      "SerialNumber": serialNumber
    };
    return _netUtil.post(SEARCH_CARS_URL, body: body).then((res) {
      try {
        if (res != null && res.length > 0)
          return res.map<Car>((s) => Car.fromJson(s)).toList();
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> changeMessageStatus(int messageId, int status) async {
    Map<String, String> params = {
      "MessageId": messageId.toString(),
      "targetStatus": status.toString()
    };
    String url = ChanegMessageStatus_URL +
        '?MessageId=' +
        messageId.toString() +
        '&' +
        "targetStatus=" +
        status.toString();
    return _netUtil.postWithParams(url, body: null).then((res) {
      try {
        if (res != null) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> sendMessage(ApiMessage message) async {
    return _netUtil
        .post(SendMessage_URL, body: message.toJsonForSendMessage())
        .then((res) {
      try {
        if (res != null && res.length > 0) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<List<ServiceType>> getCarServiceTypes() async {
    return _netUtil
        .post(
      GetServiceTypes_URL,
    )
        .then((res) {
      try {
        if (res != null && res.length > 0)
          return res.map<ServiceType>((s) => ServiceType.fromJson(s)).toList();
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> saveCarService(ApiService service) async {
    return _netUtil.post(SaveService_URL, body: service.toJson()).then((res) {
      try {
        if (res != null && res.length > 0) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> saveServiceType(ServiceType entity) async {
    return _netUtil
        .post(SaveServiceType_URL, body: entity.toJson())
        .then((res) {
      try {
        if (res != null && res.length > 0) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> savePairedCar(ApiPairedCar entity) async {
    return _netUtil.post(SavePairedCar_URL, body: entity.toJson()).then((res) {
      try {
        if (res != null) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> partialSaveInvoice(int userId, int planId) async {
    Map<String, int> params = {"UserId": userId, "PlanId": planId};

    return _netUtil
        .post(GET_INVOICE_PARTIAL_SAVE_URL, body: params)
        .then((res) {
      try {
        if (res != null && res.length > 0)
          return ServiceResult.fromJsonParitalInvoice(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> invoicePlanActivation(
      int invoiceId, String date) async {
    Map<String, dynamic> params = {"InvoiceId": invoiceId, "ActiveDate": date};

    return _netUtil
        .post(GET_INVOICE_PLAN_ACTIVATION_SAVE_URL, body: params)
        .then((res) {
      try {
        if (res != null && res.length > 0) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<ServiceResult> logoutUser() {
    return _netUtil
        .getWithNoToken(
      LogoutUser_URL,
    )
        .then((res) {
      try {
        if (res != null) return ServiceResult.fromJson(res);
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<List<Car>> getAllCars(int userId) async {
    Map<String, String> params = {
      "userId": userId.toString(),
    };

    return _netUtil
        .get(
      GET_CARS_URL,
    )
        .then((res) {
      try {
        if (res != null && res.length > 0)
          return res.map<Car>((c) => Car.fromJson(c)).toList();
      } catch (error) {
        return null;
      }
      return null;
    });
  }

  Future<List<ActionToRoleModel>> getAllActionsToRole() async {
    return _netUtil
        .get(
      GET_ACTIONS_TO_ROLE_URL,
    )
        .then((res) {
      return res
          .map<ActionToRoleModel>((c) => ActionToRoleModel.fromJson(c))
          .toList();
    });
  }

  Future<ApiCarModel> getAllCarModels() async {
    return _netUtil
        .post(
      GET_CAR_MODELS_URL,
    )
        .then((res) {
      return ApiCarModel.fromJson(res);
    });
  }

  Future<List<Role>> getAllRoles() async {
    return _netUtil
        .get(
      GET_APPROLES_URL,
    )
        .then((res) {
      return res.map<Role>((d) => Role.fromJson(d)).toList();
    });
  }

  Future<List<ActionModel>> getAllActions() async {
    return _netUtil
        .get(
      GET_ACTIONS_URL,
    )
        .then((res) {
      return res.map<ActionModel>((d) => ActionModel.fromJson(d)).toList();
    });
  }

  Future<List<ApiResultConstant>> getAllActionTypes() async {
    return _netUtil
        .get(
      GET_ACTIONS_TYPES_URL,
    )
        .then((res) {
      return res
          .map<ApiResultConstant>((d) => ApiResultConstant.fromJson(d))
          .toList();
    });
  }

  Future<ActionModel> getActionById(int actionId) async {
    Map<String, int> params = {
      "ActionId": actionId,
    };
    //Uri uri = Uri.http(BASE_URL_GET_WITH_URI ,GET_ACTION_BY_ID+GET_ACTIONS_BY_ID_METHOD, params);
    return _netUtil.post(GET_ACTIONS_BY_ID_URL, body: params).then((res) {
      return res.map<ActionModel>((c) => ActionModel.fromJson(c));
    });
  }

  Future<ActionModel> getActionToRoleById(int roleId) async {
    Map<String, int> params = {
      "RoleId": roleId,
    };
    return _netUtil
        .post(GET_ACTIONTOROLE_BY_ROLEID_URL, body: params)
        .then((res) {
      return res.map((c) => ActionModel.fromJson(c));
    });
  }

  Future<ServiceResult> assignRoleToCar(AssignRoleToCar model) async {
    return _netUtil
        .post(ASSIGN_ROLE_TO_CAR_URL, body: model.toJson())
        .then((res) {
      return ServiceResult.fromJson(res);
    });
  }

  Future<List<InvoiceModel>> getAllInvoices() async {
    return _netUtil
        .get(
      GET_INVOICE_ALL_URL,
    )
        .then((res) {
      if (res != null && res.length > 0)
        return res.map<InvoiceModel>((d) => InvoiceModel.fromJson(d)).toList();
      else
        return null;
    });
  }

  Future<List<DeviceModel>> getAllDeviceModels() async {
    return _netUtil
        .get(
      GET_DEVICE_MODEL_URL,
    )
        .then((res) {
      if (res != null && res.length > 0)
        return res.map<DeviceModel>((d) => DeviceModel.fromJson(d)).toList();
      else
        return null;
    });
  }

  Future<User> authenticate(String username, String password) async {
    return _netUtil.post<User>('AUTHENTICATE_URL',
        body: {"username": username, "password": password}).then((User res) {
      //print(res.toString());
      //if(res["error"]) throw new Exception(res["error_msg"]);
      return res;
    });
  }

  Future<SaveMagicarResponeQuery> register({Map<String, dynamic> body}) async {
    /*String content="application/json";
    Map<String,String> headers=new Map();
    headers.putIfAbsent("Content-Type",()=> content);*/

    return _netUtil
        .postNoCookie(
      SAVE_USER_MAGICAR_URL,
      body: body,
    )
        .then((res) {
      return SaveMagicarResponeQuery.fromJson(res);
    });
  }

  Future<dynamic> editProfile({Map<String, dynamic> body}) async {
    String content = "application/json";
    Map<String, String> headers = new Map();
    headers.putIfAbsent("Content-Type", () => content);

    return _netUtil
        .post<dynamic>('EDITPROFILE_URL', body: body, headers: headers)
        .then((dynamic res) {
      return res;
    });
  }

  Future<Map<String, dynamic>> requestBuyUrl(
      {Map<String, dynamic> body}) async {
    String content = "application/json";
    Map<String, String> headers = new Map();
    headers.putIfAbsent("Content-Type", () => content);

    return _netUtil
        .post(BUY_REQUEST_URL, body: body, headers: headers)
        .then((res) {
      return res;
    });
  }

  Future<dynamic> fetchOpenRouteServiceURlJSON(
      {dynamic body,
      int typeRouting = 1,
      String routeType = 'driving-car'}) async {
    String content = "application/json";
    String newRoteType = routeType;
    Map<String, String> headers = new Map();
    headers.putIfAbsent("Content-Type", () => content);
    headers.putIfAbsent('Authorization',
        () => '5b3ce3597851110001cf62480efcf9a66bbf4819825a3f50e2bfa0ea');
    headers.putIfAbsent(
        'Accept',
        () =>
            'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8');
    String url =
        'https://api.openrouteservice.org/v2/directions/${newRoteType}/geojson';
    return _netUtil.postForMap(url, mbody: body, headers: headers).then((res) {
      return res;
    });
  }

  @override
  void checkConnectivity() {}

  @override
  void init() {
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    hasInternet = hasConnection;
    //RxBus.post(new ChangeEvent(message: '',type: ))
  }

  @override
  afterResponse() {
    // TODO: implement afterResponse
    return null;
  }

  @override
  beforeRequest() {
    // TODO: implement beforeRequest
    return null;
  }
}

RestDatasource restDatasource = new RestDatasource();
