import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/CircleImage.dart';
import 'package:anad_magicar/components/bottomsheet/bottom_sheet_animated.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/circle_badge.dart';
import 'package:anad_magicar/components/engine_status.dart';
import 'package:anad_magicar/components/pull_refresh/pull_to_refresh.dart';
import 'package:anad_magicar/components/pull_refresh/pull_to_refresh.dart';
import 'package:anad_magicar/components/pull_refresh/pull_to_refresh.dart';
import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/data/server.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/accessable_action_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_info_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/model/viewmodel/map_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/model/viewmodel/status_history_vm.dart';
import 'package:anad_magicar/model/viewmodel/status_noti_vm.dart';
import 'package:anad_magicar/notifiers/opacity.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/service/noti_analyze.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/hiddendrawer/hidden_drawer/hidden_drawer_menu.dart';
import 'package:anad_magicar/ui/hiddendrawer/hidden_drawer/screen_hidden_drawer.dart';
import 'package:anad_magicar/ui/hiddendrawer/simple_hidden_drawer/provider/simple_hidden_drawer_provider.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/home.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/home/home.dart';
import 'package:anad_magicar/ui/screen/login/login2.dart';
import 'package:anad_magicar/ui/screen/login/logout_dialog.dart';
import 'package:anad_magicar/ui/screen/message/message_history_screen.dart';
import 'package:anad_magicar/ui/screen/payment/invoice_form.dart';
import 'package:anad_magicar/ui/screen/profile/profile2.dart';
import 'package:anad_magicar/ui/screen/register/register_screen.dart';
import 'package:anad_magicar/ui/screen/service/main_service_page.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/ui/screen/setting/security_screen.dart';
import 'package:anad_magicar/ui/screen/user/user_access_detail.dart';
import 'package:anad_magicar/ui/theme/app_themes.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/appbar_collapse.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/flash_bar/flash.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:simple_animations/simple_animations.dart' as sma;
import 'package:simple_animations/simple_animations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:supercharged/supercharged.dart';
//import 'package:assets_audio_player/assets_audio_player.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen({Key key, this.scaffoldKey}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

enum MaterialColor { RED, BLUE, GREEN, YELLOW, BLACK, WHITE, GREY }

class HomeScreenState extends State<HomeScreen>
    with
        WidgetsBindingObserver,
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        AfterLayoutMixin<HomeScreen> {
  static const String route = '/home';

  static bool kIsWeb = false;
  int _selectedIndex = 2;
  List<Widget> _widgets; // = <Widget>[createHomeWidget(), ProfilePage()];
  PageController pageController = PageController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userName = '';
  int userId;
  bool hasInternet = true;
  static bool sendingCommand = false;
  static bool sentCommand = false;
  static bool sentCommandHasError = false;

  static int currentCarIndex = 0;
  int commandProgressValue = 0;
  Timer periodicTimer;
  CarStateVM currentCarState;
  SolidController _solidBottomSheetController = SolidController();
  List<ScreenHiddenDrawer> itens = new List();

  Animation<double> containerGrowAnimation;
  AnimationController _screenController;
  AnimationController _buttonController;
  AnimationController animController;
  AnimationController animProgressController;
  CustomAnimationControl getStatusController = CustomAnimationControl.STOP;

  Animation<double> buttonGrowAnimation;
  Animation<double> listTileWidth;
  Animation<Alignment> listSlideAnimation;
  Animation<Alignment> buttonSwingAnimation;
  Animation<EdgeInsets> listSlidePosition;
  Animation<Color> fadeScreenAnimation;
  var animateStatus = 0;
  static Size screenSize;
  ScrollController _controller;

  Animation animation, transformationAnim;
  AnimationController animationController;
  AnimationController rotationController;

  CurvedAnimation _progressAnimation;
  Animation<Color> progressIndicatorValueColor;
  Color progressIndicatorBackgroundColor;
  AnimationController progressIndicatorController;
  Animation<Color> getStatusAnimation;
  int carCount = 0;
  int maxCarCounts = Constants.MAX_CAR_COUNTS;
  final String imageUrl = 'assets/images/user_profile.png';
  String startImagePath = 'assets/images/car_start_3_1.png';
  final int registerId = 0;
  final int helpId = 10;
  final int searchId = 20;
  final int shopId = 30;
  final int basketId = 40;
  final int myProgramsId = 50;

  OpacityNotifier opacityNotifier;
  Server server = new Server();
  StreamSubscription<String> _subscription;
  String message = '';
  String bottomSheetMessage = '';

  bool isLoginned = true;
  bool isAdmin;
  int _counter = 0;
  int messageCounts = 0;
  User user;
  bool engineStatus = false;
  bool lockStatus = true;
  bool trunkStatus = false;
  bool caputStatus = false;
  bool isDark = false;
  Future<List<AdminCarModel>> refreshedCars;
  List<AdminCarModel> newCarsList;
  int currentBottomNaviSelected = 2;
  var startEnginChangedNoty = NotyBloc<Message>();
  //var statusChangedNoty=new NotyBloc<CarStateVM>();
  var carPageChangedNoty = NotyBloc<Message>();
  var opacityChangedNoty = NotyBloc<Message>();

  var carLockPanelNoty = NotyBloc<Message>();
  var sendCommandNoty = NotyBloc<SendingCommandVM>();

  NotyBloc<Message> getStatusNoty = NotyBloc<Message>();
  //var valueNotyModelBloc=new NotyBloc<ChangeEvent>();

  var _currentColor = Colors.redAccent;
  int _currentCarId = 0;
  //cars
  final double _initFabHeight = 40.0;
  double _fabHeight;
  double _panelHeightOpen = 240.0;
  double _panelHeightClosed = 35.0;
  bool panelIsOpen = false;
  bool getStatusSucceed = false;
  //AssetsAudioPlayer _assetsAudioPlayer;

  AudioCache player = AudioCache();
  AudioPlayer advancedPlayer;

  play() {
    player.play('car_door_lock.mp3');
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

  getAdminCarsToUser() async {
    List<AdminCarModel> cars = new List();
    List<AdminCarModel> carsInWaiting = new List();

    RestDatasource restDS = new RestDatasource();
    cars = await restDS.getAllCarsToAdmin(userId);
    if (cars != null && cars.length > 0) {
      carsInWaiting = cars
          .where((c) =>
              c.CarToUserStatusConstId ==
              Constants.CAR_TO_USER_STATUS_WAITING_TAG)
          .toList();
      if (carsInWaiting != null && carsInWaiting.length > 0) {
        Navigator.pushNamed(context, '/carpage',
            arguments:
                new CarPageVM(userId: userId, isSelf: false, carAddNoty: null));
      }
    }
  }

  getCarCounts() async {
    prefRepository.getCarsCount().then((value) {
      setState(() {
        carCount = value;
        if (carCount > maxCarCounts) carCount = maxCarCounts;

        centerRepository.setInitCarStateVMMap(carCount);
      });
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

  onCarPageTap() {
    Navigator.of(context).pushNamed('/carpage',
        arguments: new CarPageVM(
            userId: userId, isSelf: true, carAddNoty: valueNotyModelBloc));
  }

  animateEngineStatus() {
    animationController =
        AnimationController(duration: Duration(seconds: 8), vsync: this);

    animation = Tween(begin: 10.0, end: 200.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    transformationAnim = BorderRadiusTween(
            begin: BorderRadius.circular(150.0),
            end: BorderRadius.circular(0.0))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease));
    //animationController.forward();
  }

  updateItemCounts(bool increment) {
    //setState(() {
    if (increment)
      this._counter = this._counter + 1;
    else if (this._counter > 0) this._counter = this._counter - 1;
    //});
  }

  Container createHomeCarPage(List menus, int carIndex) {
    // opacityNotifier = OpacityNotifier(0.0);
    return Container(
      child:
          // ChangeNotifierProvider<OpacityNotifier>(
          //   create: (context) => OpacityNotifier(0.0),
          //   child: Material(
          //     child: Consumer<OpacityNotifier>(
          //       builder: (context, opacity, child) {

          //         return
          Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          kIsWeb ? _carBody(menus, carIndex, opacityNotifier) : Container(),
          kIsWeb
              ? Positioned(
                  bottom: 1.0,
                  child: Padding(
                      padding: EdgeInsets.all(10.0), child: _carPanel(menus)),
                )
              : SlidingUpPanel(
                  renderPanelSheet: false,
                  maxHeight: _panelHeightOpen,
                  minHeight: _panelHeightClosed,

                  parallaxEnabled: true,
                  parallaxOffset: 0.05,
                  defaultPanelState: PanelState.OPEN,
                  body: _carBody(menus, carIndex, opacityNotifier),

                  panel: _carPanel(menus),
                  collapsed: _floatingCollapsed(),
                  // padding: EdgeInsets.all(0.0),
                  // margin: EdgeInsets.all(0.0),
                  panelSnapping: true,
                  onPanelOpened: () {
                    panelIsOpen = true;
                    //opacityChangedNoty.updateValue(Message(value: 0.0));
                    // opacity.decrement();
                  },
                  onPanelClosed: () {
                    panelIsOpen = false;
                    opacityChangedNoty.updateValue(Message(value: 1.0));
                    //opacity.increment();
                  },

                  onPanelSlide: (double pos) {
                    //setState(() {
                    _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
                  },
                ),
        ],
        // );
        //  ),
        // },
        //  ),
      ),
      // ),
    );
  }

  Widget _floatingCollapsed() {
    return Container(
      // height: 260.0,
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
            // width: 68.0,
            // height: 68.0,
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

  _carPanel(List menus) {
    return Container(
      //height: MediaQuery.of(context).size.height/2.0,
      decoration: BoxDecoration(
          //color: Colors.greenAccent,
          border: Border.all(color: Colors.white10, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              color: Colors.transparent,
            ),
          ]),
      //margin: const EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 2.0, left: 10.0, right: 10.0, bottom: 5.0),
      //color: Color(0xffffffff),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 1.0,
          ),
          _buildRows(menus, context, 5),
        ],
      ),
    );
  }

  _carBody(List menus, int carIndex, OpacityNotifier opacityNotifier) {
    kIsWeb = UniversalPlatform.isWeb;
    return Container(
      margin: EdgeInsets.only(bottom: 0.0),
      alignment: Alignment.topCenter,
      //color: Color(0xff757575),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.80,
      child: Stack(
        children: <Widget>[
          // Positioned(
          //   top: -10.0,
          //   child: _buildRows(menus, context, 3),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  kIsWeb
                      ? _buildRows(menus, context, 2)
                      : _buildRows(menus, context, 2),
                  kIsWeb
                      ? _buildRows(menus, context, 0)
                      : _buildRows(menus, context, 0),
                  kIsWeb
                      ? _buildRows(menus, context, 1)
                      : _buildRows(menus, context, 1),
                ],
              ),
              //buildArrowRow(context,carIndex,true),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildRows(menus, context, 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List createHomeAllCarPages(int carCounts, List pages) {
    List finalPages = new List();
    finalPages = pages;
    return finalPages;
  }

  Widget _buildRows(List menues, BuildContext context, int pos) {
    screenSize = MediaQuery.of(context).size;
    List scrollList = menues; //createScrollContents(context);
    return scrollList[pos];
  }

  List createHomeScrollList(String startImg, int carIndex, bool left,
      OpacityNotifier opacityNotifier) {
    return createScrollContents(
        context, startImg, carIndex, left, opacityNotifier);
  }

  List createScrollContents(BuildContext context, String startImg, int carIndex,
      bool left, OpacityNotifier opacityNotifier) {
    CarStateVM carStateVM = centerRepository.getCarStateVMByCarIndex(carIndex);

    final List scrollContents = [
      buildCarRow(context, carPageChangedNoty, statusChangedNoty, carIndex,
          carStateVM, rotationController, _counter),
      buildStatusRow(context, carPageChangedNoty, statusChangedNoty, carStateVM,
          lockStatus, false, engineStatus, animController),
      buildMapRow(context, carStateVM, carPageChangedNoty, statusChangedNoty,
          animController),
      buildArrowRow(context, carIndex, carStateVM, left, carPageChangedNoty,
          opacityChangedNoty),
      buildBottomRow(context, carIndex, carStateVM, left, carPageChangedNoty,
          statusChangedNoty),
      EngineStatus(
        engineStatus: engineStatus,
        lockStatus: lockStatus,
        color: _currentColor,
        carPageNoty: carPageChangedNoty,
        carStateVM: carStateVM,
        carStateNoty: statusChangedNoty,
        sendCommandNoty: sendCommandNoty,
      )
    ];

    return scrollContents;
  }

  Color clr = Colors.lightBlueAccent;
  _scrollListener() {
    if (_controller.offset > _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        clr = Colors.blueAccent;
      });
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        clr = Colors.lightBlueAccent;
      });
    }
  }

  getEngineStatus() async {
    engineStatus = await prefRepository.getStartEngineStatus();
    if (engineStatus == null) engineStatus = false;
  }

  setEngineStatus(bool status) async {
    await prefRepository.setEngineStatus(status);
  }

  getLockStatus() async {
    lockStatus = await prefRepository.getLockStatus();
    if (lockStatus == null) lockStatus = false;
  }

  setLockStatus(bool status) async {
    await prefRepository.setLockStatus(status);
  }

  List<Container> createCarPages(OpacityNotifier opacityNotifier) {
    centerRepository.setInitCarStateVMMap(carCount);
    _currentCarId = centerRepository.getCarIdByIndex(currentCarIndex);
    CenterRepository.setCurrentCarId(_currentCarId);
    final List<Container> pages = [];
    for (int i = 0; i < carCount; i++)
      pages
        ..add(createHomeCarPage(
            createHomeScrollList(startImagePath, i, true, opacityNotifier), i));

    return pages;
  }

  Container createSingleCarPage(OpacityNotifier opacityNotifier) {
    centerRepository.addInitCarStateVMMap(carCount);
    Container newPage = createHomeCarPage(
        createHomeScrollList(startImagePath, carCount, true, opacityNotifier),
        carCount);
    carCount++;
    return newPage;
  }

  Future<List<AdminCarModel>> refreshCars() async {
    RestDatasource restDatasource = new RestDatasource();
    List<AdminCarModel> cars = await restDatasource.getAllCarsByUserId(userId);
    if (cars != null && cars.length > 0) {
      centerRepository.setCarsToAdmin(cars);
      newCarsList = cars;
      getStatusNoty.updateValue(Message(type: 'GET_CAR_STATUS', status: false));
      int actionId =
          ActionsCommand.actionCommandsMap[ActionsCommand.STATUS_CAR_TAG];
      var result = await restDatasource.sendCommand(SendCommandModel(
          UserId: userId,
          ActionId: actionId,
          CarId: _currentCarId,
          Command: null));
      if (result != null) {}
      return cars;
    }
    return null;
  }

  void initLists() {
    isAdmin = true;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _screenController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _buttonController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    fadeScreenAnimation = ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );
    containerGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

    buttonGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOut,
    );
    containerGrowAnimation.addListener(() {
      this.setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

    listTileWidth = Tween<double>(
      begin: 1000.0,
      end: 600.0,
    ).animate(
      CurvedAnimation(
        parent: _screenController,
        curve: Interval(
          0.225,
          0.600,
          curve: Curves.bounceIn,
        ),
      ),
    );

    listSlideAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.700,
          curve: Curves.ease,
        ),
      ),
    );
    buttonSwingAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.ease,
        ),
      ),
    );
    listSlidePosition = new EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 16.0),
      end: const EdgeInsets.only(bottom: 80.0),
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );
    _screenController.forward();

    //createMenuContent(context);
  }

  initCustomer() async {
    user = await databaseHelper.getUserInfo();

    if (user != null) {
      isLoginned = true;
      if (user.owner <= 0) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
      setState(() {});
    } else {
      isLoginned = false;
      isAdmin = false;
    }
  }

  _showBottomSheetAccessableActions(
      BuildContext cntext, AccessableActionVM vm) {
    showModalBottomSheetCustom(
        context: cntext,
        builder: (BuildContext context) {
          return new UserAccessPage(
            accessableActionVM: vm,
          );
        });
  }

  _showBottomSheetCurrentCarInfo(
      BuildContext cntext, int carId, int userId) async {
    CarInfoVM carInfoVM = await centerRepository.getCarInfo(userId, carId);
    showModalBottomSheetCustom(
        context: cntext,
        mHeight: 0.90,
        builder: (BuildContext context) {
          String name = DartHelper.isNullOrEmptyString(carInfoVM.brandTitle);
          String desc = DartHelper.isNullOrEmptyString(carInfoVM.Description);
          String carId = carInfoVM.carId.toString();
          String modelTitle =
              DartHelper.isNullOrEmptyString(carInfoVM.modelTitle);
          String detailTitle =
              DartHelper.isNullOrEmptyString(carInfoVM.modelDetailTitle);
          String fromDate = DartHelper.isNullOrEmptyString(carInfoVM.fromDate);
          String pelak = DartHelper.isNullOrEmptyString(carInfoVM.pelak);
          String colortitle = DartHelper.isNullOrEmptyString(carInfoVM.color);
          bool isAdmin = carInfoVM.isAdmin;
          int statusId = carInfoVM.CarToUserStatusConstId;
          bool active = carInfoVM.isActive;
          return Container(
            margin: EdgeInsets.only(bottom: 2.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                    color: Colors.black38.withOpacity(0.1), width: 0.5)),
            child: Column(
              children: <Widget>[
                ListTile(
                    title: Card(
                      color: Colors.black12.withOpacity(0.0),
                      margin: new EdgeInsets.only(
                          left: 2.0, right: 2.0, top: 5.0, bottom: 5.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 0.0),
                        borderRadius:
                            new BorderRadius.all(Radius.circular(5.0)),
                      ),
                      // color: Color(0xfffefefe),
                      elevation: 0.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 5.0, left: 5.0),
                                  child: Text(Translations.current.carId(),
                                      style: TextStyle(fontSize: 18.0)),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 5.0, left: 5.0),
                                  child: Text(carId,
                                      style: TextStyle(fontSize: 20.0)),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(Translations.current.carTitle(),
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(name,
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(
                                    Translations.current.carModelTitle(),
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(modelTitle,
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(
                                    Translations.current.carModelDetailTitle(),
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(detailTitle,
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(Translations.current.carcolor(),
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(colortitle,
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(Translations.current.startDate(),
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(
                                  fromDate,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(Translations.current.carpelak(),
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: Text(
                                  pelak,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(Translations.current.description() +
                        ' : ' +
                        DartHelper.isNullOrEmptyString(desc)),
                    trailing: Container(
                      width: 0.0,
                      height: 0.0,
                    )),
                Container(
                  width: 0.0,
                  height: 0.0,
                ),
                FlatButton(
                  child: Button(
                    title: 'برگشت',
                    wid: 100,
                    clr: Colors.blueAccent,
                    color: Colors.white.value,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void _showCarControl() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new BS();
        });
  }

  void registerBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event) {
      if (event.type == 'CAR_ADDED') {
        _handleRefresh();
        getCarCounts();
      }
      if (event.message == 'USER_LOADED') {}
      if (event.message == 'USER_LOADED_ERROR') {}
      if (event.message == 'MAP_PAGE') {
        // Navigator.of(context).pushReplacementNamed('/map');
      }
      if (event.type == 'LOGIN_FAIED') {
        bottomSheetMessage = event.message;
        if (_solidBottomSheetController.isOpened)
          _solidBottomSheetController.hide();
        _solidBottomSheetController.show();
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
          RxBus.post(new ChangeEvent(
              type: 'COMMAND_SUCCESS', id: int.tryParse(commandCode)));
        }
        String newFCM = msg.substring(2, msg.length);
        Uint8List fcmBody = base64Decode(newFCM); //.toString();
        //centerRepository.showFancyToast(newFCM,true);
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
        // centerRepository.showFancyToast(event.message,true);
        FlashHelper.successBar(context, message: event.message);
        int carId = NotiAnalyze.getCarIdFromNoty(event.message);
        CarStateVM carStateVM = centerRepository.getCarStateVMByCarId(carId);
        if (carStateVM != null) carStateVM.fillNotiData(event.message, carId);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      centerRepository
          .checkParkGPSStatusPeriodic(CenterRepository.periodicUpdateTime);
      centerRepository.getCarStatusAtAppStarted(getStatusNoty);
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
    } else if (state == AppLifecycleState.detached) {
      // app suspended (not used in iOS)
    }
  }

  @override
  void initState() {
    getAppTheme();

    centerRepository.initCarColorsMap();
    getEngineStatus();
    getLockStatus();
    centerRepository.initCarMinMaxSpeed();
    getCarCounts();
    getUserName();
    registerBus();
    loadLoginedUserInfo(userId);
    isAdmin = true;
    isLoginned = true;
    initLists();

    opacityNotifier = OpacityNotifier(0.0);
    startEnginChangedNoty = NotyBloc<Message>();
    carPageChangedNoty = NotyBloc<Message>();
    carLockPanelNoty = NotyBloc<Message>();
    messageCountNoty = NotyBloc<Message>();
    getStatusNoty = NotyBloc<Message>();

    //statusChangedNoty=new NotyBloc<CarStateVM>();
    sendCommandNoty = new NotyBloc<SendingCommandVM>();
    valueNotyModelBloc = new NotyBloc<ChangeEvent>();
    _solidBottomSheetController = new SolidController();
    player = AudioCache();
    advancedPlayer = new AudioPlayer();

    //getStatusController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    rotationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    rotationController.addListener(() {});

    progressIndicatorBackgroundColor = Colors.indigoAccent;

    animController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    // animController.repeat(reverse: true);
    animProgressController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animProgressController.addListener(() {
      setState(() {
        if (commandProgressValue > 3) {
          animProgressController.reverse();
        }
        if (commandProgressValue < 0) {
          animProgressController.forward();
        }
        if (commandProgressValue < 3) {
          commandProgressValue++;
        } else if (commandProgressValue > 0) {
          commandProgressValue--;
        }
      });
    });

    /* getStatusAnimation =
    ColorTween(begin: Colors.red, end: Colors.amber).animate(getStatusController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });*/

    pageController = PageController();

    super.initState();
    CenterRepository.getPeriodicUpdateTime().then((value) async {
      // if (!kIsWeb) {
      periodicTimer = centerRepository.checkCarStatusPeriodic(
          CenterRepository.periodicUpdateTime, getStatusNoty);
      centerRepository
          .checkParkGPSStatusPeriodic(CenterRepository.periodicUpdateTime);
      // }
    });

    //if (!kIsWeb) {
    messageCountNoty
        .updateValue(Message(index: CenterRepository.messageCounts));

    Future.delayed(Duration(seconds: 3)).then((valu) {
      centerRepository.getCarStatusAtAppStarted(getStatusNoty);
    });
    // }
  }

  _showCarStatusHistorySheet(BuildContext context) async {
    String status = 'بروزرسانی وضعیت موفقیت آمیز بوده است';
    StatusHistoryVM statusHistoryVM = new StatusHistoryVM();
    statusHistoryVM = await prefRepository.geteStatusDateTime();
    if (!statusHistoryVM.state) status = 'بروزرسانی وضعیت ناموفق بوده است';
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.50,
        builder: (BuildContext context) {
          return new Container(
            height: 250.0,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'آخرین بروزرسانی وضعیت خودرو',
                        style: HeaderTextStyle,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('تاریخ', style: HeaderTextStyle),
                      Text(statusHistoryVM.date, style: HeaderTextStyle)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('زمان', style: HeaderTextStyle),
                      Text(statusHistoryVM.time, style: HeaderTextStyle)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Text(status, style: HeaderTextStyle)],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _screenController?.dispose();
    _buttonController?.dispose();
    carLockPanelNoty?.dispose();
    carPageChangedNoty?.dispose();
    opacityChangedNoty?.dispose();
    //getStatusController.cl();
    if (periodicTimer != null && periodicTimer.isActive) periodicTimer.cancel();
    RxBus.destroy();
    super.dispose();
  }

  Future<bool> _onWillPop(BuildContext ctx) {
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

  Widget createHomeWidget() {
    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        StreamBuilder<Message>(
          stream: carPageChangedNoty.noty,
          initialData: null,
          builder: (BuildContext c, AsyncSnapshot<Message> data) {
            if (data != null && data.hasData) {
              Message msg = data.data;
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
                initialData: null,
                builder:
                    (BuildContext c, AsyncSnapshot<SendingCommandVM> data) {
                  if (data.hasData && data.data != null) {
                    SendingCommandVM sendVM = data.data;
                    sendingCommand = sendVM.sending;
                    sentCommand = sendVM.sent;
                    sentCommandHasError = sendVM.hasError;
                    animProgressController.forward();
                  }
                  return Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      // Align(
                      //   alignment: Alignment(1, -1),
                      Container(
                        height: 70.0,
                        child: AppBar(
                          // automaticallyImplyLeading: true,
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
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
                      //),
                      Padding(
                        padding: EdgeInsets.only(right: 160.0, top: 30.0),
                        child: Align(
                          alignment: Alignment(1, -1),
                          child: GestureDetector(
                            onTap: () {},
                            child: StreamBuilder<Message>(
                              stream: getStatusNoty.noty,
                              initialData: null,
                              builder: (BuildContext c,
                                  AsyncSnapshot<Message> snapshot) {
                                bool hasResult = true;
                                if (snapshot.hasData && snapshot.data != null) {
                                  Message msg = snapshot.data;
                                  if (msg.type == 'GET_CAR_STATUS') {
                                    if (msg.status == true) {
                                      if (getStatusController ==
                                          CustomAnimationControl.MIRROR)
                                        getStatusController =
                                            CustomAnimationControl.STOP;
                                      getStatusSucceed = true;
                                    } else if (msg.status == false) {
                                      getStatusSucceed = false;
                                      if (getStatusController ==
                                          CustomAnimationControl.STOP) {
                                        getStatusController =
                                            CustomAnimationControl.MIRROR;
                                      }
                                    }
                                    if (msg.text == 'NO_RESULT')
                                      hasResult = false;
                                    else
                                      hasResult = true;
                                  }
                                } else {}
                                return Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: new Container(
                                    width: 24.0,
                                    height: 24.0,
                                    child: Container(
                                      width: 24.0,
                                      height: 24.0,
                                      child: GestureDetector(
                                          onTap: () {
                                            centerRepository
                                                .getCarStatusAtAppStarted(
                                                    getStatusNoty);
                                            centerRepository
                                                .checkParkGPSStatusPeriodic(
                                                    CenterRepository
                                                        .periodicUpdateTime);
                                            _showCarStatusHistorySheet(context);
                                          },
                                          child: getStatusSucceed
                                              ? Image.asset(
                                                  'assets/images/status_succeed.png',
                                                  color: hasResult
                                                      ? Colors.blueAccent
                                                      : Colors.amber,
                                                  width: 24,
                                                  height: 24,
                                                )
                                              : CustomAnimation<double>(
                                                  control: getStatusController,
                                                  animationStatusListener:
                                                      (status) {
                                                    Future.delayed(new Duration(
                                                            milliseconds: 7000))
                                                        .then((data) {
                                                      if (getStatusSucceed ==
                                                          false) {
                                                        getStatusSucceed = true;
                                                        getStatusNoty.updateValue(
                                                            new Message(
                                                                type:
                                                                    'GET_CAR_STATUS',
                                                                status: true,
                                                                text:
                                                                    'NO_RESULT'));
                                                      }
                                                    });
                                                  },
                                                  tween: (-90.0).tweenTo(90.0),

                                                  builder:
                                                      (context, child, value) {
                                                    return Transform.rotate(
                                                      angle:
                                                          value * (3.14 / 180),
                                                      child: Image.asset(
                                                        'assets/images/status.png',
                                                        width: 24,
                                                        height: 24,
                                                        color:
                                                            Colors.pinkAccent,
                                                      ),
                                                    );
                                                  },
                                                  duration: 2.seconds,
                                                  delay: 1
                                                      .seconds, // <-- add delay
                                                )) /*;
                                                new Image.asset(
                                                  'assets/images/status.png',
                                                  width: 24,
                                                  height: 24,
                                                  color: getStatusAnimation.value,
                                                  )*/
                                      ,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 100.0, top: 25.0),
                        child: Align(
                          alignment: Alignment(1, -1),
                          child: GestureDetector(
                            onTap: () {
                              RxBus.post(new ChangeEvent(
                                  type: 'NEW_PAGE',
                                  message: 'GO_TO_MESSAGE_HISTORY'));
                            },
                            child: StreamBuilder<Message>(
                              stream: messageCountNoty.noty,
                              initialData: null,
                              builder: (BuildContext c,
                                  AsyncSnapshot<Message> snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  messageCounts = snapshot.data.index;
                                } else {
                                  messageCounts =
                                      CenterRepository.messageCounts;
                                }
                                return new Container(
                                  width: 58.0,
                                  height: 58.0,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 0.0,
                                        left: 16,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 18.0,
                                              bottom: 10.0,
                                              right: 0.0,
                                              top: 0.0),
                                          child: messageCounts > 0
                                              ? CircleBadge(
                                                  number:
                                                      messageCounts.toString(),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5.0,
                                        left: 22,
                                        child: Container(
                                          width: 28.0,
                                          height: 28.0,
                                          child: new Image.asset(
                                            'assets/images/message.png',
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 50.0, top: 30.0),
                        child: Align(
                          alignment: Alignment(1, -1),
                          child: GestureDetector(
                            onTap: () {
                              // getAdminCarsToUser();
                              AccessableActionVM accessableActionVM =
                                  AccessableActionVM(
                                      userModel: ApiRelatedUserModel(
                                          userId: userId,
                                          userName: null,
                                          roleTitle: null,
                                          roleId: null),
                                      carId: _currentCarId,
                                      carStateVM: null,
                                      sendingCommandVM: null,
                                      sendCommandModel: null,
                                      isFromMainAppForCommand: true,
                                      carStateNoty: statusChangedNoty,
                                      sendingCommandNoty: sendCommandNoty);

                              _showBottomSheetCurrentCarInfo(
                                  context, _currentCarId, userId);
                            },
                            child: new Container(
                              width: 24.0,
                              height: 24.0,
                              child: Image.asset(
                                'assets/images/car_waiting.png',
                                color: Colors.indigoAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      sendingCommand
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
                          : sentCommand
                              ? Align(
                                  alignment: Alignment(1, -1),
                                  child: Column(
                                    children: <Widget>[
                                      LinearProgressIndicator(
                                        value:
                                            progressIndicatorController != null
                                                ? _progressAnimation.value
                                                : null,
                                        backgroundColor:
                                            progressIndicatorBackgroundColor,
                                        valueColor: progressIndicatorValueColor,
                                      ),
                                      //  new Text(Translations.current.sentCommand(),style: TextStyle(color: Colors.redAccent,fontSize:10.0))
                                    ],
                                  ),
                                )
                              : sentCommandHasError
                                  ? Align(
                                      alignment: Alignment(1, -1),
                                      child: Column(
                                        children: <Widget>[
                                          LinearProgressIndicator(
                                            value:
                                                progressIndicatorController !=
                                                        null
                                                    ? _progressAnimation.value
                                                    : null,
                                            backgroundColor:
                                                progressIndicatorBackgroundColor,
                                            valueColor:
                                                progressIndicatorValueColor,
                                          ),
                                          Icon(Icons.error_outline,
                                              size: 20.0, color: Colors.red),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),

                      (sendingCommand || sentCommand || sentCommandHasError)
                          ? Container(
                              width: 0.0,
                              height: 0.0,
                            )
                          : Positioned(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 80.0, top: 20.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Image.asset(
                                    'assets/images/i26.png',
                                    color: Colors.indigoAccent,
                                    scale: 1,
                                  ),
                                  alignment: Alignment(-10, 0.5),
                                ),
                              ),
                              left: -1.0,
                            ),
                      hasInternet
                          ? Container(
                              width: 0.0,
                              height: 0.0,
                            )
                          : Align(
                              alignment: Alignment(1, 0),
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                child: Image.asset(
                                    'assets/images/no_internet.png'),
                              ),
                            ),
                    ],
                    // ),
                  );
                });
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 0.0, top: 60.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.92,
            child: SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              enablePullDown: true,
              // physics: BouncingScrollPhysics(),
              footer: MaterialClassicHeader(
                color: Theme.of(context).indicatorColor,
                height: 10.0,
                backgroundColor: Theme.of(context).backgroundColor,
                //loadStyle: LoadStyle.ShowWhenLoading,
                //completeDuration: Duration(milliseconds: 500),
              ),
              header: WaterDropMaterialHeader(),
              onRefresh: () async {
                //monitor fetch data from network
                await Future.delayed(Duration(milliseconds: 1000));

                var result = await refreshCars();
                // if (mounted) setState(() {});
                if (result == null)
                  _refreshController.refreshFailed();
                else
                  _refreshController.refreshCompleted();
              },
              onLoading: () async {
                //monitor fetch data from network
                await Future.delayed(Duration(milliseconds: 1000));
                var result = await refreshCars();
                // if (mounted) setState(() {});
                if (result == null)
                  _refreshController.loadFailed();
                else
                  _refreshController.loadComplete();
              },
              child: ListView.builder(
                padding: EdgeInsets.only(top: 1.0), //kMaterialListPadding,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return AppBarCollaps(
                      _controller,
                      clr,
                      createCarPages(
                          opacityNotifier) /*createHomeScrollList(startImagePath,0)*/,
                      engineStatus,
                      lockStatus,
                      carPageChangedNoty,
                      _currentColor,
                      currentCarIndex,
                      carCount);
                },
              ),
            ),
            // },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;
    Size screenSize = MediaQuery.of(context).size;
    _panelHeightOpen = MediaQuery.of(context).size.height * 0.40;
    return
        /*new WillPopScope(
            onWillPop: () async {
              return _onWillPop(context);
            },
            child:*/ /*OfflineBuilder(
              connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                  ) {
                hasInternet = connectivity != ConnectivityResult.none;
                if (connectivity == ConnectivityResult.none) {

                }
                return child;
              },
              child:*/
        Scaffold(
      // key: widget.scaffoldKey,
      appBar: null,
      /*drawer: AppDrawer(
                  userName: userName,
                  currentRoute: route,
                  imageUrl: imageUrl,
                  carPageTap: onCarPageTap,
                  carId: _currentCarId,),*/
      body: StreamBuilder<Message>(
          stream: fcmNoty.noty,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              getStatusNoty
                  .updateValue(Message(type: 'GET_CAR_STATUS', status: true));
              Message data = snapshot.data;
              String msg = data.text;
              int carId = data.id;
              String commandCode = msg.substring(0, 2);
              int commandCodeValue = int.tryParse(commandCode);
              if (commandCodeValue != ActionsCommand.Check_Status_Car) {
                /*sendCommandNoty.updateValue(
                 new SendingCommandVM(sending: false,
                     sent: true, hasError: false));*/
                RxBus.post(ChangeEvent(
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
                prefRepository.setStatusDateTime(DateTimeUtils.getDateJalali(),
                    DateTimeUtils.getTimeNow(), true);
              } else {
                prefRepository.setStatusDateTime(DateTimeUtils.getDateJalali(),
                    DateTimeUtils.getTimeNow(), false);
              }
            }
            return createHomeWidget();
          }),
      //),
    );
  }

  Widget addSettingsIcon() {
    return isAdmin
        ? Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings', arguments: true);
                },
                icon:
                    //Icon(Icons.shopping_cart, color: Colors.white, size: 32,semanticLabel: "Cart",),
                    new Stack(
                  children: <Widget>[
                    new Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                      semanticLabel: "Settings",
                    ),
                  ],
                ),
              ),
              // },)
            ),
          )
        : new Text('');
  }

  loaduser() async {
    return await databaseHelper.getUserInfo();
  }

  Widget createServiceWidget() {
    Car car = centerRepository.getCarByCarId(_currentCarId);
    return MainPageService(
      serviceVM: new ServiceVM(
          car: car,
          carId: _currentCarId,
          editMode: null,
          service: null,
          refresh: false),
    );
  }

  Widget createPlansWidget() {
    return new InvoiceForm();
  }

  Widget createMapPageWidget() {
    return new MapPage(
      mapVM: new MapVM(
        carId: _currentCarId,
        carCounts: centerRepository.getCarsToAdmin().length,
        cars: centerRepository.getCarsToAdmin(),
      ),
    );
  }

  Widget createMessagesWidget() {
    return new MessageHistoryScreen(
      carId: _currentCarId,
    );
  }

  void onNavButtonTap(int index) {
    currentBottomNaviSelected = index;
    if (index == 4) {
      Navigator.of(context).pushNamed('/plans');
    } else if (index == 0) {
      Car car = centerRepository.getCarByCarId(_currentCarId);
      Navigator.pushNamed(context, '/servicepage',
          arguments: new ServiceVM(
              car: car,
              carId: _currentCarId,
              editMode: null,
              service: null,
              refresh: false));
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/mappage',
          arguments: new MapVM(
            carId: _currentCarId,
            carCounts: centerRepository.getCarsToAdmin().length,
            cars: centerRepository.getCarsToAdmin(),
          ));
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/home');
      // _showCarControl();
    } else if (index == 3) {
      Navigator.pushNamed(context, '/messages', arguments: _currentCarId);
    }
  }

  List<Widget> getCarsTiles() {
    List<Widget> list = [];
    if (centerRepository.getCars() != null) {
      for (Car c in centerRepository.getCars()) {
        String name = c.pelaueNumber;
        String desc = c.description;
        list.add(ListTile(
          title: Text(name),
          subtitle:
              Text(' # ' + Translations.current.carpelak() + ' : ' + name),
          trailing: FlatButton(
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Icon(Icons.directions_car, size: 28.0, color: Colors.red),
            onPressed: () {},
          ),
        ));
      }
    }
    return list;
  }

  Future<void> _handleRefresh() async {
    final Completer<void> completer = Completer<void>();
    List<AdminCarModel> carsToAdmin = new List();
    carsToAdmin = await restDatasource.getAllCarsByUserId(userId);
    if (carsToAdmin != null) {
      centerRepository.setCarsToAdmin(carsToAdmin);
      prefRepository.setCarsCount(carsToAdmin.length);
    } else {
      prefRepository.setCarsCount(0);
    }
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      widget.scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('اطلاعات بروزرسانی شد'),
          action: SnackBarAction(
              label: 'سعی مجدد',
              onPressed: () {
                //_refreshIndicatorKey.currentState.show();
              })));
    });
  }

  void createMenuContent(BuildContext context) {
    CarStateVM carStateVM;
    itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: DartHelper.isNullOrEmptyString(
            centerRepository.getUserInfo() != null
                ? centerRepository.getUserInfo().UserName
                : userName),
        colorLineSelected: Colors.teal,
        baseStyle:
            TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 25.0),
        selectedStyle: TextStyle(color: Colors.teal),
        content: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 5.0),
              child: new CircleImage(
                imageUrl: imageUrl,
                isLocal: true,
                width: 48.0,
                height: 48.0,
              ) /*CircleAvatar(
                backgroundImage: new Image(image: imageUrl)
                 radius: 50.0,
                child : Image.asset(imageUrl),)*/
              ,
            ),
            Text(
              DartHelper.isNullOrEmptyString(
                  centerRepository.getUserInfo() != null
                      ? centerRepository.getUserInfo().UserName
                      : userName),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      StreamBuilder(
          initialData: Message(text: startImagePath, type: '', status: false),
          stream:
              BlocProvider.of<GlobalBloc>(context).messageBloc.messageStream,
          builder: (context, snapshot) {
            if (snapshot != null && snapshot.hasData) {
              Message message = snapshot.data;
              if (message != null) {
                if (message.type == 'LOCK') {
                  if (currentCarState != null) {
                    currentCarState.isDoorOpen = !message.status;
                    currentCarState.setCarStatusImages();
                    centerRepository.updateCarStateVMMap(currentCarState);
                  }
                  setLockStatus(message.status);
                  lockStatus = message.status;
                  if (!lockStatus) {
                    _counter = 1;
                    rotationController.forward();
                  } else {
                    _counter = 0;
                    rotationController.reverse();
                    //_assetsAudioPlayer.stop();
                    // player.clear('car_door_lock.mp3');

                  }
                } else if (message.type == 'POWER') {
                  setEngineStatus(message.status);
                  engineStatus = message.status;
                  startImagePath = message.text;
                } else if (message.type == 'TRUNK') {
                  if (currentCarState != null) {
                    currentCarState.isTraunkOpen = message.status;
                    currentCarState.setCarStatusImages();
                    centerRepository.updateCarStateVMMap(currentCarState);
                  }
                  //rotationController.forward();
                  trunkStatus = message.status;
                  if (trunkStatus) {
                    _counter = 1;
                    // rotationController.forward();
                  } else {
                    _counter = 0;
                    // rotationController.reverse();
                  }
                } else if (message.type == 'CAPUT') {
                  if (currentCarState != null) {
                    currentCarState.isCaputOpen = message.status;
                    currentCarState.setCarStatusImages();
                    centerRepository.updateCarStateVMMap(currentCarState);
                  }
                  // rotationController.forward();
                  caputStatus = message.status;
                  if (caputStatus) {
                    _counter = 1;
                    // rotationController.forward();
                  } else {
                    _counter = 0;
                    rotationController.reverse();
                  }
                } else if (message.type == 'CARPAGE') {
                  currentCarIndex = message.index;
                }
              }
            } else {}

            return Container(
              height: MediaQuery.of(context).size.height - 60.0,
              child: SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                enablePullDown: true,
                //physics: BouncingScrollPhysics(),
                footer: MaterialClassicHeader(
                  color: Theme.of(context).indicatorColor,
                  height: 20.0,
                  backgroundColor: Theme.of(context).backgroundColor,
                  //loadStyle: LoadStyle.ShowWhenLoading,
                  //completeDuration: Duration(milliseconds: 500),
                ),
                header: WaterDropMaterialHeader(),
                onRefresh: () async {
                  //monitor fetch data from network
                  await Future.delayed(Duration(milliseconds: 1000));

                  var result = await refreshCars();
                  if (mounted) setState(() {});
                  if (result == null)
                    _refreshController.refreshFailed();
                  else
                    _refreshController.refreshCompleted();
                },
                onLoading: () async {
                  //monitor fetch data from network
                  await Future.delayed(Duration(milliseconds: 1000));
                  var result = await refreshCars();
                  if (mounted) setState(() {});
                  if (result == null)
                    _refreshController.loadFailed();
                  else
                    _refreshController.loadComplete();
                },
                child: ListView.builder(
                  padding: kMaterialListPadding,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return AppBarCollaps(
                        _controller,
                        clr,
                        createCarPages(
                            opacityNotifier) /*createHomeScrollList(startImagePath,0)*/,
                        engineStatus,
                        lockStatus,
                        carPageChangedNoty,
                        _currentColor,
                        currentCarIndex,
                        carCount);
                  },
                ),
              ),
              // },
            );
          }),
    ));

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: Translations.of(context).register(),
          colorLineSelected: Colors.orange,
          baseStyle: TextStyle(
              /*color: Colors.black.withOpacity(0.8),*/ fontSize: 25.0),
          selectedStyle: TextStyle(color: Colors.orange),
          content: ListTile(
            onTap: () {
              centerRepository.goToPage(context, '/showusers');
            },
            leading: Icon(
              Icons.person_add,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
            title: Text(Translations.of(context).users(),
                style: TextStyle(
                    fontSize: 14,
                    // color: isLoginned ? Colors.blueAccent : Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        /*isLoginned ? new LogoutDialog() : */ new RegisterScreen()));

    itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: Translations.of(context).car(),
        colorLineSelected: Colors.orange,
        baseStyle:
            TextStyle(/*color: Colors.black.withOpacity(0.8),*/ fontSize: 25.0),
        selectedStyle: TextStyle(color: Colors.orange),
        content: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Colors.pinkAccent.withOpacity(0.2),
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/carpage',
                  arguments: new CarPageVM(
                      userId: userId,
                      isSelf: true,
                      carAddNoty: valueNotyModelBloc));
            },
            leading: Icon(
              Icons.directions_car,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
            title: new Text(Translations.of(context).car(),
                style: TextStyle(
                    fontSize: 14,
                    //color: Colors.black,
                    fontWeight: FontWeight.bold)),
            subtitle: new Text(Translations.current.cars() + " ",
                style: Theme.of(context).textTheme.headline),
          ),
        ),
      ),
      new CarPage(
          carPageVM: new CarPageVM(
              userId: userId, isSelf: true, carAddNoty: valueNotyModelBloc)),
    ));
    itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: Translations.of(context).security(),
        colorLineSelected: Colors.orange,
        baseStyle:
            TextStyle(/*color: Colors.black.withOpacity(0.8),*/ fontSize: 25.0),
        selectedStyle: TextStyle(color: Colors.orange),
        content: ListTile(
          leading: Icon(
            Icons.security,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
          title: Text(Translations.of(context).security(),
              style: TextStyle(
                  fontSize: 14,
                  // color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      new SecuritySettingsScreen(),
    ));

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: !isLoginned
              ? Translations.of(context).settings()
              : Translations.of(context).exit(),
          colorLineSelected: Colors.orange,
          baseStyle: TextStyle(
              color: Theme.of(context).textTheme.headline.color,
              fontSize: 25.0),
          selectedStyle: TextStyle(color: Colors.orange),
          content: ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ),
              title: Text(
                Translations.of(context).settings(),
              )),
        ),
        Container(
          color: Colors.orange,
          child: Center(
            child: new SettingsScreen(),
          ),
        )));

    itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: Translations.of(context).profile(),
        colorLineSelected: Colors.orange,
        baseStyle:
            TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 25.0),
        selectedStyle: TextStyle(color: Colors.orange),
        content: ListTile(
          leading: Icon(
            Icons.person_pin,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
          title: Text(Translations.of(context).profile(),
              style: TextStyle(
                  fontSize: 14,
                  //color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      isLoginned
          ? new ProfileTwoPage(user: centerRepository.getUserInfo())
          : new LoginTwoPage(),
    ));

    itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: Translations.of(context).support(),
        colorLineSelected: Colors.orange,
        baseStyle:
            TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 20.0),
        selectedStyle: TextStyle(color: Colors.orange),
        content: ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.black,
            size: 20,
          ),
          title: Text(Translations.of(context).exit(),
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      isLoginned ? new LogoutDialog() : new LoginTwoPage(),
    ));
  }

  List<MenuItem> createMenuList(BuildContext context) {
    final List<MenuItem> options = [
      MenuItem(Icons.person_add, Translations.of(context).register(), context,
          registerId),
      MenuItem(
          Icons.search, Translations.of(context).search(), context, searchId),
      MenuItem(Icons.shopping_basket, Translations.of(context).basket(),
          context, basketId),
      // MenuItem(Icons.transfer_within_a_station, Translations.of(context).coach(),context,-1),
      //MenuItem(Icons.list, Translations.of(context).myPrograms(),context,myProgramsId),
      MenuItem(Icons.help, Translations.of(context).help(), context, helpId),
    ];
    return options;
  }
  /* _modalBottomSheet(Customer user){
      return showModalBottomSheet(
        context: context,
        builder: (builder){
  return LogoutDialog(user: user);
    }
      );
  }*/

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    createMenuContent(context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class MenuItem {
  int id;
  String title;
  IconData icon;
  BuildContext context;
  MenuItem(this.icon, this.title, this.context, this.id);
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.cyan,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                SimpleHiddenDrawerProvider.of(context)
                    .setSelectedMenuPosition(0);
              },
              child: Text("Menu 1"),
            ),
            RaisedButton(
                onPressed: () {
                  SimpleHiddenDrawerProvider.of(context)
                      .setSelectedMenuPosition(1);
                },
                child: Text("Menu 2"))
          ],
        ),
      ),
    );
  }
}

NotyBloc<Message> messageCountNoty = new NotyBloc<Message>();
NotyBloc<Message> fcmNoty = new NotyBloc<Message>();

//NotyBloc<Message> startEnginChangedNoty=new NotyBloc<Message>();
NotyBloc<CarStateVM> statusChangedNoty = new NotyBloc<CarStateVM>();
/*NotyBloc<Message> carPageChangedNoty=new NotyBloc<Message>();
NotyBloc<Message> carLockPanelNoty=new NotyBloc<Message>();
NotyBloc<SendingCommandVM> sendCommandNoty=new NotyBloc<SendingCommandVM>();*/
NotyBloc<ChangeEvent> valueNotyModelBloc = new NotyBloc<ChangeEvent>();
