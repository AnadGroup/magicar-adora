/*
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/send_data.dart';
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
import 'package:anad_magicar/ui/map/geojson/src/geojson.dart';
import 'package:anad_magicar/ui/map/geojson/src/models.dart';
import 'package:anad_magicar/ui/map/mapbox/lib/mapbox_gl.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/paired_car_expandable_panel.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/drawer/app_drawer.dart';
import 'package:anad_magicar/widgets/extended_navbar/extended_navbar_scaffold.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:anad_magicar/widgets/persian_datepicker/persian_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart' as navi;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocation/geolocation.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geopoint/geopoint.dart';
import 'package:pedantic/pedantic.dart';

import 'dart:math' as math;
import '../../../translation_strings.dart';
import 'page.dart';

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);


final List<String> carImgList = [
  "assets/images/car_red.png",
  "assets/images/car_blue.png",
  "assets/images/car_black.png",
  "assets/images/car_white.png",
  "assets/images/car_yellow.png",
  "assets/images/car_gray.png",
];

class LocationData {
  LocationData({
    @required this.id,
    this.result,
    @required this.origin,
    @required this.color,
    @required this.createdAtTimestamp,
    this.elapsedTimeSeconds,
  });

  final int id;
  final LocationResult result;
  final String origin;
  final Color color;
  final int createdAtTimestamp;
  final int elapsedTimeSeconds;
}

class MapUiPage extends Page {

  int carId;
  int carCounts;
  List<AdminCarModel> carsToUser;
  MapVM mapVM;

  MapUiPage({this.carId,this.mapVM,this.carsToUser,this.carCounts}) : super(const Icon(Icons.map), 'User interface');

  @override
  Widget build(BuildContext context) {
    return  MapUiBody(carId: this.carId,carCounts: this.carCounts,mapVM: this.mapVM,carsToUser: this.carsToUser,);
  }
}

class MapUiBody extends StatefulWidget {
  int carId;
  int carCounts;
  List<AdminCarModel> carsToUser;
  MapVM mapVM;
   MapUiBody({this.carId,this.mapVM,this.carsToUser,this.carCounts});

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {


  List<LocationData> _locations = [];
  List<StreamSubscription<dynamic>> _subscriptions = [];
  static const String route = '/mappage';
  static final String MINMAX_SPEED_TAG = 'MINMAX_SPEED';
  static final String MIN_SPEED_TAG = 'MIN_SPEED';
  static final String MAX_SPEED_TAG = 'MAX_SPEED';
  String userName = '';
  int userId = 0;
  int minSpeed = 30;
  int maxSpeed = 100;
  int minDelay = 0;
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
  PersianDatePickerWidget persianDatePicker;
  final String imageUrl = 'assets/images/user_profile.png';
  final String markerRed = 'assets/images/mark_red.png';
  final String markerGreen = 'assets/images/mark_green.png';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();

  bool _autoValidate = false;
  bool isDark = false;
  List<CarInfoVM> carInfos = new List();
  NotyBloc<Message> reportNoty = new NotyBloc<Message>();
  NotyBloc<Message> statusNoty = new NotyBloc<Message>();

  NotyBloc<Message> moreButtonNoty = new NotyBloc<Message>();
  NotyBloc<Message> pairedChangedNoty = new NotyBloc<Message>();
  NotyBloc<Message> animateNoty = new NotyBloc<Message>();
  NotyBloc<Message> showAllItemsdNoty = new NotyBloc<Message>();


  Future<List<CarInfoVM>> carInfoss;
  Future<List<ApiPairedCar>> carsPaired;


  List<AdminCarModel> carsToUserSelf;
  List<ApiPairedCar> carsPairedList;
  List<SlavedCar> carsSlavePairedList;

  int _carCounts = 0;

  navi.MapboxNavigation _directions;
  bool _arrived = false;
  double _distanceRemaining, _durationRemaining;
  String _platformVersion = 'Unknown';
  final _origin =
  navi.Location(name: "City Hall", latitude: 42.886448, longitude: -78.878372);
  final _destination = navi.Location(
      name: "Downtown Buffalo", latitude: 42.8866177, longitude: -78.8814924);
 */
/* Position _lastKnownPosition;
  Position _currentPosition;*//*

  List<Symbol> markers = [];
  int _symbolCount = 0;
  List<LatLng> points = [];
  StreamController<LatLng> markerlocationStream = StreamController();
  UserLocationOptions userLocationOptions;


  List<Line> lines = new List(); //<Polyline>[];
  Future<List<Line>> lines2;

  Symbol _selectedSymbol;
  int _lineCount = 0;
  Line _selectedLine;

  Symbol _marker;
  Timer _timer;
  int _markerIndex = 0;
  Line _polyLine;
  Line _polyLineAnim;

  LatLng _fpoint;
  LatLng _spoint;

  int _pointIndex = 0;
  Timer _timerLine;
  int _polyLineIndex = 0;

  String pelakForSearch = '';
  String carIdForSearch = '';
  String mobileForSearch = '';
  String minStopTime;
  String minStopDate;

  String minStopTime2;
  String minStopDate2;

  LatLng firstPoint;
  LatLng currentCarLatLng;

  bool androidFusedLocation = true;

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = navi.MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived)
      {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });

 */
/*   String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });*//*

  }

  startNavigation() async {
    await _directions.startNavigation(
        origin: _origin,
        destination: _destination,
        mode: navi.NavigationMode.drivingWithTraffic,
        simulateRoute: true, language: "German", units: navi.VoiceUnits.metric);
  }
  Future<void> _initLastKnownLocation() async {
  */
/*  Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = !androidFusedLocation;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });*//*

  }

  _onLastKnownPressed() async {
    final int id = _createLocation('last known', Colors.blueGrey);
    LocationResult result = await Geolocation.lastKnownLocation();
    if (mounted) {
      _updateLocation(id, result);
    }
  }

  _onCurrentPressed() {
    final int id = _createLocation('current', Colors.lightGreen);
    _listenToLocation(
        id, Geolocation.currentLocation(accuracy: LocationAccuracy.best));

  }

  _onSingleUpdatePressed() async {
    final int id = _createLocation('update', Colors.deepOrange);
    _listenToLocation(
        id, Geolocation.singleLocationUpdate(accuracy: LocationAccuracy.best));
  }

  _listenToLocation(int id, Stream<LocationResult> stream) {
    final subscription = stream.listen((result) {
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
        new LocationData(
          id: newId,
          result: null,
          origin: origin,
          color: color,
          createdAtTimestamp: new DateTime.now().millisecondsSinceEpoch,
          elapsedTimeSeconds: null,
        ),
      );
    });

    return newId;
  }

  _updateLocation(int id, LocationResult result) {
    final int index = _locations.indexWhere((location) => location.id == id);
    assert(index != -1);

    final LocationData location = _locations[index];

    setState(() {
      _locations[index] = new LocationData(
        id: location.id,
        result: result,
        origin: location.origin,
        color: location.color,
        createdAtTimestamp: location.createdAtTimestamp,
        elapsedTimeSeconds: (new DateTime.now().millisecondsSinceEpoch -
            location.createdAtTimestamp) ~/
            1000,
      );
    });
    if(mapController!=null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 270.0,
            target: LatLng(_locations[index].result.locations[index].latitude,
                _locations[index].result.locations[index].longitude),
            tilt: 30.0,
            zoom: 17.0,
          ),
        ),
      ).then((result) => print("mapController.animateCamera() returned "));
    }
  }



  void _add(LatLng latLng) {
    mapController.addLine(
      LineOptions(
        geometry: [
          latLng
        ],
        lineColor: "#ff0000",
        lineWidth: 14.0,
        lineOpacity: 0.5,
      ),
    );
    setState(() {
      _lineCount += 1;
    });
  }

  void _addSymbol(String iconImage, LatLng latLng) {
    mapController.addSymbol(
      SymbolOptions(
        geometry: latLng,
        iconImage: iconImage,
      ),
    );
    setState(() {
      _symbolCount += 1;
    });
  }


  Widget getMarkerOnSpeed(int speed) {
    var item = Image.asset(markerRed, key: ObjectKey(Colors.red));
    if (maxSpeed == null || maxSpeed == 0)
      maxSpeed = 100;
    if (minSpeed == null || minSpeed == 0)
      minSpeed = 30;
    if (speed == null)
      speed = 0;
    if (speed > maxSpeed)
      return item;
    else
      */
/*return Image.asset( markerGreen  , key: ObjectKey(Colors.green ),) ;
       else*//*
 return
      Image.asset(
        markerGreen, color: Colors.amber, key: ObjectKey(Colors.amber),);
  }

  String getMarkerUrlOnSpeed(int speed) {
    var item = markerRed;
    if (maxSpeed == null || maxSpeed == 0)
      maxSpeed = 100;
    if (minSpeed == null || minSpeed == 0)
      minSpeed = 30;
    if (speed == null)
      speed = 0;
    if (speed > maxSpeed)
      return item;
    else
      return markerGreen;
  }

  getMinMaxSpeed() async {
    */
/*maxSpeed=await prefRepository.getMinMaxSpeed(SettingsScreenState.MAX_SPEED_TAG);
    minSpeed=await prefRepository.getMinMaxSpeed(SettingsScreenState.MIN_SPEED_TAG);*//*


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

  animateRoutecar() async {

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _marker = markers[_markerIndex];
      _markerIndex = (_markerIndex + 1) % markers.length;
      // animateNoty.updateValue(new Message(type: 'MARKER_ANIM'));
    });
  }
  List<LatLng> geoPoints2=new List();
  animateRoutecarPolyLines() async {
    int next = 0;
    int index = 0;
    _polyLine = lines[_polyLineIndex];
  */
/*  LatLng ftemp;
    if (index < _polyLine.options.geometry.length - 1) {
      ftemp = _polyLine.options.geometry[index];
     // _spoint = _polyLine.options.geometry[next];
     // points..add(_fpoint)..add(_spoint);
    }*//*



   */
/* if(points!=null && points.length>0)
      points.clear();*//*

    List<LatLng> geoPoints=lines[0].options.geometry;

    geoPoints2..add(geoPoints[0]);
    Line mainLine=await mapController.addLine(LineOptions(
      geometry: geoPoints2,
      lineColor: "#3F51B5",
      lineWidth: 10.0,
      lineOpacity: 0.6,
    ),);



    geoPoints.forEach((g){
      if(index!=0)
        geoPoints2..add(g);
      //mainLine.options.geometry.add()
      mapController.updateLine(mainLine, LineOptions(
        geometry: geoPoints2
      ),);
      index++;
      mapController.moveCamera(
        CameraUpdate.newLatLng(
            g
        ),
      );
      Future.delayed(new Duration(milliseconds: 500)).then((value){

      });

    });

    */
/*_timerLine = Timer.periodic(Duration(milliseconds: 500), (_) {
      _polyLine = lines[_polyLineIndex];
      _polyLineIndex = (_polyLineIndex + 1) % lines.length;



      if (index < _polyLine.options.geometry.length - 1) {
        index++;
        next = index + 1;
      }
      // _fpoint=_polyLine.points[_pointIndex];
      _pointIndex = (_pointIndex + 1) % _polyLine.options.geometry.length;
      if (index < _polyLine.options.geometry.length - 1) {
        _fpoint = _polyLine.options.geometry[index];
        //_spoint = _polyLine.options.geometry[next];
       // points..add(_fpoint)..add(_spoint);
        mainLine.options.geometry.add(_fpoint);//..add(_spoint);
      }
      if ((_pointIndex + 1) >= _polyLine.options.geometry.length) {
        _timerLine.cancel();
      }
     *//*
*/
/* _polyLineAnim =
      new Line(_polyLineAnim.options.geometry.length.toString(), LineOptions(
        geometry: points,
        lineColor: "#E91E63",
        lineWidth: 16.0,
        lineOpacity: 0.5,
      ),);*//*
*/
/*



           *//*
*/
/* mapController.updateLine(mainLine, LineOptions(

            ),);*//*
*/
/*


      mapController.moveCamera(
        CameraUpdate.newLatLng(
               _fpoint
        ),
      );
      //animateNoty.updateValue(new Message(type: 'LINE_ANIM'));
    });*//*

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

  _deleteCarFromPaired(int masterId, int secondCar,) async {
    // var result=await restDatasource.savePairedCar(car);
    List<int> carIds = [secondCar];
    var result = await restDatasource.deletePairedCars(masterId, carIds);
    if (result != null) {
      if (result.IsSuccessful) {
        centerRepository.showFancyToast(result.Message);
        // setState(() {
        carsSlavePairedList.removeWhere((c) => c.CarId == secondCar);
        pairedChangedNoty.updateValue(new Message(type: 'CAR_PAIRED'));
        //});
      } else {
        centerRepository.showFancyToast(result.Message);
      }
    }
  }

  _showCarPairedActions(SlavedCar car, BuildContext context) {
    showModalBottomSheetCustom(context: context,
        mHeight: 0.70,
        builder: (BuildContext context) {
          return new Container(
            height: 250.0,
            child:
            Column(
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
                        child:
                        Button(clr: Colors.pinkAccent,
                          wid: 150.0,
                          title: Translations.current.confirm(),),),
                      onTap: () {
                        var cpaired = carsPairedList.where((c) =>
                        c.SecondCarId == car.CarId).toList();
                        if (cpaired != null && cpaired.length > 0) {
                          ApiPairedCar pairedCar = new ApiPairedCar(
                              PairedCarId: cpaired.first.PairedCarId,
                              MasterCarId: car.masterId,
                              SecondCarId: car.CarId,
                              FromDate: cpaired.first.FromDate,
                              ToDate: DateTimeUtils.getDateJalali(),
                              FromTime: cpaired.first.FromTime,
                              ToTime: DateTimeUtils.getTimeNow(),
                              Description: null,
                              IsActive: true,
                              RowStateType: Constants.ROWSTATE_TYPE_UPDATE,
                              CarIds: null,
                              master: null,
                              slaves: null);
                          addCarToPaired(
                              pairedCar, Constants.ROWSTATE_TYPE_UPDATE);
                        }
                        Navigator.pop(context);
                      },),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.0, right: 10.0, left: 10.0),
                        child:
                        Button(clr: Colors.pinkAccent,
                          wid: 150.0,
                          title: Translations.current.delete(),),),
                      onTap: () {
                        _deleteCarFromPaired(car.masterId, car.CarId);
                        Navigator.pop(context);
                      },),

                  ],
                ),


                GestureDetector(
                  child: Button(clr: Colors.pinkAccent,
                    wid: 150.0,
                    title: Translations.current.navigateToCurrent(),),
                  onTap: () {
                    Navigator.pop(context);
                    navigateToCarSelected(0, true, car.CarId);
                  },),


              ],
            ),
          );
        });
  }

  _showBottomSheetForSearchedCar(BuildContext cntext, Car car) {
    showModalBottomSheetCustom(context: cntext,
        builder: (BuildContext context) {
          return new Container(
            height: 450.0,
            child:
            new Card(
              margin: new EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 0.5),
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              child:
              new Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0xfffefefe),
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child:
                            Text(Translations.current.carId()),),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child:
                            Text(car.carId.toString()),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child:
                            Text(Translations.current.carpelak()),),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child:
                            Text(car.pelaueNumber),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child:
                            new Container(
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                              ),
                              child:
                              FlatButton(
                                  onPressed: () {
                                    String toDate = DateTimeUtils
                                        .convertIntoDateTime(
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
                                        IsActive: true,
                                        RowStateType: Constants
                                            .ROWSTATE_TYPE_INSERT,
                                        CarIds: null,
                                        master: null,
                                        slaves: null);

                                    addCarToPaired(pairedCar,
                                        Constants.ROWSTATE_TYPE_INSERT);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    Translations.current.addToPaired(),
                                    style: TextStyle(
                                        color: Colors.white),)),),),

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
        var cr = result.where((c) => c.carId == int.tryParse(carIdForSearch))
            .toList();
        if (cr != null && cr.length > 0) {
          _showBottomSheetForSearchedCar(context, cr.first);
        }
        else {
          centerRepository.showFancyToast('خودروی مورد نظر یافت نشد');
        }
      }
    }
    catch (error) {
      print('');
    }
  }

  Future<List<CarInfoVM>> getCarInfo() async {
    carsToUserSelf = centerRepository.getCarsToAdmin();

    if (_carCounts == 0) {
      if (centerRepository.getCarsToAdmin() != null)
        _carCounts = centerRepository
            .getCarsToAdmin()
            .length;
      fillCarInfo(carsToUserSelf);
    }
    var cars = await restDatasource.getAllPairedCars();
    carsPairedList = cars;
    carsSlavePairedList = new List();
    for (var c in cars) {
      for (var sc in c.slaves) {
        sc.masterId = c.master;
      }
      carsSlavePairedList..addAll(c.slaves);
    }

    fillCarsInGroup();
    return carInfos;
  }

  fillCarsInGroup() async {
    for (var car in carInfos) {
      if (carsSlavePairedList != null && carsSlavePairedList.length > 0) {
        var carfound = carsSlavePairedList.where((c) => c.CarId == car.carId)
            .toList();
        if (carfound != null && carfound.length > 0) {
          car.hasJoind = true;
        }
        else {
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
          DisplayName: null,);

        CarStateVM carState = centerRepository.getCarStateVMByCarId(
            car_info.carId);

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

  showSpeedDialog(int speed) async {
    FlashHelper.informationBar2(context,
        message: ' سرعت خودرو در این نقطه :' + speed.toString() + 'km/h');
  }

*/
/*  Future<void> processData() async {
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
  }*//*



  Future<List<Line>> processLineData(bool fromCurrent,
      String clat, String clng,
      String fromDate, String toDate,
      bool forReport, bool anim, bool fromGo) async {
    String sdate = DateTimeUtils.convertIntoDateTime(
        DateTimeUtils.getDateJalali());
    String tdate = DateTimeUtils.convertIntoDateTime(
        DateTimeUtils.getDateJalaliWithAddDays(-3));

    ApiRoute route = new ApiRoute(
        carId: lastCarIdSelected,
        startDate: forReport
            ? DateTimeUtils.convertIntoDateTime(fromDate)
            : sdate,
        endDate: forReport ? DateTimeUtils.convertIntoDateTime(toDate) : tdate,
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
            double.tryParse(firstLat[0]), double.tryParse(secondLat[0]),
            double.tryParse(secondLat[1]));

        double sresultLatLng = ConvertDegreeAngleToDouble(
            double.tryParse(firstLng[0]), double.tryParse(secondLng[0]),
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
              double.tryParse(firstLat1[0]), double.tryParse(secondLat1[0]),
              double.tryParse(secondLat1[1]));

          double sresultLatLng1 = ConvertDegreeAngleToDouble(
              double.tryParse(firstLng1[0]), double.tryParse(secondLng1[0]),
              double.tryParse(secondLng1[1]));


          double lat = fresultLatLng1;
          double lng = sresultLatLng1;
          int speed = pointDatas[i].speed;
          if (speed == null)
            speed = 0;

          if (index > 100) {
            if (i < index && speed > 0 && (i % 20) == 0)
              points += '[$lng,$lat],';
            else if (i >= index && speed > 0)
              points += '[$lng,$lat]';
          } else if (index > 300) {
            if (i < index && speed > 0 && (i % 40) == 0)
              points += '[$lng,$lat],';
            else if (i >= index && speed > 0)
              points += '[$lng,$lat]';
          }
          else if (index > 400) {
            if (i < index && speed > 0 && (i % 60) == 0)
              points += '[$lng,$lat],';
            else if (i >= index && speed > 0)
              points += '[$lng,$lat]';
          }
          else {
            if (i < index)
              points += '[$lng,$lat],';
            else
              points += '[$lng,$lat]';
          }
          //points..add(item);
          Map<String,int> _data={"Speed": speed};
          var marker = Symbol(speed.toString(),
              SymbolOptions(
                geometry: LatLng(lat, lng),
                iconImage: getMarkerUrlOnSpeed(speed),
              ),
          _data);
          */
/*width: 30.0,
              height: 30.0,
              point: LatLng(lat,lng),
              builder: (ctx) {
                return
                  GestureDetector(
                    onTap: () {
                      _showInfoPopUp = true;
                      showSpeedDialog(speed);
                    },
                    child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.transparent,
                          child: getMarkerOnSpeed(speed)
                          ,)
                    ),)*//*


          markers.add(marker);
        }
        if (points.endsWith(',')) {
          points = points.substring(0, points.length - 1);
        }
        queryBody = queryBody + points + ']}';
      } else {
        var points = '';
        double lat = 35.7511447;
        double lng = 51.4716509;
        firstPoint = LatLng(lat, lng);
        double lat2 = 35.796249;
        double lng2 = 51.427583;

        points += '[$lng,$lat],';
        points += '[$lng2,$lat2]';

        queryBody = queryBody + points + ']}';
      }
    }
    else {
      double speed = 80;
      if (_locations != null && _locations.length>0) {
        LocationData locationData=_locations[0];
        double lat1 = double.tryParse(clat);
        double lng1 = double.tryParse(clng);
        firstPoint = LatLng(lat1, lng1);
        if (clat == null || clat.isEmpty || clng == null || clng.isEmpty) {
          lat1 = 35.7511447;
          lng1 = 51.4716509;
        }

        double lat2 = double.tryParse(locationData.result.locations[0].latitude.toString());
        double lng2 = double.tryParse(locationData.result.locations[0].longitude.toString());
        speed = 0;
        if (speed == null)
          speed = 0;
        if (currentCarLocationSpeed == null || currentCarLocationSpeed == 0)
          currentCarLocationSpeed = 0;
       Map<String,int> _data={"Speed": currentCarLocationSpeed};
        var marker = Symbol(currentCarLocationSpeed.toString(),
            SymbolOptions(
              geometry: LatLng(lat1, lng1),
              iconImage: getMarkerUrlOnSpeed(currentCarLocationSpeed),
            ),_data);
        */
/*   Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(lat1,lng1),
            builder: (ctx) {
              return
                GestureDetector(
                  onTap: () {
                    _showInfoPopUp = true;
                    showSpeedDialog(int.tryParse( currentCarLocationSpeed.toString()));
                  },
                  child: Container(
                      width: 30.0,
                      height: 30.0,
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.transparent,
                        child: getMarkerOnSpeed(int.tryParse( currentCarLocationSpeed.toString())),)
                  ),);}
        );*//*

        markers.add(marker);
         _data={"Speed":int.tryParse( speed.toString())};
        marker = Symbol(speed.toString(),
            SymbolOptions(
              geometry: LatLng(lat2, lng2),
              iconImage: getMarkerUrlOnSpeed(int.tryParse(speed.toString())),
            ),_data);
        */
/*Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(lat2,lng2),
            builder: (ctx) {
              return
                GestureDetector(
                  onTap: () {
                    _showInfoPopUp = true;
                    showSpeedDialog(int.tryParse(speed.toString()));
                  },
                  child: Container(
                      width: 30.0,
                      height: 30.0,
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.transparent,
                        child:  getMarkerOnSpeed(int.tryParse( speed.toString())) ,)
                  ),);}
        );*//*

        markers.add(marker);
        queryBody = '{"coordinates":[[$lng2,$lat2],[$lng1,$lat1]]}';
      }
      else {
        centerRepository.showFancyToast(
            Translations.current.yourLocationNotFound());
      }
    }
    if (lines != null && lines.length > 0) {
      lines.clear();
    }
    markers.forEach((m){
      mapController.addSymbol(m.options);

    });
   await mapController.clearLines();
    final openRoutegeoJSON = await restDatasource
        .fetchOpenRouteServiceURlJSON(body: queryBody);
    if (openRoutegeoJSON != null) {
      final geojson = GeoJson();
      geojson.processedLines.listen((GeoJsonLine line) {
        final color = Color(
            (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
            .withOpacity(0.5);
        lines.add(new Line(
          lines.length.toString(), LineOptions(
          geometry: line.geoSerie.toLatLng().map<LatLng>((l) {
            return LatLng(l.latitude, l.longitude);
          }).toList(),
          lineColor: '#E91E63',
          lineWidth: 9.0,
          lineBlur: 10.0,
          lineGapWidth: 1.0,
          lineOpacity: 0.5,
        ),
        )
          */
/*  strokeWidth: 12.0,
            color: color,
            points: line.geoSerie.toLatLng())*//*
);
      });
      geojson.endSignal.listen((_) {
        geojson.dispose();
      });
      // unawaited(geojson.parse(data, verbose: true));
      await geojson.parse(openRoutegeoJSON, verbose: true);
    }

    if (lines != null && lines.length > 0) {
      // moreButtonNoty.updateValue(new Message(type:'CLOSE_MORE_BUTTON'));
      if(!anim) {
        lines.forEach((l) {
          mapController.addLine(l.options);
        });
      }
      if (!fromGo) {
        RxBus.post(new ChangeEvent(type: 'CLOSE_MORE_BUTTON'));
      }


    */
/*  mapController.animateCamera(
        CameraUpdate.newCameraPosition(
           CameraPosition(
            bearing: 270.0,
            target: firstPoint,
            tilt: 30.0,
            zoom: 17.0,
          ),
        ),
      ).then((result)=>print("mapController.animateCamera() returned "));*//*

      return lines;
    }

    return null;
  }


  Future<List<Symbol>> processLineDataForReportMinTime(String fromDat,
      String toDat,
      String minTime) async {
    String sdate = DateTimeUtils.convertIntoDateTime(
        DateTimeUtils.getDateJalali());
    String tdate = DateTimeUtils.convertIntoDateTime(
        DateTimeUtils.getDateJalaliWithAddDays(0));


    ApiRoute route = new ApiRoute(
        carId: lastCarIdSelected,
        startDate: (fromDat != null && fromDat.isNotEmpty) ? DateTimeUtils
            .convertIntoDateTime(fromDat) : sdate,
        endDate: (toDat != null && toDat.isNotEmpty) ? DateTimeUtils
            .convertIntoDateTime(toDat) : tdate,
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
      minDelay = 10;
    }
    centerRepository.showProgressDialog(
        context, Translations.current.loadingdata());
    var queryBody = '{"coordinates":['; //$lng2,$lat2],[$lng1,$lat1]]}';

    final pointDatas = await restDatasource.getRouteList(route);
    if (pointDatas != null && pointDatas.length > 0) {
      if (markers != null && markers.length > 0)
        markers.clear();
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
          double.tryParse(firstLat[0]), double.tryParse(secondLat[0]),
          double.tryParse(secondLat[1]));

      double sresultLatLng = ConvertDegreeAngleToDouble(
          double.tryParse(firstLng[0]), double.tryParse(secondLng[0]),
          double.tryParse(secondLng[1]));

      firstPoint = LatLng(fresultLatLng,
          sresultLatLng);
      for (var i = 0; i < pointDatas.length; i++) {
        String latStr2 = pointDatas[i].lat;
        String lngStr2 = pointDatas[i].long;
        var firstLat1 = latStr2.split('*');
        var firstLng1 = lngStr2.split('*');
        var secondLat1 = firstLat1[1].split("'");
        var secondLng1 = firstLng1[1].split("'");

        double fresultLatLng1 = ConvertDegreeAngleToDouble(
            double.tryParse(firstLat1[0]), double.tryParse(secondLat1[0]),
            double.tryParse(secondLat1[1]));

        double sresultLatLng1 = ConvertDegreeAngleToDouble(
            double.tryParse(firstLng1[0]), double.tryParse(secondLng1[0]),
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
              double.tryParse(firstLat1[0]), double.tryParse(secondLat1[0]),
              double.tryParse(secondLat1[1]));

          sresultLatLng1 = ConvertDegreeAngleToDouble(
              double.tryParse(firstLng1[0]), double.tryParse(secondLng1[0]),
              double.tryParse(secondLng1[1]));

          double lat2 = fresultLatLng1;
          double lng2 = sresultLatLng1;

          */
/*  double lat2 = double.tryParse(pointDatas[i + 1].lat);
            double lng2 = double.tryParse(pointDatas[i + 1].lat);
*//*

          int speed = pointDatas[i].speed;
          if (speed == null)
            speed = 0;
          if (i < index)
            points += '[$lng,$lat],';
          else
            points += '[$lng,$lat]';
          //points..add(item);
          // final Distance distance = new Distance();

          if (speed < 1 && (minStopTime == null || minStopTime.isEmpty)) {
            minStopDate = pointDatas[i].dateTime;
            minStopTime = pointDatas[i].enterTime;
          } else
          if (speed > 1 && (minStopTime != null && minStopTime.isNotEmpty)) {
            minStopDate2 = pointDatas[i].dateTime;
            minStopTime2 = pointDatas[i].enterTime;


            var time1 = minStopTime.split(':');
            var time2 = minStopTime2.split(':');
            */
/* int h1=int.tryParse(time1[0]);
              int m1=int.tryParse(time1[1]);
              int s1=int.tryParse(time1[2]);

              int h2=int.tryParse(time2[0]);
              int m2=int.tryParse(time2[1]);
              int s2=int.tryParse(time2[2]);*//*


            minStopDate = minStopDate.replaceAll('/', '');
            minStopDate2 = minStopDate2.replaceAll('/', '');
            if (minStopDate.trim() == minStopDate2.trim()) {
              int diff = DateTimeUtils.diffMinsFromDateToDate4(
                  DateTimeUtils.convertIntoTimeOnly(minStopTime2),
                  DateTimeUtils.convertIntoTimeOnly(minStopTime));
              if (diff > minDelay) {
                Map<String,int> _data={"Speed": speed};
                var marker = Symbol(
                    speed.toString(),
                    SymbolOptions(
                      geometry: LatLng(lat, lng),
                      iconImage: getMarkerUrlOnSpeed(
                          int.tryParse(speed.toString())),

                    ),_data);
                */
/*Marker(
                    width: 30.0,
                    height: 30.0,
                    point: LatLng(lat, lng),
                    builder: (ctx) {
                      return
                        GestureDetector(
                          onTap: () {
                            showSpeedDialog(speed);
                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              child: getMarkerOnSpeed(speed),
                            ),),);} );*//*


                markers.add(marker);
                 _data={"Speed": speed};
                marker = Symbol(speed.toString(),
                    SymbolOptions(
                      geometry: LatLng(lat2, lng2),
                      iconImage: getMarkerUrlOnSpeed(
                          int.tryParse(speed.toString())),

                    ),_data);
                */
/*Marker(
                    width: 30.0,
                    height: 30.0,
                    point: LatLng(lat2, lng2),
                    builder: (ctx){
                      return
                        GestureDetector(
                          onTap: () {
                            showSpeedDialog(speed);
                          },
                          child: Container(
                              width: 30.0,
                              height: 30.0,
                              child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset( markerRed
                                    , key: ObjectKey(Colors.red ),))
                          ),);}
                );*//*


                markers.add(marker);
                minStopTime = '';
              }
            }
          }
        }

      }

      queryBody = queryBody + points + ']}';
    } else {
      var points = '';
      double lat = 35.7511447;
      double lng = 51.4716509;
      firstPoint = LatLng(lat, lng);
      double lat2 = 35.796249;
      double lng2 = 51.427583;

      points += '[$lng,$lat],';
      points += '[$lng2,$lat2]';
      queryBody = queryBody + points + ']}';
    }


    if (markers != null && markers.length > 0) {
      if (firstPoint.longitude != markers[0].options.geometry.latitude &&
          firstPoint.longitude != markers[0].options.geometry.longitude) {
        firstPoint = markers[0].options.geometry;
      }
      markers.forEach((m){
        mapController.addSymbol(m.options);
      });
      // moreButtonNoty.updateValue(new Message(type: 'CLOSE_MORE_BUTTON'));
      RxBus.post(new ChangeEvent(type: 'CLOSE_MORE_BUTTON'));

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
           CameraPosition(
            bearing: 270.0,
            target: firstPoint,
            tilt: 30.0,
            zoom: 17.0,
          ),
        ),
      ).then((result)=>print("mapController.animateCamera() returned "));

      reportNoty.updateValue(new Message(type: 'HAS_MARKERS'));

      return markers;
    }
    return null;
  }


  _onConfirmDefaultSettings(String type, BuildContext context) async {
    _formKey.currentState.save();

    prefRepository.setMinMaxSpeed(MIN_SPEED_TAG, minSpeed);
    prefRepository.setMinMaxSpeed(MAX_SPEED_TAG, maxSpeed);
    centerRepository.showFancyToast('اطلاعات با موفقیت ذخیره شد.');

    Navigator.pop(context);
  }

  _showDefaultSettingsSheet(BuildContext context, String type) {
    showModalBottomSheetCustom(context: context,
        mHeight: 0.90,
        builder: (BuildContext context) {
          return Builder(builder:
              (context) {
            return Form(
              key: _formKey,
              child:
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 10,
                height: 450.0,
                child:
                Column(
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
                              Translations.current.maxSpeed(), 80.0,
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
                              Translations.current.minSpeed(), 80.0,
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
                                clr: Colors.green,),
                            )
                        )
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
    return
      new TextFormField(
        decoration: new InputDecoration(
          labelText: hint,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(2.0),
            borderSide: new BorderSide(
            ),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          return null;
        },
        onSaved: (value) {
          minDelay = int.tryParse(value == null ? '0' : value);
        },
        keyboardType: TextInputType.numberWithOptions(
            decimal: false, signed: false),
        style: new TextStyle(
          fontFamily: "IranSans",
        ),
        onFieldSubmitted: (value) {

        },
      );
  }

  Widget _buildMaxTextField(String hint, double width, String result) {
    return
      new TextFormField(
        decoration: new InputDecoration(
          labelText: "حداکثر سرعت",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(2.0),
            borderSide: new BorderSide(
            ),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          return null;
        },
        onSaved: (value) {
          maxSpeed = int.tryParse(value == null ? '0' : value);
        },
        keyboardType: TextInputType.numberWithOptions(
            decimal: false, signed: false),
        style: new TextStyle(
          fontFamily: "IranSans",
        ),
        onFieldSubmitted: (value) {

        },
      );
  }

  Widget _buildMinTextField(String hint, double width, String result) {
    return
      new TextFormField(
        decoration: new InputDecoration(
          labelText: "حداقل سرعت",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(2.0),
            borderSide: new BorderSide(
            ),
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
        keyboardType: TextInputType.numberWithOptions(
            decimal: false, signed: false),
        style: new TextStyle(
          fontFamily: "IranSans",
        ),
        onFieldSubmitted: (value) {

        },

      );
  }

  Widget createInfoPopup(String lastDateOnline, String lastTimeOnline,
      String pelak) {
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
              title: Text(
                  lastDateOnline, style: TextStyle(color: Colors.white)),
              subtitle: Text(
                  lastTimeOnline, style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.album, size: 70),
              title: Text(pelak, style: TextStyle(color: Colors.white)),
              subtitle: Text(
                  lastTimeOnline, style: TextStyle(color: Colors.white)),
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


    double ConvertDegreeAngleToDouble(double degrees, double minutes,
        double seconds) {
      //Decimal degrees =
      //   whole number of degrees,
      //   plus minutes divided by 60,
      //   plus seconds divided by 3600

      return degrees + (minutes / 60) + (seconds / 3600);
    }
    _showInfoDialog(int carId) async {
      List<int> carIds = new List();
      carIds..add(carId);

      ApiRoute apiRoute = new ApiRoute(carId: null,
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
            double.tryParse(firstLat[0]), double.tryParse(secondLat[0]),
            double.tryParse(secondLat[1]));

        double sresultLatLng = ConvertDegreeAngleToDouble(
            double.tryParse(firstLng[0]), double.tryParse(secondLng[0]),
            double.tryParse(secondLng[1]));

        double lat = fresultLatLng;
        double lng = sresultLatLng;
        LatLng latLng = LatLng(lat, lng);
        currentCarLatLng = LatLng(lat, lng);
        String date = result[0].Date;
        String time = result[0].Time;
        int speed = result[0].speed;

        String msgTemp = time + ' ' + 'با سرعت : ' + speed.toString() +
            ' km/h ';
        DateTime newObjDate = DateTimeUtils.convertIntoDateObject(date);
        String newDate = DateTimeUtils.getDateJalaliFromDateTimeObj(newObjDate);
        FlashHelper.informationBar2(context, title: newDate, message: msgTemp,);
      }
      else {
        FlashHelper.informationBar2(
          context, title: null, message: 'اطلاعاتی برای نمایش یافت نشد',);
      }
    }
    Future<ApiRoute> navigateToCarSelected(int index, bool isCarPaired,
        int carId) async {
      String imgUrl = '';
      CarInfoVM carInfo;
      //SlavedCar carSlave;
      if (isCarPaired) {
        // carSlave=carsSlavePairedList[index];
      }
      else {
        carInfo = carInfos[index];
      }

      List<int> carIds = new List();
      if (isCarPaired) {
        carIds..add(carId);
        imgUrl = carImgList[0];
      }
      else {
        carIds..add(carInfo.carId);
        imgUrl = carInfo != null ? carInfo.imageUrl : carImgList[0];
      }
      if (imgUrl == null || imgUrl.isEmpty) {
        imgUrl = carImgList[0];
      }
      lastCarIdSelected =
      carId > 0 ? carId : (carInfo != null) ? carInfo.carId : 0;
      ApiRoute apiRoute = new ApiRoute(carId: null,
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

        if (date != null && time != null) {
          isGPRSOn = true;
        }
        else {
          isGPRSOn = false;
        }

        DateTime gpsDt = DateTimeUtils.convertIntoDateTimeObject(GPSDateTime);
        DateTime now = DateTime.now();
        Duration diff = now.difference(gpsDt);
        if (diff.inMinutes <= 2) {
          isGPSOn = true;
        }
        else {
          isGPSOn = false;
        }

        if (speed == null)
          speed = 100;

        currentCarLocationSpeed = speed;
        String latStr = result[0].Latitude;
        String lngStr = result[0].Longitude;
        var firstLat = latStr.split('*');
        var firstLng = lngStr.split('*');
        var secondLat = firstLat[1].split("'");
        var secondLng = firstLng[1].split("'");

        double fresultLatLng = ConvertDegreeAngleToDouble(
            double.tryParse(firstLat[0]), double.tryParse(secondLat[0]),
            double.tryParse(secondLat[1]));

        double sresultLatLng = ConvertDegreeAngleToDouble(
            double.tryParse(firstLng[0]), double.tryParse(secondLng[0]),
            double.tryParse(secondLng[1]));

        double lat = fresultLatLng;
        double lng = sresultLatLng;
        LatLng latLng = LatLng(lat, lng);
        currentCarLatLng = LatLng(lat, lng);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
             CameraPosition(
              bearing: 270.0,
              target: new LatLng(lat, lng),
              tilt: 30.0,
              zoom: 17.0,
            ),
          ),
        ).then((result)=>print("mapController.animateCamera() returned "));
        var marker =  Symbol(lastCarIdSelected.toString(),
            SymbolOptions(
              geometry: LatLng(lat, lng),
              iconImage: imgUrl,
              iconSize: 0.2
            ));
        */
/*Marker(
          width: 40.0,
          height: 40.0,
          point: latLng,
          builder: (ctx) =>
              Container(
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
                            imgUrl, key: ObjectKey(Colors.green),))
                  ),),),
        );*//*


        markers.add(marker);
        markers.forEach((m){
          Map<String ,int> _data={"CarId":lastCarIdSelected};
          mapController.addSymbol(m.options,_data);

        });

       // mapController.onSymbolTapped(_showInfoDialog(lastCarIdSelected));

        statusNoty.updateValue(new Message(type: 'GPS_GPRS_UPDATE'));
      } else {
        double lat = 35.796249;
        double lng = 51.427583;

        LatLng latLng = LatLng(lat, lng);
        currentCarLatLng = LatLng(lat, lng);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 270.0,
              target: new LatLng(lat, lng),
              tilt: 30.0,
              zoom: 17.0,
            ),
          ),
        ).then((result)=>print("mapController.animateCamera() returned "));
        var marker = Symbol(lastCarIdSelected.toString(),
            SymbolOptions(
              geometry: LatLng(lat, lng),
              iconImage: imgUrl,
              iconSize: 0.2
            ));
    */
/*    Marker(

          width: 40.0,
          height: 40.0,
          point: latLng,
          builder: (ctx) =>
              Container(
                child: GestureDetector(
                  onTap: () async {
                    _showInfoPopUp = true;
                    _showInfoDialog(lastCarIdSelected);
                  },
                  child:
                  Container(
                      width: 38.0,
                      height: 38.0,
                      child: CircleAvatar(
                          radius: 38.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            imgUrl, key: ObjectKey(Colors.amber),))
                  ),),
              ),
        );*//*


        markers.add(marker);
        markers.forEach((m){
          Map<String ,int> _data={"CarId":lastCarIdSelected};
          mapController.addSymbol(m.options,_data);

        });

        statusNoty.updateValue(new Message(type: 'GPS_GPRS_UPDATE'));
      }
    }

    addCarToPaired(ApiPairedCar car, int type) async {
      if (type != Constants.ROWSTATE_TYPE_UPDATE)
        car.PairedCarId = 0;
      var result = await restDatasource.savePairedCar(car);
      if (result != null) {
        centerRepository.showFancyToast(result.Message);
        if (result.IsSuccessful) {
          centerRepository.showFancyToast(result.Message);
          pairedChangedNoty.updateValue(new Message(type: 'CAR_PAIRED'));
        }
        else {
          centerRepository.showFancyToast(result.Message);
        }
      }
    }

    onCarPageTap() {
      Navigator.of(context).pushNamed('/carpage', arguments: new CarPageVM(
          userId: centerRepository
              .getUserCached()
              .id,
          isSelf: true,
          carAddNoty: valueNotyModelBloc));
    }


    _showBottomSheetLastCars(BuildContext cntext, List<ApiPairedCar> cars) {
      showModalBottomSheetCustom(context: cntext,
          builder: (BuildContext context) {
            return new Container(
              height: 450.0,
              child:
              new Card(
                margin: new EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 0.0,
                child:
                new Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: Color(0xfffefefe),
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(5.0)),
                  ),
                  child:
                  PairedCarsExpandPanel(cars: cars,),
                ),
              ),
            );
          });
    }
    initDatePicker(TextEditingController controller, String type) {
      persianDatePicker = PersianDatePicker(
        controller: controller,
        datetime: Jalali.now().toString(),
        fontFamily: 'IranSans',
        onChange: (String oldText, String newText) {
          if (type == 'From')
            fromDate = newText;
          else
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
      var cars = await restDatasource.getAllPairedCars();
      if (cars != null && cars.length > 0)
        _showBottomSheetLastCars(cntext, cars);
    }
    _showBottomSheetDates(BuildContext cntext) {
      showModalBottomSheetCustom(context: cntext,
          mHeight: 0.95,
          builder: (BuildContext context) {
            return
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(Translations.current.fromDate(),
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                    textAlign: TextAlign.center,),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.35,
                    child: initDatePicker(textEditingController, 'From'),
                  ),
                  Text(Translations.current.toDate(),
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                    textAlign: TextAlign.center,),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.35,
                    child: initDatePicker(textEditingController, 'To'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 10.0),
                        child:
                        FlatButton(
                          child: Button(wid: 120.0,
                            clr: Colors.pinkAccent,
                            title: Translations.current.doFilter(),),
                          onPressed: () {
                            if (lastCarIdSelected == null ||
                                lastCarIdSelected == 0) {
                              centerRepository.showFancyToast(
                                  'لطفا ابتدا خودرو را انتخاب نمایید');
                            } else {
                              forAnim = false;
                              Navigator.pop(context);
                              lines2 = processLineData(
                                  false,
                                  currentCarLatLng.latitude.toString(),
                                  currentCarLatLng.longitude.toString(),
                                  fromDate,
                                  toDate,
                                  true,
                                  false,
                                  false);
                              Navigator.pop(context);
                            }
                          },
                        ),),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 10.0),
                        child:
                        FlatButton(
                          child: Button(wid: 120.0,
                            clr: Colors.pinkAccent,
                            title: Translations.current.close(),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),),
                    ],
                  )
                ],
              );
          });
    }
    showFilterDate(BuildContext context, bool from) {
      return _showBottomSheetDates(context);
    }
    _showBottomSheetReport(BuildContext cntext) {
      double wid = MediaQuery
          .of(cntext)
          .size
          .width * 0.75;
      showModalBottomSheetCustom(context: cntext,
          mHeight: 0.85,
          builder: (BuildContext context) {
            return Stack(
              overflow: Overflow.visible,
              //alignment: Alignment.topCenter,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              'اگر تاریخ را انتخاب نکنید بصورت پیش فرض روز جاری در نظر گرفته میشود',style: TextStyle(fontSize: 11.0),)
                        ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.only(
                                top: 5.0, right: 5.0, left: 5.0),
                            constraints: new BoxConstraints.expand(
                              height: 48.0,
                              width: wid,
                            ),
                            decoration: BoxDecoration(
                              //color: Colors.pinkAccent,
                              border: Border(),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  15.0)),
                            ),
                            child: FlatButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                showFilterDate(context, true);
                              },
                              child: Button(title: Translations.current
                                  .fromDateToDate(), wid: wid, clr: Colors
                                  .blueAccent,),
                            )
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.85,
                          height: 400,
                          child:

                          new ListView (
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.all(0.0),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.80,
                                height: 400,
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.75,
                                      child:
                                      Form(
                                        key: _formKey,
                                        autovalidate: _autoValidate,
                                        child:
                                        SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          child: new Column(
                                            children: <Widget>[
                                              Container(
                                                //height: 45,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 2.0),
                                                child:
                                                _buildMinDelayTextField(
                                                    'حداقل زمان توقف دقیقه',
                                                    150.0, null),
                                              ),
                                              Container(
                                                //height: 45,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 2.0),
                                                child:
                                                _buildMinTextField(
                                                    'حداقل سرعت', 150.0, null),


                                              ),
                                              Container(
                                                //height: 45,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 2.0),
                                                child:
                                                _buildMaxTextField(
                                                    'حداکثر سرعت', 150.0, null),
                                              ),
                                              new GestureDetector(
                                                onTap: () {},

                                                child: new Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5.0,
                                                        right: 5.0,
                                                        left: 5.0,
                                                        bottom: 5.0),
                                                    constraints: new BoxConstraints
                                                        .expand(
                                                      height: 48.0,
                                                      width: wid,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      //color: Colors.pinkAccent,
                                                      border: Border(),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                          15.0)),
                                                    ),
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        if (lastCarIdSelected ==
                                                            null ||
                                                            lastCarIdSelected ==
                                                                0) {
                                                          centerRepository
                                                              .showFancyToast(
                                                              'لطفا ابتدا خودرو را انتخاب نمایید');
                                                        } else {
                                                          forAnim = false;
                                                          _formKey.currentState
                                                              .save();
                                                          processLineDataForReportMinTime(
                                                              fromDate, toDate,
                                                              minDelay
                                                                  .toString());
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Button(
                                                        title: Translations
                                                            .current
                                                            .showReport(),
                                                        wid: wid,
                                                        clr: Colors
                                                            .blueAccent,),
                                                    )
                                                ),

                                              ),
                                              Padding(padding: EdgeInsets.only(
                                                  bottom: 10.0),
                                                child:
                                                new GestureDetector(
                                                  onTap: () {
                                                    if (lastCarIdSelected ==
                                                        null ||
                                                        lastCarIdSelected ==
                                                            0) {
                                                      centerRepository
                                                          .showFancyToast(
                                                          'لطفا ابتدا خودرو را انتخاب نمایید');
                                                    } else {
                                                      _formKey.currentState
                                                          .save();
                                                      forAnim = true;
                                                      lines2 = processLineData(
                                                          false,
                                                          currentCarLatLng
                                                              .latitude
                                                              .toString(),
                                                          currentCarLatLng
                                                              .longitude
                                                              .toString(),
                                                          fromDate,
                                                          toDate,
                                                          true,
                                                          true,
                                                          false);
                                                      lines2.then((result) {
                                                        if (result != null &&
                                                            result.length > 0) {
                                                          reportNoty
                                                              .updateValue(
                                                              new Message(
                                                                  type: 'ANIM_ROUTE'));
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child:
                                                  Container(
                                                    width: wid,
                                                    height: 40.0,
                                                    child:
                                                    new Button(
                                                      title: 'گزارش با حرکت خودرو در مسیر',
                                                      color: Colors.white.value,
                                                      clr: Colors.pinkAccent,),
                                                  ),
                                                ),),
                                              new GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                Container(
                                                  width: wid,
                                                  height: 40.0,
                                                  child:
                                                  new Button(
                                                    title: Translations.current
                                                        .cancel(),
                                                    color: Colors.white.value,
                                                    clr: Colors.pinkAccent,),
                                                ),
                                              ),
                                            ],
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
                      children: <Widget>[
                      ],
                    ),
                  ],
                ),
              ],
            );
          });
    }

    _showReportSheet(BuildContext context) async {
      _showBottomSheetReport(context);
    }

    _showMapGuid(BuildContext context) async {
      _showBottomSheetGuid(context);
    }

    _showBottomSheetGuid(BuildContext context) {
      double wid = MediaQuery
          .of(context)
          .size
          .width * 0.95;
      showModalBottomSheetCustom(context: context,
          mHeight: 0.85,
          builder: (BuildContext context) {
            return new Padding(
              padding: EdgeInsets.only(top: 10.0, right: 10.0),
              child:
              Container(
                width: wid,
                child:
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 68,
                            height: 68,
                            child:
                            Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 10.0),
                              child:
                              Image.asset(markerRed),
                            ),),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.70,
                            height: 48,
                            child:
                            Text(
                              'نقاط قرمز برروی نقشه نشان از سرعت بالای 100 کیلومتر می باشد',
                              softWrap: true, style: TextStyle(
                                fontSize: 13.0),),),
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
                              child:
                              Image.asset(markerRed, color: Colors.amber,),),
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.70,
                            height: 48,
                            child:
                            Text(
                              'نقاط زرد برروی نقشه نشان از سرعت زیر 30 کیلومتر می باشد',
                              softWrap: true, style: TextStyle(
                                fontSize: 13.0),),),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.80,
                            height: 48,
                            child:
                            Text(
                              'با لمس هر نقطه اطلاعات سرعت و ... را مشاهده نمایید.',
                              softWrap: true, style: TextStyle(
                                fontSize: 13.0),),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.80,
                            height: 48,
                            child:
                            Text(
                              'برای گزارش حرکت خودرو با انتخاب تاریخ تا تاریخ و انتخاب تاریخ مورد نظر ',
                              softWrap: true, style: TextStyle(
                                fontSize: 13.0),),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.80,
                            height: 48,
                            child:
                            Text(
                              'و سپس لمس دکمه بستن در منوی زیرین گزارش مسیر با حرکت خودرو را انتخاب کنید',
                              softWrap: true, style: TextStyle(
                                fontSize: 13.0),),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.80,
                            height: 80,
                            child:
                            Text(
                              'جهت تایید یا رد درخواست افزودن خودرو به ارتباط گروهی در منوی پایین در قسمت مرتبط به خودروها جهت افزودن به گروه با لمس هر وخدور میتوانید تایید یا رد درخواست کنید.',
                              softWrap: true, style: TextStyle(
                                fontSize: 13.0),),),
                        ],
                      )
                    ]
                ),
              ),
            );
          });
    }

    showRouteCurrentToCar() async {
      if (lastCarIdSelected == null || lastCarIdSelected == 0) {
        centerRepository.showFancyToast('لطفا ابتدا خودرو را انتخاب نمایید');
      } else {
        lines2 = processLineData(
            true,
            currentCarLatLng.latitude.toString(),
            currentCarLatLng.longitude.toString(),
            '',
            '',
            false,
            false,
            true);
      }
    }

    showCarRoute() {
      if (lastCarIdSelected == null || lastCarIdSelected == 0) {
        centerRepository.showFancyToast('لطفا ابتدا خودرو را انتخاب نمایید');
      } else {
        lines2 = processLineData(
            false,
            '',
            '',
            '',
            '',
            false,
            false,
            false);
      }
    }


    MapUiBodyState();

    static final CameraPosition _kInitialPosition = const CameraPosition(
      target: LatLng(35.6917856, 51.4204603),
      zoom: 15.0,
    );

    MapboxMapController mapController;
    CameraPosition _position = _kInitialPosition;
    bool _isMoving = false;
    bool _compassEnabled = true;
    CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
    MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
    String _styleString = MapboxStyles.MAPBOX_STREETS;
    bool _rotateGesturesEnabled = true;
    bool _scrollGesturesEnabled = true;
    bool _tiltGesturesEnabled = true;
    bool _zoomGesturesEnabled = true;
    bool _myLocationEnabled = true;
    bool _telemetryEnabled = true;
    MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode
        .Tracking;

    @override
    void initState() {
      super.initState();
      _onCurrentPressed();
      initPlatformState();


      getUserId();
      //getMinMaxSpeed();
     // location = new Location();
     // mapController=new MapController();
      reportNoty=new NotyBloc<Message>();
      pairedChangedNoty=new NotyBloc<Message>();
      moreButtonNoty=new NotyBloc<Message>();
      animateNoty=new NotyBloc<Message>();
      statusNoty=new NotyBloc<Message>();
      showAllItemsdNoty=NotyBloc<Message>();
      carInfoss= getCarInfo();



     */
/* location.onLocationChanged().listen((LocationData currentLocation) {
        print(currentLocation.latitude);
        print(currentLocation.longitude);

      });*//*


    }

    void _onMapChanged() {
      setState(() {
        _extractMapInfo();
      });
    }

    void _extractMapInfo() {
      _position = mapController.cameraPosition;
      _isMoving = mapController.isCameraMoving;
    }

    @override
    void dispose() {
      mapController.removeListener(_onMapChanged);
      _subscriptions.forEach((it) => it.cancel());
      super.dispose();
    }

  enableLocationServices() async {
    Geolocation.enableLocationServices().then((result) {
      // Request location
    }).catchError((e) {
      // Location Services Enablind Cancelled
    });
  }

  GeolocationResult _locationOperationalResult;
  GeolocationResult _requestPermissionResult;

  _checkLocationOperational() async {
    final GeolocationResult result = await Geolocation.isLocationOperational();

    if (mounted) {
      setState(() {
        _locationOperationalResult = result;
      });
    }
  }

  _requestPermission() async {
    final GeolocationResult result =
    await Geolocation.requestLocationPermission(
      permission: const LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if (mounted) {
      setState(() {
        _requestPermissionResult = result;
      });
    }
  }

    Widget _myLocationTrackingModeCycler() {
      final MyLocationTrackingMode nextType =
      MyLocationTrackingMode.values[(_myLocationTrackingMode.index + 1) %
          MyLocationTrackingMode.values.length];
      return FlatButton(
        child: Text('change to $nextType'),
        onPressed: () {
          setState(() {
            _myLocationTrackingMode = nextType;
          });
        },
      );
    }

    Widget _compassToggler() {
      return FlatButton(
        child: Text('${_compassEnabled ? 'disable' : 'enable'} compasss'),
        onPressed: () {
          setState(() {
            _compassEnabled = !_compassEnabled;
          });
        },
      );
    }

    Widget _latLngBoundsToggler() {
      return FlatButton(
        child: Text(
          _cameraTargetBounds.bounds == null
              ? 'bound camera target'
              : 'release camera target',
        ),
        onPressed: () {
          setState(() {
            _cameraTargetBounds = _cameraTargetBounds.bounds == null
                ? CameraTargetBounds(sydneyBounds)
                : CameraTargetBounds.unbounded;
          });
        },
      );
    }

    Widget _zoomBoundsToggler() {
      return FlatButton(
        child: Text(_minMaxZoomPreference.minZoom == null
            ? 'bound zoom'
            : 'release zoom'),
        onPressed: () {
          setState(() {
            _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
                ? const MinMaxZoomPreference(12.0, 16.0)
                : MinMaxZoomPreference.unbounded;
          });
        },
      );
    }

    Widget _setStyleToSatellite(String style) {
      return FlatButton(
        child: Text('change map style to Satellite'),
        onPressed: () {
          setState(() {
            _styleString = style;
          });
        },
      );
    }

    changeStyleTo(String style){

      setState(() {
        _styleString = showSattelite ? MapboxStyles.SATELLITE_STREETS : MapboxStyles.MAPBOX_STREETS;
      });
    }
    Widget _rotateToggler() {
      return FlatButton(
        child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
        onPressed: () {
          setState(() {
            _rotateGesturesEnabled = !_rotateGesturesEnabled;
          });
        },
      );
    }

    Widget _scrollToggler() {
      return FlatButton(
        child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
        onPressed: () {
          setState(() {
            _scrollGesturesEnabled = !_scrollGesturesEnabled;
          });
        },
      );
    }

    Widget _tiltToggler() {
      return FlatButton(
        child: Text('${_tiltGesturesEnabled ? 'disable' : 'enable'} tilt'),
        onPressed: () {
          setState(() {
            _tiltGesturesEnabled = !_tiltGesturesEnabled;
          });
        },
      );
    }

    Widget _zoomToggler() {
      return FlatButton(
        child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
        onPressed: () {
          setState(() {
            _zoomGesturesEnabled = !_zoomGesturesEnabled;
          });
        },
      );
    }

    Widget _myLocationToggler() {
      return FlatButton(
        child: Text('${_myLocationEnabled ? 'disable' : 'enable'} my location'),
        onPressed: () {
          setState(() {
            _myLocationEnabled = !_myLocationEnabled;
          });
        },
      );
    }

    Widget _telemetryToggler() {
      return FlatButton(
        child: Text('${_telemetryEnabled ? 'disable' : 'enable'} telemetry'),
        onPressed: () {
          setState(() {
            _telemetryEnabled = !_telemetryEnabled;
          });
          mapController?.setTelemetryEnabled(_telemetryEnabled);
        },
      );
    }

    Widget _visibleRegionGetter() {
      return FlatButton(
        child: Text('get currently visible region'),
        onPressed: () async {
          var result = await mapController.getVisibleRegion();
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(
              "SW: ${result.southwest.toString()} NE: ${result.northeast
                  .toString()}"),));
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      final MapboxMap mapboxMap = MapboxMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: _kInitialPosition,
          trackCameraPosition: false,
          compassEnabled: _compassEnabled,
          cameraTargetBounds: _cameraTargetBounds,
          minMaxZoomPreference: _minMaxZoomPreference,
          styleString: _styleString,
          rotateGesturesEnabled: _rotateGesturesEnabled,
          scrollGesturesEnabled: _scrollGesturesEnabled,
          tiltGesturesEnabled: _tiltGesturesEnabled,
          zoomGesturesEnabled: _zoomGesturesEnabled,
          myLocationEnabled: _myLocationEnabled,
          myLocationTrackingMode: _myLocationTrackingMode,
          myLocationRenderMode: MyLocationRenderMode.GPS,
          gestureRecognizers:
          <Factory<OneSequenceGestureRecognizer>>[
            Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
            ),
          ].toSet(),
          onMapClick: (point, latLng) async {
            print("${point.x},${point.y}   ${latLng.latitude}/${latLng
                .longitude}");
            List features = await mapController.queryRenderedFeatures(
                point, [], null);
            if (features.length > 0) {
              print(features[0]);
            }
          },
          onCameraTrackingDismissed: () {
            this.setState(() {
              _myLocationTrackingMode = MyLocationTrackingMode.None;
            });
          }
      );


      final List<Widget> columnChildren = <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.75,
              child: mapboxMap,
            ),
          ),
        ),
      ];

      */
/*  if (mapController != null) {
      columnChildren.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              Text('camera bearing: ${_position.bearing}'),
              Text(
                  'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
                  '${_position.target.longitude.toStringAsFixed(4)}'),
              Text('camera zoom: ${_position.zoom}'),
              Text('camera tilt: ${_position.tilt}'),
              Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
              _compassToggler(),
              _myLocationTrackingModeCycler(),
              _latLngBoundsToggler(),
              _setStyleToSatellite(),
              _zoomBoundsToggler(),
              _rotateToggler(),
              _scrollToggler(),
              _tiltToggler(),
              _zoomToggler(),
              _myLocationToggler(),
              _telemetryToggler(),
              _visibleRegionGetter(),
            ],
          ),
        ),
      );
    }*//*

      return Scaffold(
        appBar: AppBar(title: const Text('')),
        body:
        StreamBuilder<Message>(
          //initialData: new Message(t),
          stream: pairedChangedNoty.noty,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data.type == 'CAR_PAIRED')
                getCarInfo();
            }

            return
              FutureBuilder<List<CarInfoVM>>(
                future: carInfoss,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null) {
                    final parallaxCardItemsList = <ParallaxCardItem>[
                      for(var car in carInfos)
                        ParallaxCardItem(
                            backColor: (car.hasJoind != null && car.hasJoind)
                                ? Colors.lightBlue
                                : Colors.white,
                            title: DartHelper.isNullOrEmptyString(
                                car.car.pelaueNumber),
                            body: DartHelper.isNullOrEmptyString(
                                car.carId.toString()),
                            background: Container(
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
                      for(var car in carsSlavePairedList)
                        ParallaxCardItem(
                          backColor: Colors.blueAccent,
                          title: DartHelper.isNullOrEmptyString(car.BrandTitle),
                          body: DartHelper.isNullOrEmptyString(car.CarId
                              .toString()),
                          background: Container(
                            width: 160.0,
                            color: Theme
                                .of(context)
                                .cardColor,
                            child: Container(
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[

                                  Row(
                                    children: <Widget>[
                                      Text(Translations.current.thisCarPaired(),
                                        style: TextStyle(fontSize: 10.0),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text(Translations.current.masterCarId(),
                                          style: TextStyle(fontSize: 10.0)),
                                      Text(DartHelper.isNullOrEmptyString(
                                          car.masterId.toString()),
                                          style: TextStyle(fontSize: 10.0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(DartHelper.isNullOrEmptyString(
                                          car.CarModelTitle),
                                          style: TextStyle(fontSize: 10.0)),
                                      Container(
                                        width: 50.0,
                                        // color:  Colors.lightBlue ,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 30.0,
                                          child: Image.asset(carImgList[1]),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(DartHelper.isNullOrEmptyString(
                                          car.CarModelDetailTitle),
                                          style: TextStyle(fontSize: 10.0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ];

                    return
                      StreamBuilder<Message>(
                        stream: showAllItemsdNoty.noty,
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null) {

                          }
                          return
                            ExtendedNavigationBarScaffold(
                              notyBloc: moreButtonNoty,
                              key: _scaffoldKey,
                              drawer: AppDrawer(userName: userName,
                                currentRoute: route,
                                imageUrl: imageUrl,
                                carPageTap: onCarPageTap,
                                carId: widget.mapVM.carId,),
                              body:
                              Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[

                                            StreamBuilder<Message>(
                                              stream: reportNoty.noty,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData &&
                                                    snapshot.data != null) {
                                                  Message msg = snapshot.data;
                                                  if (msg.type ==
                                                      'ANIM_ROUTE') {
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
                                                    if (_polyLineAnim != null) {
                                                      forAnim = false;
                                                      _polyLineAnim = null;
                                                    }

                                                    if (lines != null &&
                                                        lines.length > 0) {
                                                      lines.clear();
                                                    }
                                                    if (markers != null &&
                                                        markers.length > 0) {
                                                      markers.clear();
                                                    }
                                                    if (lines2 != null) {
                                                      lines2 = null;
                                                    }
                                                    mapController.clearLines();
                                                  }
                                                }
                                                return StreamBuilder<Message>(
                                                  stream: animateNoty.noty,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.data != null) {
                                                      if (_fpoint != null)
                                                        {
                                                          mapController.animateCamera(
                                                            CameraUpdate.newCameraPosition(
                                                              CameraPosition(
                                                                bearing: 270.0,
                                                                target: _fpoint,
                                                                tilt: 30.0,
                                                                zoom: 17.0,
                                                              ),
                                                            ),
                                                          ).then((result)=>print("mapController.animateCamera() returned "));
                                                        }

                                                    }
                                                    return

                                                      StreamBuilder<Message>(
                                                        stream: statusNoty.noty,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData &&
                                                              snapshot.data !=
                                                                  null) {}
                                                          return
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .all(0.0),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        top: 0.0,
                                                                        bottom: 0.0),
                                                                    child: Container(),
                                                                  ),
                                                                  Flexible(
                                                                    child: Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        mapboxMap,
                                                                        showAllItemsOnMap
                                                                            ? Positioned(
                                                                          right: 20.0,
                                                                          bottom: 360.0,
                                                                          child:
                                                                          Container(
                                                                            width: 38.0,
                                                                            height: 38.0,
                                                                            child:
                                                                            FloatingActionButton(
                                                                              onPressed: () {
                                                                                showSattelite =
                                                                                !showSattelite;
                                                                                */
/*showAllItemsdNoty
                                                                                    .updateValue(
                                                                                    new Message(
                                                                                        type: 'SATTELITE'));*//*

                                                                               changeStyleTo(MapboxStyles.SATELLITE_STREETS);
                                                                              },
                                                                              child: Container(
                                                                                width: 38.0,
                                                                                height: 38.0,
                                                                                child: Image
                                                                                    .asset(
                                                                                  'assets/images/sattelite.png',
                                                                                  color: showAllItemsOnMap
                                                                                      ? Colors
                                                                                      .white
                                                                                      : Colors
                                                                                      .amber,),),
                                                                              elevation: 0.0,
                                                                              backgroundColor: Colors
                                                                                  .blueAccent,
                                                                              heroTag: 'SATTELITE',
                                                                            ),
                                                                          ),
                                                                        )
                                                                            : Container(),
                                                                        Positioned(
                                                                          right: 20.0,
                                                                          bottom: 210.0,
                                                                          child:
                                                                          Container(
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
                                                                                        type: 'CLEAR_ALL'));
                                                                              },
                                                                              child: Container(
                                                                                width: 38.0,
                                                                                height: 38.0,
                                                                                child: Image
                                                                                    .asset(
                                                                                  'assets/images/clear_all.png',
                                                                                  color: showAllItemsOnMap
                                                                                      ? Colors
                                                                                      .white
                                                                                      : Colors
                                                                                      .amber,),),
                                                                              elevation: 0.0,
                                                                              backgroundColor: Colors
                                                                                  .blueAccent,
                                                                              heroTag: 'CLEARALL2',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        showAllItemsOnMap
                                                                            ? Positioned(
                                                                          right: 20.0,
                                                                          bottom: 310.0,
                                                                          child:
                                                                          Container(
                                                                            width: 38.0,
                                                                            height: 38.0,
                                                                            child:
                                                                            FloatingActionButton(
                                                                              onPressed: () {
                                                                                reportNoty
                                                                                    .updateValue(
                                                                                    new Message(
                                                                                        type: 'CLEAR_MAP'));
                                                                              },
                                                                              child: Container(
                                                                                width: 38.0,
                                                                                height: 38.0,
                                                                                child: Image
                                                                                    .asset(
                                                                                  'assets/images/clear_map.png',
                                                                                  color: Colors
                                                                                      .white,),),
                                                                              elevation: 3.0,
                                                                              backgroundColor: Colors
                                                                                  .blueAccent,
                                                                              heroTag: 'ClearMap1',
                                                                            ),
                                                                          ),
                                                                        )
                                                                            : Container(),
                                                                        showAllItemsOnMap
                                                                            ? Positioned(
                                                                          right: 20.0,
                                                                          bottom: 260.0,
                                                                          child:
                                                                          Container(
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
                                                                                child: Image
                                                                                    .asset(
                                                                                  'assets/images/go.png',
                                                                                  color: Colors
                                                                                      .white,),),
                                                                              elevation: 0.0,
                                                                              backgroundColor: Colors
                                                                                  .blueAccent,
                                                                              heroTag: 'GO1',
                                                                            ),
                                                                          ),
                                                                        )
                                                                            : Container(),
                                                                        Positioned(
                                                                          right: 20.0,
                                                                          bottom: 160.0,
                                                                          child:
                                                                          Container(
                                                                            width: 38.0,
                                                                            height: 38.0,
                                                                            child:
                                                                            FloatingActionButton(
                                                                              onPressed: () {
                                                                                //showRouteCurrentToCar();
                                                                                _onCurrentPressed();
                                                                              },
                                                                              child: Container(
                                                                                width: 38.0,
                                                                                height: 38.0,
                                                                                child: Image
                                                                                    .asset(
                                                                                  'assets/images/current_loc.png',
                                                                                  color: Colors
                                                                                      .white,),),
                                                                              elevation: 0.0,
                                                                              backgroundColor: Colors
                                                                                  .blueAccent,
                                                                              heroTag: 'CURRENT',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        showAllItemsOnMap
                                                                            ? Positioned(
                                                                          left: 10.0,
                                                                          top: 10.0,
                                                                          child:
                                                                          Container(
                                                                            width: 38.0,
                                                                            height: 38.0,
                                                                            child:
                                                                            FloatingActionButton(
                                                                              onPressed: () {

                                                                              },
                                                                              child: Container(
                                                                                width: 38.0,
                                                                                height: 38.0,
                                                                                child: isGPSOn
                                                                                    ? ImageNeonGlow(
                                                                                  imageUrl: 'assets/images/gps.png',
                                                                                  counter: 0,
                                                                                  color: Colors
                                                                                      .indigoAccent,)
                                                                                    :
                                                                                Image
                                                                                    .asset(
                                                                                  'assets/images/gps.png',
                                                                                  color: Colors
                                                                                      .white,),),
                                                                              elevation: 1.0,
                                                                              backgroundColor: Colors
                                                                                  .transparent,
                                                                              heroTag: 'GPS',
                                                                            ),
                                                                          ),
                                                                        )
                                                                            : Container(),
                                                                        showAllItemsOnMap
                                                                            ? Positioned(
                                                                          left: 60.0,
                                                                          top: 10.0,
                                                                          child:
                                                                          Container(
                                                                            width: 38.0,
                                                                            height: 38.0,
                                                                            child:
                                                                            FloatingActionButton(
                                                                              onPressed: () {

                                                                              },
                                                                              child: Container(
                                                                                width: 38.0,
                                                                                height: 38.0,
                                                                                child: isGPRSOn
                                                                                    ? ImageNeonGlow(
                                                                                  imageUrl: 'assets/images/gprs.png',
                                                                                  counter: 0,
                                                                                  color: Colors
                                                                                      .indigoAccent,)
                                                                                    :
                                                                                Image
                                                                                    .asset(
                                                                                  'assets/images/gprs.png',
                                                                                  color: Colors
                                                                                      .white,),),
                                                                              elevation: 1.0,
                                                                              backgroundColor: Colors
                                                                                  .transparent,
                                                                              heroTag: 'GPRS',
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
                                            ),


                                ],
                              ),
                              elevation: 0,
                              floatingAppBar: true,
                              floatAppbar:
                              Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment(1, -1),
                                    child:
                                    Container(
                                      width: 0.0,
                                      height: 0.0,

                                      */
/*AppBar(
                                        automaticallyImplyLeading: true,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0.0,
                                        actions: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.arrow_forward,
                                              color: Colors.indigoAccent,),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/home');
                                            },
                                          ),
                                        ],
                                        leading: null,
                                      ),*//*

                                    ),
                                  ),
                                  showAllItemsOnMap ? Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child:
                                    Container(
                                      color: Colors.transparent,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width - 10,
                                      height: 100.0,
                                      child:
                                      PageTransformer(
                                        pageViewBuilder: (context,
                                            visibilityResolver) {
                                          return
                                            PageView.builder(
                                              physics: BouncingScrollPhysics(),
                                              controller: PageController(
                                                viewportFraction: 0.5,),
                                              itemCount: parallaxCardItemsList
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final item = parallaxCardItemsList[index];
                                                final pageVisibility =
                                                visibilityResolver
                                                    .resolvePageVisibility(
                                                    index);
                                                return GestureDetector(
                                                  onTap: () {
                                                    navigateToCarSelected(
                                                        index, false, 0);
                                                  },
                                                  child:
                                                  Container(
                                                    color: Colors.white
                                                        .withOpacity(0.0),
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
                                  ) : Container(),
                                ],),
                              appBar: null */
/*AppBar(
                      shape: kAppbarShape,
                      actions: <Widget>[
                      ],
                      leading: IconButton(
                        icon: Icon(
                          EvaIcons.person,
                          color: Colors.pinkAccent,
                        ),
                        onPressed: () {},
                      ),
                      title: Text(
                        'خودروهای تعریف شده',
                        style: TextStyle(color: Colors.black),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.white,
                    )*//*
,
                              navBarColor: Colors.white,
                              navBarIconColor: Colors.blueAccent,
                              moreButtons: [
                                MoreButtonModel(
                                  icon: MaterialCommunityIcons.account_question,
                                  label: 'درخواست ها',
                                  onTap: () {
                                    showLastCarJoint(context);
                                  },
                                ),
                                MoreButtonModel(
                                  icon: MaterialCommunityIcons.parking,
                                  label: 'مسیر طی شده',
                                  onTap: () {
                                    showCarRoute();
                                  },
                                ),
                                MoreButtonModel(
                                  icon: FontAwesome.book,
                                  label: 'گزارش مسیر',
                                  onTap: () {
                                    _showReportSheet(context);
                                  },
                                ),

                                MoreButtonModel(
                                  icon: MaterialCommunityIcons
                                      .help_circle_outline,
                                  label: 'راهنما',
                                  onTap: () {
                                    _showMapGuid(context);
                                  },
                                ),

                                null,

                                null,

                                null,
                                null,

                                null,
                              ],
                              searchWidget: Container(
                                width: 350.0,
                                height: 300,
                                child:
                                Stack(
                                  children: <Widget>[
                                    new ListView (
                                      physics: BouncingScrollPhysics(),
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          //margin: EdgeInsets.symmetric(horizontal: 20.0),
                                          children: <Widget>[
                                            SizedBox(
                                              height: 0,
                                            ),
                                            */
/* FlatButton(
                          onPressed: (){ showLastCarJoint(context);},
                          child: Button(color: Colors.blueAccent.value,wid: 220,title: Translations.current.carJoindBefore(),),
                        ),*//*

                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.70,
                                              child:
                                              Form(
                                                key: _formKey2,
                                                autovalidate: _autoValidate,
                                                child:
                                                SingleChildScrollView(
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  physics: BouncingScrollPhysics(),
                                                  child: new Column(
                                                    children: <Widget>[

                                                      Container(
                                                        //height: 45,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: 2.0,
                                                            horizontal: 2.0),
                                                        child:
                                                        FormBuilderTextField(
                                                          initialValue: '',
                                                          attribute: "CarId",
                                                          decoration: InputDecoration(
                                                            errorStyle: TextStyle(
                                                                color: Colors
                                                                    .pinkAccent),
                                                            labelText: Translations
                                                                .current
                                                                .carId(),
                                                          ),
                                                          onChanged: (value) =>
                                                              _onCarIdChanged(
                                                                  value),
                                                          valueTransformer: (
                                                              text) =>
                                                              num.tryParse(
                                                                  text),
                                                          // autovalidate: true,
                                                          validators: [
                                                            FormBuilderValidators
                                                                .required(),
                                                            FormBuilderValidators
                                                                .numeric(),
                                                            FormBuilderValidators
                                                                .maxLength(20),
                                                          ],
                                                          keyboardType: TextInputType
                                                              .number,
                                                        ),

                                                      ),
                                                      Container(
                                                        // height: 45,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: 2.0,
                                                            horizontal: 2.0),
                                                        child:
                                                        FormBuilderTextField(
                                                          initialValue: '',
                                                          attribute: "SerialNumber",
                                                          decoration: InputDecoration(
                                                            errorStyle: TextStyle(
                                                                color: Colors
                                                                    .pinkAccent),
                                                            labelText: Translations
                                                                .current
                                                                .serialNumber(),
                                                          ),
                                                          onChanged: (value) =>
                                                              _onMobileChanged(
                                                                  value),
                                                          valueTransformer: (
                                                              text) => text,
                                                          validators: [],
                                                          keyboardType: TextInputType
                                                              .text,
                                                        ),
                                                      ),
                                                      Container(
                                                        // height: 45,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: 2.0,
                                                            horizontal: 2.0),
                                                        child:
                                                        FormBuilderTextField(
                                                          initialValue: '',
                                                          attribute: "Pelak",
                                                          inputFormatters: [
                                                            BlacklistingTextInputFormatter(
                                                                RegExp(
                                                                    "[,@#%^&*()+=!.`~\"';:?؟و/\\\\]"))
                                                          ],
                                                          decoration: InputDecoration(
                                                            errorStyle: TextStyle(
                                                                color: Colors
                                                                    .pinkAccent),
                                                            labelText: Translations
                                                                .current
                                                                .carpelak(),
                                                          ),
                                                          onChanged: (value) =>
                                                              _onPelakChanged(
                                                                  value),
                                                          valueTransformer: (
                                                              text) => text,
                                                          validators: [],
                                                          // keyboardType: TextInputType.text,
                                                        ),
                                                      ),


                                                      new GestureDetector(
                                                        onTap: () {
                                                          // _formKey2.currentState.save();
                                                          if (_formKey2
                                                              .currentState
                                                              .validate())
                                                            searchCar();
                                                        },
                                                        child:
                                                        Container(

                                                          child:
                                                          new SendData(),
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
                              ),
                              // onTap: (button) {},
                              // currentBottomBarCenterPercent: (currentBottomBarParallexPercent) {},
                              // currentBottomBarMorePercent: (currentBottomBarMorePercent) {},
                              // currentBottomBarSearchPercent: (currentBottomBarSearchPercent) {},
                              parallexCardPageTransformer: PageTransformer(
                                pageViewBuilder: (context, visibilityResolver) {
                                  return
                                    PageView.builder(
                                      controller: PageController(
                                          viewportFraction: 0.50),
                                      itemCount: carPairedItemsList.length,
                                      itemBuilder: (context, index) {
                                        final item = carPairedItemsList[index];
                                        final pageVisibility =
                                        visibilityResolver
                                            .resolvePageVisibility(index);
                                        return GestureDetector(
                                          child:
                                          Container(
                                            color: Colors.white.withOpacity(
                                                0.0),
                                            width: 200.0,
                                            height: 130.0,
                                            child: ParallaxCardsWidget(
                                              item: item,
                                              pageVisibility: pageVisibility,
                                            ),
                                          ),
                                          onTap: () {
                                            _showCarPairedActions(
                                                carsSlavePairedList[index],
                                                context);
                                          },
                                        );
                                      },
                                    );
                                },
                              ),
                            );
                        },
                      );
                  }
                  else {
                    return NoDataWidget();
                  }
                },
              );
          },
        ),
      );
    }
  void _updateSelectedSymbol(SymbolOptions changes) {
    mapController.updateSymbol(_selectedSymbol, changes);
  }

  void _onSymbolTapped(Symbol symbol) {

    */
/*setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedSymbol(
      SymbolOptions(
        iconSize: 1.4,
      ),
    );*//*

    _selectedSymbol=symbol;
    if (_selectedSymbol != null) {
      if(_selectedSymbol.data!=null){
        if(_selectedSymbol.data.containsKey("CarId")){
          _showInfoDialog( _selectedSymbol.data["CarId"]);
        }
        else if(_selectedSymbol.data.containsKey("Speed"))
       showSpeedDialog(_selectedSymbol.data["Speed"]);
      }else {
        _showInfoDialog( int.tryParse(_selectedSymbol.id));
      }
    }

  }

    void onMapCreated(MapboxMapController controller) {
      mapController = controller;
      mapController.addListener(_onMapChanged);
      _extractMapInfo();

      mapController.onSymbolTapped.add(_onSymbolTapped);
     */
/* mapController.getTelemetryEnabled().then((isEnabled) =>
          setState(() {
            _telemetryEnabled = isEnabled;
          }));*//*

    }

}
*/
