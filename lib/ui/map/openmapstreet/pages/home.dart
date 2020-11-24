import 'dart:async';
//import 'dart:html';
import 'dart:math' as math;

import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/api_route.dart';
import 'package:anad_magicar/model/apis/api_search_car_model.dart';
import 'package:anad_magicar/model/apis/paired_car.dart';
import 'package:anad_magicar/model/apis/slave_paired_car.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/viewmodel/car_info_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/model/viewmodel/map_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/service/user_location/src/user_location_options.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/map/geojson/geojson.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/location_data.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/ui/theme/app_themes.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/extended_navbar/extended_navbar_scaffold.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:anad_magicar/widgets/persian_datepicker/persian_datepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocator/geolocator.dart' as locator;
import 'package:geopoint/geopoint.dart';
import 'package:geopoint_location/geopoint_location.dart';
import 'package:latlong/latlong.dart';
import 'package:livemap/livemap.dart';
import 'package:location/location.dart' as loc;
import 'package:maps_toolkit/maps_toolkit.dart' as maptoolkit;
import 'package:pedantic/pedantic.dart';
import 'package:popup_menu/popup_menu.dart' as popmenu;
import 'dart:ui' as ui;

final List<String> carImgList = [
  "assets/images/car_red.png",
  "assets/images/car_blue.png",
  "assets/images/car_black.png",
  "assets/images/car_white.png",
  "assets/images/car_yellow.png",
  "assets/images/car_gray.png",
];

class LocationDataGeo {
  LocationDataGeo({
    @required this.id,
    this.result,
    @required this.origin,
    @required this.color,
    @required this.createdAtTimestamp,
    this.elapsedTimeSeconds,
  });

  final int id;
  final geo.LocationResult result;
  final String origin;
  final Color color;
  final int createdAtTimestamp;
  final int elapsedTimeSeconds;
}

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}

class MapPage extends StatefulWidget {
  int carId;
  int carCounts;
  List<AdminCarModel> carsToUser;
  GlobalKey<ScaffoldState> scaffoldKey;
  MapVM mapVM;
  MapPage(
      {@required this.mapVM,
      @required this.carId,
      @required this.carCounts,
      @required this.carsToUser,
      @required this.scaffoldKey});

  @override
  MapPageState createState() {
    // TODO: implement createState
    return MapPageState();
  }
}

class MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  static const String route = '/mappage';

  popmenu.PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();

  List<LocationDataGeo> _locations = [];
  List<StreamSubscription<dynamic>> _subscriptions = [];
  List<GroupModel> _group = [
    GroupModel(
      text: "نمایش بصورت هوایی",
      index: 1,
    ),
    GroupModel(
      text: "نمایش بصورت زمینی",
      index: 2,
    ),
    GroupModel(
      text: "نمایش بصورت پیاده",
      index: 3,
    ),
  ];
  static final String MINMAX_SPEED_TAG = 'MINMAX_SPEED';
  static final String MIN_SPEED_TAG = 'MIN_SPEED';
  static final String MAX_SPEED_TAG = 'MAX_SPEED';
  String userName = '';
  double buttonWidth = 110;
  int periodicTimePosition = 60;
  int userId = 0;
  int minSpeed = 30;
  int maxSpeed = 100;
  int minDelay = 10;
  bool hasPoint = true;
  int currentCarLocationSpeed = 0;
  static bool forAnim = false;
  static int lastCarIdSelected = 0;
  bool _showInfoPopUp = false;
  bool isGPSOn = false;
  bool isGPRSOn = false;
  bool showAllItemsOnMap = true;
  bool showSattelite = false;
  final TextEditingController textEditingController = TextEditingController();
  String fromDate = '';
  String toDate = '';
  String minStopTime1 = '';
  String mStopTime2 = '';
  bool showMinSpeedMarkers = true;
  bool showMaxSpeedMarkers = true;
  bool showStopSpeedMarkers = false;
  bool showSimulateSpeedMarkers = false;

  int showSelectedRoutingIndex = 1;
  //برای نمایش هوایی زمینی یا پیاده
  int _currentIndex = 1;

  PersianDatePickerWidget persianDatePicker;
  final String imageUrl = 'assets/images/user_profile.png';
  final String markerRed = 'assets/images/mark_red.png';
  final String markerGreen = 'assets/images/mark_green.png';
  final String markerPark = 'assets/images/park_marker.png';
  final String markerStart = 'assets/images/start_point.png';
  final String markerEnd = 'assets/images/end_point.png';

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();

  bool _autoValidate = false;
  bool isDark = false;
  List<CarInfoVM> carInfos = new List();
  NotyBloc<Message> reportNoty = new NotyBloc<Message>();
  NotyBloc<Message> reportDateNoty = new NotyBloc<Message>();
  NotyBloc<Message> statusNoty = new NotyBloc<Message>();
  NotyBloc<Message> changedCheckBoxNoty = new NotyBloc<Message>();
  NotyBloc<Message> changedRoutRadioBoxNoty = new NotyBloc<Message>();

  //NotyBloc<Message> moreButtonNoty=new NotyBloc<Message>();
  NotyBloc<Message> pairedChangedNoty = new NotyBloc<Message>();
  NotyBloc<Message> animateNoty = new NotyBloc<Message>();
  NotyBloc<Message> showAllItemsdNoty = new NotyBloc<Message>();
  NotyBloc<Message> showAllItemsdNoty2 = new NotyBloc<Message>();

  Future<List<CarInfoVM>> carInfoss;
  Future<List<ApiPairedCar>> carsPaired;

  List<AdminCarModel> carsToUserSelf;
  List<ApiPairedCar> carsPairedList;
  List<ApiPairedCar> pcarsPairedList;
  List<ApiPairedCar> pcarsPairedActivated = new List<ApiPairedCar>();
  List<SlavedCar> carsSlavePairedList;

  int _carCounts = 0;
  LocationDataLocator currentLocation;
  StreamSubscription<loc.LocationData> _locationSubscription;

  loc.LocationData _lastKnownPosition;
  loc.LocationData _currentPosition;
  bool gpsDialogGasShownBefore = false;
  List<Marker> markers = [];
  List<Marker> carAnimMarkers = [];
  Map<int, LatLng> carInMarkerMap = Map();
  Map<int, int> carIndexMarkerMap = Map();
  Map<int, Marker> carMarkersMap = Map();

  List<LatLng> points = [];
  List<double> degress = [];
  StreamController<LatLng> markerlocationStream = StreamController();
  UserLocationOptions userLocationOptions;

  final polygons = <Polygon>[];
  List<Polyline> lines = List(); //<Polyline>[];
  Future<List<Polyline>> lines2;

  MapController mapController;
  LiveMapController liveMapController;

  Marker _marker;
  Timer _timerupdate;
  int _markerIndex = 0;
  Polyline _polyLine;
  Polyline _polyLineAnim;

  LatLng _fpoint;
  LatLng _spoint;

  int _pointIndex = 0;
  Timer _timerLine;
  int _polyLineIndex = 0;
  double markerSize = 16;
  String pelakForSearch = '';
  String carIdForSearch = '';
  String mobileForSearch = '';
  String minStopTime;
  String minStopDate;

  String minStopTime2;
  String minStopDate2;

  LatLng firstPoint;
  LatLng currentCarLatLng;
  bool showWaiting = false;
  bool _serviceEnabled;
  loc.Location location = loc.Location();
  loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData;

//برای تشخیص زوم شدن توسط کاربر
  StreamSubscription _changefeed;
  double _myzoom = 15.0;
  double _zoom = 15.0;

  // Widget getMap() {
  //   String htmlId = "7";

  //   // ignore: undefined_prefixed_name
  //   ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
  //     final myLatlng = LatLng(1.3521, 103.8198);

  //     final mapOptions = MapOptions();
  //     //mapOptions.zoom = 10.0;
  //     mapOptions..center = LatLng(1.3521, 103.8198);

  //     final elem = DivElement()
  //       ..id = htmlId
  //       ..style.width = "100%"
  //       ..style.height = "100%"
  //       ..style.border = 'none';

  //     final map = GMap(elem, mapOptions);

  //     Marker(MarkerOptions()
  //       ..position = myLatlng
  //       ..map = map
  //       ..title = 'Hello World!');

  //     return elem;
  //   });

  //   return HtmlElementView(viewType: htmlId);
  // }

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    _serviceEnabled = serviceEnabledResult;
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
      _serviceEnabled = serviceRequestedResult;
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future<void> _checkPermissions() async {
    final loc.PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    _permissionGranted = permissionGrantedResult;
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != loc.PermissionStatus.granted) {
      final loc.PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      _permissionGranted = permissionRequestedResult;
      if (permissionRequestedResult != loc.PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      _locationData = _locationResult;
    } on PlatformException catch (err) {
      print(err.toString());
    }
  }

  Future<LocationDataLocator> getLocationForRoute() async {
    await _checkPermissions();
    if (_permissionGranted != loc.PermissionStatus.granted) {
      await _requestPermission();
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      await _checkService();
      if (!_serviceEnabled) {
        await _requestService();
      }
      if (_serviceEnabled) {
        await _getLocation();
        if (_locationData != null) {
          currentLocation = mapLocationData(_locationData);
        }
      }
    }

    return currentLocation;
  }

  registerRxBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event) {
      if (event.type == 'GPS_STATUS') {}
    });
  }

  double getDirection(double lat1, double lng1, double lat2, double lng2) {
    double PI = math.pi;
    double dTeta = math
        .log(math.tan((lat2 / 2) + (PI / 4)) / math.tan((lat1 / 2) + (PI / 4)));
    double dLon = (lng1 - lng2).abs();
    double teta = math.atan2(dLon, dTeta);
    double direction = radianToDeg(teta);
    return direction; //direction in degree
  }

// دریافت رنگ سرعت ها
  Widget getMarkerOnSpeed(int speed, int diff) {
    var item = Image.asset(markerRed, key: ObjectKey(Colors.red));
    if (maxSpeed == null || maxSpeed == 0) maxSpeed = 100;
    if (minSpeed == null || minSpeed == 0) minSpeed = 30;
    if (speed == null) speed = 0;
    if (minDelay == null) minDelay = 0;
    if (speed >= maxSpeed)
      return item;
    else if (speed < 5 && diff >= minDelay)
      return Image.asset(
        markerPark,
        key: ObjectKey(Colors.green),
      );
    /*else if(speed >= minSpeed && speed < maxSpeed)
      return*/
    else if (speed <= minSpeed)
      return Image.asset(
        markerGreen,
        color: Colors.amber,
        key: ObjectKey(Colors.amber),
      );
    else
      return Image.asset(
        markerGreen,
        color: Colors.transparent,
        key: ObjectKey(Colors.green),
      );
  }

  getPeriodicTimePosition() async {
    periodicTimePosition = await prefRepository
        .getPeriodicTime(SettingsScreenState.PERIODIC_TIME_TAG);
    if (periodicTimePosition == null || periodicTimePosition == 0)
      periodicTimePosition = 60;
  }

  getDefaultSettingsValues() async {
    minSpeed =
        await prefRepository.getMinMaxSpeed(SettingsScreenState.MIN_SPEED_TAG);
    maxSpeed =
        await prefRepository.getMinMaxSpeed(SettingsScreenState.MAX_SPEED_TAG);
    minDelay = await prefRepository
        .getMinMaxSpeed(SettingsScreenState.MINMAX_SPEED_TAG);
    showSelectedRoutingIndex =
        await prefRepository.getRoutingType(CenterRepository.ROUTING_TYPE_TAG);
    if (minSpeed == null) minSpeed = 30;
    if (maxSpeed == null) maxSpeed = 100;
    if (minDelay == null) minDelay = 10;
    if (showSelectedRoutingIndex == null || showSelectedRoutingIndex == 0)
      showSelectedRoutingIndex = 1;
    _currentIndex = showSelectedRoutingIndex;
  }

  getAppTheme() async {
    int dark = await changeThemeBloc.getOption();
    setState(() {
      if (dark == 1)
        isDark = true;
      else
        isDark = false;
    });
  }

  Marker currentMarker;
  animateToCurrentLocation() async {
    statusNoty.updateValue(Message(type: 'SEARCH_LOCATION'));
    var result = await getLocationForRoute();
    if (result != null) {
      var marker = Marker(
          width: markerSize + 28,
          height: markerSize + 28,
          point: LatLng(result.latitude, result.longitude),
          builder: (ctx) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: markerSize + 28,
                height: markerSize + 28,
                child: CircleAvatar(
                  radius: markerSize + 28,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('assets/images/location.png',
                      color: Colors.indigoAccent, key: ObjectKey(Colors.red)),
                ),
              ),
            );
          });
      currentMarker = marker;
      if (!kIsWeb) {
        liveMapController.mapController
            .move(LatLng(result.latitude, result.longitude), 18);
      } else {
        mapController.move(LatLng(result.latitude, result.longitude), 18);
      }
    }
    statusNoty.updateValue(Message(type: 'CURRENT_LOCATION_UPDATED'));
  }

  animateRoutecarPolyLines() async {
    String carImage = '';
    var car = carInfos.where((c) => c.carId == lastCarIdSelected).toList();
    if (car != null && car.length > 0) {
      carImage = Constants.carImagesInColorMap[car.first.colorId];
    }

    if (carImage == null || carImage.isEmpty) {
      carImage = Constants.carImagesInColorMap[Constants.CAR_COLOR_WHITE_TAG];
    }

    int next = 0;
    int index = 0;
    _timerLine = Timer.periodic(Duration(milliseconds: 350), (_) {
      _polyLine = lines[_polyLineIndex];
      _polyLineIndex = (_polyLineIndex + 1) % lines.length;
      //index=_polyLine.points.length;
      if (index < _polyLine.points.length - 1) {
        index++;
        next = index + 1;
      }
      // _fpoint=_polyLine.points[_pointIndex];
      _pointIndex = (_pointIndex + 1) % _polyLine.points.length;
      if (index < _polyLine.points.length - 1) {
        _fpoint = _polyLine.points[index];
        _spoint = _polyLine.points[next];
        points..add(_fpoint)..add(_spoint);
        maptoolkit.LatLng slng =
            maptoolkit.LatLng(_fpoint.latitude, _fpoint.longitude);
        maptoolkit.LatLng slng2 =
            maptoolkit.LatLng(_spoint.latitude, _spoint.longitude);

        double deg = maptoolkit.SphericalUtil.computeHeading(slng2,
            slng); //getDirection(_fpoint.latitude, _fpoint.longitude, _spoint.latitude, _spoint.longitude);
        degress..add(deg - 90);
      }
      if ((_pointIndex + 1) >= _polyLine.points.length) {
        _timerLine.cancel();
      }
      _polyLineAnim = Polyline(
          strokeWidth: (8.0 * _myzoom) / _zoom,
          color: Colors.blueAccent,
          points: points);

      if (degress != null && degress.length > 0) {
        double _size = (markerSize + 28) * _myzoom / _zoom;
        var marker = Marker(
            width: _size,
            height: _size,
            point: _spoint,
            builder: (ctx) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                    width: _size,
                    height: _size,
                    child: CircleAvatar(
                      radius: _size,
                      backgroundColor: Colors.transparent,
                      child: Transform.rotate(
                        angle: (math.pi * (degress[index - 1] - 90)) / 180,
                        child:
                            Image.asset(carImage, key: ObjectKey(Colors.red)),
                      ),
                    )),
              );
            });
        if (carAnimMarkers != null && carAnimMarkers.isNotEmpty) {
          carAnimMarkers = [];
        }
        carAnimMarkers..add(marker);
      }
      animateNoty.updateValue(Message(type: 'LINE_ANIM'));
    });
  }

  getUserId() async {
    userId = await prefRepository.getLoginedUserId();
  }

  _onPelakChanged(value) {
    pelakForSearch = value.toString();
  }

  _onMobileChanged(value) {
    mobileForSearch = value.toString();
  }

  _onCarIdChanged(value) {
    carIdForSearch = value.toString();
  }

  _updateLastPositionCarPeriodically(
      int index, int carId, bool isCarPaired) async {
    int updateTime = periodicTimePosition * 1000;
    _timerupdate = Timer.periodic(Duration(milliseconds: updateTime), (_) {
      navigateToCarSelected(index, isCarPaired, carId, true, true, false);
    });
  }

  _deleteCarFromPaired(
    int masterId,
    int secondCar,
  ) async {
    // var result=await restDatasource.savePairedCar(car);
    /* String toDate=DateTimeUtils.convertIntoDateTime(DateTimeUtils.getDateJalali());
    String toTime=DateTimeUtils.getTimeNow();
*/
    ApiPairedCar pairedCar = ApiPairedCar(
        PairedCarId: 0,
        MasterCarId: masterId,
        SecondCarId: secondCar,
        FromDate: toDate,
        ToDate: null,
        FromTime: null,
        ToTime: null,
        Description: null,
        IsActive: false,
        RowStateType: Constants.ROWSTATE_TYPE_DELETE,
        CarIds: null,
        master: null,
        slaves: null);
    List<int> carIds = [secondCar];
    var result = await restDatasource.deletePairedCars(masterId, carIds);
    if (result != null) {
      if (result.IsSuccessful) {
        centerRepository.showFancyToast(result.Message, true);
        // setState(() {
        carsPairedList.removeWhere((c) => c.SecondCarId == secondCar);
        pairedChangedNoty.updateValue(new Message(type: 'CAR_PAIRED'));
        //});
      } else {
        centerRepository.showFancyToast(result.Message, false);
      }
    }
  }

  _showCarPairedActions(ApiPairedCar car, BuildContext context) {
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.70,
        builder: (BuildContext context) {
          return Container(
            height: 250.0,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /* GestureDetector(
          child : Padding(
            padding: EdgeInsets.only(bottom: 20.0, right: 10.0,left: 10.0),
            child:
            Button(clr: Colors.pinkAccent,wid:150.0,title: Translations.current.confirm(),),),
          onTap: (){
            if(pcarsPairedList!=null && pcarsPairedList.length > 0) {
              var ppcar = pcarsPairedList.where((p) => p.SecondCarId == car.CarId).toList();
              if(ppcar!=null && ppcar.length > 0) {
                ApiPairedCar pairedCar = new ApiPairedCar(
                    PairedCarId: ppcar.first.PairedCarId,
                    MasterCarId: ppcar.first.MasterCarId,
                    SecondCarId: ppcar.first.SecondCarId,
                    FromDate: ppcar.first.FromDate,
                    ToDate: DateTimeUtils.getDateJalali(),
                    FromTime: ppcar.first.FromTime,
                    ToTime: DateTimeUtils.getTimeNow(),
                    Description: null,
                    IsActive: true,
                    RowStateType: Constants.ROWSTATE_TYPE_UPDATE,
                    CarIds: null,
                    master: null,
                    slaves: null);
                addCarToPaired(pairedCar, Constants.ROWSTATE_TYPE_UPDATE);
              }
              */ /*if (carsSlavePairedList != null &&
                  carsSlavePairedList.length > 0) {

                var cpaired = carsSlavePairedList.where((c) =>
                c.CarId == car.CarId).toList();
                if (cpaired != null && cpaired.length > 0) {


                }
              }*/ /*
              Navigator.pop(context);
            }

          },),*/
                      Expanded(
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 10.0, right: 10.0, left: 10.0),
                            child: Button(
                              fixWidth: false,
                              clr: Colors.pinkAccent,
                              wid: 150.0,
                              color: Colors.pinkAccent.value,
                              backTransparent: true,
                              title: Translations.current.delete(),
                            ),
                          ),
                          onTap: () {
                            //_deleteCarFromPaired(car.MasterCar.carId,car.SecondCar.carId);
                            ApiPairedCar pairedCar = new ApiPairedCar(
                                PairedCarId: car.PairedCarId,
                                MasterCarId: car.MasterCar.carId,
                                SecondCarId: car.SecondCar.carId,
                                FromDate: DateTimeUtils.getDateNow(),
                                ToDate: car.ToDate,
                                FromTime: DateTimeUtils.getTimeNow(),
                                ToTime: car.ToTime,
                                Description: null,
                                IsActive: false,
                                RowStateType: Constants.ROWSTATE_TYPE_DELETE,
                                CarIds: null,
                                master: null,
                                slaves: null);
                            addCarToPaired(
                                pairedCar, Constants.ROWSTATE_TYPE_DELETE);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 10.0, right: 10.0, left: 10.0),
                            child: Button(
                              fixWidth: false,
                              clr: Colors.pinkAccent,
                              color: Colors.pinkAccent.value,
                              backTransparent: true,
                              wid: 150.0,
                              title: Translations.current.navigateToCurrent(),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            if (_timerupdate != null && _timerupdate.isActive)
                              _timerupdate.cancel();
                            lastCarIdSelected = car.SecondCar.carId;
                            navigateToCarSelected(0, true, car.SecondCar.carId,
                                true, false, true);

                            //navigateToCarSelected(0,true, car.SecondCar.carId,true,false);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 10.0, right: 10.0, left: 10.0),
                            child: Button(
                              fixWidth: false,
                              clr: Colors.pinkAccent,
                              color: Colors.pinkAccent.value,
                              backTransparent: true,
                              wid: 150.0,
                              title: 'محل جاری خودرو',
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            navigateToCarSelected(0, true, car.SecondCar.carId,
                                true, false, false);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showBottomSheetForSearchedCar(BuildContext cntext, Car car) {
    showModalBottomSheetCustom(
        context: cntext,
        builder: (BuildContext context) {
          return new Container(
            height: 450.0,
            child: new Card(
              margin: new EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 0.5),
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              child: new Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0xfffefefe),
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Text(Translations.current.carId()),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Text(car.carId.toString()),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Text(Translations.current.carpelak()),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Text(car.pelaueNumber),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: new Container(
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                              ),
                              child: FlatButton(
                                  onPressed: () {
                                    String toDate =
                                        DateTimeUtils.convertIntoDateTime(
                                            DateTimeUtils.getDateJalali());
                                    String toTime = DateTimeUtils.getTimeNow();

                                    ApiPairedCar pairedCar = new ApiPairedCar(
                                        PairedCarId: 0,
                                        MasterCarId: widget.mapVM.carId,
                                        SecondCarId: car.carId,
                                        FromDate: toDate,
                                        ToDate: null,
                                        FromTime: toTime,
                                        ToTime: null,
                                        Description: null,
                                        IsActive: false,
                                        RowStateType:
                                            Constants.ROWSTATE_TYPE_INSERT,
                                        CarIds: null,
                                        master: null,
                                        slaves: null);

                                    addCarToPaired(pairedCar,
                                        Constants.ROWSTATE_TYPE_INSERT);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    Translations.current.addToPaired(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  searchCar() async {
    //_formKey2.currentState.save();
    if ((carIdForSearch == '' ||
            carIdForSearch.isEmpty ||
            carIdForSearch == null) &&
        (pelakForSearch == '' ||
            pelakForSearch.isEmpty ||
            pelakForSearch == null) &&
        (mobileForSearch == '' ||
            mobileForSearch.isEmpty ||
            mobileForSearch == null)) {
      centerRepository.showFancyToast(
          'حداقل باید یکی از موارد جستجو وارد گردد', false);
    } else {
      SearchCarModel searchCarModel = new SearchCarModel(
          AdminUserId: null,
          RequestFromThisUserId: null,
          CarId: int.tryParse(carIdForSearch),
          Message: null,
          userId: userId,
          pelak: pelakForSearch,
          DecviceSerialNumber: mobileForSearch);
      try {
        centerRepository.showProgressDialog(context, 'در حال جستجو...');
        List<Car> result = await restDatasource.searchCars(
            int.tryParse(carIdForSearch), pelakForSearch, mobileForSearch);
        if (result != null && result.length > 0) {
          centerRepository.dismissDialog(context);
          var cr = result
              .where((c) => c.carId == int.tryParse(carIdForSearch))
              .toList();
          if (cr != null && cr.length > 0) {
            Navigator.pop(context);
            _showBottomSheetForSearchedCar(context, cr.first);
          } else {
            centerRepository.showFancyToast('خودروی مورد نظر یافت نشد', false);
          }
        }
      } catch (error) {
        print('');
      }
    }
  }

  Future<List<CarInfoVM>> getCarInfo(bool refresh) async {
    carsToUserSelf = centerRepository.getCarsToAdmin();
    if (refresh) {
      if (centerRepository.getCarsToAdmin() != null)
        _carCounts = centerRepository.getCarsToAdmin().length;
      fillCarInfo(carsToUserSelf);
    } else {
      if (_carCounts == 0) {
        if (centerRepository.getCarsToAdmin() != null)
          _carCounts = centerRepository.getCarsToAdmin().length;
        fillCarInfo(carsToUserSelf);
      }
    }
    // var cars=await restDatasource.getAllPairedCars();
    // carsPairedList=cars;
    var pcars_temp = await restDatasource.getPairedCars();
    carsPairedList = pcars_temp;
    // carsPairedList = carsPairedList.where(test);
    /*carsSlavePairedList=new List();
    for(var c in cars) {
      for(var sc in c.slaves ){
        sc.masterId=c.master;
      }
      carsSlavePairedList..addAll(c.slaves);
    }*/

    fillCarsInGroup();
    return carInfos;
  }

  fillCarsInGroup() async {
    for (var car in carInfos) {
      if (carsPairedList != null && carsPairedList.length > 0) {
        var carfound = carsPairedList
            .where((c) => c.SecondCar.carId == car.carId)
            .toList();
        if (carfound != null && carfound.length > 0) {
          car.hasJoind = true;
        } else {
          car.hasJoind = false;
        }
      }
    }
  }

  fillCarInfo(List<AdminCarModel> carsToUser) {
    carInfos = new List();
    int indx = 0;
    for (var car in carsToUser) {
      Car car_info = centerRepository
          .getCars()
          .where((c) => c.carId == car.CarId)
          .toList()
          .first;
      if (car_info != null) {
        int tip = 0;
        if (centerRepository.getCarBrands() != null) {
          // tip=centerRepository.getCarBrands().where((d)=>d.brandId==car_info. )
        }
        SaveCarModel editModel = new SaveCarModel(
          carId: car_info.carId,
          brandId: 0,
          modelId: null,
          tip: null,
          pelak: car_info.pelaueNumber,
          colorId: car_info.colorTypeConstId,
          distance: null,
          ConstantId: null,
          DisplayName: null,
        );

        CarStateVM carState =
            centerRepository.getCarStateVMByCarId(car_info.carId);

        CarInfoVM carInfoVM = new CarInfoVM(
            brandModel: null,
            car: car_info,
            carColor: null,
            carModel: null,
            carModelDetail: null,
            brandTitle: car_info.brandTitle,
            modelTitle: car_info.carModelTitle,
            modelDetailTitle: car_info.carModelDetailTitle,
            color: '',
            carId: car_info.carId,
            Description: car_info.description,
            fromDate: car.FromDate,
            CarToUserStatusConstId: car.CarToUserStatusConstId,
            isAdmin: car.IsAdmin,
            userId: car.UserId,
            imageUrl: carState != null ? carState.carImage : carImgList[indx]);
        carInfos.add(carInfoVM);
        indx++;
      }
    }
  }

  _showCarPairedConfirmActions(int carId, BuildContext context) {
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.70,
        builder: (BuildContext context) {
          return new Container(
            height: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.0, right: 10.0, left: 10.0),
                        child: Button(
                          clr: Colors.pinkAccent,
                          color: Colors.pinkAccent.value,
                          backTransparent: true,
                          wid: 150.0,
                          title: 'تایید درخواست',
                        ),
                      ),
                      onTap: () {
                        if (carsPairedList != null &&
                            carsPairedList.length > 0) {
                          var ppcar = carsPairedList
                              .where((p) => p.SecondCar.carId == carId)
                              .toList();
                          if (ppcar != null && ppcar.length > 0) {
                            ApiPairedCar pairedCar = new ApiPairedCar(
                                PairedCarId: ppcar.first.PairedCarId,
                                MasterCarId: ppcar.first.MasterCar.carId,
                                SecondCarId: ppcar.first.SecondCar.carId,
                                FromDate: DateTimeUtils.getDateNow(),
                                ToDate: null,
                                FromTime: DateTimeUtils.getTimeNow(),
                                ToTime: null,
                                Description: null,
                                IsActive: true,
                                RowStateType: Constants.ROWSTATE_TYPE_UPDATE,
                                CarIds: null,
                                master: null,
                                slaves: null);
                            addCarToPaired(
                                pairedCar, Constants.ROWSTATE_TYPE_UPDATE);
                          }
                          /*if (carsSlavePairedList != null &&
                  carsSlavePairedList.length > 0) {

                var cpaired = carsSlavePairedList.where((c) =>
                c.CarId == car.CarId).toList();
                if (cpaired != null && cpaired.length > 0) {


                }
              }*/
                          // Navigator.pop(context);
                        }
                      },
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.0, right: 10.0, left: 10.0),
                        child: Button(
                          clr: Colors.pinkAccent,
                          color: Colors.pinkAccent.value,
                          backTransparent: true,
                          wid: 150.0,
                          title: 'رد درخواست',
                        ),
                      ),
                      onTap: () {
                        var ppcar = carsPairedList
                            .where((p) => p.SecondCar.carId == carId)
                            .toList();
                        if (ppcar != null && ppcar.length > 0) {
                          ApiPairedCar pairedCar = new ApiPairedCar(
                              PairedCarId: ppcar.first.PairedCarId,
                              MasterCarId: ppcar.first.MasterCar.carId,
                              SecondCarId: ppcar.first.SecondCar.carId,
                              FromDate: ppcar.first.FromDate,
                              ToDate: ppcar.first.ToDate,
                              FromTime: ppcar.first.FromTime,
                              ToTime: ppcar.first.ToTime,
                              Description: null,
                              IsActive: false,
                              RowStateType: Constants.ROWSTATE_TYPE_DELETE,
                              CarIds: null,
                              master: null,
                              slaves: null);
                          addCarToPaired(
                              pairedCar, Constants.ROWSTATE_TYPE_DELETE);
                          // _deleteCarFromPaired(ppcar.first.MasterCar.carId, ppcar.first.SecondCar.carId);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child :Button(clr: Colors.pinkAccent,wid:150.0,title: Translations.current.navigateToCurrent(),),
                      onTap: (){
                        Navigator.pop(context);
                        navigateToCarSelected(0,true, car.CarId,true);
                      },),
                    GestureDetector(
                      child :Button(clr: Colors.pinkAccent,wid:150.0,title: 'محل جاری خودرو',),
                      onTap: (){
                        Navigator.pop(context);
                        navigateToCarSelected(0,true, car.CarId,false);
                      },),
                  ],
                ),*/
              ],
            ),
          );
        });
  }

  Widget createExpanded(List<ApiPairedCar> cars) {
    return Container(
      height: 350.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          String carPelaq = '';
          String model = '';
          String detail = '';
          String brand = '';
          String carColor = '';

          String carPelaq_master = '';
          String model_master = '';
          String detail_master = '';
          String brand_master = '';
          String carColor_master = '';

          if (centerRepository.getCars() != null &&
              centerRepository.getCars().length > 0) {
            var carFound = centerRepository
                .getCars()
                .where((c) => c.carId == cars[index].SecondCar.carId)
                .toList();
            if (carFound != null && carFound.length > 0) {
              Car cr = carFound.first;
              carPelaq = cr.pelaueNumber ?? '';
              model = cr.carModelTitle ?? '';
              detail = cr.carModelDetailTitle ?? '';
              brand = cr.brandTitle ?? '';
              carColor = cr.colorTitle ?? '';
            }
            carFound = centerRepository
                .getCars()
                .where((c) => c.carId == cars[index].MasterCar.carId)
                .toList();
            if (carFound != null && carFound.length > 0) {
              Car cr = carFound.first;
              carPelaq_master = cr.pelaueNumber ?? '';
              model_master = cr.carModelTitle ?? '';
              detail_master = cr.carModelDetailTitle ?? '';
              brand_master = cr.brandTitle ?? '';
              carColor_master = cr.colorTitle ?? '';
            }
          }
          return Card(
            margin: new EdgeInsets.only(
                left: 5.0, right: 5.0, top: 8.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Color(0xffe5e5e5).withOpacity(0.4), width: 0.0),
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 0.0,
            child: GestureDetector(
              onTap: () {
                // _showCarPairedConfirmActions(cars[index].SecondCar.carId, context);
              },
              child: new Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: cars[index].IsActive
                      ? Colors.lightBlue.withOpacity(0.4)
                      : Color(0xffe5e5e5).withOpacity(0.4),
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'درخواست دهنده (شناسه خودرو):',
                            style: HeaderTextStyle,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 5.0),
                            child: Text(
                              cars[index].SecondCar.carId.toString(),
                              style: HeaderTextStyle,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 20.0),
                            child: Text(
                              DartHelper.isNullOrEmptyString(brand),
                              style: HeaderTextStyle,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DartHelper.isNullOrEmptyString(model),
                            style: HeaderTextStyle,
                          ),
                          Text(
                            DartHelper.isNullOrEmptyString(
                                DartHelper.isNullOrEmptyString(detail)),
                            style: HeaderTextStyle,
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Translations.current.carpelak(),
                            style: HeaderTextStyle,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 5.0),
                            child: Text(
                              DartHelper.isNullOrEmptyString(carPelaq),
                              style: HeaderTextStyle,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Translations.current.carcolor(),
                            style: HeaderTextStyle,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 5.0),
                            child: Text(
                              DartHelper.isNullOrEmptyString(carColor),
                              style: HeaderTextStyle,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 0.0,
                      color: Colors.blue.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 20.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  Translations.current.carId(),
                                  style: ContentTextStyle,
                                ),
                                new Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.0, left: 5.0),
                                  child: Text(
                                    cars[index].MasterCar.carId.toString(),
                                    style: ContentTextStyle,
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 20.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.0, left: 20.0),
                                  child: Text(
                                    DartHelper.isNullOrEmptyString(
                                        brand_master),
                                    style: ContentTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 20.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  DartHelper.isNullOrEmptyString(model_master),
                                  style: ContentTextStyle,
                                ),
                                Text(
                                  DartHelper.isNullOrEmptyString(
                                      DartHelper.isNullOrEmptyString(
                                          detail_master)),
                                  style: ContentTextStyle,
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 20.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  Translations.current.carpelak(),
                                  style: ContentTextStyle,
                                ),
                                new Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.0, left: 5.0),
                                  child: Text(
                                    DartHelper.isNullOrEmptyString(
                                        carPelaq_master),
                                    style: ContentTextStyle,
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 20.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  Translations.current.carcolor(),
                                  style: ContentTextStyle,
                                ),
                                new Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.0, left: 5.0),
                                  child: Text(
                                    DartHelper.isNullOrEmptyString(
                                        carColor_master),
                                    style: ContentTextStyle,
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 20.0, right: 10.0, left: 10.0),
                            child: Button(
                              clr: Colors.pinkAccent,
                              color: Colors.pinkAccent.value,
                              backTransparent: true,
                              wid: 150.0,
                              title: 'تایید درخواست',
                            ),
                          ),
                          onTap: () {
                            if (!cars[index].IsActive) {
                              if (carsPairedList != null &&
                                  carsPairedList.length > 0) {
                                var ppcar = carsPairedList
                                    .where((p) =>
                                        p.SecondCar.carId ==
                                        cars[index].SecondCar.carId)
                                    .toList();
                                if (ppcar != null && ppcar.length > 0) {
                                  ApiPairedCar pairedCar = new ApiPairedCar(
                                      PairedCarId: ppcar.first.PairedCarId,
                                      MasterCarId: ppcar.first.MasterCar.carId,
                                      SecondCarId: ppcar.first.SecondCar.carId,
                                      FromDate: DateTimeUtils.getDateNow(),
                                      ToDate: null,
                                      FromTime: DateTimeUtils.getTimeNow(),
                                      ToTime: null,
                                      Description: null,
                                      IsActive: true,
                                      RowStateType:
                                          Constants.ROWSTATE_TYPE_UPDATE,
                                      CarIds: null,
                                      master: null,
                                      slaves: null);
                                  addCarToPaired(pairedCar,
                                      Constants.ROWSTATE_TYPE_UPDATE);
                                }
                                /*if (carsSlavePairedList != null &&
                  carsSlavePairedList.length > 0) {

                var cpaired = carsSlavePairedList.where((c) =>
                c.CarId == car.CarId).toList();
                if (cpaired != null && cpaired.length > 0) {


                }
              }*/
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 20.0, right: 10.0, left: 10.0),
                            child: Button(
                              clr: Colors.pinkAccent,
                              wid: 150.0,
                              color: Colors.pinkAccent.value,
                              backTransparent: true,
                              title: 'رد درخواست',
                            ),
                          ),
                          onTap: () {
                            var ppcar = carsPairedList
                                .where((p) =>
                                    p.SecondCar.carId ==
                                    cars[index].SecondCar.carId)
                                .toList();
                            if (ppcar != null && ppcar.length > 0) {
                              // _deleteCarFromPaired(ppcar.first.MasterCar.carId, ppcar.first.SecondCar.carId);
                              ApiPairedCar pairedCar = new ApiPairedCar(
                                  PairedCarId: ppcar.first.PairedCarId,
                                  MasterCarId: ppcar.first.MasterCar.carId,
                                  SecondCarId: ppcar.first.SecondCar.carId,
                                  FromDate: DateTimeUtils.getDateNow(),
                                  ToDate: ppcar.first.ToDate,
                                  FromTime: DateTimeUtils.getTimeNow(),
                                  ToTime: ppcar.first.ToTime,
                                  Description: null,
                                  IsActive: false,
                                  RowStateType: Constants.ROWSTATE_TYPE_DELETE,
                                  CarIds: null,
                                  master: null,
                                  slaves: null);
                              addCarToPaired(
                                  pairedCar, Constants.ROWSTATE_TYPE_DELETE);
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),

                    /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child :Button(clr: Colors.pinkAccent,wid:150.0,title: Translations.current.navigateToCurrent(),),
                      onTap: (){
                        Navigator.pop(context);
                        navigateToCarSelected(0,true, car.CarId,true);
                      },),
                    GestureDetector(
                      child :Button(clr: Colors.pinkAccent,wid:150.0,title: 'محل جاری خودرو',),
                      onTap: (){
                        Navigator.pop(context);
                        navigateToCarSelected(0,true, car.CarId,false);
                      },),
                  ],
                ),*/
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  showSpeedDialog(int speed) async {
    FlashHelper.informationBar2(context,
        message: ' سرعت خودرو در این نقطه :' + speed.toString() + 'km/h',
        duration: new Duration(milliseconds: 5000));
  }

  Future<void> processData() async {
    final geojson = GeoJson();
    geojson.processedMultipolygons.listen((GeoJsonMultiPolygon multiPolygon) {
      for (final polygon in multiPolygon.polygons) {
        final geoSerie = GeoSerie(
            type: GeoSerieType.polygon,
            name: polygon.geoSeries[0].name,
            geoPoints: <GeoPoint>[]);
        for (final serie in polygon.geoSeries) {
          geoSerie.geoPoints.addAll(serie.geoPoints);
        }
        final color =
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                .withOpacity(0.3);
        final poly = Polygon(
            points: geoSerie.toLatLng(ignoreErrors: true), color: color);
        setState(() => polygons.add(poly));
      }
    });
    geojson.endSignal.listen((bool _) => geojson.dispose());
    final data = await rootBundle.loadString('assets/images/test.geojson');
    final nameProperty = "ADMIN";
    unawaited(geojson.parse(data, nameProperty: nameProperty, verbose: true));
  }

  Future<List<Polyline>> processLineData(
      bool fromCurrent,
      String clat,
      String clng,
      String fromDate,
      String toDate,
      bool forReport,
      bool anim,
      bool fromGo) async {
    List<LatLng> geoSeries = new List();

    String routType = Constants.routingTypeMap[RoutingType.DRIVING];
    int rout =
        await prefRepository.getRoutingType(CenterRepository.ROUTING_TYPE_TAG);
    if (rout == 1) routType = Constants.routingTypeMap[RoutingType.AIR];
    if (rout == 2) routType = Constants.routingTypeMap[RoutingType.DRIVING];
    if (rout == 3) routType = Constants.routingTypeMap[RoutingType.WALKING];

    String tdate = DateTimeUtils.convertIntoDateTimeWithTime(
        DateTimeUtils.getDateJalali(), 0, 0);
    String sdate = DateTimeUtils.convertIntoDateTimeWithTime(
        DateTimeUtils.getDateJalaliWithAddDays(0), 23, 59);

    ApiRoute route = new ApiRoute(
        carId: lastCarIdSelected,
        startDate: forReport
            ? DateTimeUtils.convertIntoDate(
                fromDate) //DateTimeUtils.convertIntoDateTimeWithTime(fromDate, 0, 0)
            : sdate,
        endDate: forReport
            ? DateTimeUtils.convertIntoDate(
                toDate) //DateTimeUtils.convertIntoDateTimeWithTime(toDate, 23, 59)
            : tdate,
        dateTime: null,
        speed: null,
        lat: null,
        long: null,
        enterTime: null,
        carIds: null,
        DeviceId: null,
        Latitude: null,
        Longitude: null,
        Date: null,
        Time: null,
        CreatedDateTime: null);

    centerRepository.showProgressDialog(
        context, Translations.current.loadingdata());
    var queryBody = '{"coordinates":['; //$lng2,$lat2],[$lng1,$lat1]]}';
    if (!fromCurrent) {
      final pointDatas = await restDatasource.getRouteList(route);
      if (pointDatas != null && pointDatas.length > 0) {
        if (markers != null && markers.length > 0) {
          markers.clear();
        }
        var points = '';
        int index = pointDatas.length - 1;

        String latStr1 = pointDatas[0].lat;
        String lngStr1 = pointDatas[0].long;
        var firstLat = latStr1.split('*');
        var firstLng = lngStr1.split('*');
        var secondLat = firstLat[1].split("'");
        var secondLng = firstLng[1].split("'");

        double fresultLatLng = ConvertDegreeAngleToDouble(
            double.tryParse(firstLat[0]),
            double.tryParse(secondLat[0]),
            double.tryParse(secondLat[1]));

        double sresultLatLng = ConvertDegreeAngleToDouble(
            double.tryParse(firstLng[0]),
            double.tryParse(secondLng[0]),
            double.tryParse(secondLng[1]));

        firstPoint = LatLng(fresultLatLng, sresultLatLng);
        points += '[$sresultLatLng,$fresultLatLng],';

        var marker = Marker(
            width: markerSize + 28,
            height: markerSize + 28,
            point: firstPoint,
            builder: (ctx) {
              return GestureDetector(
                onTap: () {
                  _showInfoPopUp = true;
                  showSpeedDialog(0);
                },
                child: Container(
                    width: markerSize + 28,
                    height: markerSize + 28,
                    child: CircleAvatar(
                      radius: markerSize + 28,
                      backgroundColor: Colors.transparent,
                      child:
                          Image.asset(markerStart, key: ObjectKey(Colors.red)),
                    )),
              );
            });
        markers..add(marker);
        //////////////////////////////////
        minStopTime = '';
        minStopTime2 = '';
        minStopDate = '';
        minStopDate2 = '';

        //////////////////////

        int firstIndex = 0;
        int nextIndex = 0;
        double div = (index + 1) / 29;
        if (index < 29) {
          div = 1;
        }
        if (minDelay == null) minDelay = 0;
        geoSeries..add(firstPoint);
        for (var i = 1; i < pointDatas.length - 1; i++) {
          int diff = 0;
          firstIndex = i;
          String latStr2 = pointDatas[i].lat;
          String lngStr2 = pointDatas[i].long;
          var firstLat1 = latStr2.split('*');
          var firstLng1 = lngStr2.split('*');
          var secondLat1 = firstLat1[1].split("'");
          var secondLng1 = firstLng1[1].split("'");

          double fresultLatLng1 = ConvertDegreeAngleToDouble(
              double.tryParse(firstLat1[0]),
              double.tryParse(secondLat1[0]),
              double.tryParse(secondLat1[1]));

          double sresultLatLng1 = ConvertDegreeAngleToDouble(
              double.tryParse(firstLng1[0]),
              double.tryParse(secondLng1[0]),
              double.tryParse(secondLng1[1]));

          double lat = fresultLatLng1;
          double lng = sresultLatLng1;
          int speed = pointDatas[i].speed;
          if (speed == null) speed = 0;

          if (i < index) {
            firstIndex = i;
            nextIndex = firstIndex + 1;
          }

          minStopDate = pointDatas[firstIndex].dateTime;
          minStopTime = pointDatas[firstIndex].enterTime;

          minStopDate2 = pointDatas[nextIndex].dateTime;
          minStopTime2 = pointDatas[nextIndex].enterTime;

          var time1 = minStopTime.split(':');
          var time2 = minStopTime2.split(':');
          /* int h1=int.tryParse(time1[0]);
              int m1=int.tryParse(time1[1]);
              int s1=int.tryParse(time1[2]);

              int h2=int.tryParse(time2[0]);
              int m2=int.tryParse(time2[1]);
              int s2=int.tryParse(time2[2]);*/

          minStopDate = minStopDate.replaceAll('/', '');
          minStopDate2 = minStopDate2.replaceAll('/', '');

          if (minStopDate.trim() == minStopDate2.trim()) {
            diff = DateTimeUtils.diffMinsFromDateToDate4(
                DateTimeUtils.convertIntoTimeOnly(minStopTime2),
                DateTimeUtils.convertIntoTimeOnly(minStopTime));

            //حداکثر فاصله زمانی دو دقیقه
            if (diff >= 1) {
              if (speed > 5) {
                double x = speed * (diff / 60);
                if (x > 50) {
                  points += '[$lng,$lat],';
                }
              }
            } else {
              if (speed > 5) {
                // double x=speed*(diff / 60);
                // if(x>50) {
                if ((i % div.floor()) == 0) points += '[$lng,$lat],';
                //}
              }
            }
          }

          var marker = Marker(
              width: markerSize,
              height: markerSize,
              point: LatLng(lat, lng),
              builder: (ctx) {
                return GestureDetector(
                  onTap: () {
                    _showInfoPopUp = true;
                    showSpeedDialog(speed);
                  },
                  child: Container(
                      width: markerSize,
                      height: markerSize,
                      child: CircleAvatar(
                        radius: markerSize,
                        backgroundColor: Colors.transparent,
                        child: getMarkerOnSpeed(speed, diff),
                      )),
                );
              });

          if (((speed <= minSpeed && showMinSpeedMarkers) ||
              (speed >= maxSpeed && showMaxSpeedMarkers) ||
              (diff >= minDelay && showStopSpeedMarkers))) markers.add(marker);

          if (routType == Constants.routingTypeMap[RoutingType.AIR]) {
            geoSeries..add(new LatLng(lat, lng));
          }
        }

        latStr1 = pointDatas[index].lat;
        lngStr1 = pointDatas[index].long;
        firstLat = latStr1.split('*');
        firstLng = lngStr1.split('*');
        secondLat = firstLat[1].split("'");
        secondLng = firstLng[1].split("'");

        fresultLatLng = ConvertDegreeAngleToDouble(double.tryParse(firstLat[0]),
            double.tryParse(secondLat[0]), double.tryParse(secondLat[1]));

        sresultLatLng = ConvertDegreeAngleToDouble(double.tryParse(firstLng[0]),
            double.tryParse(secondLng[0]), double.tryParse(secondLng[1]));

        points += '[$sresultLatLng,$fresultLatLng]';

        int speed = pointDatas[index].speed;
        if (speed == null) speed = 0;

        marker = Marker(
            width: markerSize + 28,
            height: markerSize + 28,
            point: LatLng(fresultLatLng, sresultLatLng),
            builder: (ctx) {
              return GestureDetector(
                onTap: () {
                  _showInfoPopUp = true;
                  showSpeedDialog(speed);
                },
                child: Container(
                    width: markerSize + 28,
                    height: markerSize + 28,
                    child: CircleAvatar(
                      radius: markerSize + 28,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(markerEnd, key: ObjectKey(Colors.red)),
                    )),
              );
            });
        markers..add(marker);
        if (points.endsWith(',')) {
          points = points.substring(0, points.length - 1);
        }

        queryBody = queryBody + points + ']}';
        hasPoint = true;
        geoSeries..add(LatLng(fresultLatLng, sresultLatLng));
      } else {
        hasPoint = false;
        /*var points = '';
        double lat = 35.7511447;
        double lng = 51.4716509 ;
        firstPoint = LatLng(lat,lng);
        double lat2 = 35.796249;
        double lng2 = 51.427583 ;

        points += '[$lng,$lat],';
        points += '[$lng2,$lat2]';

        queryBody = queryBody + points + ']}';*/

      }
    } else {
      double speed = 80;
      if (currentLocation == null) {
        await getLocationForRoute();
      }
      if (currentLocation != null) {
        double lat1 = double.tryParse(clat);
        double lng1 = double.tryParse(clng);
        firstPoint = LatLng(lat1, lng1);
        if (clat == null || clat.isEmpty || clng == null || clng.isEmpty) {
          lat1 = 35.7511447;
          lng1 = 51.4716509;
        }

        double lat2 = double.tryParse(currentLocation.latitude.toString());
        double lng2 = double.tryParse(currentLocation.longitude.toString());
        speed = currentLocation.speed;
        if (speed == null) speed = 0;
        if (currentCarLocationSpeed == null || currentCarLocationSpeed == 0)
          currentCarLocationSpeed = 0;
        var marker = Marker(
            width: markerSize,
            height: markerSize,
            point: LatLng(lat1, lng1),
            builder: (ctx) {
              return GestureDetector(
                onTap: () {
                  _showInfoPopUp = true;
                  showSpeedDialog(
                      int.tryParse(currentCarLocationSpeed.toString()));
                },
                child: Container(
                    width: markerSize,
                    height: markerSize,
                    child: CircleAvatar(
                      radius: markerSize,
                      backgroundColor: Colors.transparent,
                      child: getMarkerOnSpeed(
                          int.tryParse(currentCarLocationSpeed.toString()), 0),
                    )),
              );
            });

        markers.add(marker);

        marker = Marker(
            width: markerSize,
            height: markerSize,
            point: LatLng(lat2, lng2),
            builder: (ctx) {
              return GestureDetector(
                onTap: () {
                  _showInfoPopUp = true;
                  showSpeedDialog(int.tryParse(speed.toString()));
                },
                child: Container(
                    width: markerSize,
                    height: markerSize,
                    child: CircleAvatar(
                      radius: markerSize,
                      backgroundColor: Colors.transparent,
                      child:
                          getMarkerOnSpeed(int.tryParse(speed.toString()), 0),
                    )),
              );
            });

        markers.add(marker);
        queryBody = '{"coordinates":[[$lng2,$lat2],[$lng1,$lat1]]}';
        hasPoint = true;
      } else {
        centerRepository.showFancyToast(
            Translations.current.yourLocationNotFound(), false);
      }
    }
    if (lines != null && lines.length > 0) {
      lines.clear();
    }
    if (hasPoint) {
      // String routType='';

      if (routType == Constants.routingTypeMap[RoutingType.AIR]) {
        final color = Colors.blueAccent.withOpacity(0.7);
        lines.add(Polyline(strokeWidth: 8.0, color: color, points: geoSeries));
      } else {
        if (fromGo) {
          routType = Constants.routingTypeMap[RoutingType.WALKING];
        } else {
          /* int rout= await  prefRepository.getRoutingType(CenterRepository.ROUTING_TYPE_TAG);
            if(rout==1)
              routType=Constants.routingTypeMap[RoutingType.AIR];
            if(rout==2)
              routType=Constants.routingTypeMap[RoutingType.DRIVING];
            if(rout==3)
              routType=Constants.routingTypeMap[RoutingType.WALKING];*/

        }
        final openRoutegeoJSON = await restDatasource
            .fetchOpenRouteServiceURlJSON(body: queryBody, routeType: routType);
        if (openRoutegeoJSON != null) {
          final geojson = GeoJson();
          geojson.processedLines.listen((GeoJsonLine line) {
            final color = Colors.blueAccent.withOpacity(0.7);
            lines.add(Polyline(
                strokeWidth: 8.0,
                color: color,
                points: line.geoSerie.toLatLng()));
          });
          geojson.endSignal.listen((_) {
            geojson.dispose();
          });
          // unawaited(geojson.parse(data, verbose: true));
          await geojson.parse(openRoutegeoJSON, verbose: true);
        }
      }
      if (lines != null && lines.length > 0) {
        // moreButtonNoty.updateValue(new Message(type:'CLOSE_MORE_BUTTON'));
        if (!fromGo) {
          RxBus.post(new ChangeEvent(type: 'CLOSE_MORE_BUTTON'));
        }
        if (!kIsWeb) {
          liveMapController.mapController.move(firstPoint, 15);
        } else {
          mapController.move(firstPoint, 15);
        }
        return lines;
      }
    } else {
      centerRepository.showFancyToast('اطلاعاتی یافت نشد', false);
    }

    return null;
  }

  Future<List<Marker>> processLineDataForReportMinTime(
      String fromDat, String toDat, String minTime) async {
    String tdate =
        DateTimeUtils.convertIntoDateTime(DateTimeUtils.getDateJalali());
    String sdate = DateTimeUtils.convertIntoDateTime(
        DateTimeUtils.getDateJalaliWithAddDays(0));

    ApiRoute route = new ApiRoute(
        carId: lastCarIdSelected,
        startDate: (fromDat != null && fromDat.isNotEmpty)
            ? DateTimeUtils.convertIntoDateTime(fromDat)
            : sdate,
        endDate: (toDat != null && toDat.isNotEmpty)
            ? DateTimeUtils.convertIntoDateTime(toDat)
            : tdate,
        dateTime: null,
        speed: null,
        lat: null,
        long: null,
        enterTime: null,
        carIds: null,
        DeviceId: null,
        Latitude: null,
        Longitude: null,
        Date: null,
        Time: null,
        CreatedDateTime: null);

    if (minDelay == null) {
      minDelay = 30;
    }
    centerRepository.showProgressDialog(
        context, Translations.current.loadingdata());
    var queryBody = '{"coordinates":['; //$lng2,$lat2],[$lng1,$lat1]]}';

    final pointDatas = await restDatasource.getRouteList(route);
    if (pointDatas != null && pointDatas.length > 0) {
      hasPoint = true;
      if (markers != null && markers.length > 0) markers.clear();
      minStopTime = '';
      minStopTime2 = '';
      minStopDate = '';
      minStopDate2 = '';

      var points = '';
      int index = pointDatas.length - 1;

      String latStr1 = pointDatas[0].lat;
      String lngStr1 = pointDatas[0].long;
      var firstLat = latStr1.split('*');
      var firstLng = lngStr1.split('*');
      var secondLat = firstLat[1].split("'");
      var secondLng = firstLng[1].split("'");

      double fresultLatLng = ConvertDegreeAngleToDouble(
          double.tryParse(firstLat[0]),
          double.tryParse(secondLat[0]),
          double.tryParse(secondLat[1]));

      double sresultLatLng = ConvertDegreeAngleToDouble(
          double.tryParse(firstLng[0]),
          double.tryParse(secondLng[0]),
          double.tryParse(secondLng[1]));

      firstPoint = LatLng(fresultLatLng, sresultLatLng);
      for (var i = 0; i < pointDatas.length; i++) {
        String latStr2 = pointDatas[i].lat;
        String lngStr2 = pointDatas[i].long;
        var firstLat1 = latStr2.split('*');
        var firstLng1 = lngStr2.split('*');
        var secondLat1 = firstLat1[1].split("'");
        var secondLng1 = firstLng1[1].split("'");

        double fresultLatLng1 = ConvertDegreeAngleToDouble(
            double.tryParse(firstLat1[0]),
            double.tryParse(secondLat1[0]),
            double.tryParse(secondLat1[1]));

        double sresultLatLng1 = ConvertDegreeAngleToDouble(
            double.tryParse(firstLng1[0]),
            double.tryParse(secondLng1[0]),
            double.tryParse(secondLng1[1]));

        double lat = fresultLatLng1;
        double lng = sresultLatLng1;
        if (i < pointDatas.length - 1) {
          latStr2 = pointDatas[i + 1].lat;
          lngStr2 = pointDatas[i + 1].long;

          firstLat1 = latStr2.split('*');
          firstLng1 = lngStr2.split('*');
          secondLat1 = firstLat1[1].split("'");
          secondLng1 = firstLng1[1].split("'");

          fresultLatLng1 = ConvertDegreeAngleToDouble(
              double.tryParse(firstLat1[0]),
              double.tryParse(secondLat1[0]),
              double.tryParse(secondLat1[1]));

          sresultLatLng1 = ConvertDegreeAngleToDouble(
              double.tryParse(firstLng1[0]),
              double.tryParse(secondLng1[0]),
              double.tryParse(secondLng1[1]));

          double lat2 = fresultLatLng1;
          double lng2 = sresultLatLng1;

          /*  double lat2 = double.tryParse(pointDatas[i + 1].lat);
            double lng2 = double.tryParse(pointDatas[i + 1].lat);
*/
          int speed = pointDatas[i].speed;
          if (speed == null) speed = 0;
          if (i < index)
            points += '[$lng,$lat],';
          else
            points += '[$lng,$lat]';
          //points..add(item);
          final Distance distance = new Distance();

          if (speed < 1 && (minStopTime == null || minStopTime.isEmpty)) {
            minStopDate = pointDatas[i].dateTime;
            minStopTime = pointDatas[i].enterTime;
          } else if (speed > 1 &&
              (minStopTime != null && minStopTime.isNotEmpty)) {
            minStopDate2 = pointDatas[i].dateTime;
            minStopTime2 = pointDatas[i].enterTime;

            var time1 = minStopTime.split(':');
            var time2 = minStopTime2.split(':');
            /* int h1=int.tryParse(time1[0]);
              int m1=int.tryParse(time1[1]);
              int s1=int.tryParse(time1[2]);

              int h2=int.tryParse(time2[0]);
              int m2=int.tryParse(time2[1]);
              int s2=int.tryParse(time2[2]);*/

            minStopDate = minStopDate.replaceAll('/', '');
            minStopDate2 = minStopDate2.replaceAll('/', '');
            if (minStopDate.trim() == minStopDate2.trim()) {
              int diff = DateTimeUtils.diffMinsFromDateToDate4(
                  DateTimeUtils.convertIntoTimeOnly(minStopTime2),
                  DateTimeUtils.convertIntoTimeOnly(minStopTime));
              if (diff > minDelay) {
                var marker = Marker(
                    width: markerSize,
                    height: markerSize,
                    point: LatLng(lat, lng),
                    builder: (ctx) {
                      return GestureDetector(
                        onTap: () {
                          showSpeedDialog(speed);
                        },
                        child: Container(
                          width: markerSize,
                          height: markerSize,
                          child: CircleAvatar(
                            radius: markerSize,
                            backgroundColor: Colors.transparent,
                            child: getMarkerOnSpeed(speed, diff),
                          ),
                        ),
                      );
                    });

                if (speed <= maxSpeed && speed >= minSpeed) {
                  markers.add(marker);
                }
                if (speed <= 1) {
                  marker = Marker(
                      width: markerSize,
                      height: markerSize,
                      point: LatLng(lat2, lng2),
                      builder: (ctx) {
                        return GestureDetector(
                          onTap: () {
                            showSpeedDialog(speed);
                          },
                          child: Container(
                              width: markerSize,
                              height: markerSize,
                              child: CircleAvatar(
                                  radius: markerSize,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    markerPark,
                                    key: ObjectKey(Colors.green),
                                  ))),
                        );
                      });
                  //if(showSpeedMarkers)
                  markers.add(marker);
                }
                minStopTime = '';
              }
            }
          }
        }
      }

      queryBody = queryBody + points + ']}';
    } else {
      hasPoint = false;
      /*  var points = '';
        double lat = 35.7511447;
        double lng = 51.4716509 ;
        firstPoint = LatLng(lat,lng);
        double lat2 = 35.796249;
        double lng2 = 51.427583 ;

        points += '[$lng,$lat],';
        points += '[$lng2,$lat2]';
        queryBody = queryBody + points + ']}';*/

    }

    if (markers != null && markers.length > 0) {
      if (firstPoint.longitude != markers[0].point.latitude &&
          firstPoint.longitude != markers[0].point.longitude) {
        firstPoint = markers[0].point;
      }
      // moreButtonNoty.updateValue(new Message(type: 'CLOSE_MORE_BUTTON'));
      RxBus.post(new ChangeEvent(type: 'CLOSE_MORE_BUTTON'));

      if (!kIsWeb) {
        liveMapController.mapController.move(firstPoint, 15);
      } else {
        mapController.move(firstPoint, 15);
      }
      reportNoty.updateValue(new Message(type: 'HAS_MARKERS'));

      return markers;
    } else {
      centerRepository.showFancyToast('اطلاعاتی یافت نشد', false);
    }
    return null;
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(popmenu.MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
    menu.dismiss();
    if (item.menuTitle == 'راهنما') _showBottomSheetGuid(context);
    if (item.menuTitle == 'تنظیمات') _showBottomSheetSettings(context);
    if (item.menuTitle == 'جستجو') _showBottomSheetSearchCarForJoin(context);
    if (item.menuTitle == 'درخواست') showLastCarJoint(context);
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  Future<void> _initLastKnownLocation() async {
    //locator.Position position;
    loc.LocationData position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      //final locator.Geolocator geolocator = locator.Geolocator();
      await _getLocation();
      if (_locationData != null) {
        position = _locationData;
      }
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    _lastKnownPosition = position;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() async {
    await _getLocation();

    if (_locationData != null) {
      currentLocation = getLocationDataFromPosition(_locationData);
    }

    _currentPosition = _locationData;

    if (_locationData != null) {
      currentLocation = LocationDataLocator.fromMap({
        'latitude': _locationData.latitude,
        'longitude': _locationData.longitude,
        'speed': _locationData.speed,
        'accuracy': _locationData.accuracy,
        'altitude': _locationData.altitude,
        'speedAccuracy': _locationData.speedAccuracy
      });
      mapController.move(
          LatLng(_locationData.latitude, _locationData.longitude), 16);
    }
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    //setState(() {
    _lastKnownPosition = null;
    _currentPosition = null;
    // });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }

  getLocationDataFromPosition(loc.LocationData position) {
    LocationDataLocator _location;
    if (position != null) {
      _location = LocationDataLocator.fromMap({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'speed': position.speed,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speedAccuracy': position.speedAccuracy
      });
      return _location;
    }
    return null;
  }

  mapLocationData(loc.LocationData position) {
    LocationDataLocator _location;
    if (position != null) {
      _location = LocationDataLocator.fromMap({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'speed': position.speed,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speedAccuracy': position.speedAccuracy
      });
      return _location;
    }
    return null;
  }

  showGPSAlertDialog(BuildContext context) async {
    await animated_dialog_box.showScaleAlertBox(
        title: Center(child: Text('هشدار!')),
        context: context,
        firstButton: Builder(
          builder: (contxt) {
            return MaterialButton(
              // FIRST BUTTON IS REQUIRED
              elevation: 0.0,
              focusColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: Colors.redAccent,
              child: Text('باشه'),
              onPressed: () {
                CenterRepository.isFromMapForGPSCheckForFirstTime = false;
                Navigator.pop(contxt);
              },
            );
          },
        ),
        secondButton: null,
        icon: Icon(
          Icons.info_outline,
          color: Colors.red,
        ),
        // IF YOU WANT TO ADD ICON
        yourWidget: Container(
          child: Text('GPS  دستگاه شما خاموش و یا غیرفعال می باشد.بررسی کنید'),
        ));
  }

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      _locationSubscription.cancel();
    }).listen((loc.LocationData currentLocation) {
      _locationData = currentLocation;
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

  @override
  void initState() {
    registerRxBus();

    Constants.createRouteTypeMap();
    Constants.createCarImageInColorMap();
    getDefaultSettingsValues();
    //geolocator = locator.Geolocator();
    menu = popmenu.PopupMenu(
      items: [
        popmenu.MenuItem(
            title: 'راهنما',
            image: Icon(
              Icons.help_outline,
              color: Colors.white,
            )),
        popmenu.MenuItem(
            title: 'درخواست',
            image: Icon(
              Icons.compare_arrows,
              color: Colors.white,
            )),
        popmenu.MenuItem(
            title: 'جستجو',
            image: Icon(
              Icons.search,
              color: Colors.white,
            )),
        popmenu.MenuItem(
            title: 'تنظیمات',
            image: Icon(
              Icons.settings,
              color: Colors.white,
            ))
      ],
      onClickMenu: onClickMenu,
      onDismiss: onDismiss, /* maxColumn: 4*/
    );

    getUserId();
    if (!kIsWeb) {
      getPeriodicTimePosition();
    }
    currentMarker = Marker(
        width: markerSize + 28,
        height: markerSize + 28,
        point: LatLng(35.696811, 51.3748819),
        builder: (ctx) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: markerSize + 28,
              height: markerSize + 28,
              child: CircleAvatar(
                radius: markerSize + 28,
                backgroundColor: Colors.transparent,
                child: Image.asset('assets/images/location.png',
                    color: Colors.indigoAccent, key: ObjectKey(Colors.red)),
              ),
            ),
          );
        });
    mapController = new MapController();
    reportNoty = new NotyBloc<Message>();
    reportDateNoty = new NotyBloc<Message>();
    pairedChangedNoty = new NotyBloc<Message>();
    animateNoty = new NotyBloc<Message>();
    statusNoty = new NotyBloc<Message>();
    changedCheckBoxNoty = new NotyBloc<Message>();
    changedRoutRadioBoxNoty = new NotyBloc<Message>();
    showAllItemsdNoty = NotyBloc<Message>();
    showAllItemsdNoty2 = NotyBloc<Message>();

    pcarsPairedActivated = List();
    carInfoss = getCarInfo(false);

    if (!kIsWeb) {
      liveMapController = LiveMapController(
        autoCenter: true,
        mapController: mapController,
        verbose: true,
        autoRotate: true,
        positionStreamEnabled: true,
        updateTimeInterval: 1,
        updateDistanceFilter: 1,
      );
      liveMapController.onReady.then((_) {
        _myzoom = liveMapController.zoom;
        _changefeed = liveMapController.changeFeed.listen((change) {
          if (change.name == "zoom") {
            print("New zoom value: ${change.value}");
          }
        });
      });
    } else {}
    _listenLocation();

    //gpsStatus = checkGPSStatus();

    // geolocator.getPositionStream().listen((event) {});
    markerlocationStream.stream.asBroadcastStream().listen((onData) {
      print(onData.latitude);
    });
    userLocationOptions = UserLocationOptions(
        context: context,
        mapController:
            !kIsWeb ? liveMapController.mapController : mapController,
        markers: markers,
        onLocationUpdate: (LatLng pos) {
          print("onLocationUpdate ${pos.toString()}");
          // mapController.move(pos, 17.0);
          // liveMapController.mapController.move(pos, 14);
        },
        updateMapLocationOnPositionChange: true,
        showMoveToCurrentLocationFloatingActionButton: true,
        zoomToCurrentLocationOnLoad: true,
        //showHeading: true,
        fabBottom: 90,
        fabRight: 20,
        verbose: true);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkService().then((value) {
        if (_serviceEnabled == null || !_serviceEnabled) {
          CenterRepository.isFromMapForGPSCheckForFirstTime = true;
          showGPSAlertDialog(context);
        } else {
          animateToCurrentLocation();
          CenterRepository.GPS_STATUS = true;
          CenterRepository.GPS_STATUS_CONFIRMED = true;
          if (widget.mapVM != null &&
              widget.mapVM.forReport != null &&
              widget.mapVM.forReport &&
              (CenterRepository.GPS_STATUS ||
                  CenterRepository.GPS_STATUS_CONFIRMED)) {
            lines2 = processLineData(false, '', '', widget.mapVM.fromDate,
                widget.mapVM.toDate, widget.mapVM.forReport, false, false);
          }
          if (carInfos != null &&
              carInfos.isNotEmpty &&
              (CenterRepository.GPS_STATUS ||
                  CenterRepository.GPS_STATUS_CONFIRMED)) {
            navigateToCarSelected(
                0, false, carInfos[0].carId, true, false, false);
          }
        }
      });
    });
  }

  _onConfirmDefaultSettings(String type, BuildContext context) async {
    _formKey.currentState.save();

    prefRepository.setMinMaxSpeed(MIN_SPEED_TAG, minSpeed);
    prefRepository.setMinMaxSpeed(MAX_SPEED_TAG, maxSpeed);
    centerRepository.showFancyToast('اطلاعات با موفقیت ذخیره شد.', true);

    Navigator.pop(context);
  }

  _showDefaultSettingsSheet(BuildContext context, String type) {
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.90,
        builder: (BuildContext context) {
          return Builder(
            builder: (context) {
              return Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 450.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 150.0,
                            height: 50.0,
                            child: _buildMaxTextField(
                                Translations.current.maxSpeed(),
                                80.0,
                                maxSpeed.toString()),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 150.0,
                            height: 50.0,
                            child: _buildMinTextField(
                                Translations.current.minSpeed(),
                                80.0,
                                minSpeed.toString()),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FlatButton(
                            onPressed: () {
                              _onConfirmDefaultSettings(type, context);
                            },
                            child: Button(
                              title: Translations.current.confirm(),
                              wid: 120.0,
                              clr: Colors.green,
                              color: Colors.green.value,
                              backTransparent: true,
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _buildMinDelayTextField(String hint, double width, String result) {
    if (minDelay == null) minDelay = 0;
    return TextFormField(
      initialValue: minDelay.toString(),
      decoration: InputDecoration(
        labelText: hint,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        return null;
      },
      onSaved: (value) {
        minDelay = int.tryParse(value == null ? '0' : value);
      },
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      style: TextStyle(
        fontFamily: "IranSans",
      ),
      onFieldSubmitted: (value) {},
    );
  }

  Widget _buildShowSpeedMarkers(String hint, double width) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Checkbox(
            value: showMinSpeedMarkers,
            onChanged: (value) {
              showMinSpeedMarkers = value;
              changedCheckBoxNoty
                  .updateValue(new Message(type: 'CHECKED_CHANGED'));
            }),
        new Text(
          'نمایش نقاط حداقل',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildShowMaxSpeedMarkers(String hint, double width) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Checkbox(
            value: showMaxSpeedMarkers,
            onChanged: (value) {
              showMaxSpeedMarkers = value;
              changedCheckBoxNoty
                  .updateValue(new Message(type: 'CHECKED_CHANGED'));
            }),
        new Text(
          'نمایش نقاط حداکثر',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildShowSpeedStopMarkers(String hint, double width) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Checkbox(
            value: showStopSpeedMarkers,
            onChanged: (value) {
              showStopSpeedMarkers = value;
              changedCheckBoxNoty
                  .updateValue(new Message(type: 'CHECKED_CHANGED'));
            }),
        new Text(
          'نمایش نقاط توقف',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildShowAirRouting(String hint, double width) {
    bool selected = showSelectedRoutingIndex == 0 ? true : false;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
            value: selected,
            onChanged: (value) {
              if (value) showSelectedRoutingIndex = 0;
              changedRoutRadioBoxNoty
                  .updateValue(new Message(type: 'CHECKED_CHANGED'));
            }),
        new Text(
          'نمایش بصورت هوایی',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildShowEarthRouting(String hint, double width) {
    bool selected = showSelectedRoutingIndex == 1 ? true : false;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
            value: selected,
            onChanged: (value) {
              if (value) showSelectedRoutingIndex = 1;
              changedRoutRadioBoxNoty
                  .updateValue(new Message(type: 'CHECKED_CHANGED'));
            }),
        new Text(
          'نمایش بصورت زمینی',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildShowFootRouting(String hint, double width) {
    bool selected = showSelectedRoutingIndex == 2 ? true : false;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
            value: selected,
            onChanged: (value) {
              if (value) showSelectedRoutingIndex = 2;
              changedRoutRadioBoxNoty
                  .updateValue(new Message(type: 'CHECKED_CHANGED'));
            }),
        new Text(
          'نمایش بصورت پیاده',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildShowSpeedSimulateMarkers(String hint, double width) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Checkbox(
            value: showSimulateSpeedMarkers,
            onChanged: (value) {
              showSimulateSpeedMarkers = value;
              changedCheckBoxNoty
                  .updateValue(new Message(type: 'CHECKED_CHANGED'));
            }),
        new Text(
          'نمایش شبیه سازی مسیر حرکت',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildMaxTextField(String hint, double width, String result) {
    return new TextFormField(
      initialValue: maxSpeed.toString(),
      decoration: new InputDecoration(
        alignLabelWithHint: true,
        hintText: hint,
        labelText: hint,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(2.0),
          borderSide: new BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        return null;
      },
      onSaved: (value) {
        maxSpeed = int.tryParse(value == null ? '0' : value);
      },
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      style: new TextStyle(
        fontFamily: "IranSans",
      ),
      onFieldSubmitted: (value) {},
    );
  }

  Widget _buildMinTextField(String hint, double width, String result) {
    return new TextFormField(
      enableInteractiveSelection: true,
      initialValue: minSpeed.toString(),
      decoration: new InputDecoration(
        labelText: hint,
        hintText: hint,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(2.0),
          borderSide: new BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        return null;
      },
      onSaved: (value) {
        minSpeed = int.tryParse(value == null ? '0' : value);
        // result=value;
      },
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      style: new TextStyle(
        fontFamily: "IranSans",
      ),
      onFieldSubmitted: (value) {},
    );
  }

  Widget createInfoPopup(
      String lastDateOnline, String lastTimeOnline, String pelak) {
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.pink,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album, size: 70),
              title:
                  Text(lastDateOnline, style: TextStyle(color: Colors.white)),
              subtitle:
                  Text(lastTimeOnline, style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.album, size: 70),
              title: Text(pelak, style: TextStyle(color: Colors.white)),
              subtitle:
                  Text(lastTimeOnline, style: TextStyle(color: Colors.white)),
            ),
            ButtonBarTheme(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(Translations.current.close(),
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<loc.LocationData> getCurrentLoaction() async {
    _initLastKnownLocation();
    _initCurrentLocation();
  }

  double ConvertDegreeAngleToDouble(
      double degrees, double minutes, double seconds) {
    //Decimal degrees =
    //   whole number of degrees,
    //   plus minutes divided by 60,
    //   plus seconds divided by 3600

    return degrees + (minutes / 60) + (seconds / 3600);
  }

  _showInfoDialog(int carId) async {
    List<int> carIds = new List();
    carIds..add(carId);

    ApiRoute apiRoute = ApiRoute(
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
      String latStr = result[0].Latitude;
      String lngStr = result[0].Longitude;
      var firstLat = latStr.split('*');
      var firstLng = lngStr.split('*');
      var secondLat = firstLat[1].split("'");
      var secondLng = firstLng[1].split("'");

      double fresultLatLng = ConvertDegreeAngleToDouble(
          double.tryParse(firstLat[0]),
          double.tryParse(secondLat[0]),
          double.tryParse(secondLat[1]));

      double sresultLatLng = ConvertDegreeAngleToDouble(
          double.tryParse(firstLng[0]),
          double.tryParse(secondLng[0]),
          double.tryParse(secondLng[1]));

      double lat = fresultLatLng;
      double lng = sresultLatLng;
      LatLng latLng = LatLng(lat, lng);
      currentCarLatLng = LatLng(lat, lng);
      String date = result[0].Date;
      String time = result[0].Time;
      int speed = result[0].speed;

      String msgTemp = time + ' ' + 'با سرعت : ' + speed.toString() + ' km/h ';
      DateTime newObjDate = DateTimeUtils.convertIntoDateObject(date);
      String newDate = DateTimeUtils.getDateJalaliFromDateTimeObj(newObjDate);
      FlashHelper.informationBar2(context,
          title: newDate,
          message: msgTemp,
          duration: Duration(milliseconds: 5000));
    } else {
      FlashHelper.informationBar2(context,
          title: null,
          message: 'اطلاعاتی برای نمایش یافت نشد',
          duration: Duration(milliseconds: 5000));
    }
  }

  updateMarkerPosition(int carId, Marker newMarker, LatLng latLng) {
    if (carMarkersMap.containsKey(lastCarIdSelected)) {
      Marker mark = carMarkersMap[carId];
      if (markers != null && markers.length > 0) {
        int markerIndex = markers.indexWhere((m) => m == mark);
        if (markerIndex != null && markerIndex > -1) {
          if (latLng != mark.point) markers[markerIndex] = newMarker;
        }
      } else {
        markers.add(newMarker);
      }

      carMarkersMap.update(lastCarIdSelected, (value) => newMarker);
      if (latLng != mark.point)
        statusNoty.updateValue(Message(
            type: 'GPS_GPRS_UPDATE', index: carId, id: carId, status: false));
    } else {
      markers.add(newMarker);
      carMarkersMap.putIfAbsent(lastCarIdSelected, () => newMarker);
      statusNoty.updateValue(Message(
          type: 'GPS_GPRS_UPDATE', index: carId, id: carId, status: false));
    }
    if (carInMarkerMap.containsKey(lastCarIdSelected)) {
      carInMarkerMap.update(lastCarIdSelected, (value) => latLng);
    } else {
      carInMarkerMap.putIfAbsent(lastCarIdSelected, () => latLng);
    }

    if (!kIsWeb) {
      if (liveMapController != null && liveMapController.mapController != null)
        liveMapController.mapController.move(latLng, 14);
    } else {
      mapController.move(latLng, 14);
    }
  }

  Future<bool> getParkAndSpeedStatus(NotyBloc<CarStateVM> notyBloc) async {
    List<int> carIds = List();
    carIds..add(lastCarIdSelected);
    ApiRoute route = ApiRoute(
        carId: lastCarIdSelected,
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
        CreatedDateTime: null,
        gpsDateTime: null,
        GPSDateTimeGregorian: null);
    var result = await restDatasource.getLastPositionRoute(route);
    if (result != null && result.length > 0) {
      ApiRoute apiRoute = result.first;
      String GPSDateTime = apiRoute.GPSDateTimeGregorian;
      int speed = apiRoute.speed;
      String date = apiRoute.Date;
      String time = apiRoute.Time;
      int h = 0, min = 0, sec = 0;
      DateTime now = DateTime.now();
      if (date != null && time != null) {
        DateTime gprsDate = DateTimeUtils.convertIntoDateObject(date);
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
      }
      DateTime gpsDt = DateTimeUtils.convertIntoDateTimeObject(GPSDateTime);
      Duration diff = now.difference(gpsDt);
      if (diff.inMinutes <= 1) {
        isGPRSOn = true;
      } else {
        isGPRSOn = false;
      }

      int minSpeed = await prefRepository
          .getMinMaxSpeed(SettingsScreenState.MIN_SPEED_TAG);
      int maxSpeed = await prefRepository
          .getMinMaxSpeed(SettingsScreenState.MAX_SPEED_TAG);
      if (speed > maxSpeed) {
        // highSpeed=true;
      } else if (speed < maxSpeed && speed > minSpeed) {
        // highSpeed=false;
      }
      if (speed < 5) {
        // isPark=true;
      } else {
        // isPark=false;
      }
      // notyBloc.updateValue(this);
      return true;
    }
    return false;
  }

  Future<ApiRoute> navigateToCarSelected(int index, bool isCarPaired, int carId,
      bool route, bool fromUpdate, bool forPairedRoute) async {
    if (!fromUpdate) {
      if (_timerupdate != null && _timerupdate.isActive) _timerupdate.cancel();
    }
    String imgUrl = '';
    CarInfoVM carInfo;
    //SlavedCar carSlave;
    if (isCarPaired) {
      // carSlave=carsSlavePairedList[index];
    } else {
      carInfo = carInfos[index];
    }

    List<int> carIds = new List();
    if (isCarPaired) {
      carIds..add(carId);
      var cr =
          centerRepository.getCars().where((c) => c.carId == carId).toList();
      if (cr != null && cr.length > 0) {
        imgUrl = CenterRepository.getCarImageURlByColorConstId(
            cr.first.colorTypeConstId);
      }
    } else {
      carIds..add(carInfo.carId);
      var cr =
          centerRepository.getCars().where((c) => c.carId == carId).toList();
      imgUrl = carInfo != null
          ? carInfo.imageUrl
          : (cr != null && cr.length > 0)
              ? CenterRepository.getCarImageURlByColorConstId(
                  cr.first.colorTypeConstId)
              : carImgList[1];
    }
    if (imgUrl == null || imgUrl.isEmpty) {
      imgUrl = carImgList[1];
    }
    lastCarIdSelected = carId > 0
        ? carId
        : (carInfo != null)
            ? carInfo.carId
            : 0;
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
      int speed = result[0].speed;
      String GPSDateTime = result[0].GPSDateTimeGregorian;

      String date = result[0].Date;
      String time = result[0].Time;

      int h = 0, min = 0, sec = 0;
      DateTime now = DateTime.now();
      if (date != null && time != null) {
        DateTime gprsDate = DateTimeUtils.convertIntoDateObject(date);
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
      }
      DateTime gpsDt = DateTimeUtils.convertIntoDateTimeObject(GPSDateTime);
      Duration diff = now.difference(gpsDt);
      if (diff.inMinutes <= 1) {
        isGPRSOn = true;
      } else {
        isGPRSOn = false;
      }

      statusNoty.updateValue(new Message(
          type: 'GPS_GPRS_UPDATE',
          index: index,
          id: carId,
          status: isCarPaired));
      if (speed == null) speed = 100;

      currentCarLocationSpeed = speed;
      String latStr = result[0].Latitude;
      String lngStr = result[0].Longitude;
      var firstLat = latStr.split('*');
      var firstLng = lngStr.split('*');
      var secondLat = firstLat[1].split("'");
      var secondLng = firstLng[1].split("'");

      double fresultLatLng = ConvertDegreeAngleToDouble(
          double.tryParse(firstLat[0]),
          double.tryParse(secondLat[0]),
          double.tryParse(secondLat[1]));

      double sresultLatLng = ConvertDegreeAngleToDouble(
          double.tryParse(firstLng[0]),
          double.tryParse(secondLng[0]),
          double.tryParse(secondLng[1]));

      double lat = fresultLatLng;
      double lng = sresultLatLng;
      LatLng latLng = LatLng(lat, lng);
      currentCarLatLng = LatLng(lat, lng);

      var marker = Marker(
        width: 40.0,
        height: 40.0,
        point: latLng,
        builder: (ctx) => Container(
          child: GestureDetector(
            onTap: () {
              _showInfoDialog(lastCarIdSelected);
              _showInfoPopUp = true;
            },
            child: Container(
                width: 38.0,
                height: 38.0,
                child: CircleAvatar(
                    radius: 38.0,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      imgUrl,
                      key: ObjectKey(Colors.green),
                    ))),
          ),
        ),
      );

      // markers.add(marker);
      if (carIndexMarkerMap == null) carIndexMarkerMap = new Map();
      if (carInMarkerMap == null) carInMarkerMap = new Map();
      if (carMarkersMap == null) {
        carMarkersMap = new Map();
      }

      if (route) {
        if (latLng != null)
          updateMarkerPosition(lastCarIdSelected, marker, latLng);
      } else {
        if (latLng != null) {
          carMarkersMap.putIfAbsent(lastCarIdSelected, () => marker);
          carInMarkerMap.putIfAbsent(lastCarIdSelected, () => latLng);
        }
      }
      //carIndexMarkerMap.putIfAbsent(index, ()=>)
      // if(!route) {

      if (isCarPaired) {
        updateMarkerPosition(lastCarIdSelected, marker, latLng);
        //liveMapController.mapController.move(latLng, 14);
      }
      if (_timerupdate == null || !_timerupdate.isActive)
        _updateLastPositionCarPeriodically(
            index, lastCarIdSelected, isCarPaired);
      // }
    } else {
      centerRepository.showFancyToast('اطلاعاتی یافت نشد', false);
    }

    if (isCarPaired && forPairedRoute) {
      showRouteCurrentToCar();
    }
  }

  addCarToPaired(ApiPairedCar car, int type) async {
    if (type == Constants.ROWSTATE_TYPE_INSERT) car.PairedCarId = 0;
    var result = await restDatasource.savePairedCar(car);
    if (result != null) {
      centerRepository.showFancyToast(result.Message, true);
      if (result.IsSuccessful) {
        centerRepository.showFancyToast(result.Message, true);
        pairedChangedNoty
            .updateValue(new Message(type: 'CAR_PAIRED', id: car.SecondCarId));
      } else {
        centerRepository.showFancyToast(result.Message, false);
      }
    } else {
      centerRepository.showFancyToast('خطا در تایید خودرو...', false);
    }
  }

  onCarPageTap() {
    Navigator.of(context).pushNamed('/carpage',
        arguments: new CarPageVM(
            userId: centerRepository.getUserCached().id,
            isSelf: true,
            carAddNoty: valueNotyModelBloc));
  }

  _showBottomSheetLastCars(
      BuildContext cntext, List<ApiPairedCar> cars, List<ApiPairedCar> pcars) {
    List<ApiPairedCar> carsNotActivated =
        pcars.where((p) => p.IsActive == false).toList();
    List<ApiPairedCar> filteredCarsNotActivated = new List();
    List<ApiPairedCar> found_items = new List();
    if (centerRepository.getCarsToAdmin() != null &&
        centerRepository.getCarsToAdmin().length > 0) {
      centerRepository.getCarsToAdmin().forEach((c) {
        found_items = carsNotActivated
            .where((p) => p.MasterCar.carId == c.CarId)
            .toList();
        if (found_items != null && found_items.length > 0) {
          filteredCarsNotActivated..add(found_items.first);
        }
      });

      showModalBottomSheetCustom(
          context: cntext,
          builder: (BuildContext context) {
            return new Container(
              height: 450.0,
              child: new Card(
                margin: new EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 0.0,
                child: new Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: Color(0xfffefefe),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(5.0)),
                  ),
                  child: createExpanded(filteredCarsNotActivated),
                  //PairedCarsExpandPanel(changePairedNoty:pairedChangedNoty , cars: cars,pcars: filteredCarsNotActivated,),
                ),
              ),
            );
          });
    }
  }

  initDatePicker(TextEditingController controller, String type) {
    persianDatePicker = PersianDatePicker(
      controller: controller,
      datetime: Jalali.now().toString(),
      fontFamily: 'IranSans',
      onChange: (String oldText, String newText) {
        if (type == 'From') {
          fromDate = newText;
          toDate = newText;
        } else
          toDate = newText;
      },
    ).init();
    return persianDatePicker;
  }

  _onValueChanged(String value) {
    minStopTime = value;
  }

  showLastCarJoint(BuildContext cntext) async {
    //var cars=await databaseHelper.getLastCarsJoint();
    //var cars=await restDatasource.getAllPairedCars();
    var pcars = await restDatasource.getPairedCars();
    if (pcars != null && pcars.length > 0)
      _showBottomSheetLastCars(cntext, null, pcars);
    else {
      centerRepository.showFancyToast('اطلاعاتی یافت نشد', false);
    }
  }

  _showBottomSheetDates(BuildContext cntext) {
    showModalBottomSheetCustom(
        context: cntext,
        mHeight: 0.98,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Translations.current.fromDate(),
                style: TextStyle(color: Colors.pinkAccent, fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: initDatePicker(textEditingController, 'From'),
              ),
              /*Text(Translations.current.toDate(),
                  style: TextStyle(color: Colors.pinkAccent,fontSize: 12.0),
                  textAlign: TextAlign.center,),
                Container(
                  height:MediaQuery.of(context).size.height*0.35,
                  child: initDatePicker(textEditingController, 'To'),
                ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*Padding(
                      padding: EdgeInsets.only(right: 10.0,left: 10.0),
                      child:
                    FlatButton(
                      child: Button(wid: 120.0,clr: Colors.pinkAccent,title: Translations.current.doFilter(),),
                      onPressed: () {
                        if(lastCarIdSelected==null || lastCarIdSelected==0){
                         centerRepository.showFancyToast('لطفا ابتدا خودرو را انتخاب نمایید');
                        }else {
                          forAnim=false;
                          Navigator.pop(context);
                          */ /*lines2 =*/ /* processLineData(
                              false, currentCarLatLng.latitude.toString(),
                              currentCarLatLng.longitude.toString(), fromDate,
                              toDate, true,false,false).then((data) {
                                if(data!=null && data.length > 0) {
                                  reportNoty.updateValue(new Message(type: 'DO_FILTER'));
                                }
                          });
                          Navigator.pop(context);

                        }
                      },
                    ),),*/
                  Padding(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    child: FlatButton(
                      child: Button(
                        wid: 120.0,
                        clr: Colors.pinkAccent,
                        title: 'ادامه',
                        color: Colors.pinkAccent.value,
                        backTransparent: true,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        reportDateNoty.updateValue(new Message(
                            text: ' تاریخ انتخاب شده : ' + fromDate));
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  showFilterDate(BuildContext context, bool from) {
    return _showBottomSheetDates(context);
  }

  _showBottomSheetSettings(BuildContext cntext) async {
    double wid = MediaQuery.of(cntext).size.width * 0.75;
    await getDefaultSettingsValues();
    _currentIndex = showSelectedRoutingIndex;
    showModalBottomSheetCustom(
        context: cntext,
        mHeight: 0.90,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            height: MediaQuery.of(cntext).size.height * 0.85,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width * 0.80,
                              height: 400,
                              child: new ListView(
                                //physics: Scr ,
                                children: <Widget>[
                                  /*Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.all(0.0),
                                    width: MediaQuery.of(context).size.width*0.80,
                                    height: 350,
                                    child:*/
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    //margin: EdgeInsets.symmetric(horizontal: 20.0),
                                    children: <Widget>[
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Form(
                                          key: _formKey,
                                          autovalidate: _autoValidate,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            physics: BouncingScrollPhysics(),
                                            child: StreamBuilder<Message>(
                                              stream:
                                                  changedRoutRadioBoxNoty.noty,
                                              builder: (context, snapshot) {
                                                int wichItem = 0;
                                                if (snapshot.hasData &&
                                                    snapshot.data != null) {
                                                  Message msg = snapshot.data;
                                                  if (msg.type == 'minS')
                                                    wichItem = 0;
                                                  if (msg.type == 'maxS')
                                                    wichItem = 1;
                                                  if (msg.type == 'minD')
                                                    wichItem = 2;
                                                }
                                                return new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 70,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.50,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0,
                                                              horizontal: 2.0),
                                                      child: _buildMinTextField(
                                                          'حداقل سرعت',
                                                          150,
                                                          null),
                                                    ),
                                                    Container(
                                                      height: 70,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.50,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0,
                                                              horizontal: 2.0),
                                                      child: _buildMaxTextField(
                                                          'حداکثر سرعت',
                                                          150,
                                                          null),
                                                    ),
                                                    Container(
                                                      height: 70,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.50,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0,
                                                              horizontal: 2.0),
                                                      child:
                                                          _buildMinDelayTextField(
                                                              'حداقل توقف',
                                                              150,
                                                              null),
                                                    ),
                                                    Container(
                                                      height: 180,
                                                      child: ListView(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        children: _group
                                                            .map((item) =>
                                                                RadioListTile(
                                                                  groupValue:
                                                                      _currentIndex,
                                                                  title: Text(
                                                                      "${item.text}"),
                                                                  value: item
                                                                      .index,
                                                                  onChanged:
                                                                      (val) {
                                                                    //setState(() {
                                                                    _currentIndex =
                                                                        val;
                                                                    showSelectedRoutingIndex =
                                                                        _currentIndex;
                                                                    changedRoutRadioBoxNoty.updateValue(
                                                                        new Message(
                                                                            type:
                                                                                'RADIO_VALUE_CHANGED'));
                                                                    // });
                                                                  },
                                                                ))
                                                            .toList(),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {},
                              child: new Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0,
                                      right: 15.0,
                                      left: 15.0,
                                      bottom: 5.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      _formKey.currentState.save();
                                      prefRepository.setRoutingType(
                                          CenterRepository.ROUTING_TYPE_TAG,
                                          showSelectedRoutingIndex);
                                      prefRepository.setMinMaxSpeed(
                                          MIN_SPEED_TAG, minSpeed);
                                      prefRepository.setMinMaxSpeed(
                                          MAX_SPEED_TAG, maxSpeed);
                                      prefRepository.setMinMaxSpeed(
                                          MINMAX_SPEED_TAG, minDelay);
                                      centerRepository.showFancyToast(
                                          'اطلاعات با موفقیت ذخیره شد', true);
                                      Navigator.pop(context);
                                    },
                                    child: Button(
                                        title: Translations.current.confirm(),
                                        wid: buttonWidth,
                                        clr: Colors.blueAccent,
                                        color: Colors.pinkAccent.value,
                                        backTransparent: true),
                                  )),
                            ),
                            new GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0,
                                    right: 15.0,
                                    left: 15.0,
                                    bottom: 5.0),
                                width: buttonWidth,
                                height: 40.0,
                                child: new Button(
                                    title: Translations.current.cancel(),
                                    wid: buttonWidth,
                                    color: Colors.pinkAccent.value,
                                    clr: Colors.pinkAccent,
                                    backTransparent: true),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _showBottomSheetJoindCars(
      BuildContext context, List<ParallaxCardItem> parallaxCardItemsList) {
    // double wid=MediaQuery.of(cntext).size.width*0.75;
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.50,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(top: 65.0),
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width - 10,
              height: 100.0,
              child: PageTransformer(
                pageViewBuilder: (context, visibilityResolver) {
                  return PageView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: PageController(
                      viewportFraction: 0.5,
                    ),
                    itemCount: parallaxCardItemsList.length,
                    itemBuilder: (context, index) {
                      final item = parallaxCardItemsList[index];
                      final pageVisibility =
                          visibilityResolver.resolvePageVisibility(index);
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          ApiPairedCar car = pcarsPairedActivated[index];
                          _showCarPairedActions(car, context);
                        },
                        child: Container(
                          color: Colors.white.withOpacity(0.0),
                          width: 200.0,
                          height: 100.0,
                          child: ParallaxCardsWidget(
                            item: item,
                            pageVisibility: pageVisibility,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  _showBottomSheetReport(BuildContext cntext) {
    double wid = MediaQuery.of(cntext).size.width * 0.75;
    showModalBottomSheetCustom(
        context: cntext,
        mHeight: 0.95,
        builder: (BuildContext context) {
          return StreamBuilder<Message>(
              stream: reportDateNoty.noty,
              builder: (context, snapshot) {
                String dateTitle = 'هنوز تاریخ را مشخص نکرده اید';
                if (snapshot.hasData && snapshot.data != null) {
                  dateTitle = snapshot.data.text;
                }
                return Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  height: MediaQuery.of(cntext).size.height * 0.75,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Stack(
                        overflow: Overflow.visible,
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        'اگر تاریخ را انتخاب نکنید بصورت پیش فرض روز جاری در نظر گرفته میشود',
                                        style: TextStyle(fontSize: 12.0))
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                      margin: EdgeInsets.only(
                                          top: 5.0, right: 5.0, left: 5.0),
                                      constraints: new BoxConstraints.expand(
                                        height: 40.0,
                                        width: wid,
                                      ),
                                      decoration: BoxDecoration(
                                        //color: Colors.pinkAccent,
                                        border: Border(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      child: FlatButton(
                                        onPressed: () {
                                          // Navigator.pop(context);
                                          showFilterDate(context, true);
                                        },
                                        child: Button(
                                          title: 'انتخاب تاریخ گزارش',
                                          wid: wid,
                                          clr: Colors.blueAccent,
                                          color: Colors.blueAccent.value,
                                          backTransparent: true,
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(dateTitle,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.redAccent))
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    height: 250,
                                    child: new ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topCenter,
                                          margin: EdgeInsets.all(0.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          height: 250,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            //margin: EdgeInsets.symmetric(horizontal: 20.0),
                                            children: <Widget>[
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Container(
                                                alignment: Alignment.topCenter,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 1.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                child: Form(
                                                  key: _formKey,
                                                  autovalidate: _autoValidate,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    child:
                                                        StreamBuilder<Message>(
                                                      stream:
                                                          changedCheckBoxNoty
                                                              .noty,
                                                      builder:
                                                          (context, snapshot) {
                                                        int wichItem = 0;
                                                        if (snapshot.hasData &&
                                                            snapshot.data !=
                                                                null) {
                                                          Message msg =
                                                              snapshot.data;
                                                          if (msg.type ==
                                                              'minS')
                                                            wichItem = 0;
                                                          if (msg.type ==
                                                              'maxS')
                                                            wichItem = 1;
                                                          if (msg.type ==
                                                              'minD')
                                                            wichItem = 2;
                                                        }

                                                        return new Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 40,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.80,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child:
                                                                  _buildShowSpeedMarkers(
                                                                      '', 15.0),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.80,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child:
                                                                  _buildShowMaxSpeedMarkers(
                                                                      '', 15.0),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.80,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child:
                                                                  _buildShowSpeedStopMarkers(
                                                                      '', 15.0),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.80,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child:
                                                                  _buildShowSpeedSimulateMarkers(
                                                                      '', 15.0),
                                                            ),

                                                            /*Container(
                                              //height: 45,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0, horizontal: 2.0),
                                              child:
                                              _buildMinDelayTextField('حداقل زمان توقف دقیقه', 150.0, null),
                                            ),
                                            Container(
                                              //height: 45,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0, horizontal: 2.0),
                                              child:
                                                   _buildMinTextField('حداقل سرعت', 150.0, null),


                                            ),
                                            Container(
                                              //height: 45,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0, horizontal: 2.0),
                                              child:
                                              _buildMaxTextField('حداکثر سرعت', 150.0, null),
                                            ),*/
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                      margin: EdgeInsets.only(
                                          top: 5.0,
                                          right: 15.0,
                                          left: 15.0,
                                          bottom: 5.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          if (lastCarIdSelected == null ||
                                              lastCarIdSelected == 0) {
                                            centerRepository.showFancyToast(
                                                'لطفا ابتدا خودرو را انتخاب نمایید',
                                                false);
                                          } else {
                                            forAnim = false;
                                            _formKey.currentState.save();
                                            // processLineDataForReportMinTime(fromDate,toDate,minDelay.toString());
                                            processLineData(
                                                    false,
                                                    currentCarLatLng.latitude
                                                        .toString(),
                                                    currentCarLatLng.longitude
                                                        .toString(),
                                                    fromDate,
                                                    toDate,
                                                    true,
                                                    showSimulateSpeedMarkers,
                                                    false)
                                                .then((data) {
                                              if (data != null &&
                                                  data.length > 0) {
                                                if (showSimulateSpeedMarkers) {
                                                  forAnim = true;
                                                  reportNoty.updateValue(
                                                      new Message(
                                                          type: 'ANIM_ROUTE'));
                                                } else {
                                                  reportNoty.updateValue(
                                                      new Message(
                                                          type: 'DO_FILTER'));
                                                }
                                              }
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Button(
                                          title:
                                              Translations.current.showReport(),
                                          wid: 150,
                                          clr: Colors.blueAccent,
                                          color: Colors.blueAccent.value,
                                          backTransparent: true,
                                        ),
                                      )),
                                  new GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 5.0,
                                          right: 15.0,
                                          left: 15.0,
                                          bottom: 5.0),
                                      width: buttonWidth,
                                      height: 40.0,
                                      child: new Button(
                                        title: Translations.current.cancel(),
                                        wid: buttonWidth,
                                        color: Colors.blueAccent.value,
                                        clr: Colors.pinkAccent,
                                        backTransparent: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        });
  }

  _showReportSheet(BuildContext context) async {
    // _showBottomSheetReport(context);
  }

  _showMapGuid(BuildContext context) async {
    _showBottomSheetGuid(context);
  }

  _showBottomSheetGuid(BuildContext context) {
    double wid = MediaQuery.of(context).size.width * 0.95;
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.98,
        builder: (BuildContext context) {
          return new Padding(
            padding: EdgeInsets.only(top: 10.0, right: 10.0),
            child: Container(
              width: wid,
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 68,
                          height: 68,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 10.0),
                            child: Image.asset(markerRed),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          height: 48,
                          child: Text(
                            'گزارش مسیر طی شده تاریخ روز را نمایش داده میشود.',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 13.0, color: Colors.redAccent),
                          ),
                        ),
                        //Text('نقاط زرد برروی نقشه نشان از سرعت زیر 30 کیلومتر می باشد',overflow: TextOverflow.visible,softWrap: true,style: TextStyle(fontSize: 15.0),),
                        // Text('نقاط سبز برروی نقشه نشان از سرعت زیر 100 کیلومتر می باشد',overflow: TextOverflow.visible,softWrap: true,style: TextStyle(fontSize: 15.0),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 68,
                          height: 68,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 10.0),
                            child: Image.asset(markerRed),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          height: 48,
                          child: Text(
                            'نقاط قرمز برروی نقشه نشان از سرعت بالای حداکثر سرعت در تنظیمات به کیلومتر می باشد',
                            softWrap: true,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                        //Text('نقاط زرد برروی نقشه نشان از سرعت زیر 30 کیلومتر می باشد',overflow: TextOverflow.visible,softWrap: true,style: TextStyle(fontSize: 15.0),),
                        // Text('نقاط سبز برروی نقشه نشان از سرعت زیر 100 کیلومتر می باشد',overflow: TextOverflow.visible,softWrap: true,style: TextStyle(fontSize: 15.0),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 68,
                          height: 68,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 10.0),
                            child: Image.asset(
                              markerRed,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          height: 48,
                          child: Text(
                            'نقاط زرد برروی نقشه نشان از سرعت زیر حداقل سرعت در تنظیمات به کیلومتر می باشد',
                            softWrap: true,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 68,
                          height: 68,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 10.0),
                            child: Image.asset(
                              markerPark,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          height: 48,
                          child: Text(
                            'نقاط توقف برروی نقشه نشان از عدم حرکت خودرو می باشد',
                            softWrap: true,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 48,
                          child: Text(
                            'با لمس هر نقطه اطلاعات سرعت و ... را مشاهده نمایید.',
                            softWrap: true,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 48,
                          child: Text(
                            'برای گزارش حرکت خودرو با انتخاب تاریخ تا تاریخ و انتخاب تاریخ مورد نظر ',
                            softWrap: true,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 48,
                          child: Text(
                            'و سپس لمس دکمه بستن در منوی زیرین گزارش مسیر با حرکت خودرو را انتخاب کنید',
                            softWrap: true,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 80,
                          child: Text(
                            'جهت تایید یا رد درخواست افزودن خودرو به ارتباط گروهی در منوی پایین در قسمت مرتبط به خودروها جهت افزودن به گروه با لمس هر وخدور میتوانید تایید یا رد درخواست کنید.',
                            softWrap: true,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          );
        });
  }

  showRouteCurrentToCar() async {
    if (lastCarIdSelected == null || lastCarIdSelected == 0) {
      centerRepository.showFancyToast(
          'لطفا ابتدا خودرو را انتخاب نمایید', false);
    } else {
      lines2 = processLineData(true, currentCarLatLng.latitude.toString(),
          currentCarLatLng.longitude.toString(), '', '', false, false, true);
    }
  }

  showCarRoute() {
    if (lastCarIdSelected == null || lastCarIdSelected == 0) {
      centerRepository.showFancyToast(
          'لطفا ابتدا خودرو را انتخاب نمایید', false);
    } else {
      processLineData(false, '', '', '', '', false, false, false).then((data) {
        if (data != null && data.length > 0) {
          reportNoty.updateValue(new Message(type: 'CAR_ROUTE_REPORT'));
        }
      });
    }
  }

  _showBottomSheetSearchCarForJoin(BuildContext context) {
    double wid = MediaQuery.of(context).size.width * 0.95;
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.75,
        builder: (BuildContext context) {
          return new Container(
            width: 350.0,
            height: 300,
            child: Stack(
              children: <Widget>[
                new ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      //margin: EdgeInsets.symmetric(horizontal: 20.0),
                      children: <Widget>[
                        SizedBox(
                          height: 0,
                        ),
                        /* FlatButton(
                          onPressed: (){ showLastCarJoint(context);},
                          child: Button(color: Colors.blueAccent.value,wid: 220,title: Translations.current.carJoindBefore(),),
                        ),*/
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: Form(
                            key: _formKey2,
                            autovalidate: _autoValidate,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              child: new Column(
                                children: <Widget>[
                                  Container(
                                    //height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child: FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "CarId",
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(color: Colors.pinkAccent),
                                        labelText: Translations.current.carId(),
                                      ),
                                      onChanged: (value) =>
                                          _onCarIdChanged(value),
                                      valueTransformer: (text) =>
                                          num.tryParse(text),
                                      // autovalidate: true,
                                      validators: [] /*[
                                        FormBuilderValidators
                                            .required(),
                                        FormBuilderValidators
                                            .numeric(),
                                        FormBuilderValidators.maxLength(20),
                                      ]*/
                                      ,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Container(
                                    // height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child: FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "SerialNumber",
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(color: Colors.pinkAccent),
                                        labelText:
                                            Translations.current.serialNumber(),
                                      ),
                                      onChanged: (value) =>
                                          _onMobileChanged(value),
                                      valueTransformer: (text) => text,
                                      validators: [],
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  Container(
                                    // height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child: FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "Pelak",
                                      inputFormatters: [
                                        BlacklistingTextInputFormatter(RegExp(
                                            "[,@#%^&*()+=!.`~\"';:?؟و/\\\\]"))
                                      ],
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(color: Colors.pinkAccent),
                                        labelText:
                                            Translations.current.carpelak(),
                                      ),
                                      onChanged: (value) =>
                                          _onPelakChanged(value),
                                      valueTransformer: (text) => text,
                                      validators: [],
                                      // keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      // _formKey2.currentState.save();
                                      if (_formKey2.currentState.validate())
                                        searchCar();
                                    },
                                    child: Container(
                                      child: new Button(
                                        title: 'جستجو',
                                        wid: 80.0,
                                        clr: Colors.blueAccent,
                                        color: Colors.blueAccent.value,
                                        backTransparent: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    // geolocator = null;
    userLocationOptions = null;
    reportNoty?.dispose();
    statusNoty?.dispose();
    pairedChangedNoty?.dispose();
    markerlocationStream?.close();
    animateNoty?.dispose();
    //location=null;
    _timerupdate?.cancel();
    showAllItemsdNoty?.dispose();
    showAllItemsdNoty2?.dispose();
    liveMapController?.dispose();
    changedCheckBoxNoty.dispose();
    mapController = null;
    _timerLine?.cancel();

    super.dispose();
  }

  _onLastKnownPressed() async {
    final int id = _createLocation('last known', Colors.blueGrey);
    geo.LocationResult result = await geo.Geolocation.lastKnownLocation();
    if (mounted) {
      _updateLocation(id, result);
    }
  }

  _onCurrentPressed() {
    final int id = _createLocation('current', Colors.lightGreen);
    _listenToLocation(id,
        geo.Geolocation.currentLocation(accuracy: geo.LocationAccuracy.best));
  }

  _onSingleUpdatePressed() async {
    final int id = _createLocation('update', Colors.deepOrange);
    _listenToLocation(
        id,
        geo.Geolocation.singleLocationUpdate(
            accuracy: geo.LocationAccuracy.best));
  }

  _listenToLocation(int id, Stream<geo.LocationResult> stream) {
    final subscription = stream.asBroadcastStream().listen((result) {
      _updateLocation(id, result);
    });

    subscription.onDone(() {
      _subscriptions.remove(subscription);
    });

    _subscriptions.add(subscription);
  }

  int _createLocation(String origin, Color color) {
    final int lastId = _locations.isNotEmpty
        ? _locations.map((location) => location.id).reduce(math.max)
        : 0;
    final int newId = lastId + 1;

    setState(() {
      _locations.insert(
        0,
        LocationDataGeo(
          id: newId,
          result: null,
          origin: origin,
          color: color,
          createdAtTimestamp: DateTime.now().millisecondsSinceEpoch,
          elapsedTimeSeconds: null,
        ),
      );
    });

    return newId;
  }

  _updateLocation(int id, geo.LocationResult result) {
    final int index = _locations.indexWhere((location) => location.id == id);
    assert(index != -1);

    final LocationDataGeo location = _locations[index];

    setState(() {
      _locations[index] = LocationDataGeo(
        id: location.id,
        result: result,
        origin: location.origin,
        color: location.color,
        createdAtTimestamp: location.createdAtTimestamp,
        elapsedTimeSeconds: (DateTime.now().millisecondsSinceEpoch -
                location.createdAtTimestamp) ~/
            1000,
      );
    });
    if (location.result.isSuccessful) if (!kIsWeb) {
      liveMapController.mapController.move(
          LatLng(location.result.locations[0].latitude,
              location.result.locations[0].latitude),
          15);
    } else {
      mapController.move(
          LatLng(location.result.locations[0].latitude,
              location.result.locations[0].latitude),
          15);
    }
  }

  @override
  Widget build(BuildContext context) {
    popmenu.PopupMenu.context = context;

    return FutureBuilder<List<CarInfoVM>>(
      future: carInfoss,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (carsPairedList != null && carsPairedList.length > 0) {
            pcarsPairedActivated =
                carsPairedList.where((p) => p.IsActive == true).toList();
            if (pcarsPairedActivated != null &&
                pcarsPairedActivated.length > 0) {
              pcarsPairedActivated.forEach((pc) {
                var crs = centerRepository
                    .getCars()
                    .where((c) => c.carId == pc.SecondCar.carId)
                    .toList();
                if (crs != null && crs.length > 0) {
                  pc.SecondCar.pelaueNumber = crs.first.pelaueNumber;
                }
              });
            }
          }
        }
        final parallaxCardItemsList = <ParallaxCardItem>[
          for (var car in carInfos)
            ParallaxCardItem(
                backColor: (car.hasJoind != null && car.hasJoind)
                    ? Colors.lightBlue
                    : Colors.white,
                title: DartHelper.isNullOrEmptyString(car.car.pelaueNumber),
                body: DartHelper.isNullOrEmptyString(car.carId.toString()),
                background: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  width: 50.0,
                  // color: (car.hasJoind!=null && car.hasJoind) ? Colors.lightBlue : Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 30.0,
                    child: Image.asset(car.imageUrl),
                  ),
                )),
        ];

        final carPairedItemsList = <ParallaxCardItem>[
          for (var carp in pcarsPairedActivated)
            ParallaxCardItem(
              backColor: Colors.blueAccent,
              title:
                  DartHelper.isNullOrEmptyString(carp.SecondCar.pelaueNumber),
              body: DartHelper.isNullOrEmptyString(
                  carp.SecondCar.carId.toString()),
              background: Container(
                width: 160.0,
                color: Colors.blueAccent,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(Translations.current.masterCarId(),
                              style: TextStyle(fontSize: 10.0)),
                          Text(
                              DartHelper.isNullOrEmptyString(
                                  carp.MasterCar.carId.toString()),
                              style: TextStyle(fontSize: 10.0)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              DartHelper.isNullOrEmptyString(
                                  carp.SecondCar.carModelTitle),
                              style: TextStyle(fontSize: 10.0)),
                          Container(
                            width: 50.0,
                            // color:  Colors.lightBlue ,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 30.0,
                              child: Image.asset(
                                  CenterRepository.getCarImageURlByColorConstId(
                                      carp.SecondCar.colorTypeConstId)),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                              DartHelper.isNullOrEmptyString(
                                  carp.SecondCar.carModelDetailTitle),
                              style: TextStyle(fontSize: 10.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ];
        if (carInfos != null && carInfos.length > 0)
          navigateToCarSelected(
              0, false, carInfos[0].carId, true, false, false);
        return StreamBuilder<Message>(
          //initialData: new Message(t),
          stream: pairedChangedNoty.noty,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data.type == 'CAR_PAIRED')
                carInfoss = getCarInfo(true);
            }

            return Scaffold(
              body: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  FutureBuilder<List<Polyline>>(
                      future: lines2,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          centerRepository.dismissDialog(context);

                          return StreamBuilder<Message>(
                            stream: reportNoty.noty,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                Message msg = snapshot.data;
                                if (msg.type == 'ANIM_ROUTE') {
                                  // if (forAnim) {
                                  animateRoutecarPolyLines();
                                  // }
                                }
                                if (msg.type == 'CLEAR_MAP') {
                                  if (_timerLine != null &&
                                      _timerLine.isActive) {
                                    //_timerLine=null;
                                    _timerLine.cancel();
                                  }
                                  if (_timerupdate != null &&
                                      _timerupdate.isActive) {
                                    _timerupdate.cancel();
                                  }
                                  if (_polyLineAnim != null) {
                                    forAnim = false;
                                    _polyLineAnim.points.clear();
                                    _polyLineAnim = null;
                                  }

                                  if (lines != null && lines.length > 0) {
                                    lines.clear();
                                  }
                                  if (carInMarkerMap != null &&
                                      carInMarkerMap.length > 0)
                                    carInMarkerMap.clear();
                                  if (carMarkersMap != null &&
                                      carMarkersMap.length > 0)
                                    carMarkersMap.clear();
                                  if (carIndexMarkerMap != null &&
                                      carIndexMarkerMap.length > 0)
                                    carIndexMarkerMap.clear();
                                  if (markers != null && markers.length > 0) {
                                    markers.clear();
                                  }
                                  if (carAnimMarkers != null &&
                                      carAnimMarkers.length > 0) {
                                    carAnimMarkers.clear();
                                  }
                                  if (lines2 != null) {
                                    lines2 = null;
                                  }
                                }
                              }

                              return StreamBuilder<Message>(
                                stream: statusNoty.noty,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    if (snapshot.data.type ==
                                        'GPS_GPRS_UPDATE') {}
                                  }
                                  return StreamBuilder<Message>(
                                    stream: showAllItemsdNoty.noty,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {}
                                      return Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 0.0),
                                              child: Text(''),
                                            ),
                                            Flexible(
                                              child: Stack(
                                                children: <Widget>[
                                                  StreamBuilder<Message>(
                                                      stream: animateNoty.noty,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData &&
                                                            snapshot.data !=
                                                                null) {
                                                          if (_fpoint !=
                                                              null) if (!kIsWeb) {
                                                            liveMapController
                                                                .mapController
                                                                .move(_fpoint,
                                                                    15);
                                                          } else {
                                                            mapController.move(
                                                                _fpoint, 15);
                                                          }
                                                        }
                                                        return FlutterMap(
                                                          mapController: !kIsWeb
                                                              ? liveMapController
                                                                  .mapController
                                                              : mapController,
                                                          options: MapOptions(
                                                            center: firstPoint !=
                                                                    null
                                                                ? firstPoint
                                                                : currentLocation !=
                                                                        null
                                                                    ? LatLng(
                                                                        currentLocation
                                                                            .latitude,
                                                                        currentLocation
                                                                            .longitude)
                                                                    : LatLng(
                                                                        35.6917856,
                                                                        51.4204603),
                                                            zoom: 15.0,
                                                            /*plugins: [
                                                                      UserLocationPlugin()
                                                                    ],*/
                                                          ),
                                                          layers: [
                                                            showSattelite
                                                                ? TileLayerOptions(
                                                                    //urlTemplate: 'https://{s}.tiles.mapbox.com/v3/pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdnB2dDAwdGwzZnMwc2lhcTlxd3QifQ.61hONdUooWn7aBJs-Km8OA/{z}/{x}/{y}.png',
                                                                    // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                                    //urlTemplate:'https://api.mapbox.com/styles/v1/rezand/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',

                                                                    urlTemplate:
                                                                        'https://api.mapbox.com/styles/v1/rezand/ck7d3ul4c0k3w1ir0n2a419pd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                    additionalOptions: {
                                                                      'accessToken':
                                                                          'pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                      //'id': 'mapbox.mapbox-streets-v7'
                                                                    },
                                                                    subdomains: [
                                                                      'a',
                                                                      'b',
                                                                      'c',
                                                                      'd'
                                                                    ],
                                                                  )
                                                                : TileLayerOptions(
                                                                    //urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                                    urlTemplate:
                                                                        'https://api.mapbox.com/styles/v1/rezand/ck7ge41221jke1inrbezkflve/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                    additionalOptions: {
                                                                      'accessToken':
                                                                          'pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                      'id':
                                                                          'mapbox.mapbox-streets-v7'
                                                                    },
                                                                    subdomains: [
                                                                      'a',
                                                                      'b',
                                                                      'c'
                                                                    ],
                                                                    //additionalOptions: {'key':'2UnTxClTTOQ2d3xsUL5T'},
                                                                  ),

                                                            MarkerLayerOptions(
                                                                markers:
                                                                    markers),
                                                            MarkerLayerOptions(
                                                                markers: [
                                                                  currentMarker
                                                                ]),

                                                            (forAnim &&
                                                                    _polyLineAnim !=
                                                                        null)
                                                                ? PolylineLayerOptions(
                                                                    polylines: <
                                                                        Polyline>[
                                                                        _polyLineAnim
                                                                      ])
                                                                : PolylineLayerOptions(
                                                                    polylines:
                                                                        lines),

                                                            MarkerLayerOptions(
                                                                markers:
                                                                    carAnimMarkers),

                                                            //userLocationOptions,
                                                          ],
                                                        );
                                                      }),
                                                  Positioned(
                                                    right: 20.0,
                                                    bottom: 90.0,
                                                    child: Container(
                                                      width: 38.0,
                                                      height: 38.0,
                                                      child:
                                                          FloatingActionButton(
                                                        onPressed: () async {
                                                          animateToCurrentLocation();
                                                        },
                                                        child: Container(
                                                          width: 38.0,
                                                          height: 38.0,
                                                          child: Image.asset(
                                                            'assets/images/location.png',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        elevation: 0.0,
                                                        backgroundColor:
                                                            Colors.blueAccent,
                                                        heroTag:
                                                            'CURRENTLOCATION1',
                                                      ),
                                                    ),
                                                  ),
                                                  showAllItemsOnMap
                                                      ? Positioned(
                                                          right: 20.0,
                                                          bottom: 340.0,
                                                          child: Container(
                                                            width: 38.0,
                                                            height: 38.0,
                                                            child:
                                                                FloatingActionButton(
                                                              onPressed: () {
                                                                showSattelite =
                                                                    !showSattelite;
                                                                showAllItemsdNoty
                                                                    .updateValue(
                                                                        new Message(
                                                                            type:
                                                                                'SATTELITE'));
                                                              },
                                                              child: Container(
                                                                width: 38.0,
                                                                height: 38.0,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/sattelite.png',
                                                                  color: !showSattelite
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .amber,
                                                                ),
                                                              ),
                                                              elevation: 0.0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueAccent,
                                                              heroTag:
                                                                  'SATTELITE1',
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                  Positioned(
                                                    right: 20.0,
                                                    bottom: 140.0,
                                                    child: Container(
                                                      width: 38.0,
                                                      height: 38.0,
                                                      child:
                                                          FloatingActionButton(
                                                        onPressed: () {
                                                          showAllItemsOnMap =
                                                              !showAllItemsOnMap;

                                                          showAllItemsdNoty
                                                              .updateValue(
                                                                  new Message(
                                                                      type:
                                                                          'CLEAR_ALL'));
                                                          showAllItemsdNoty2
                                                              .updateValue(new Message(
                                                                  status:
                                                                      showAllItemsOnMap,
                                                                  type:
                                                                      'CLEAR_ALL'));
                                                        },
                                                        child: Container(
                                                          width: 38.0,
                                                          height: 38.0,
                                                          child: Image.asset(
                                                            'assets/images/clear_all.png',
                                                            color:
                                                                showAllItemsOnMap
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .amber,
                                                          ),
                                                        ),
                                                        elevation: 0.0,
                                                        backgroundColor:
                                                            Colors.blueAccent,
                                                        heroTag: 'CLEARALL1',
                                                      ),
                                                    ),
                                                  ),
                                                  showAllItemsOnMap
                                                      ? Positioned(
                                                          right: 20.0,
                                                          bottom: 240.0,
                                                          child: Container(
                                                            width: 38.0,
                                                            height: 38.0,
                                                            child:
                                                                FloatingActionButton(
                                                              onPressed: () {
                                                                reportNoty.updateValue(
                                                                    new Message(
                                                                        type:
                                                                            'CLEAR_MAP'));
                                                              },
                                                              child: Container(
                                                                width: 38.0,
                                                                height: 38.0,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/clear_map.png',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              elevation: 3.0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueAccent,
                                                              heroTag:
                                                                  'ClearMap1',
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                  showAllItemsOnMap
                                                      ? Positioned(
                                                          right: 20.0,
                                                          bottom: 290.0,
                                                          child: Container(
                                                            width: 38.0,
                                                            height: 38.0,
                                                            child:
                                                                FloatingActionButton(
                                                              onPressed: () {
                                                                showRouteCurrentToCar();
                                                              },
                                                              child: Container(
                                                                width: 38.0,
                                                                height: 38.0,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/go.png',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              elevation: 0.0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueAccent,
                                                              heroTag: 'GO1',
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                  showAllItemsOnMap
                                                      ? Positioned(
                                                          right: 20.0,
                                                          bottom: 190.0,
                                                          child: Container(
                                                            width: 38.0,
                                                            height: 38.0,
                                                            child:
                                                                FloatingActionButton(
                                                              onPressed: () {
                                                                showCarRoute();
                                                              },
                                                              child: Container(
                                                                width: 38.0,
                                                                height: 38.0,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/routecar.png',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              elevation: 1.0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueAccent,
                                                              heroTag:
                                                                  'ROUTECAR',
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          double lat = currentLocation != null
                              ? currentLocation.latitude
                              : 35.6917856;
                          double long = currentLocation != null
                              ? currentLocation.longitude
                              : 51.4204603;
                          return StreamBuilder<Message>(
                            stream: reportNoty.noty,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                Message msg = snapshot.data;
                                if (msg.type == 'ANIM_ROUTE') {
                                  if (forAnim) {
                                    animateRoutecarPolyLines();
                                  }
                                }
                                if (msg.type == 'CLEAR_MAP') {
                                  if (_timerLine != null &&
                                      _timerLine.isActive) {
                                    _timerLine.cancel();
                                  }
                                  if (_timerupdate != null &&
                                      _timerupdate.isActive) {
                                    _timerupdate.cancel();
                                  }
                                  if (_polyLineAnim != null) {
                                    forAnim = false;
                                    _polyLineAnim.points.clear();
                                    _polyLineAnim = null;
                                    degress.clear();
                                  }

                                  if (lines != null && lines.length > 0) {
                                    lines.clear();
                                  }
                                  if (carInMarkerMap != null &&
                                      carInMarkerMap.length > 0)
                                    carInMarkerMap.clear();
                                  if (carMarkersMap != null &&
                                      carMarkersMap.length > 0)
                                    carMarkersMap.clear();
                                  if (carIndexMarkerMap != null &&
                                      carIndexMarkerMap.length > 0)
                                    carIndexMarkerMap.clear();
                                  if (markers != null && markers.length > 0) {
                                    markers.clear();
                                  }
                                  if (carAnimMarkers != null &&
                                      carAnimMarkers.length > 0) {
                                    carAnimMarkers.clear();
                                  }

                                  if (lines2 != null) {
                                    lines2 = null;
                                  }
                                }
                              }

                              return StreamBuilder<Message>(
                                stream: statusNoty.noty,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    if (snapshot.data.type ==
                                        'GPS_GPRS_UPDATE') {}
                                    if (snapshot.data.type ==
                                        'CURRENT_LOCATION_UPDATED') {
                                      showWaiting = false;
                                    }
                                    if (snapshot.data.type ==
                                        'SEARCH_LOCATION') {
                                      showWaiting = true;
                                    }
                                  }
                                  return StreamBuilder<Message>(
                                    stream: showAllItemsdNoty.noty,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {}
                                      return Column(
                                        children: [
                                          Flexible(
                                            child: Stack(
                                              children: <Widget>[
                                                StreamBuilder<Message>(
                                                  stream: animateNoty.noty,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.data != null) {
                                                      if (_fpoint !=
                                                          null) if (!kIsWeb) {
                                                        liveMapController
                                                            .mapController
                                                            .move(_fpoint, 15);
                                                      } else {
                                                        mapController.move(
                                                            _fpoint, 15);
                                                      }
                                                    }
                                                    return FlutterMap(
                                                      options: MapOptions(
                                                        center:
                                                            LatLng(lat, long),
                                                        zoom: _zoom,
                                                        /*plugins: [
                                                                    UserLocationPlugin()
                                                                  ],*/
                                                      ),
                                                      layers: [
                                                        showSattelite
                                                            ? TileLayerOptions(
                                                                //urlTemplate: 'https://{s}.tiles.mapbox.com/v3/pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdnB2dDAwdGwzZnMwc2lhcTlxd3QifQ.61hONdUooWn7aBJs-Km8OA/{z}/{x}/{y}.png',
                                                                // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                                //urlTemplate:'https://api.mapbox.com/styles/v1/rezand/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',

                                                                urlTemplate:
                                                                    'https://api.mapbox.com/styles/v1/rezand/ck7d3ul4c0k3w1ir0n2a419pd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                additionalOptions: {
                                                                  'accessToken':
                                                                      'pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                  //'id': 'mapbox.mapbox-streets-v7'
                                                                },
                                                                subdomains: [
                                                                  'a',
                                                                  'b',
                                                                  'c',
                                                                  'd'
                                                                ],
                                                              )
                                                            : TileLayerOptions(
                                                                //urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                                urlTemplate:
                                                                    'https://api.mapbox.com/styles/v1/rezand/ck7ge41221jke1inrbezkflve/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                additionalOptions: {
                                                                  'accessToken':
                                                                      'pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdHg3djAwdDAzZnMwcTc1N2ZpY2YifQ.fl5LG72G5Uz6CLVfhbazNw',
                                                                  'id':
                                                                      'mapbox.mapbox-streets-v7'
                                                                },
                                                                subdomains: [
                                                                  'a',
                                                                  'b',
                                                                  'c'
                                                                ],
                                                              ),
                                                        MarkerLayerOptions(
                                                            markers: markers),
                                                        MarkerLayerOptions(
                                                            markers: [
                                                              currentMarker
                                                            ]),
                                                        (forAnim &&
                                                                _polyLineAnim !=
                                                                    null)
                                                            ? PolylineLayerOptions(
                                                                polylines: <
                                                                    Polyline>[
                                                                    _polyLineAnim
                                                                  ])
                                                            : PolylineLayerOptions(
                                                                polylines:
                                                                    lines),
                                                        MarkerLayerOptions(
                                                            markers:
                                                                carAnimMarkers),
                                                      ],
                                                      mapController: !kIsWeb
                                                          ? liveMapController
                                                              .mapController
                                                          : mapController,
                                                    );
                                                  },
                                                ),
                                                Positioned(
                                                  right: 20.0,
                                                  bottom: 90.0,
                                                  child: Container(
                                                    width: 38.0,
                                                    height: 38.0,
                                                    child: FloatingActionButton(
                                                      onPressed: () async {
                                                        animateToCurrentLocation();
                                                      },
                                                      child: Container(
                                                        width: 38.0,
                                                        height: 38.0,
                                                        child: Image.asset(
                                                          'assets/images/location.png',
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      elevation: 0.0,
                                                      backgroundColor:
                                                          Colors.blueAccent,
                                                      heroTag:
                                                          'CURRENTLOCATION2',
                                                    ),
                                                  ),
                                                ),
                                                showAllItemsOnMap
                                                    ? Positioned(
                                                        right: 20.0,
                                                        bottom: 340.0,
                                                        child: Container(
                                                          width: 38.0,
                                                          height: 38.0,
                                                          child:
                                                              FloatingActionButton(
                                                            onPressed: () {
                                                              showSattelite =
                                                                  !showSattelite;
                                                              showAllItemsdNoty
                                                                  .updateValue(
                                                                      new Message(
                                                                          type:
                                                                              'SATTELITE'));
                                                            },
                                                            child: Container(
                                                              width: 38.0,
                                                              height: 38.0,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/sattelite.png',
                                                                color: !showSattelite
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .amber,
                                                              ),
                                                            ),
                                                            elevation: 0.0,
                                                            backgroundColor:
                                                                Colors
                                                                    .blueAccent,
                                                            heroTag:
                                                                'SATTELITE2',
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                Positioned(
                                                  right: 20.0,
                                                  bottom: 140.0,
                                                  child: Container(
                                                    width: 38.0,
                                                    height: 38.0,
                                                    child: FloatingActionButton(
                                                      onPressed: () {
                                                        showAllItemsOnMap =
                                                            !showAllItemsOnMap;
                                                        showAllItemsdNoty
                                                            .updateValue(
                                                                new Message(
                                                                    type:
                                                                        'CLEAR_ALL'));
                                                        showAllItemsdNoty2
                                                            .updateValue(new Message(
                                                                status:
                                                                    showAllItemsOnMap,
                                                                type:
                                                                    'CLEAR_ALL'));
                                                      },
                                                      child: Container(
                                                        width: 38.0,
                                                        height: 38.0,
                                                        child: Image.asset(
                                                          'assets/images/clear_all.png',
                                                          color:
                                                              showAllItemsOnMap
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .amber,
                                                        ),
                                                      ),
                                                      elevation: 0.0,
                                                      backgroundColor:
                                                          Colors.blueAccent,
                                                      heroTag: 'CLEARALL2',
                                                    ),
                                                  ),
                                                ),
                                                showAllItemsOnMap
                                                    ? Positioned(
                                                        right: 20.0,
                                                        bottom: 290.0,
                                                        child: Container(
                                                          width: 38.0,
                                                          height: 38.0,
                                                          child:
                                                              FloatingActionButton(
                                                            onPressed: () {
                                                              // liveMapController.removeMarkers();
                                                              reportNoty.updateValue(
                                                                  new Message(
                                                                      type:
                                                                          'CLEAR_MAP'));
                                                            },
                                                            child: Container(
                                                              width: 38.0,
                                                              height: 38.0,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/clear_map.png',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            elevation: 3.0,
                                                            backgroundColor:
                                                                Colors
                                                                    .blueAccent,
                                                            heroTag:
                                                                'ClearMap2',
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                showAllItemsOnMap
                                                    ? Positioned(
                                                        right: 20.0,
                                                        bottom: 240.0,
                                                        child: Container(
                                                            width: 38.0,
                                                            height: 38.0,
                                                            child:
                                                                FloatingActionButton(
                                                              onPressed: () {
                                                                showRouteCurrentToCar();
                                                              },
                                                              child: Container(
                                                                width: 38.0,
                                                                height: 38.0,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/go.png',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              elevation: 0.0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueAccent,
                                                              heroTag: 'GO2',
                                                            )),
                                                      )
                                                    : Container(),
                                                showAllItemsOnMap
                                                    ? Positioned(
                                                        right: 20.0,
                                                        bottom: 190.0,
                                                        child: Container(
                                                          width: 38.0,
                                                          height: 38.0,
                                                          child:
                                                              FloatingActionButton(
                                                            onPressed: () {
                                                              showCarRoute();
                                                            },
                                                            child: Container(
                                                              width: 38.0,
                                                              height: 38.0,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/routecar.png',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            elevation: 1.0,
                                                            backgroundColor:
                                                                Colors
                                                                    .blueAccent,
                                                            heroTag:
                                                                'ROUTECAR2',
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }
                      }
                      // ),
                      ),

                  /* elevation: 0,
                            floatingAppBar: true,
                            floatAppbar:
                            Stack(
                              children: <Widget>[*/
                  Container(
                    height: 71.0,
                    child: Column(
                      children: [
                        Container(
                          height: 70.0,
                          child: AppBar(
                            automaticallyImplyLeading: true,
                            backgroundColor: Colors.white,
                            elevation: 0.0,
                            actions: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 5),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.blueAccent,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    carInfoss = getCarInfo(true);
                                  },
                                ),
                              ),
                              Container(
                                width: 38.0,
                                height: 38.0,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    width: 38.0,
                                    height: 38.0,
                                    child: isGPSOn
                                        ? ImageNeonGlow(
                                            imageUrl: 'assets/images/gps.png',
                                            counter: 0,
                                            color: Colors.blueAccent,
                                          )
                                        : Image.asset(
                                            'assets/images/gps.png',
                                            color: Colors.black38,
                                          ),
                                  ),
                                  elevation: 1.0,
                                  backgroundColor: Colors.transparent,
                                  heroTag: 'GPS1',
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                width: 38.0,
                                height: 38.0,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  child: Container(
                                    width: 38.0,
                                    height: 38.0,
                                    child: isGPRSOn
                                        ? ImageNeonGlow(
                                            imageUrl: 'assets/images/gprs.png',
                                            counter: 0,
                                            color: Colors.blueAccent,
                                          )
                                        : Image.asset(
                                            'assets/images/gprs.png',
                                            color: Colors.black38,
                                          ),
                                  ),
                                  elevation: 1.0,
                                  backgroundColor: Colors.transparent,
                                  heroTag: 'GPRS1',
                                ),
                              ),
                            ],
                            leading: IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.indigoAccent,
                              ),
                              onPressed: () {
                                widget.scaffoldKey.currentState.openDrawer();
                              },
                            ),
                          ),
                        ),
                        showWaiting
                            ? Container(
                                height: 2.0,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.indigoAccent,
                                ))
                            : Container(),
                      ],
                    ),
                    // ],
                  ),
                  StreamBuilder<Message>(
                    stream: showAllItemsdNoty2.noty,
                    builder: (context, snapshot) {
                      bool status = true;
                      if (snapshot.hasData && snapshot.data != null) {
                        status = snapshot.data.status;
                      }
                      return status
                          ? Padding(
                              padding: EdgeInsets.only(top: 65.0),
                              child: Container(
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width - 10,
                                height: 100.0,
                                child: PageTransformer(
                                  pageViewBuilder:
                                      (context, visibilityResolver) {
                                    return PageView.builder(
                                      physics: BouncingScrollPhysics(),
                                      controller: PageController(
                                        viewportFraction: 0.5,
                                      ),
                                      itemCount: parallaxCardItemsList.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            parallaxCardItemsList[index];
                                        final pageVisibility =
                                            visibilityResolver
                                                .resolvePageVisibility(index);
                                        return GestureDetector(
                                          onTap: () {
                                            navigateToCarSelected(index, false,
                                                0, true, false, false);
                                          },
                                          child: Container(
                                            color:
                                                Colors.white.withOpacity(0.0),
                                            width: 200.0,
                                            height: 100.0,
                                            child: ParallaxCardsWidget(
                                              item: item,
                                              pageVisibility: pageVisibility,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 50,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Card(
                            margin: EdgeInsets.all(0),
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      _showBottomSheetReport(context);
                                    },
                                    child: Icon(
                                      Icons.history,
                                      size: 24,
                                      color: Colors.blueAccent,
                                    )),
                                FlatButton(
                                    key: btnKey2,
                                    onPressed: () {
                                      menu.show(widgetKey: btnKey2);
                                    },
                                    child: Icon(
                                      Icons.more_horiz,
                                      size: 24,
                                      color: Colors.blueAccent,
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      _showBottomSheetJoindCars(
                                          context, carPairedItemsList);
                                    },
                                    child: Icon(
                                      Icons.directions_car,
                                      size: 24,
                                      color: Colors.blueAccent,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          // );
          // },
        );
        // } else {
        //   return NoDataWidget();
        // }
        // );
      },
    );
    /*  },
        );*/
    /*},
    );*/
  }

  void addGeoMarkerFromCurrentPosition() async {
    GeoPoint gp = await geoPointFromLocation(name: "Current position");
    Marker m = Marker(
        width: 180.0,
        height: 250.0,
        point: gp.point,
        builder: (BuildContext context) {
          return Icon(Icons.location_on);
        });
    if (!kIsWeb) {
      await liveMapController.addMarker(marker: m, name: "Current position");
      await liveMapController.fitMarker("Current position");
    } else {}
  }

  void addGeoMarkerFromPosition(LatLng pos) async {
    GeoPoint gp = await geoPointFromLocation(name: "Current position");
    Marker m = Marker(
        width: 180.0,
        height: 250.0,
        point: gp.point,
        builder: (BuildContext context) {
          return Icon(Icons.location_on);
        });
    if (!kIsWeb) {
      await liveMapController.addMarker(marker: m, name: "Current position");
      await liveMapController.fitMarker("Current position");
    } else {}
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
