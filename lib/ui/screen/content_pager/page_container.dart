import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/logout_form.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/map_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/home.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/plugin_scalebar.dart';
import 'package:anad_magicar/ui/screen/adora_vehicle_status/adora_vehicle_status_screen.dart';
import 'package:anad_magicar/ui/screen/car/register_car_screen.dart';
import 'package:anad_magicar/ui/screen/device/register_device.dart';
import 'package:anad_magicar/ui/screen/help/help_screen.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/login/finger_print_auth.dart';
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
import 'package:anad_magicar/ui/screen/user/user_access_detail.dart';
import 'package:anad_magicar/widgets/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageContent extends StatefulWidget {
  GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  PageContent({Key key, this.navigatorKey, this.scaffoldKey}) : super(key: key);

  @override
  PageContentState createState() {
    return PageContentState();
  }
}

class PageContentState extends State<PageContent> {
  final navigatorKey = GlobalKey<NavigatorState>();

  static String lastRouteSelected =    '/home';

  String route = '/first';
  final String imageUrl = 'assets/images/user_profile.png';
  String userName = '';
  int userId = 0;
  bool isDark = false;
  int _selectedIndex = 2;
  int _currentCarId = 0;
  NotyBloc<Message> _changeIndexSelected = new NotyBloc<Message>();

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

  void _onItemTapped(int index) {
    //pageController.animateToPage(index, duration: new Duration(milliseconds: 200), curve: Curves.ease);
    String root = '/home';
    if (index == 0) {
      root = '/servicepage';
    }
    if (index == 1) {
      root = '/mappage';
    }
    if (index == 2) {
      root = '/home';
    }
    if (index == 3) {
      root = '/messages';
    }
    if (index == 4) {
      root = '/plans';
    }
    CenterRepository.lastPageSelected = index;
    _push(context, root, null, materialIndex: index);
  }

  void _onPageChanged(int index) {
    _selectedIndex = index;
    CenterRepository.lastPageSelected = index;
    _changeIndexSelected.updateValue(new Message(index: _selectedIndex));
  }

  Widget createServiceWidget() {
    _currentCarId = CenterRepository.getCurrentCarId();
    Car car = centerRepository.getCarByCarId(_currentCarId);
    return MainPageService(
      scaffoldKey: widget.scaffoldKey,
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
      scaffoldKey: widget.scaffoldKey,
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
      scaffoldKey: widget.scaffoldKey,
    );
  }

  Widget createMessagesWidget() {
    _currentCarId = CenterRepository.getCurrentCarId();
    return MessageHistoryScreen(
      carId: _currentCarId,
      scaffoldKey: widget.scaffoldKey,
    );
  }

  void _push(BuildContext context, String root, RouteSettings routeSettings,
      {int materialIndex: 500}) {
    lastRouteSelected = root;
    var routeBuilders =
        _routeBuilders(context, routeSettings, materialIndex: materialIndex);

    navigatorKey.currentState.push(MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => routeBuilders[root](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(
      BuildContext context, RouteSettings routeSettings,
      {int materialIndex: 500}) {

    return {

 
         AdoraVehicleStatusScreen.route: (context) {
        _onPageChanged(2);
        return AdoraVehicleStatusScreen(
          scaffoldKey: widget.scaffoldKey,
        );
      },

      '/': (context) {
          if(CenterRepository.APP_TYPE_ADORA ) {
 return AdoraVehicleStatusScreen(
          scaffoldKey: widget.scaffoldKey,
        );
          } else {
        return HomeScreen(
          scaffoldKey: widget.scaffoldKey,
        );
          }
      },
      '/help': (context) {
        return HelpScreen(
          pathPDF: routeSettings.arguments,
        );
      },
      '/home': (context) {
      
         _onPageChanged(2);
          if(CenterRepository.APP_TYPE_ADORA ) {
 return AdoraVehicleStatusScreen(
          scaffoldKey: widget.scaffoldKey,
        );
          } else {
        return HomeScreen(
          scaffoldKey: widget.scaffoldKey,
        );
          }
  
      },

      '/servicepage': (context) {
        _onPageChanged(0);
        return createServiceWidget();
      },
      '/mappage': (context) {
        _onPageChanged(1);
        return createMapPageWidget();
      },
      '/messages': (context) {
        _onPageChanged(3);
        return createMessagesWidget();
      },
      '/plans': (context) {
        _onPageChanged(4);
        return createPlansWidget();
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
        return ProfileTwoPage(
          user: routeSettings.arguments,
        );
      },
      '/addcar': (context) {
        return RegisterCarScreen(
          addCarVM: routeSettings.arguments,
        );
      },
      // '/carpage': (context) { return   new CarPage(carPageVM: routeSettings.arguments,);},
      '/messageapp': (context) {
        return MessageAppPage(
          carId: routeSettings.arguments,
          scaffoldKey: widget.scaffoldKey,
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
          scaffoldKey: widget.scaffoldKey,
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
      //'/settings': (context) { return  new SecuritySettingsScreen(fromMain: routeSettings.arguments,);},
      // '/appsettings': (context) { return  new SettingsScreen();},
      // '/loadingscreen': (context) { return  new LoadingScreen(messageHandler: null,);},
      //'/showusers': (context) { return  new UsersPage();},
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
    super.initState();
    _changeIndexSelected = new NotyBloc<Message>();
    getAppTheme();
    // getUserName();
    // pageController = new PageController(initialPage: _selectedIndex,keepPage: true);

    /* if(CenterRepository.lastPageSelected>-1)
      if(mounted)  _onItemTapped(CenterRepository.lastPageSelected);*/
    _selectedIndex = CenterRepository.lastPageSelected > -1
        ? CenterRepository.lastPageSelected
        : 2;
  }

  @override
  void dispose() {
    _changeIndexSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
      onWillPop: () async {
        return _onWillPop(context);
      },
      child: Scaffold(
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
        bottomNavigationBar: StreamBuilder<Message>(
            stream: _changeIndexSelected.noty,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                _selectedIndex = snapshot.data.index;
              }
              return CurvedNavigationBar(
                animationDuration: new Duration(milliseconds: 800),
                index: _selectedIndex,
                height: 60.0,
                color: centerRepository.getBackNavThemeColor(!isDark, context),
                backgroundColor: centerRepository.getBackNavThemeColor(
                    isDark, context), //Colors.blueAccent[400],
                items: <Widget>[
                  Icon(Icons.build, size: 30, color: CenterRepository.APP_TYPE_ADORA ? Colors.white : Colors.indigoAccent),
                  Icon(Icons.pin_drop, size: 30, color: CenterRepository.APP_TYPE_ADORA ? Colors.white : Colors.indigoAccent),
                  Icon(Icons.directions_car,
                      size: 30, color: CenterRepository.APP_TYPE_ADORA ? Colors.white : Colors.indigoAccent),
                  Icon(Icons.message, size: 30, color: CenterRepository.APP_TYPE_ADORA ? Colors.white : Colors.indigoAccent),
                  Icon(
                    Icons.payment,
                    size: 30,
                    color:  CenterRepository.APP_TYPE_ADORA ? Colors.white : Colors.indigoAccent,
                  ),
                ],
                onTap: (index) {
                  _onItemTapped(index);
                },
              );
            }),
      ),
    );
  }
}
