import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/api_route.dart';
import 'package:anad_magicar/model/apis/notification_model.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/status_noti_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/service/noti_analyze.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/utils/checkOS.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

enum MaterialColor { RED, BLUE, GREEN, YELLOW, BLACK, WHITE, GREY }
enum CarNums { ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN }
enum CarStatus {
  ONLYDOOROPEN,
  ONLYTRUNKOPEN,
  BOTHOPEN,
  BOTHCLOSED,
  ONLYCAPUTOPNE,
  ALLOPEN
}

class CarStateVM {
  NotiAnalyze notiAnalyze;
  final List<String> imgList = [
    "assets/images/car_red.png",
    "assets/images/car_blue.png",
    "assets/images/car_black.png",
    "assets/images/car_white.png",
    "assets/images/car_gray.png",
    "assets/images/car_gray.png",
  ];

  final List<String> carRedStatusList = [
    "assets/images/car_red_door.png",
    "assets/images/car_red_opendoor.png",
    "assets/images/car_red_trunk.png",
    "assets/images/car_red_caput.png"
  ];

  final List<String> carBlueStatusList = [
    "assets/images/car_blue_door.png",
    "assets/images/car_blue_opendoor.png",
    "assets/images/car_blue_trunk.png",
    "assets/images/car_blue_caput.png"
  ];

  final List<String> carGreenStatusList = [
    "assets/images/car_black_door.png",
    "assets/images/car_black_opendoor.png",
    "assets/images/car_black_trunk.png",
    "assets/images/car_black_caput.png"
  ];

  final List<String> carYellowStatusList = [
    "assets/images/car_white_door.png",
    "assets/images/car_white_opendoor.png",
    "assets/images/car_white_trunk.png",
    "assets/images/car_white_caput.png"
  ];

  final List<String> carBlackStatusList = [
    "assets/images/car_black_door.png",
    "assets/images/car_black_opendoor.png",
    "assets/images/car_black_trunk.png",
    "assets/images/car_black_caput.png"
  ];

  final List<String> carWhiteStatusList = [
    "assets/images/car_white_door.png",
    "assets/images/car_white_opendoor.png",
    "assets/images/car_white_trunk.png",
    "assets/images/car_white_caput.png"
  ];

  final List<String> carGrayStatusList = [
    "assets/images/car_gray_door.png",
    "assets/images/car_gray_opendoor.png",
    "assets/images/car_gray_trunk.png",
    "assets/images/car_gray_caput.png"
  ];

  final List<String> carNumbers = [
    "assets/images/one.png",
    "assets/images/two.png",
    "assets/images/three.png",
    "assets/images/four.png",
    "assets/images/four.png",
    "assets/images/four.png",
  ];

  HashMap<CarNums, String> carNumsMap = new HashMap();
  HashMap<MaterialColor, String> carColorsMap = new HashMap();
  HashMap<MaterialColor, List<String>> matStatusColorsMap = new HashMap();
  HashMap<CarStatus, String> carStatusImagesMap = new HashMap();
  HashMap<int, Color> colorsMap = new HashMap();
  HashMap<int, Color> colorsIndexMap = new HashMap();
  HashMap<MaterialColor, Color> carsColorMap = new HashMap();

  HashMap<CarStatus, bool> carStatusMap = new HashMap();
  HashMap<CarStatus, bool> carActionStatusMap = new HashMap();

  HashMap<CarStatus, int> carNotiMap = new HashMap();

  List<Color> colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.black,
    Colors.black38,
    Colors.black54,
  ];

  int colorIndex;
  MaterialColor color;
  bool isDoorOpen;
  bool arm;
  bool isTraunkOpen;
  bool isCaputOpen;
  bool isPowerOn;
  bool AUX1_On;
  bool AUX2_On;
  bool siren;
  bool bothClosed;
  int carIndex;
  int carId;
  int deviceId;
  int colorId;
  bool isPark;
  bool highSpeed;
  bool isGPSOn;
  bool isGPRSON;
  bool reservation;
  bool valet;
  bool pass_mode;
  bool turbo;

  int battery_value = 0;
  int tempreture = 0;
  int carSpeed = 0;
  String carImage;
  String carDoorImage;
  String carTrunkImage;
  String carCaputImage;
  String carStatusImage;

  Color _currentColor;

  String brandTitle;
  String modelTitle;
  String modelDetailTitle;
  String colorTitle;
  String cioBinary;

  CarStateVM(
      {@required this.colorIndex,
      @required this.color,
      @required this.carIndex,
      @required this.isDoorOpen,
      @required this.siren,
      @required this.isTraunkOpen,
      @required this.isCaputOpen,
      @required this.bothClosed,
      @required this.carImage,
      @required this.carDoorImage,
      @required this.carTrunkImage,
      @required this.carCaputImage,
      @required this.carId,
      @required this.deviceId = 0,
      @required this.colorId,
      @required this.arm,
      @required this.valet,
      @required this.pass_mode,
      @required this.turbo,
      @required this.cioBinary,
      this.carStatusImage}) {
    carStatusMap = new HashMap();

    carActionStatusMap = new HashMap();

    matStatusColorsMap.putIfAbsent(MaterialColor.RED, () => carRedStatusList);
    matStatusColorsMap.putIfAbsent(
        MaterialColor.BLACK, () => carBlackStatusList);
    matStatusColorsMap.putIfAbsent(MaterialColor.BLUE, () => carBlueStatusList);
    matStatusColorsMap.putIfAbsent(
        MaterialColor.YELLOW, () => carYellowStatusList);
    matStatusColorsMap.putIfAbsent(
        MaterialColor.GREEN, () => carGreenStatusList);
    matStatusColorsMap.putIfAbsent(
        MaterialColor.WHITE, () => carWhiteStatusList);
    matStatusColorsMap.putIfAbsent(MaterialColor.GREY, () => carGrayStatusList);

    carColorsMap.putIfAbsent(MaterialColor.RED, () => imgList[0]);
    carColorsMap.putIfAbsent(MaterialColor.BLUE, () => imgList[1]);
    carColorsMap.putIfAbsent(MaterialColor.GREEN, () => imgList[2]);
    carColorsMap.putIfAbsent(MaterialColor.YELLOW, () => imgList[3]);
    carColorsMap.putIfAbsent(MaterialColor.BLACK, () => imgList[2]);
    carColorsMap.putIfAbsent(MaterialColor.WHITE, () => imgList[3]);
    carColorsMap.putIfAbsent(MaterialColor.GREY, () => imgList[4]);

    carNumsMap.putIfAbsent(CarNums.ONE, () => carNumbers[0]);
    carNumsMap.putIfAbsent(CarNums.TWO, () => carNumbers[1]);
    carNumsMap.putIfAbsent(CarNums.THREE, () => carNumbers[2]);
    carNumsMap.putIfAbsent(CarNums.FOUR, () => carNumbers[3]);
    carNumsMap.putIfAbsent(CarNums.FIVE, () => carNumbers[4]);
    carNumsMap.putIfAbsent(CarNums.SIX, () => carNumbers[5]);

    int index = 0;
    colors.forEach((c) {
      colorsMap.putIfAbsent(c.value, () => c);
      colorsIndexMap.putIfAbsent(index, () => c);
      index++;
    });

    if (carsColorMap == null) carsColorMap = new HashMap();

    Constants.createCarColorsMap();

    carsColorMap.putIfAbsent(MaterialColor.RED, () => colors[0]);
    carsColorMap.putIfAbsent(MaterialColor.BLUE, () => colors[1]);
    carsColorMap.putIfAbsent(MaterialColor.GREEN, () => colors[2]);
    carsColorMap.putIfAbsent(MaterialColor.YELLOW, () => colors[3]);
    carsColorMap.putIfAbsent(MaterialColor.BLACK, () => colors[4]);
    carsColorMap.putIfAbsent(MaterialColor.WHITE, () => colors[5]);
    carsColorMap.putIfAbsent(MaterialColor.GREY, () => colors[6]);
    //carStatusImagesMap.putIfAbsent(CarStatus.ONLYDOOROPEN, ()=>)

    fillCarInfo();
  }

  setCurrentColor(Color color, MaterialColor materialColor, int carIndex) {
    this._currentColor = getColorFromColorValueMap(color);
  }

  Color getCurrentColor() {
    return this._currentColor;
  }

  Color getColorFromIndexMap(int index) {
    return colorsIndexMap[index];
  }

  MaterialColor getCurrentCarColor(Color color, int value) {
    MaterialColor materialColor = MaterialColor.RED;
    Color colr;
    if (color != null) {
      colr = colorsMap[color.value];
    } else {
      colr = colorsMap[
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

  HashMap<CarStatus, bool> getCarStatusMap() {
    return this.carStatusMap;
  }

  HashMap<CarStatus, bool> getCarActionsStatusMap() {
    return this.carActionStatusMap;
  }

  setCarStatusMap(HashMap<CarStatus, bool> newMap) {
    this.carStatusMap = newMap;
  }

  setCarActionsStatusMap(HashMap<CarStatus, bool> newMap) {
    this.carActionStatusMap = newMap;
  }

  Color getColorFromColorValueMap(Color colr) {
    return colorsMap[colr.value];
  }

  CarStatus carStatus;

  bool setCarStatusImages() {
    carStatus = fetchCarStatus(this);
    if (carStatus == CarStatus.ONLYDOOROPEN) {
      carImage = matStatusColorsMap[color][1]; //carRedStatusList[1];
      carDoorImage = matStatusColorsMap[color][0]; //carRedStatusList[0];
      carTrunkImage = '';
      carCaputImage = isCaputOpen ? matStatusColorsMap[color][3] : '';
    }

    if (carStatus == CarStatus.ONLYTRUNKOPEN) {
      carImage = carColorsMap[color];
      carTrunkImage = matStatusColorsMap[color][2]; //carRedStatusList[2];
      carCaputImage = isCaputOpen ? matStatusColorsMap[color][3] : '';
      carDoorImage = '';
    }

    if (carStatus == CarStatus.BOTHOPEN) {
      carImage = matStatusColorsMap[color][1]; //carRedStatusList[1];
      carDoorImage = matStatusColorsMap[color][0]; //carRedStatusList[0];
      carTrunkImage = matStatusColorsMap[color][2]; //carRedStatusList[2]
      carCaputImage = isCaputOpen ? matStatusColorsMap[color][3] : '';
    }

    if (carStatus == CarStatus.BOTHCLOSED) {
      carImage = carColorsMap[color];
      carDoorImage = '';
      carCaputImage = isCaputOpen ? matStatusColorsMap[color][3] : '';
      carTrunkImage = '';
    }
    return true;
  }

  fillCarInfo() {
    if (carId != null) {
      Car car = centerRepository.getCarByCarId(carId);
      if (car != null) {
        this.deviceId = car.deviceId;
        brandTitle = car.brandTitle;
        modelTitle = car.carModelTitle;
        modelDetailTitle = car.carModelDetailTitle;
        colorTitle = car.colorTitle;
      } else {
        this.deviceId = 0;
        brandTitle = '';
        modelTitle = '';
        modelDetailTitle = '';
        colorTitle = '';
      }
    }
  }

  fillNotiData(String noty, int car_Id) {
    notiAnalyze = new NotiAnalyze(noti: noty, carId: car_Id);
    notiAnalyze.analyzeNoti();
    NotiAnalyze.carNotiMap2.forEach((k, v) {
      if (v == true) carStatus = k;
    });
    if (carStatus != null) {
      setCarStatusImages();
    }
  }

  fillStatusNotiData(StatusNotiVM status, NotyBloc<CarStateVM> statusNoty) {
    if (status != null) {
      isDoorOpen = status.door;
      arm = status.arm;
      isCaputOpen = status.hood;
      isTraunkOpen = status.trunk;
      isPowerOn = status.engine;
      battery_value = status.batteryValue;
      tempreture = status.temp;
      reservation = status.manualTransmission;
      valet = status.valet;
      turbo = status.turbo;
      pass_mode = status.passiveArming;
      //AUX1_On=status;
      //AUX2_On=false;
      siren = status.siren;
      bool result = setCarStatusImages();
      if (result) {
        statusNoty.updateValue(this);
      }
    }
  }

  Future<bool> getParkAndSpeedStatus(NotyBloc<CarStateVM> notyBloc) async {
    List<int> carIds = new List();
    carIds..add(carId);
    ApiRoute route = new ApiRoute(
        carId: carId,
        startDate: null,
        endDate: null,
        dateTime: null,
        speed: null,
        lat: null,
        long: null,
        enterTime: null,
        carIds: carIds,
        DeviceId: deviceId,
        Latitude: null,
        Longitude: null,
        Date: null,
        Time: null,
        CreatedDateTime: null,
        gpsDateTime: null,
        GPSDateTimeGregorian: null);
    var result = await restDatasource.getLastPositionRoute(route);
    if (result != null && result.length > 0) {
      ApiRoute apiRoute = result.first;

      //  if (isIos()) {
      if (apiRoute.HaveNotification != null && apiRoute.HaveNotification) {
        List<NotificationModelApi> notif = await restDatasource
            .getNotificationByDeviceId(apiRoute.DeviceId.toString());
        if (notif != null && notif.isNotEmpty) {
          String msg = notif.last.Status;
          int carId = apiRoute.carId;
          if (msg != null && msg.isNotEmpty) {
            RxBus.post(
                ChangeEvent(type: 'FCM_STATUS', message: msg, id: carId));
          }
        }
      }
      cioBinary = apiRoute.cioBinary;
      //برای دریافت تنظیملت GPRS  میباشد
      String GPSDateTime = apiRoute.GPSDateTimeGregorian;
      int speed = apiRoute.speed;
      if (speed == null) speed = 0;
      String date = apiRoute.Date;
      String time = apiRoute.Time;
      int h = 0, min = 0, sec = 0;
      DateTime now = DateTime.now();
      if (date != null && time != null) {
        DateTime gprsDate = DateTimeUtils.convertIntoDateObject(date);
        // DateTime gprsTime=DateTimeUtils.convertIntoTimeOnly2(time);
        //String timeNow=DateTimeUtils.getTimeNowString();
        var timeStr = time.split(":");
        if (timeStr != null && timeStr.length == 3) {
          h = int.tryParse(timeStr[0]);
          min = int.tryParse(timeStr[1]);
          sec = int.tryParse(timeStr[2]);
        }
        String dateNow = DateTimeUtils.getDateNow();
        String gprsDateStr = DateTimeUtils.getDateFrom(gprsDate);
        //String gprsTimeStr=DateTimeUtils.getTimeFrom(gprsTime);
        DateTime newGPRSDateTime =
            gprsDate.add(Duration(hours: h, minutes: min, seconds: sec));
        Duration gprsTimeDiff = now.difference(newGPRSDateTime);
        if (dateNow == gprsDateStr && gprsTimeDiff.inHours <= 1)
          isGPSOn = true;
        else
          isGPSOn = false;
      } else {
        isGPRSON = false;
      }
      DateTime gpsDt = DateTimeUtils.convertIntoDateTimeObject(GPSDateTime);

      Duration diff = now.difference(gpsDt);
      if (diff.inMinutes <= 1) {
        isGPRSON = true;
      } else {
        isGPRSON = false;
      }

      carSpeed = speed;
      int minSpeed = await prefRepository
          .getMinMaxSpeed(SettingsScreenState.MIN_SPEED_TAG);
      int maxSpeed = await prefRepository
          .getMinMaxSpeed(SettingsScreenState.MAX_SPEED_TAG);
      if (speed > maxSpeed) {
        highSpeed = true;
      } else if (speed < maxSpeed && speed > minSpeed) {
        highSpeed = false;
      }
      if (speed < 5) {
        isPark = true;
      } else {
        isPark = false;
      }
      notyBloc.updateValue(this);
      return true;
    }
    return false;
  }

  CarStatus fetchCarStatus(CarStateVM stateVM) {
    CarStatus carStatus = CarStatus.BOTHCLOSED;
    if (stateVM.isDoorOpen && !stateVM.isTraunkOpen) {
      carStatus = CarStatus.ONLYDOOROPEN;
      if (carStatusMap.containsKey(CarStatus.ONLYDOOROPEN))
        carStatusMap.remove(CarStatus.ONLYDOOROPEN);

      carStatusMap.putIfAbsent(CarStatus.ONLYDOOROPEN, () => true);
    }
    if (stateVM.isTraunkOpen && !stateVM.isDoorOpen) {
      carStatus = CarStatus.ONLYTRUNKOPEN;
      if (carStatusMap.containsKey(CarStatus.ONLYTRUNKOPEN))
        carStatusMap.remove(CarStatus.ONLYTRUNKOPEN);
      carStatusMap.putIfAbsent(CarStatus.ONLYTRUNKOPEN, () => true);
    }
    if (stateVM.isDoorOpen && stateVM.isTraunkOpen) {
      carStatus = CarStatus.BOTHOPEN;
      if (carStatusMap.containsKey(CarStatus.BOTHOPEN))
        carStatusMap.remove(CarStatus.BOTHOPEN);
      carStatusMap.putIfAbsent(CarStatus.BOTHOPEN, () => true);
    }

    return carStatus;
  }
}
