import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/custom_progress_dialog.dart';
import 'package:anad_magicar/components/date_picker/flutter_datetime_picker.dart'
    as dtpicker;
import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/data/ds/action_ds.dart';
import 'package:anad_magicar/data/ds/car_brands_ds.dart';
import 'package:anad_magicar/data/ds/car_color_ds.dart';
import 'package:anad_magicar/data/ds/car_device_ds.dart';
import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/data/ds/car_model_detail_ds.dart';
import 'package:anad_magicar/data/ds/car_model_ds.dart';
import 'package:anad_magicar/data/ds/plan_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/action_to_role_model.dart';
import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/apis/api_device_model.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/apis/api_route.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/current_user_accessable_action.dart';
import 'package:anad_magicar/model/apis/device_model.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/cars/car_model_detail.dart';
import 'package:anad_magicar/model/gender.dart';
import 'package:anad_magicar/model/invoice/invoice.dart';
import 'package:anad_magicar/model/invoice/invoice_detail.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/plan_model.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/settings/settings_model.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/role.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/user/user_data.dart';
import 'package:anad_magicar/model/viewmodel/add_car_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_info_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart' as mat;
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/model/viewmodel/init_data_vm.dart';
import 'package:anad_magicar/model/viewmodel/map_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/fake_server.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/service/network_checker.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:universal_platform/universal_platform.dart';
enum CarStatus { ONLYDOOROPEN, ONLYTRUNKOPEN, BOTHOPEN, BOTHCLOSED }
typedef VoidFutureConfirmCallBack = Future<void> Function(int);

//enum MaterialColor {RED,BLUE,YELLOW,GREEN,BLACK,WHITE}
class CenterRepository {
  List<Color> colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.black,
    Colors.black38,
    Colors.black54,
  ];

  static final CenterRepository centerRepository = CenterRepository._internal();
  static final String TOKEN_TAG = 'TOKEN';
  static final String USERNAME_TAG = 'USERNAME';
  static final String FIRSTNAME_TAG = 'FIRSTNAME';
  static final String LASTNAME_TAG = 'LASTNAME';
  static final String MOBILE_TAG = 'MOBILENAME';
  static final String PASSWORD_TAG = 'PASSWORDNAME';
  static final String ROLEID_TAG = 'ROLEID';

  static final String ISADMIN_TAG = 'ISADMIN';
  static final String USERID_TAG = 'USERID';
  static final String VISION_AUTH_TAG = 'VISION_AUTH';
  static final String ClientID_TAG = 'ClientID';
  static final String CarsCount_TAG = 'CarsCounts';
  static final String ProfileImagePath_TAG = 'ProfileImagePath';
  static final String FCM_TOKEN_TAG = 'FCM_TOKEN';
  static final String ROUTING_TYPE_TAG = 'ROUTING_TYPE';
  static bool GPS_STATUS = false;
  static bool GPS_STATUS_CONFIRMED = false;

  static String LANG_CODE_LOCAL = '';

  static CarBrandsDS carBrandsDS;
  static CarColorsDS carColorsDS;
  static CarModelDS carModelDS;
  static CarDevicesDS carDevicesDS;
  static CarDS carDS;
  static ActionDS actionDS;
  static PlanDS planDS;
  static CarModelDetaillDS carModelDetaillDS;

//مربوط به اپ آدورا میباشد درصورت درست بودن خروجی آدورا میشود
  static bool APP_TYPE_ADORA = true;
  int carId = 0;
  static int userId;
  static int currentCarId = 0;
  static int messageCounts = 0;
  static int periodicUpdateTime = 60;
  static int lastPageSelected = -1;
  static bool isFromMapForGPSCheckForFirstTime = false;
  static ProgressDialog progressDialog;
  User userCached;
  SaveUserModel userModelInCach;
  UserLoginedInfo cachedUserInfo;
  HashMap<int, Color> carColorsMap = new HashMap();
  HashMap<mat.MaterialColor, Color> carsColorMap = new HashMap();
  HashMap<int, CarStateVM> carStateVMMap = new HashMap();
  // HashMap<int,CarStateVM> carStateVMMap=new HashMap();

  List<int> carIds;
  List<int> userIds;

  List<CarStateVM> carStates = new List();

  List<ActionModel> actions = new List();
  List<CurrentUserAccessableActionModel> currentUserAccessableActionModel =
      new List();
  List<ActionToRoleModel> actionToRoles = new List();
  List<AdminCarModel> carsToAdmin;
  List<PlanModel> plans = new List();
  List<CarModel> carModels;
  List<CarModelDetail> carModelDetails;
  List<ApiCarColor> carColors;
  List<ApiDeviceModel> carDevices;
  List<DeviceModel> carDeviceModels;
  List<InvoiceModel> invoices;
  List<InvoiceDetailModel> invoiceDetails;
  List<ApiRelatedUserModel> relatedUsers;
  List<BrandModel> carBrands;
  List<Role> roles;
  List<ServiceType> serviceTypes;

  List<Car> cars = [
    new Car(
        carId: 1,
        businessUnitId: 3,
        deviceId: 10,
        description: 'Car 1',
        isActive: true,
        owner: 2,
        pelaueNumber: '123456',
        totalDistance: 10),
    new Car(
        carId: 2,
        businessUnitId: 3,
        deviceId: 10,
        description: 'Car 2',
        isActive: true,
        owner: 2,
        pelaueNumber: '12345622',
        totalDistance: 10),
    new Car(
        carId: 3,
        businessUnitId: 3,
        deviceId: 10,
        description: 'Car 3',
        isActive: true,
        owner: 2,
        pelaueNumber: '12345336',
        totalDistance: 10)
  ];

  HashMap<String, List<ApiCarColor>> mapOfCarColor = new HashMap();
  HashMap<String, List<CarModel>> mapOfCarModel = new HashMap();
  HashMap<String, List<BrandModel>> mapOfCarBrands = new HashMap();
  HashMap<String, List<Car>> mapOfCars = new HashMap();
  HashMap<String, List<CarModelDetail>> mapOfCarModelDetails = new HashMap();

  factory CenterRepository() {
    progressDialog = new ProgressDialog();
    carBrandsDS = new CarBrandsDS();
    carModelDS = new CarModelDS();
    carColorsDS = new CarColorsDS();
    carDevicesDS = new CarDevicesDS();
    carDS = new CarDS();
    planDS = new PlanDS();
    actionDS = new ActionDS();
    carModelDetaillDS = new CarModelDetaillDS();
    return centerRepository;
  }
  CenterRepository._internal();

  static int getUserId() {
    return userId;
  }

  static setPeriodicUpdateTime() async {
    await prefRepository.setPeriodicUpdate(
        SettingsScreenState.PERIODIC_UPDTAE_TIME_TAG, 60);
  }

  static Future<int> getPeriodicUpdateTime() async {
    periodicUpdateTime = await prefRepository
        .getPeriodicUpdate(SettingsScreenState.PERIODIC_UPDTAE_TIME_TAG);
    if (periodicUpdateTime == 0 || periodicUpdateTime == null)
      periodicUpdateTime = 60;
    return periodicUpdateTime;
  }

  initDataValues() {
    carId = 0;
    userId = 0;
    currentCarId = 0;
    messageCounts = 0;
    periodicUpdateTime = 60;
  }

  initCarMinMaxSpeed() async {
    prefRepository.setMinMaxSpeed(SettingsScreenState.MIN_SPEED_TAG, 60);
    prefRepository.setMinMaxSpeed(SettingsScreenState.MAX_SPEED_TAG, 100);
  }

  getLoginType() async {
    final bool forceShowLogin =
        await prefRepository.getLoginStatusAtAppStarted();
    if (forceShowLogin == null) {
      int loginType = LoginType.PASWWORD.index;
      return LoginType.values[loginType];
    }
    if (forceShowLogin != null && forceShowLogin) {
      int loginType = await prefRepository.getLoginStatusTypeAtAppStarted();
      if (loginType == null) loginType = LoginType.PASWWORD.index;
      return LoginType.values[loginType];
    } else if (forceShowLogin != null && !forceShowLogin) {
      return null;
    }
  }

  vibrateOnStatus(bool siren) async {
    int dur = 500;
    int amp = 128;
    if (siren) {
      dur = 5000;
      amp = 128;
    }
    if (await Vibration.hasVibrator()) {
      if (await Vibration.hasAmplitudeControl()) {
        //if(actionCode==Con)
        Vibration.vibrate(duration: dur, amplitude: 128);
      } else
        Vibration.vibrate(duration: dur);
    }
  }

  checkGPSStatus(int carId) async {
    ApiRoute apiRoute = new ApiRoute(
        carId: null,
        startDate: null,
        endDate: null,
        dateTime: null,
        speed: null,
        lat: null,
        long: null,
        enterTime: null,
        carIds: carIds,
        DeviceId: null,
        Latitude: null,
        Longitude: null,
        Date: null,
        Time: null,
        CreatedDateTime: null);
    var result = await restDatasource.getLastPositionRoute(apiRoute);
    if (result != null && result.length > 0) {
      double lat = double.tryParse(result[0].Latitude);
      double lng = double.tryParse(result[0].Longitude);
    }
  }

  checkGPSDeviceStatus(BuildContext context) async {
    await NetworkCheck.checkGPSMethod2(context);
  }

  static setUserId(int usrId) {
    userId = usrId;
  }

  static String getCarImageURlByColorConstId(int constId) {
    if (Constants.carImagesInColorMap != null) {
      if (Constants.carImagesInColorMap.containsKey(constId))
        return Constants.carImagesInColorMap[constId];
      else
        return Constants.carImagesInColorMap[Constants.CAR_COLOR_BLACK_TAG];
    }
  }

  static sendCarStatusCommand() async {
    int actionId =
        ActionsCommand.actionCommandsMap[ActionsCommand.STATUS_CAR_TAG];
    var result = await restDatasource.sendCommand(new SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: currentCarId,
        Command: null));
    if (result != null) {}
  }

  Timer checkCarStatusPeriodic(int min, NotyBloc<Message> statusNoty) {
    //getCarStatusAtAppStarted(statusNoty);

    Timer tmr = Timer.periodic(Duration(seconds: min), (t) {
      prefRepository.setStatusDateTime(
          DateTimeUtils.getDateJalali(), DateTimeUtils.getTimeNow(), false);
      statusNoty
          .updateValue(new Message(status: false, type: 'GET_CAR_STATUS'));
      sendCarStatusCommand();
    });
    return tmr;
  }

  getCarStatusAtAppStarted(NotyBloc<Message> statusNoty) {
    prefRepository.setStatusDateTime(
        DateTimeUtils.getDateJalali(), DateTimeUtils.getTimeNow(), false);
    statusNoty.updateValue(Message(status: false, type: 'GET_CAR_STATUS'));
    sendCarStatusCommand();
  }

  fetchGPSStatus() async {
    CarStateVM stateVM = centerRepository.getCarStateVMByCarId(currentCarId);
    if (stateVM != null) {
      stateVM.getParkAndSpeedStatus(statusChangedNoty);
    }
  }

  checkParkGPSStatusPeriodic(int min) {
    fetchGPSStatus();
    Timer.periodic(Duration(seconds: min), (t) => fetchGPSStatus());
  }

  Future<CarInfoVM> getCarInfo(int userId, int carId) async {
    var carInfos = new List();
    var carInfo;
    getCars();
    var carsToUserSelf = await carDS.getAllCarsByUserId(userId);
    if (carsToUserSelf != null) {
      carInfos = fillCarInfo(carsToUserSelf);
    } else {
      if (centerRepository.getCarsToAdmin() != null) {
        List<AdminCarModel> carsToAdmin = new List();
        carsToAdmin = await carDS.getAllCarsByUserId(userId);
        if (carsToAdmin != null) {
          centerRepository.setCarsToAdmin(carsToAdmin);
          prefRepository.setCarsCount(carsToAdmin.length);
        }
      }
      carInfos = fillCarInfo(carsToUserSelf);
    }
    if (carInfos != null && carInfos.length > 0) {
      var carInfo1 = carInfos.where((cc) => cc.carId == carId).toList();
      if (carInfo1 != null && carInfo1.length > 0) {
        carInfo = carInfo1.first;
      }
    } else
      carInfo = null;
    return carInfo;
  }

  List<CarInfoVM> fillCarInfo(List<AdminCarModel> carsToUser) {
    List<CarInfoVM> carInfos = new List();

    for (var car in carsToUser) {
      Car car_info = centerRepository
          .getCars()
          .where((c) => c.carId == car.CarId)
          .toList()
          .first;
      if (car_info != null) {
        int tip = 0;
        int modelId = 0;
        int brandId = 0;
        if (centerRepository.getCarBrands() != null) {
          // tip=centerRepository.getCarBrands().where((d)=>d.brandId==car_info. )
        }
        if (centerRepository.getCarModelDetails() != null &&
            centerRepository.getCarModelDetails().length > 0) {
          var modelDetail = centerRepository
              .getCarModelDetails()
              .where((c) => c.carModelDetailId == car_info.carModelDetailId)
              .toList();
          if (modelDetail != null && modelDetail.length > 0) {
            modelId = modelDetail.first.carModelId;
            if (centerRepository.getCarBrands() != null &&
                centerRepository.getCarBrands().length > 0) {
              var model = centerRepository
                  .getCarModels()
                  .where((c) => c.carModelId == modelId)
                  .toList();
              if (model != null && model.length > 0) {
                var brand = centerRepository
                    .getCarBrands()
                    .where((c) => c.brandId == model.first.brandId)
                    .toList();
                if (brand != null && brand.length > 0) {
                  brandId = brand.first.brandId;
                }
              }
            }
          }
        }

        CarInfoVM carInfoVM = new CarInfoVM(
            colorId: car_info.colorTypeConstId,
            brandId: brandId,
            moddelId: modelId,
            modelDetailId: car_info.carModelDetailId,
            brandModel: null,
            car: car_info,
            carColor: null,
            carModel: null,
            isActive: car.IsActive,
            pelak: car_info.pelaueNumber,
            distance: car_info.totalDistance.toString(),
            carModelDetail: null,
            brandTitle: car_info.brandTitle,
            modelTitle: car_info.carModelTitle,
            modelDetailTitle: car_info.carModelDetailTitle,
            color: car_info.colorTitle,
            carId: car_info.carId,
            Description: car_info.description,
            fromDate: car.FromDate,
            CarToUserStatusConstId: car.CarToUserStatusConstId,
            isAdmin: car.IsAdmin,
            userId: car.UserId);
        carInfos.add(carInfoVM);
      }
    }
    return carInfos;
  }

  static onCarPageTap(BuildContext context, int userId) {
    Navigator.of(context).popAndPushNamed('/carpage',
        arguments: new CarPageVM(
            userId: userId, isSelf: true, carAddNoty: valueNotyModelBloc));
  }

  String toRials(double amount) {
    String format = NumberFormat.simpleCurrency(
            locale: 'fa', name: 'ریال', decimalDigits: 0)
        .format(amount);
    return format;
  }

  String convertToMoney(double amountt) {
    if (amountt != null) {
      FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
          settings: MoneyFormatterSettings(
              symbol: 'ریال',
              thousandSeparator: '.',
              decimalSeparator: ',',
              symbolAndNumberSeparator: ' ',
              fractionDigits: 3,
              compactFormatType: CompactFormatType.short),
          amount: 3000000.0);
      return fmf.output.withoutFractionDigits;
    } else
      return '0';
  }

  static int onNavButtonTap(BuildContext context, int index, {int carId}) {
    int currentBottomNaviSelected = index;
    if (index == 4) {
      Navigator.of(context).pushReplacementNamed('/plans');
    } else if (index == 0) {
      Navigator.pushReplacementNamed(context, '/servicepage',
          arguments: new ServiceVM(
              carId: carId, editMode: null, service: null, refresh: false));
    } else if (index == 1) {
      Navigator.of(context).pushReplacementNamed('/mappage',
          arguments: new MapVM(
            carId: 0,
            carCounts: centerRepository.getCarsToAdmin().length,
            cars: centerRepository.getCarsToAdmin(),
          ));
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/messages', arguments: carId);
    }
    return currentBottomNaviSelected;
  }

  showProgressDialog(BuildContext context, String message) {
    progressDialog.showProgressDialog(context, textToBeDisplayed: message);
  }

  dismissDialog(BuildContext context) {
    progressDialog.dismissProgressDialog(context);
  }

  Color getBackNavThemeColor(bool dark, BuildContext context) {
    Color res = APP_TYPE_ADORA
        ? !dark
            ? Color(0xfffefefe)
            : Colors.deepOrange
        : !dark
            ? Color(0xfffefefe)
            : Colors.black87;
    return res;
  }

  Future<SharedPreferences> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs);
  }

  static setCurrentCarId(int carId) {
    currentCarId = carId;
  }

  static int getCurrentCarId() {
    return currentCarId;
  }

  setRole(List<Role> rols) {
    if (roles == null) roles = new List();
    roles = rols;
  }

  List<Role> getRoles() {
    return this.roles;
  }

  setCarStateVMMap(CarStateVM stateVM) {
    if (carStateVMMap.containsKey(stateVM.carIndex)) {
      // carStateVMMap.remove(stateVM.carIndex);
      carStateVMMap.update(stateVM.carIndex, (value) => stateVM);
    } else {
      carStateVMMap.putIfAbsent(stateVM.carIndex, () => stateVM);
    }
  }

  updateCarStateVMMap(CarStateVM stateVM) {
    if (carStateVMMap.containsKey(stateVM.carIndex)) {
      carStateVMMap.remove(stateVM.carIndex);
    }
    carStateVMMap.putIfAbsent(stateVM.carIndex, () => stateVM);
  }

  setInvoices(List<InvoiceModel> invs) {
    if (invoices == null) invoices = new List();
    invoices = invs;
  }

  setServiceTypes(List<ServiceType> sTypes) {
    if (serviceTypes == null) serviceTypes = new List();
    if (serviceTypes != null && serviceTypes.length > 0) serviceTypes.clear();
    serviceTypes = sTypes;
  }

  List<ServiceType> getServiceTypes() {
    return serviceTypes;
  }

  List<InvoiceModel> getInvoices() {
    return this.invoices;
  }

  setInvoiceDetails(List<InvoiceDetailModel> invs) {
    if (invoiceDetails == null) invoiceDetails = new List();
    invoiceDetails = invs;
  }

  List<InvoiceDetailModel> getInvoiceDetails() {
    return this.invoiceDetails;
  }

  setInitCarStateVMMap(int carCounts) {
    for (var carIndex = 0; carIndex < carCounts; carIndex++) {
      int car_Id = getCarIdByIndex(carIndex);

      int colorId = getCarByCarId(car_Id).colorTypeConstId;

      CarStateVM carStateVM = new CarStateVM(
        carId: car_Id,
        arm: false,
        siren: false,
        isDoorOpen: false,
        isTraunkOpen: false,
        isCaputOpen: false,
        carIndex: carIndex,
        color:
            getCurrentCarColor(Constants.colorIdToColorsMap[colorId], carIndex),
        bothClosed: true,
      );
      carStateVM.setCurrentColor(
          Constants.colorIdToColorsMap[colorId], null, carIndex);
      carStateVM.setCarStatusImages();

      centerRepository.setCarStateVMMap(carStateVM);
    }
  }

  CarStateVM getCarStateVMByCarIndex(int carIndex) {
    return carStateVMMap[carIndex];
  }

  CarStateVM getCarStateVMByCarId(int carId) {
    CarStateVM carStateVMResult;
    carStateVMMap.forEach((i, carStateVM) {
      if (carStateVM.carId == carId) {
        carStateVMResult = carStateVM;
      }
    });
    return carStateVMResult;
  }

  addInitCarStateVMMap(int carIndex) {
    int car_Id = getCarIdByIndex(carIndex);
    int colorId = getCarByCarId(car_Id).colorTypeConstId;
    CarStateVM carStateVM = new CarStateVM(
      carId: car_Id,
      siren: false,
      arm: false,
      isDoorOpen: false,
      isTraunkOpen: false,
      isCaputOpen: false,
      carIndex: carIndex,
      color:
          getCurrentCarColor(Constants.colorIdToColorsMap[colorId], carIndex),
      bothClosed: true,
    );
    carStateVM.setCurrentColor(
        Constants.colorIdToColorsMap[colorId], null, carIndex);
    carStateVM.setCarStatusImages();

    centerRepository.setCarStateVMMap(carStateVM);
  }

  initCarColorsMap() {
    if (carColorsMap == null) carColorsMap = new HashMap();
    if (carsColorMap == null) carsColorMap = new HashMap();
    int indx = 0;
    colors.forEach((c) {
      carColorsMap.putIfAbsent(c.value, () => c);
    });

    Constants.createCarColorsMap();

    carsColorMap.putIfAbsent(mat.MaterialColor.RED, () => colors[0]);
    carsColorMap.putIfAbsent(mat.MaterialColor.BLUE, () => colors[1]);
    carsColorMap.putIfAbsent(mat.MaterialColor.GREEN, () => colors[2]);
    carsColorMap.putIfAbsent(mat.MaterialColor.YELLOW, () => colors[3]);
    carsColorMap.putIfAbsent(mat.MaterialColor.BLACK, () => colors[4]);
    carsColorMap.putIfAbsent(mat.MaterialColor.WHITE, () => colors[5]);
    carsColorMap.putIfAbsent(mat.MaterialColor.GREY, () => colors[6]);
  }

  setUserInfo(SaveUserModel user) {
    if (userModelInCach == null) userModelInCach = new SaveUserModel();
    userModelInCach = user;
  }

  setCarId(int carId) {
    this.carId = carId;
  }

  int getCarId() {
    return this.carId;
  }

  SaveUserModel getUserInfo() {
    return userModelInCach;
  }

  mat.MaterialColor getCurrentCarColor(Color color, int value) {
    mat.MaterialColor materialColor = mat.MaterialColor.RED;
    Color colr;
    if (color != null) {
      colr = carColorsMap[color.value];
    } else {
      colr = carColorsMap[
          Constants.colorIdToColorsMap[value].value /*colors[value].value*/];
    }
    if (colr != null) {
      if (carsColorMap.containsValue(colr)) {
        carsColorMap.forEach((mat, cl) {
          if (cl.value == colr.value) {
            materialColor = mat;
          }
        });
      }
    }

    return materialColor;
  }

  List<Car> getCars() {
    return this.cars;
  }

  setRelatedUsers(List<ApiRelatedUserModel> users) {
    if (relatedUsers == null) relatedUsers = new List();
    relatedUsers = users;
  }

  setCurrentUserAccessableActionModel(
      List<CurrentUserAccessableActionModel> actions) {
    if (currentUserAccessableActionModel == null)
      currentUserAccessableActionModel = new List();
    currentUserAccessableActionModel = actions;
  }

  List<CurrentUserAccessableActionModel> getCurrentUserAccessableActionModel() {
    return this.currentUserAccessableActionModel;
  }

  List<ApiRelatedUserModel> getRelatedUsers() {
    return this.relatedUsers;
  }

  setCarModelDetail(List<CarModelDetail> modelDetails) {
    if (carModelDetails == null) carModelDetails = new List();
    carModelDetails = modelDetails;
  }

  List<CarModelDetail> getCarModelDetails() {
    return this.carModelDetails;
  }

  setUserIds(int id) {
    if (userIds == null) {
      userIds = new List();
    }
    userIds.add(id);
  }

  setCarIds(int id) {
    if (carIds == null) {
      carIds = new List();
    }
    carIds.add(id);
  }

  List<int> getUserIds() {
    return this.userIds;
  }

  List<int> getCarIds() {
    return this.carIds;
  }

  setCarState(CarStateVM stateVM) {
    if (carStates == null) carStates = new List();
    List<CarStateVM> result =
        carStates.where((s) => s.carIndex == stateVM.carIndex).toList();
    if (result == null || result.length == 0)
      carStates.add(stateVM);
    else {
      int index = carStates.indexWhere((s) => s.carIndex == stateVM.carIndex);
      if (index > -1) {
        carStates[index] = stateVM;
      }
    }
  }

  setUserLoginedInfoCached(UserLoginedInfo data) {
    if (this.cachedUserInfo == null) cachedUserInfo = new UserLoginedInfo();
    cachedUserInfo = data;
  }

  UserLoginedInfo getCachedUserLoginedInfo() {
    if (cachedUserInfo != null) return this.cachedUserInfo;
    return null;
  }

  CarStateVM getCarState(int indx, CarStateVM stateVM) {
    int carIndex = stateVM != null ? stateVM.carIndex : indx;
    List<CarStateVM> result =
        carStates.where((s) => s.carIndex == carIndex).toList();
    if (result != null && result.length > 0) return result[0];
    return null;
  }

  CarStatus fetchCarStatus(CarStateVM stateVM) {
    CarStatus carStatus = CarStatus.BOTHCLOSED;
    if (stateVM.isDoorOpen && !stateVM.isTraunkOpen) {
      carStatus = CarStatus.ONLYDOOROPEN;
    }
    if (stateVM.isTraunkOpen && !stateVM.isDoorOpen) {
      carStatus = CarStatus.ONLYTRUNKOPEN;
    }
    if (stateVM.isDoorOpen && stateVM.isTraunkOpen) {
      carStatus = CarStatus.BOTHOPEN;
    }
    return carStatus;
  }

  setDevices(List<ApiDeviceModel> devices) {
    if (carDevices == null) carDevices = new List();
    if (carDevices.length == 0) carDevices = devices;
  }

  setDeviceModels(List<DeviceModel> devices) {
    if (carDeviceModels == null) carDeviceModels = new List();
    carDeviceModels = devices;
  }

  List<DeviceModel> getDeviceModels() {
    return this.carDeviceModels;
  }

  setCarsToAdmin(List<AdminCarModel> cars) {
    if (carsToAdmin == null) carsToAdmin = new List();
    if (carsToAdmin != null && carsToAdmin.length > 0) carsToAdmin.clear();

    for (var cr in cars) {
      Car car_temp = getCarByCarId(cr.CarId);
      if (car_temp != null) {
        cr.colorTitle = car_temp.colorTitle;
        cr.colorId = car_temp.colorTypeConstId;
      }
      carsToAdmin.add(cr);
    }
  }

  setActionToRoles(List<ActionToRoleModel> actionRoles) {
    if (actionToRoles == null) actionToRoles = new List();
    actionToRoles = actionRoles;
  }

  List<ActionToRoleModel> getActionToRoles() {
    return this.actionToRoles;
  }

  setActions(List<ActionModel> acts) {
    if (actions == null) actions = new List();
    actions = acts;
  }

  List<ActionModel> getActions() {
    return this.actions;
  }

  ActionModel getActionByActionCode(int actionId) {
    if (actions != null && actions.length > 0) {
      List<ActionModel> result =
          actions.where((a) => a.ActionId == actionId).toList();
      if (result != null && result.length > 0)
        return result.first;
      else
        return null;
    }
    return null;
  }

  List<AdminCarModel> getCarsToAdmin() {
    return this.carsToAdmin;
  }

  List<ApiDeviceModel> getDevices() {
    return this.carDevices;
  }

  showConfirmDialog(BuildContext context, String bodyTitle, String bodyText,
      VoidFutureConfirmCallBack onConfirm, Function onCancel, int carId) async {
    await animated_dialog_box.showScaleAlertBox(
        title: Center(child: Text(bodyTitle)),
        context: context,
        firstButton: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text(Translations.current.yes()),
          onPressed: () async => onConfirm(carId),
        ),
        secondButton: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text(Translations.current.no()),
          onPressed: () {
            if (onCancel == null)
              Navigator.of(context).pop();
            else
              onCancel();
          },
        ),
        icon: Icon(
          Icons.info_outline,
          color: Colors.red,
        ),
        yourWidget: Container(
          child: Text(bodyText),
        ));
  }

  int getCarIdByIndex(int index) {
    if (this.carsToAdmin != null && this.carsToAdmin.length > 0) {
      int carId = this.carsToAdmin[index].CarId;
      return carId;
    }
    return 0;
  }

  int getCarColorByIndex(int index) {
    if (this.carsToAdmin != null && this.carsToAdmin.length > 0) {
      int carId = this.carsToAdmin[index].CarId;
      Car cr = getCarByCarId(carId);
      if (cr != null) return cr.colorTypeConstId;
      return 0;
    }
    return 0;
  }

  Car getCarByCarId(int carId) {
    if (cars != null && cars.length > 0) {
      List<Car> crs = cars.where((c) => c.carId == carId).toList();

      if (crs != null && crs.length > 0) {
        Car cr = crs.first;
        return cr;
      } else
        return null;
    }
    return null;
  }

  setCars(List<Car> carss) {
    if (cars == null) cars = new List();
    cars = carss;
  }

  setPlans(List<PlanModel> plns) {
    if (this.plans == null) plans = new List();
    plans = plns;
  }

  List<PlanModel> getPlans() {
    return this.plans;
  }

  List<CarModel> getCarModels() {
    return this.carModels;
  }

  setCarModels(List<CarModel> models) {
    if (carModels == null) carModels = new List();
    if (carModels.length == 0) carModels = models;
  }

  List<ApiCarColor> getCarColors() {
    return this.carColors;
  }

  setCarColors(List<ApiCarColor> colors) {
    if (carColors == null) carColors = new List();
    if (carColors.length == 0) carColors = colors;
  }

  List<BrandModel> getCarBrands() {
    return this.carBrands;
  }

  List<String> getBrandsTitle() {
    List<String> brandsTitle = new List();
    getCarBrands().forEach((b) {
      brandsTitle.add(b.brandTitle);
    });
    return brandsTitle;
  }

  setCarBrands(List<BrandModel> brands) {
    if (carBrands == null) carBrands = new List();
    if (carBrands.length == 0) carBrands.addAll(brands);
  }

  HashMap<String, List<Car>> getCarsMap() {
    return this.mapOfCars;
  }

  setCarsMap(List<Car> cars, String key) {
    getCarsMap().putIfAbsent(key, () => cars);
  }

  HashMap<String, List<ApiCarColor>> getCarColorsMap() {
    return this.mapOfCarColor;
  }

  setCarColorsMap(List<ApiCarColor> colors, String key) {
    getCarColorsMap().putIfAbsent(key, () => colors);
  }

  HashMap<String, List<CarModel>> getCarModelMap() {
    return this.mapOfCarModel;
  }

  setCarModelsMap(List<CarModel> models, String key) {
    getCarModelMap().putIfAbsent(key, () => models);
  }

  HashMap<String, List<BrandModel>> getCarBrandsMap() {
    return this.mapOfCarBrands;
  }

  setCarBrandsMap(List<BrandModel> brands, String key) {
    getCarBrandsMap().putIfAbsent(key, () => brands);
  }

  User getUserCached() {
    return userCached;
  }

  setUserCached(User usr) {
    userCached = usr;
  }

  setCachedLocal(String lang_code) {
    LANG_CODE_LOCAL = lang_code;
  }

  getCachedLangCode() {
    return LANG_CODE_LOCAL;
  }

  File profileImage;
  Map<String, dynamic> toMap() {
    return {
      'User': userCached,
    };
  }

  showSnackLogin(GlobalKey<ScaffoldState> scaffoldKey, BuildContext context,
      String message, bool isLoading) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 6),
      backgroundColor: Colors.amber,
      elevation: 0.8,
      content: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        child: new Column(
          children: <Widget>[
            isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        new CircularProgressIndicator(),
                        // new Text(message,style: TextStyle(fontFamily: 'IranSans',fontSize: 20.0),)
                      ])
                : new Icon(
                    Icons.error_outline,
                    color: Colors.black,
                  ),
            Expanded(
              child: new Text(
                message,
                style: TextStyle(fontFamily: 'IranSans', fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  factory CenterRepository.fromMap(Map<String, dynamic> map) {
    return new CenterRepository();
  }

  AndroidAuthMessages get androidAuthMessages {
    return new AndroidAuthMessages(
      fingerprintHint: Translations.current.fingerPrintHint(),
      fingerprintNotRecognized: Translations.current.fingerprintNotRecognized(),
      fingerprintSuccess: Translations.current.fingerprintSuccess(),
      cancelButton: Translations.current.cancel(),
      signInTitle: Translations.current.signInTitle(),
      fingerprintRequiredTitle: Translations.current.fingerprintRequiredTitle(),
      goToSettingsButton: Translations.current.goToSettingsButton(),
      goToSettingsDescription: Translations.current.goToSettingsDescription(),
    );
  }

  IOSAuthMessages get iosAuthMessages {
    return new IOSAuthMessages(
      lockOut: Translations.current.lockOut(),
      goToSettingsButton: Translations.current.goToSettingsButton(),
      goToSettingsDescription: Translations.current.goToSettingsDescription(),
      cancelButton: Translations.current.cancel(),
    );
  }

  List<Genders> getGenders() {
    List<Genders> genders = new List();
    Genders mgender = new Genders(title: 'مرد', type: null, value: true);
    Genders fgender = new Genders(title: 'زن', type: null, value: false);
    genders.add(mgender);
    genders.add(fgender);
    return genders;
  }

  List<Map<String, dynamic>> getGendersMap() {
    List<Map<String, dynamic>> genders = new List();
    Genders mgender = new Genders(title: 'مرد', type: null, value: true);
    Genders fgender = new Genders(title: 'زن', type: null, value: false);
    genders.add(mgender.toMap());
    genders.add(fgender.toMap());
    return genders;
  }

  List<Map<String, dynamic>> getSettingItems() {
    List<Map<String, dynamic>> items = new List();
    SettingsModel item1 = new SettingsModel(title: 'item1', image: '', id: 1);
    SettingsModel item2 = new SettingsModel(title: 'item2', image: '', id: 2);
    SettingsModel item3 = new SettingsModel(title: 'item3', image: '', id: 3);
    SettingsModel item4 = new SettingsModel(title: 'item4', image: '', id: 4);
    SettingsModel item5 = new SettingsModel(title: 'item5', image: '', id: 5);
    items.add(item1.toMap());
    items.add(item2.toMap());
    items.add(item3.toMap());
    items.add(item4.toMap());
    items.add(item5.toMap());
    return items;
  }

  gotoAddCar(BuildContext context, AddCarVM addCarVM) {
    Navigator.of(context).pushNamed('/addcar', arguments: addCarVM);
  }

  goToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  goToPage(BuildContext context, String page) {
    Navigator.of(context).pushNamed(page);
  }

  goToPageAndPop(BuildContext context, String page) {
    Navigator.of(context).popAndPushNamed(page);
  }

  goToPage2(BuildContext context, String page, bool pop) {
    if (pop)
      Navigator.of(context).popAndPushNamed(page);
    else
      Navigator.of(context).pushNamed(page);
  }

  Future<bool> getEngineStatus() async {
    bool status = await prefRepository.getStartEngineStatus();
    return status;
  }

  showFancyToast(String message, bool succeed) {
    // Fluttertoast.showToast(

    //   msg: message,
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIos: 1,
    //   backgroundColor: succeed ? Colors.green : Colors.red,
    //   textColor: Colors.white,
    //   fontSize: 16.0,

    // );
    if (UniversalPlatform.isWeb) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        //backgroundColor: succeed ? Colors.green : Colors.red,
        webBgColor: succeed ? Colors.green : Colors.red,
        textColor: Colors.white,
        timeInSecForIosWeb: 2,
      );
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: succeed ? Colors.green : Colors.red,
        //webBgColor: succeed ? Colors.green : Colors.red,
        textColor: Colors.white,
        timeInSecForIosWeb: 2,
      );
    }
  }

  Future<bool> getAppTheme() async {
    bool isDark;
    int dark = await changeThemeBloc.getOption();
    if (dark == 1)
      isDark = true;
    else
      isDark = false;
    return isDark;
  }

  Future<bool> onWillPop(BuildContext ctx) {
    return showDialog(
          context: ctx,
          child: new AlertDialog(
            title: new Text(Translations.current.areYouSureToExit()),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: new Text(Translations.current.no()),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text(Translations.current.yes()),
              ),
            ],
          ),
        ) ??
        false;
  }

  String showFilterDate(BuildContext context, bool from) {
    //var nowDate=Jalali.now();
    dtpicker.DatePicker.showDatePicker(context,
        theme: dtpicker.DatePickerTheme(
            cancelStyle: TextStyle(
                fontFamily: 'IranSans',
                fontSize: 28.0,
                color: Colors.pinkAccent),
            itemStyle: TextStyle(fontFamily: 'IranSans', fontSize: 20.0),
            doneStyle: TextStyle(
                fontFamily: 'IranSans', fontSize: 28.0, color: Colors.green)),
        showTitleActions: true,
        minTime: DateTime(1980, 1, 1),
        maxTime: DateTime(2049, 12, 31),
        onChanged: (date) {}, onConfirm: (date) {
      var newDate = Jalali.fromDateTime(date);
      String resultDate = newDate.year.toString() +
          '/' +
          newDate.month.toString() +
          '/' +
          newDate.day.toString();
      return resultDate;
    }, currentTime: Jalali.now().toDateTime(), locale: dtpicker.LocaleType.fa);
  }

  Future<InitDataVM> loadInitData(bool hasInternet) async {
    RestDatasource restDS = RestDatasource();
    if (hasInternet) {
      int userId = await prefRepository.getLoginedUserId();

      try {
        List<SaveUserModel> userInfo =
            await restDS.getUserInfo(userId.toString());
        if (userInfo != null && userInfo.length > 0) if (userInfo[0].isSuccess)
          centerRepository.setUserInfo(userInfo[0]);
      } catch (error) {
        Fluttertoast.showToast(msg: error.toString());
      }

      List<BrandModel> brands = new List();
      brands = await carBrandsDS.getAll(BaseRestDS.GET_BRANDS_URL);
      if (brands != null) centerRepository.setCarBrands(brands);

      List<ApiCarColor> colors = new List();
      colors = await carColorsDS.getAll(BaseRestDS.GET_CAR_COLORS_URL);
      if (colors != null) centerRepository.setCarColors(colors);

      List<CarModel> models = new List();
      models = await carModelDS.getAll(BaseRestDS.GET_CAR_MODELS_URL);
      if (models != null) centerRepository.setCarModels(models);

      /*List<ApiDeviceModel> devices = new List();
      try {
        devices = await carDevicesDS.getAll(BaseRestDS.GET_DEVICES_URL);
      }
      catch(error)
    {
      centerRepository.showFancyToast(error.toString());
    }

      if (devices != null)
        centerRepository.setDevices(devices);*/

      List<ActionModel> actions = new List();
      actions = await actionDS.getAll('');
      centerRepository.setActions(actions);

      List<PlanModel> plns = new List();
      plns = await planDS.getAll(BaseRestDS.GET_PLANS_URL);
      centerRepository.setPlans(plns);

      List<ActionToRoleModel> actionToRoles = new List();
      actionToRoles = await restDS.getAllActionsToRole();
      if (actionToRoles != null && actionToRoles.length > 0)
        centerRepository.setActionToRoles(actionToRoles);

      List<CurrentUserAccessableActionModel> accessableActionModel = new List();
      accessableActionModel =
          await restDS.getGetCurrentUserAccessableActions(userId);
      if (accessableActionModel != null && accessableActionModel.length > 0)
        centerRepository
            .setCurrentUserAccessableActionModel(accessableActionModel);

      List<AdminCarModel> carsToAdmin = new List();
      // carsToAdmin = await carDS.getAllCarsByUserId(userId);
      if (carsToAdmin != null) {
        centerRepository.setCarsToAdmin(carsToAdmin);
        prefRepository.setCarsCount(carsToAdmin.length);
      } else {
        prefRepository.setCarsCount(0);
      }

      List<Car> cars = List();
      cars = await restDS.getAllCars(userId);
      centerRepository.setCars(cars);

      List<CarModelDetail> carModelDetails = List();
      carModelDetails =
          await carModelDetaillDS.getAll(BaseRestDS.GET_CAR_MODEL_DETAIL_URL);
      centerRepository.setCarModelDetail(carModelDetails);

      if (brands != null &&
          colors != null &&
          models != null &&
          carModelDetails != null) {
        InitDataVM resultModel = InitDataVM(
            carColor: null,
            carModel: null,
            carBrand: null,
            carDevice: null,
            carDevices: centerRepository.getDevices(),
            carModels: centerRepository.getCarModels(),
            carColors: centerRepository.getCarColors(),
            carBrands: centerRepository.getCarBrands(),
            carsToAdmin: carsToAdmin);

        return resultModel;
      }
    } else {
      centerRepository.setUserInfo(new SaveUserModel(
          UserName: 'Reza',
          FirstName: 'reza',
          LastName: 'nader',
          MobileNo: '09309200925',
          Password: null,
          SimCard: null,
          UserId: 3));
      prefRepository.setLoginedUserId(3);
      prefRepository.setLoginedUserName('Reza');
      prefRepository.setLoginedIsAdmin(true);
      centerRepository.setCarBrands(FakeServer.createBrands());
      centerRepository.setCars(FakeServer.createCars());
      centerRepository.setCarColors(FakeServer.createCarColors());
      centerRepository.setCarModels(FakeServer.createCarModels());
      centerRepository.setCarModelDetail(FakeServer.createCarModelDetails());
      centerRepository.setActions(FakeServer.createActions());
      centerRepository.setPlans(FakeServer.createPlans());
      centerRepository.setCarsToAdmin(FakeServer.createAdminCars());
      centerRepository.setRelatedUsers(FakeServer.createRelatedUsers());
      centerRepository.setActionToRoles(FakeServer.createActionToRoles());
      centerRepository.setCurrentUserAccessableActionModel(
          FakeServer.createCurrentUserAccessableActionModel());
      centerRepository.setDeviceModels(FakeServer.createDeviceModel());
      prefRepository.setCarsCount(centerRepository.getCarsToAdmin().length);
      InitDataVM resultModel = new InitDataVM(
          carColor: null,
          carModel: null,
          carBrand: null,
          carDevice: null,
          carDevices: centerRepository.getDevices(),
          carModels: centerRepository.getCarModels(),
          carColors: centerRepository.getCarColors(),
          carBrands: centerRepository.getCarBrands(),
          carsToAdmin: centerRepository.getCarsToAdmin());
      return resultModel;
    }
    return null;
  }
}

CenterRepository centerRepository = new CenterRepository();
