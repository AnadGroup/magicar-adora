import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/components/logout_form.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/map_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/home.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/plugin_scalebar.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/car/register_car_screen.dart';
import 'package:anad_magicar/ui/screen/content_pager/page_container.dart';
import 'package:anad_magicar/ui/screen/device/register_device.dart';
import 'package:anad_magicar/ui/screen/help/help_screen.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/login/finger_print_auth.dart';
import 'package:anad_magicar/ui/screen/login/login_page.dart';
import 'package:anad_magicar/ui/screen/login/reset/reset_screen.dart';
import 'package:anad_magicar/ui/screen/message/message_history_screen.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_page.dart';
import 'package:anad_magicar/ui/screen/message_app/new_message_item.dart';
import 'package:anad_magicar/ui/screen/payment/invoice_form.dart';
import 'package:anad_magicar/ui/screen/profile/profile2.dart';
import 'package:anad_magicar/ui/screen/register/edit_profile.dart';
import 'package:anad_magicar/ui/screen/register/register_screen.dart';
import 'package:anad_magicar/ui/screen/service/main_service_page.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_type/register_service_type_page.dart';
import 'package:anad_magicar/ui/screen/service/service_type/service_type_page.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/ui/screen/setting/security_screen.dart';
import 'package:anad_magicar/ui/screen/user/user_access_detail.dart';
import 'package:anad_magicar/ui/screen/user/users_page.dart';
import 'package:anad_magicar/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class MainNavigator extends StatefulWidget {
  MainNavigator({
    this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  MainNavigatorState createState() {
    return MainNavigatorState();
  }
}

class MainNavigatorState extends State<MainNavigator> {
  final navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String route = '/main';
  static String lastRouteSelected = '/first';
  final String imageUrl = 'assets/images/user_profile.png';
  String userName = '';
  int userId = 0;
  bool isDark = false;
  // int _selectedIndex = 2;
  int _currentCarId = 0;
  // NotyBloc<Message> _changeIndexSelected = new NotyBloc<Message>();
  //List<Widget> _widgets;//= <Widget>[HomeScreen(), ProfilePage()];
  // PageController pageController = PageController();

  getAppTheme() async {
    int dark = await changeThemeBloc.getOption();
    setState(() {
      if (dark == 1)
        isDark = true;
      else
        isDark = false;
    });
  }

  getUserName() async {
    userName = await prefRepository.getLoginedUserName();
    userId = await prefRepository.getLoginedUserId();
    CenterRepository.setUserId(userId);
    centerRepository.setUserCached(
      new User(userName: userName, imageUrl: imageUrl, id: userId),
    );
    _currentCarId = CenterRepository.getCurrentCarId();
  }

  onCarPageTap(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/carpage',
        arguments: new CarPageVM(
            userId: userId, isSelf: true, carAddNoty: valueNotyModelBloc));
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

  void _push(BuildContext context, String root, RouteSettings routeSettings,
      {int materialIndex: 500}) {
    var routeBuilders =
        _routeBuilders(context, routeSettings, materialIndex: materialIndex);

    navigatorKey.currentState.push(MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => routeBuilders[root](context)));
  }

  void registerEventRXBUS() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event) {
      if (event.type == 'NEW_PAGE') {
        _push(context, MessageAppPageState.route,
            RouteSettings(arguments: CenterRepository.getCurrentCarId()));
      }
    });
  }

  Widget createServiceWidget() {
    _currentCarId = CenterRepository.getCurrentCarId();
    Car car = centerRepository.getCarByCarId(_currentCarId);
    return MainPageService(
      scaffoldKey: _scaffoldKey,
      serviceVM: new ServiceVM(
          car: car,
          carId: _currentCarId,
          editMode: null,
          service: null,
          refresh: false),
    );
  }

  Widget createPlansWidget() {
    _currentCarId = CenterRepository.getCurrentCarId();
    return InvoiceForm(
      scaffoldKey: _scaffoldKey,
    );
  }

  Widget createMapPageWidget() {
    _currentCarId = CenterRepository.getCurrentCarId();
    return MapPage(
      mapVM: MapVM(
        carId: _currentCarId,
        carCounts: centerRepository.getCarsToAdmin().length,
        cars: centerRepository.getCarsToAdmin(),
      ),
      scaffoldKey: _scaffoldKey,
    );
  }

  Widget createMessagesWidget() {
    _currentCarId = CenterRepository.getCurrentCarId();
    return MessageHistoryScreen(
      carId: _currentCarId,
      scaffoldKey: _scaffoldKey,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(
      BuildContext context, RouteSettings routeSettings,
      {int materialIndex: 500}) {
    return {
      '/first': (context) {
        return PageContent(
          navigatorKey: navigatorKey,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/servicepage': (context) {
        return PageContent(
          navigatorKey: navigatorKey,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/mappage': (context) {
        return PageContent(
          navigatorKey: navigatorKey,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/messages': (context) {
        return PageContent(
          navigatorKey: navigatorKey,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/plans': (context) {
        return PageContent(
          navigatorKey: navigatorKey,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/help': (context) {
        return HelpScreen(
          pathPDF: routeSettings.arguments,
        );
      },
      '/login': (context) {
        return LoginPage(
          messageHandler: null,
          navigatorKey: navigatorKey,
          userRepository: UserRepository(),
          loginType: routeSettings.arguments,
        );
      },

      '/register': (context) {
        return RegisterScreen(
          mobile: routeSettings.arguments,
        );
      },
      '/editprofile': (context) {
        return EditProfileScreen();
      },
      '/adduser': (context) {
        return RegisterScreen();
      },
      '/myprofile': (context) {
        return ProfileTwoPage(user: routeSettings.arguments);
      },
      '/addcar': (context) {
        return RegisterCarScreen(
          addCarVM: routeSettings.arguments,
        );
      },
      '/carpage': (context) {
        return CarPage(
          carPageVM: routeSettings.arguments,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/messageapp': (context) {
        return MessageAppPage(
          carId: routeSettings.arguments,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/messageappdetail': (context) {
        return NewMessageItem(
          detailVM: routeSettings.arguments,
        );
      },
      '/servicetypepage': (context) {
        return ServiceTypePage(
          carId: routeSettings.arguments,
        );
      },
      '/registerservicepage': (context) {
        return RegisterServicePage(
          serviceVM: routeSettings.arguments,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/registerservicetypepage': (context) {
        return RegisterServiceTypePage(
          regServiceTypeVM: routeSettings.arguments,
        );
      },
      '/adddevice': (context) {
        return RegisterDeviceScreen(
          hasConnection: true,
          userId: CenterRepository.getUserId(),
          changeFormNotyBloc: changeFormNotyBloc,
          fromMainApp: routeSettings.arguments,
        );
      },
      '/fingerprint': (context) {
        return TouchID();
      },
      '/settings': (context) {
        return SecuritySettingsScreen(
          fromMain: routeSettings.arguments,
          scaffoldKey: _scaffoldKey,
        );
      },
      '/appsettings': (context) {
        return SettingsScreen(
          scaffoldKey: _scaffoldKey,
        );
      },
      // '/loadingscreen': (context) { return  new LoadingScreen(messageHandler: null,);},
      '/showusers': (context) {
        return UsersPage(
          scaffoldKey: _scaffoldKey,
        );
      },
      '/showuser': (context) {
        return UserAccessPage(
          accessableActionVM: routeSettings.arguments,
        );
      },
      '/logout': (context) {
        return LogoutForm();
      },
      '/reset': (context) {
        return ResetScreen();
      },
      '/plugin_scalebar': (context) {
        return PluginScaleBar();
      },
    };
  }

  @override
  void initState() {
    lastRouteSelected = '/first';
    super.initState();
    registerEventRXBUS();
    getAppTheme();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onWillPop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(
          navigatStateKey: navigatorKey,
          // key: _scaffoldKey,
          userId: userId,
          scafoldKey: _scaffoldKey,
          userName: userName,
          currentRoute: route,
          imageUrl: imageUrl,
          carPageTap: onCarPageTap,
          carId: CenterRepository.getCurrentCarId(),
        ),
        appBar: null,
        body: Navigator(
            key: navigatorKey,
            initialRoute: lastRouteSelected,
            onGenerateRoute: (routeSettings) {
              var routeBuilders = _routeBuilders(context, routeSettings);
              lastRouteSelected = routeSettings.name;
              return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (context) =>
                      routeBuilders[routeSettings.name](context));
            }),
      ),
    );
  }
}
