import 'dart:convert';
import 'dart:typed_data';

import 'package:anad_magicar/Routes.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/bounce_animation.dart';
import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/pull_refresh/src/smart_refresher.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/model/viewmodel/status_noti_vm.dart';
import 'package:anad_magicar/notifiers/opacity.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/service/noti_analyze.dart';
import 'package:anad_magicar/ui/screen/adora_car_status_setting/car_status_setting_screen.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/remote_setting/remote_setting.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/appbar_collapse.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../translation_strings.dart';

class CarCounts {
  int carCounts;
  CarCounts(this.carCounts);
}

class AdoraVehicleStatusScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  static final route = '/adora_vehicle_status';

  const AdoraVehicleStatusScreen({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _AdoraVehicleStatusScreenState createState() =>
      _AdoraVehicleStatusScreenState();
}

// NotyBloc<CarStateVM> statusChangedNoty = NotyBloc<CarStateVM>();

class _AdoraVehicleStatusScreenState extends State<AdoraVehicleStatusScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  AnimationController progressIndicatorController;
  CurvedAnimation _progressAnimation;
  Color progressIndicatorBackgroundColor;
  Animation<Color> progressIndicatorValueColor;

  ScrollController _controller;
  Color clr = Colors.lightBlueAccent;
  bool engineStatus = false;
  bool lockStatus = true;
  var _currentColor = Colors.redAccent;
  static int currentCarIndex = 0;
  final double _initFabHeight = 40.0;
  int carCount = 0;
  final String imageUrl = 'assets/images/user_profile.png';
  String startImagePath = 'assets/images/car_start_3_1.png';
  double _fabHeight;
  double _panelHeightOpen = 250.0;
  double _panelHeightClosed = 35.0;
  bool panelIsOpen = false;
  int maxCarCounts = Constants.MAX_CAR_COUNTS;

  int _currentCarIndex = 0;
  NotyBloc<Message> carPageChangedNoty;
  NotyBloc<SendingCommandVM> sendCommandNoty;
  NotyBloc<Message> getStatusNoty;

  int _currentCarId;
  bool _sendingCommand = false;
  bool _sentCommandHasError = false;
  bool _sentCommand = false;
  String userName;
  int userId=0;
  bool isAdmin = true;
  bool isLoginned = true;

 void registerBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event) {
      if (event.type == 'CAR_ADDED') {
       // _handleRefresh();
        getCarCounts();
      }
      if (event.message == 'USER_LOADED') {}
      if (event.message == 'USER_LOADED_ERROR') {}
      if (event.message == 'MAP_PAGE') {
        // Navigator.of(context).pushReplacementNamed('/map');
      }
      if (event.type == 'LOGIN_FAIED') {
       
      }

      if (event.type == 'FCM_STATUS') {
        getStatusNoty
            .updateValue(Message(type: 'GET_CAR_STATUS', status: true));
        String msg = event.message;
        int carId = event.id;
        String commandCode = msg.substring(0, 2);
        int commandCodeValue = int.tryParse(commandCode);
        if (commandCodeValue != ActionsCommand.Check_Status_Car) {
          /*sendCommandNoty.updateValue(
                 new SendingCommandVM(sending: false,
                     sent: true, hasError: false));*/
          RxBus.post( ChangeEvent(
              type: 'COMMAND_SUCCESS', id: int.tryParse(commandCode)));
        }
        String newFCM = msg.substring(2, msg.length);
        Uint8List fcmBody = base64Decode(newFCM); //.toString();

        NotiAnalyze notiAnalyze =
            new NotiAnalyze(noti: null, carId: carId, data: fcmBody);
        StatusNotiVM status = notiAnalyze.analyzeStatusNoti();
        if (status != null) {
          CarStateVM carStateVMForThisCarId =
              centerRepository.getCarStateVMByCarId(carId);
          if (carStateVMForThisCarId != null) {
            carStateVMForThisCarId.fillStatusNotiData(
                status, statusChangedNoty);
            if (status.siren) {
              //centerRepository.vibrateOnStatus(true);
            }
          }
          prefRepository.setStatusDateTime(
              DateTimeUtils.getDateJalali(), DateTimeUtils.getTimeNow(), true);
        } else {
          prefRepository.setStatusDateTime(
              DateTimeUtils.getDateJalali(), DateTimeUtils.getTimeNow(), false);
        }
      } else if (event.type == 'FCM') {
        FlashHelper.successBar(context, message: event.message);
        int carId = NotiAnalyze.getCarIdFromNoty(event.message);
        CarStateVM carStateVM = centerRepository.getCarStateVMByCarId(carId);
        if (carStateVM != null) carStateVM.fillNotiData(event.message, carId);
      }
    });
  }

 getUserName() async {
    userName = await prefRepository.getLoginedUserName();
    userId = await prefRepository.getLoginedUserId();
    CenterRepository.setUserId(userId);
    centerRepository.setUserCached(
      new User(userName: userName, imageUrl: imageUrl, id: userId),
    );
  }

   loadLoginedUserInfo(int userId) async {
    List<SaveUserModel> result =
        await restDatasource.getUserInfo(userId.toString());
    if (result != null && result.length > 0) {
      SaveUserModel user = result.first;
      prefRepository.setLoginedPassword(user.Password);
      prefRepository.setLoginedFirstName(user.FirstName);
      prefRepository.setLoginedLastName(user.LastName);
      prefRepository.setLoginedMobile(user.MobileNo);
      prefRepository.setLoginedUserName(user.UserName);
    }
  }
  
  @override
  void initState() {
    centerRepository.initCarColorsMap();
    centerRepository.initCarMinMaxSpeed();
    CenterRepository.getPeriodicUpdateTime();
    carPageChangedNoty = NotyBloc<Message>();
    getStatusNoty = NotyBloc<Message>();
    sendCommandNoty = NotyBloc<SendingCommandVM>();
    
    progressIndicatorBackgroundColor = Colors.indigoAccent;
    getUserName();
    registerBus();
    loadLoginedUserInfo(userId);
    isAdmin = true;
    isLoginned = true;


  
    super.initState();
    centerRepository
        .checkParkGPSStatusPeriodic(CenterRepository.periodicUpdateTime);


  }

 Future<CarCounts> getCarCounts() async {
   if(carCount==null ||carCount==0 ) {
    carCount=await prefRepository.getCarsCount();      
        if (carCount > maxCarCounts) carCount = maxCarCounts;
        centerRepository.setInitCarStateVMMap(carCount);
        CarCounts  carCnts = CarCounts(carCount);
    
        return carCnts;
   } else {
        CarCounts  carCnts = CarCounts(carCount);
     return carCnts;
   }
  }

  Widget _carPanel(List menus) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white10, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              color: Colors.transparent,
            ),
          ]),
      margin: EdgeInsets.only(top: 2.0, left: 10.0, right: 10.0, bottom: 5.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 1.0,
          ),
          menus[1],
        ],
      ),
    );
  }

  _carBody(List menus) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.0),
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.90,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
             CenterRepository.APP_TYPE_ADORA ? 
             Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  menus[2],
                  menus[0],
                  //buildArrowRow(context,carIndex,true),
                ],
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 Expanded(child: menus[2],),
                  Expanded(child:menus[0],),
                  //buildArrowRow(context,carIndex,true),
                ],
              ),
            ],
          ),
          /*Positioned(
           bottom: 158,
           child: _buildRows(menus, context, 4),
         ),
         */
        ],
      ),
    );
  }

  List<Container> createCarPages()  {
    
      centerRepository.setInitCarStateVMMap(carCount);
    _currentCarId = centerRepository.getCarIdByIndex(currentCarIndex);
    CenterRepository.setCurrentCarId(_currentCarId);
    final List<Container> pages = [];
    for (int i = 0; i < carCount; i++)
      pages
        ..add(createHomeCarPage(
            createHomeScrollList(startImagePath, i, true), i));

    return pages;
  }

  List createHomeScrollList(String startImg, int carIndex, bool left) {
    return createScrollContents(context, startImg, carIndex, left);
  }

  Widget _floatingCollapsed() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      margin: const EdgeInsets.fromLTRB(50.0, 2.0, 50.0, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.asset(
              'assets/images/up.png',
              fit: BoxFit.cover,
              width: 28.0,
              height: 28.0,
            ),
          ),
        ],
      ),
    );
  }

  Container createHomeCarPage(List menus, int carIndex) {
    return Container(
      child: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              renderPanelSheet: false,
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: 0.04,
              defaultPanelState: PanelState.OPEN,
              body: _carBody(menus),
              // panel: _carPanel(menus),
              panel: menus[1],
              collapsed: _floatingCollapsed(),
              panelSnapping: true,
              onPanelOpened: () {
                panelIsOpen = true;
              },
              onPanelClosed: () {
                panelIsOpen = false;
              },
              onPanelSlide: (double pos) {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              },
            ),
          ],
        ),
      ),
    );
  }

  List createScrollContents(
      BuildContext context, String startImg, int carIndex, bool left) {
    CarStateVM carStateVM = centerRepository.getCarStateVMByCarIndex(carIndex);
    final List scrollContents = [
      buildCarRow(context, null, statusChangedNoty, carIndex, carStateVM),
      RemoteSetting(
        status: RemoteStatus.done,
        carStateVM: carStateVM,
        sendCommandNoty: sendCommandNoty,
      ),
      buildStatusRow(
          context, carPageChangedNoty, statusChangedNoty, carStateVM),
    ];
    return scrollContents;
  }

  CarStateVM currentState;

  // main car in middle
  Widget buildCarRow(
    BuildContext context,
    NotyBloc<Message> carPageChangedNoty,
    NotyBloc<CarStateVM> carStateNoty,
    int index,
    CarStateVM statusVM,
  ) {
    double angle = CenterRepository.APP_TYPE_ADORA ? 1.57 : 0.0;
    return StreamBuilder<CarStateVM>(
      stream: carStateNoty.noty,
      initialData: statusVM,
      builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
        if (data != null && data.hasData) {
          currentState = data.data;
          print("-------------> ${currentState.carCaputImage}");
        } else {
          currentState = statusVM;
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 3000),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          child: Container(
            margin: EdgeInsets.all(0.0),
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width * 0.99,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: <Widget>[
             Container(
        
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ Padding(
                    padding: EdgeInsets.only(top: 1.0),
                    child:  Transform.rotate(angle: angle , child: Image.asset(

                      currentState.carImage,
                      fit: BoxFit.fill,
                      scale: 1.0,
                      alignment: Alignment.center,

                    ),
                    alignment: Alignment.center,
                    origin: Offset.zero,
                    ) 
                  ),],),),
             
                Container(
                  width: 38.0,
                  height: 38.0,
                  // child: CircleAvatar(
                  //   backgroundColor: Colors.black12,
                  //   radius: 50.0,
                    child: Text(
                      statusVM.deviceId.toString(),
                      style: TextStyle(
                          color: Colors.pinkAccent.withOpacity(0.95),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                //),
              ],
            ),
          ),
        );
      },
    );
  }

// Left Icons
  Widget buildStatusRow(
    BuildContext context,
    NotyBloc<Message> carPageChangedNoty,
    NotyBloc<CarStateVM> carStatusNoty,
    CarStateVM carStateVM,
  ) {
    double angle = CenterRepository.APP_TYPE_ADORA ? 0 : 0.0;
    double w = MediaQuery.of(context).size.width / 8.0;
    String cioBinary = "00000000";
    var _currentColorRow = carStateVM.getCurrentColor();
    double i_w = 64.0;
    double i_h = 64.0;
    // centerRepository.fetchGPSStatus();
    return StreamBuilder<CarStateVM>(
      stream: carStatusNoty.noty,
      initialData: carStateVM,
      builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
        if (data != null && data.hasData) {
          CarStateVM carState = data.data;
          if (carState.cioBinary != null) {
            cioBinary = carState.cioBinary;
            print(cioBinary);
          }
        }
        return Transform.rotate(angle: angle, child:  
        Container(
          margin: EdgeInsets.only(right: 10.0, top: 0.0),
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.15,
          child: SingleChildScrollView(
          
          scrollDirection: Axis.horizontal,
          child: Container(
         // margin: EdgeInsets.only(right: 10.0, top: 0.0),
          width: MediaQuery.of(context).size.width * 0.90,
          child:
           CarStatusSettingScreen.done(
              status: CarIconsStatus.done,
              currentColorRow: _currentColorRow,
              cioBinary: cioBinary),
        ), ),
        ),
                    alignment: Alignment.center ,
                    origin: Offset.zero,
                    ) 
         ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CarCounts> (
    
          future: getCarCounts(),
          initialData: CarCounts(0),
          builder: (context,snapshot) {
                if(snapshot.hasData && snapshot.data!=null){
                 CarCounts carCounts=snapshot.data;
                 carCount = carCounts.carCounts;
                }
return
     Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Colors.indigoAccent,
            ),
            onPressed: () {
              widget.scaffoldKey.currentState.openDrawer();
            },
          ),
          title: appBarStatus(),
        ),
        body: StreamBuilder<Message>(
            stream: carPageChangedNoty.noty,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot != null && snapshot.hasData) {
                Message msg = snapshot.data;
                if (msg.type == 'CARPAGE') {
                  currentCarIndex = msg.index;
                  _currentCarId =
                      centerRepository.getCarIdByIndex(currentCarIndex);
                  CenterRepository.setCurrentCarId(_currentCarId);
                }
                if (msg.type == 'LOCK_PANEL') {}
              }
              return StreamBuilder<SendingCommandVM>(
                  stream: sendCommandNoty.noty,
                  //initialData: null,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      SendingCommandVM sendVM = snapshot.data;
                      _sendingCommand = sendVM.sending;
                      _sentCommand = sendVM.sent;
                      _sentCommandHasError = sendVM.hasError;
                      if(_sendingCommand==null)  _sendingCommand=false ;
                      if(_sentCommand==null) _sentCommand=false;
                    }
                    return Column(
                      children: <Widget>[
                        _sendingCommand
                            ? Align(
                                alignment: Alignment(1, -1),
                                child: Column(
                                  children: <Widget>[
                                    LinearProgressIndicator(
                                      value: progressIndicatorController != null
                                          ? _progressAnimation.value
                                          : null,
                                      backgroundColor:
                                          progressIndicatorBackgroundColor,
                                      valueColor: progressIndicatorValueColor,
                                    ),
                                    Text(
                                      Translations.current.sendingCommand(),
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 10.0),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 0.0, top: 10.0),
                            child: Container(
                              color: Colors.grey,
                              height: MediaQuery.of(context).size.height * 0.92,
                              child: SmartRefresher(
                                controller: _refreshController,
                                enablePullUp: false,
                                enablePullDown: false,
                                physics: BouncingScrollPhysics(),
                                child: AppBarCollaps(
                                    _controller,
                                    clr,
                                    createCarPages(),
                                    engineStatus,
                                    lockStatus,
                                    // null,
                                    carPageChangedNoty,
                                    _currentColor,
                                    currentCarIndex,
                                    carCount),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            }),
      ),
     );
        
          },
    );

  }

  Widget appBarStatus() {
    bool isGPSOn = false;
    bool isGPRSOn = false;

    return StreamBuilder<CarStateVM>(
        stream: statusChangedNoty.noty,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.hasData) {
            // getStatusExecuted = true;
            CarStateVM stateVM = snapshot.data;
            isGPSOn = stateVM.isGPSOn;
            isGPRSOn = stateVM.isGPRSON;
          }
          return Container(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "وضعیت خودرو",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ),
                (isGPSOn != null && isGPSOn)
                    ? ImageNeonGlow(
                        imageUrl: 'assets/images/gps.png',
                        counter: 0,
                        color: Colors.black,
                        scale: 2.0,
                      )
                    : Image.asset(
                        'assets/images/gps.png',
                        fit: BoxFit.fill,
                        color: Colors.black.withOpacity(0.5),
                        scale: 2.0,
                      ),
                SizedBox(
                  width: 8.0,
                ),
                (isGPRSOn != null && isGPRSOn)
                    ? ImageNeonGlow(
                        imageUrl: 'assets/images/gprs.png',
                        counter: 0,
                        color: Colors.black,
                        scale: 2.0,
                      )
                    : Image.asset(
                        'assets/images/gprs.png',
                        fit: BoxFit.fill,
                        color: Colors.black.withOpacity(0.5),
                        scale: 2.0,
                      ),
              ],
            ),
          );
        });
  }
}
