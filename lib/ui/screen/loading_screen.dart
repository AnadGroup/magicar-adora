import 'dart:async';
import 'dart:math';

import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/components/do_download.dart';
import 'package:anad_magicar/components/fancy_background.dart';
import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/data/ds/action_ds.dart';
import 'package:anad_magicar/data/ds/car_brands_ds.dart';
import 'package:anad_magicar/data/ds/car_color_ds.dart';
import 'package:anad_magicar/data/ds/car_device_ds.dart';
import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/data/ds/car_model_detail_ds.dart';
import 'package:anad_magicar/data/ds/car_model_ds.dart';
import 'package:anad_magicar/data/ds/plan_ds.dart';
import 'package:anad_magicar/data/fetch_data.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/firebase/message/firebase_message_handler.dart';
import 'package:anad_magicar/model/action_to_role_model.dart';
import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/current_user_accessable_action.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/cars/car_model_detail.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/invoice/invoice.dart';
import 'package:anad_magicar/model/plan_model.dart';
import 'package:anad_magicar/model/shopcart_model.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/role.dart';
import 'package:anad_magicar/model/user/user_data.dart';
import 'package:anad_magicar/model/viewmodel/init_data_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/download/download_repository.dart';
import 'package:anad_magicar/repository/fake_server.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/ui/screen/content_pager/main_navigator.dart';
import 'package:anad_magicar/utils/check_status_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoadingScreen extends StatefulWidget {
  FireBaseMessageHandler messageHandler;
  final GlobalKey<NavigatorState> navigatorKey;
  LoadingScreen({Key key, this.messageHandler, this.navigatorKey})
      : super(key: key);

  @override
  _LoadingScreenState createState() => new _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  bool _loadingInProgress;
  bool isLoading = false;
  String message = '';
  Animation<double> _angleAnimation;

  Animation<double> _scaleAnimation;

  AnimationController _controller;
  VoidCallback _showBottomSheetCallback;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  InitDataVM initDataVM;
  FetchData<InitDataVM> fetchData;

  CarBrandsDS carBrandsDS;
  CarColorsDS carColorsDS;
  CarModelDS carModelDS;
  CarDevicesDS carDevicesDS;
  CarDS carDS;
  ActionDS actionDS;
  PlanDS planDS;
  CarModelDetaillDS carModelDetaillDS;
  RestDatasource restDS;

  Future<InitDataVM> initData;
  void registerBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event) {
      message = event.message;

      if (event.message == 'APP_VERSION_CHECKED_VALID') {
        _dataLoaded();
      } else if (event.message == "APP_VERSION_CHECKED_NOTVALID") {
        _modalBottomSheetDownload();
      } else if (event.message == 'DOWNLOAD_CANCELED') {
        _dataLoaded();
      }
    });
  }

  void _modalBottomSheetDownload() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return DownloadAPK();
        });
  }

  void _loadItemsInCart() async {
    List<ShopCartModel> itemsInCart = new List();
    itemsInCart = await databaseHelper.getShopCartItems();
    if (itemsInCart != null && itemsInCart.length > 0) {}
  }

  void sendFCMToken() async {
    int userId = await prefRepository.getLoginedUserId();
    String token = await prefRepository.getFCMToken();
    if (token != null && token.isNotEmpty) {
      ServiceResult result = await restDatasource.sendFCMToken(userId, token);
      if (result != null) {
        if (result.IsSuccessful) {
        } else {}
      }
    }
  }

  static bool hasInternet = true;
  static StreamSubscription _connectionChangeStream;
  static void connectionChanged(dynamic hasConnection) {
    hasInternet = hasConnection;
  }

  void checkInternet() async {
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    hasInternet = await connectionStatus.checkConnection();
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
    centerRepository.initDataValues();
    // widget.messageHandler.initMessageHandler();
    ActionsCommand.createActionsTitleMap();
    ActionsCommand.createActionIconsURlMap();
    _loadingInProgress = true;
    _showBottomSheetCallback = _showPersistBottomSheet;
    registerBus();

    //initConnectivity();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _angleAnimation = new Tween(begin: 0.0, end: 360.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _scaleAnimation = new Tween(begin: 1.0, end: 6.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _angleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_loadingInProgress) {
          _controller.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (_loadingInProgress) {
          _controller.forward();
        }
      }
    });

    _controller.forward();

    carBrandsDS = new CarBrandsDS();
    carModelDS = new CarModelDS();
    carColorsDS = new CarColorsDS();
    carDevicesDS = new CarDevicesDS();
    carDS = new CarDS();
    planDS = new PlanDS();
    actionDS = new ActionDS();
    carModelDetaillDS = new CarModelDetaillDS();
    restDS = new RestDatasource();

    initData = _loadData();
  }

  Future<List<ApiMessage>> getMessages() {
    var result = restDatasource.getUserMessage();
    if (result != null) {
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
          /* OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ) {
              if (connectivity == ConnectivityResult.none) {
                hasInternet=false;
                initData= _loadData();
                return FutureBuilder<InitDataVM>(
                  future: initData,
                  builder: (context,snapshot) {
                    */ /*if (snapshot.connectionState == ConnectionState.none &&
          snapshot.hasData == null) {
        return Container();
      }
      else*/ /* if(*/ /*snapshot.connectionState == ConnectionState.done &&*/ /*
                    snapshot.hasData &&
                        snapshot.data!=null)
                    {
                      _dataLoaded();
                      return new HomeScreen();
                    }
                    else if(!snapshot.hasData && !hasInternet)
                    {

                      return new HomeScreen();
                    }
                    else if(snapshot.hasError)
                    {
                      return Text("${snapshot.error}");
                    }

                    return
                      FancyBackgroundApp();
                  },

                );
              } else {
                initData= _loadData();
                return child;
              }
            },
            child:*/
          FutureBuilder<InitDataVM>(
        future: initData,
        builder: (context, snapshot) {
          /*if (snapshot.connectionState == ConnectionState.none &&
          snapshot.hasData == null) {
        return Container();
      }
      else*/
          if (/*snapshot.connectionState == ConnectionState.done &&*/
              snapshot.hasData && snapshot.data != null) {
            _dataLoaded();
            return new MainNavigator(
              navigatorKey: widget.navigatorKey,
            );
          } else if (!snapshot.hasData && !hasInternet) {
            return new MainNavigator(
              navigatorKey: widget.navigatorKey,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return FancyBackgroundApp();
        },

        //  ),
      ),
    );
  }

  void _showPersistBottomSheet() {
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          final ThemeData themeData = Theme.of(context);
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.close),
                    title: new Text(
                        'نسخه جدسد برنامه در دسترس میباشد.جهت دریافت و نصب دکمه دریات را لمس کنید'),
                    onTap: () => null,
                  ),
                  new DownloadAPK(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // re-enable the button
                        _showBottomSheetCallback = null;
                      });
                    },
                    child: new DoDownload(),
                  ),
                ],
              ),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button
              _showBottomSheetCallback = _showPersistBottomSheet;
            });
          }
        });
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return new Stack(
        children: [
          new Center(
              child: new SpinKitCubeGrid(
            color: Colors.white,
            size: 80.0,
          )),
          new Center(
            child: _buildAnimation(),
          )
        ],
      );
    } else {
      return new Center(
        child: new SpinKitCubeGrid(
          color: Colors.white,
          size: 80.0,
        ),
      );
    }
  }

  Widget _buildAnimation() {
    double circleWidth = 10.0 * _scaleAnimation.value;
    Widget circles = new Container(
      width: circleWidth * 2.0,
      height: circleWidth * 2.0,
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              _buildCircle(circleWidth,CenterRepository.APP_TYPE_ADORA ? Colors.deepOrange : Colors.blue),
              _buildCircle(circleWidth, Colors.red),
            ],
          ),
          new Row(
            children: <Widget>[
              _buildCircle(circleWidth, Colors.yellow),
              _buildCircle(circleWidth, Colors.green),
            ],
          ),
        ],
      ),
    );

    double angleInDegrees = _angleAnimation.value;
    return new Transform.rotate(
      angle: angleInDegrees / 360 * 2 * pi,
      child: new Container(
        child: circles,
      ),
    );
  }

  Widget _buildCircle(double circleWidth, Color color) {
    return new Container(
      width: circleWidth,
      height: circleWidth,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Future<InitDataVM> _loadData() async {
    if (hasInternet) {
      isLoading = true;
      int userId = await prefRepository.getLoginedUserId();

      try {
        List<SaveUserModel> userInfo =
            await restDS.getUserInfo(userId.toString());
        if (userInfo != null && userInfo.length > 0) if (userInfo[0].isSuccess)
          centerRepository.setUserInfo(userInfo[0]);
      } catch (error) {
        Fluttertoast.showToast(msg: error.toString());
      }

      List<BrandModel> brands = List();
      brands = await carBrandsDS.getAll(BaseRestDS.GET_BRANDS_URL);
      if (brands != null) centerRepository.setCarBrands(brands);

      List<ApiCarColor> colors = new List();
      colors = await carColorsDS.getAll(BaseRestDS.GET_CAR_COLORS_URL);
      if (colors != null) centerRepository.setCarColors(colors);

      List<CarModel> models = new List();
      models = await carModelDS.getAll(BaseRestDS.GET_CAR_MODELS_URL);
      if (models != null) centerRepository.setCarModels(models);

      List<Role> roles = new List();
      roles = await restDatasource.getAllRoles();
      if (roles != null) centerRepository.setRole(roles);

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

      List<Car> cars = new List();
      cars = await restDS.getAllCars(userId);
      centerRepository.setCars(cars);

      List<CarModelDetail> carModelDetails = new List();
      carModelDetails =
          await carModelDetaillDS.getAll(BaseRestDS.GET_CAR_MODEL_DETAIL_URL);
      centerRepository.setCarModelDetail(carModelDetails);

      List<AdminCarModel> carsToAdmin = new List();
      carsToAdmin = await carDS.getAllCarsByUserId(userId);
      if (carsToAdmin != null) {
        centerRepository.setCarsToAdmin(carsToAdmin);
        prefRepository.setCarsCount(carsToAdmin.length);
      } else {
        prefRepository.setCarsCount(0);
      }

      List<InvoiceModel> invoices = new List();
      invoices = await restDS.getAllInvoices();
      if (invoices != null) centerRepository.setInvoices(invoices);

      List<ServiceType> sTypes = new List();
      sTypes = await restDatasource.getCarServiceTypes();
      if (sTypes != null && sTypes.length > 0)
        centerRepository.setServiceTypes(sTypes);

      List<ApiMessage> messages = await getMessages();
      if (messages != null && messages.length > 0) {
        var result = messages
            .where((m) =>
                m.MessageStatusConstId != ApiMessage.MESSAGE_STATUS_AS_READ_TAG)
            .toList();
        if (result != null && result.length > 0) {
          CenterRepository.messageCounts = result.length;
        }
      }

      if (brands != null &&
          colors != null &&
          models != null &&
          carModelDetails != null) {
        InitDataVM resultModel = new InitDataVM(
            carColor: null,
            carModel: null,
            carBrand: null,
            carDevice: null,
            carDevices: centerRepository.getDevices(),
            carModels: centerRepository.getCarModels(),
            carColors: centerRepository.getCarColors(),
            carBrands: centerRepository.getCarBrands(),
            carsToAdmin: carsToAdmin);

        isLoading = false;
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
          carDevices: null /*centerRepository.getDevices()*/,
          carModels: centerRepository.getCarModels(),
          carColors: centerRepository.getCarColors(),
          carBrands: centerRepository.getCarBrands(),
          carsToAdmin: centerRepository.getCarsToAdmin());

      isLoading = false;
      return resultModel;
    }
    return null;
  }

  _dataLoaded() async {
    sendFCMToken();
    String userName = await prefRepository.getLoginedUserName();
    String auth_token = await prefRepository.getLoginedToken();
    int userId = await prefRepository.getLoginedUserId();
    int carCounts = await prefRepository.getCarsCount();
    int userCounts = 0;
    _loadingInProgress = false;
    UserLoginedInfo userLoginedInfo = new UserLoginedInfo(
        userName: userName,
        userCounts: userCounts,
        carCounts: carCounts,
        auth_token: auth_token,
        logined_date: '',
        userId: userId);
    centerRepository.setUserLoginedInfoCached(userLoginedInfo);
    // return new HomeScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _LoadingScreenState() : super();
}
