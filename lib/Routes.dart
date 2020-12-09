import 'dart:async';

import 'package:anad_magicar/TranslationsDelegate.dart';
import 'package:anad_magicar/authentication/authentication.dart';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart' as gbloc;
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/bloc/local/change_local_bloc.dart';
import 'package:anad_magicar/bloc/local/change_local_state.dart';
import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/theme/change_theme_state.dart';
import 'package:anad_magicar/bloc/theme/theme.dart';
import 'package:anad_magicar/common/common.dart';
import 'package:anad_magicar/components/loading_indicator.dart';
import 'package:anad_magicar/components/logout_form.dart';
import 'package:anad_magicar/components/pull_refresh/pull_to_refresh.dart';
import 'package:anad_magicar/components/pull_refresh/refresh_glowindicator.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/plugin_scalebar.dart';
import 'package:anad_magicar/ui/screen/AnimatedSplashScreen.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/car/register_car_screen.dart';
import 'package:anad_magicar/ui/screen/content_pager/main_navigator.dart';
import 'package:anad_magicar/ui/screen/content_pager/page_container.dart';
import 'package:anad_magicar/ui/screen/device/register_device.dart';
import 'package:anad_magicar/ui/screen/loading_screen.dart';
import 'package:anad_magicar/ui/screen/login/finger_print_auth.dart';
import 'package:anad_magicar/ui/screen/login/login_page.dart';
import 'package:anad_magicar/ui/screen/login/reset/reset_screen.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_page.dart';
import 'package:anad_magicar/ui/screen/message_app/new_message_item.dart';
import 'package:anad_magicar/ui/screen/profile/profile2.dart';
import 'package:anad_magicar/ui/screen/register/edit_profile.dart';
import 'package:anad_magicar/ui/screen/register/register_screen.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_type/register_service_type_page.dart';
import 'package:anad_magicar/ui/screen/service/service_type/service_type_page.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/ui/screen/setting/security_screen.dart';
import 'package:anad_magicar/ui/screen/user/user_access_detail.dart';
import 'package:anad_magicar/ui/screen/user/users_page.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:screen_state/screen_state.dart';

/*final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();*/

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

class Routes {
  void _enablePlatformOverrideForDesktop() {
    if (!kIsWeb) {
      // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    }
  }

  Routes() {
    _enablePlatformOverrideForDesktop();
    runApp(MyApp(
      userRepository: UserRepository(),
    ));
  }
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;

  MyApp({Key key, this.userRepository}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  static var theme;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // Screen _screen;
  //StreamSubscription<ScreenStateEvent> _subscription;

  AuthenticationBloc _authenticationBloc;

  UserRepository get _userRepository => widget.userRepository;
  ThemeBloc _themeBloc;
  Future<Locale> local;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  TranslationsDelegate _localeOverrideDelegate =
      TranslationsDelegate(Locale('fa', 'IR'));

  showSnackLogin(BuildContext context, String message, bool isLoading) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 6),
      backgroundColor: Colors.amber,
      elevation: 0.8,
      content: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        child: Column(
          children: <Widget>[
            isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        CircularProgressIndicator(),
                      ])
                : Icon(
                    Icons.error_outline,
                    color: Colors.black,
                  ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontFamily: 'IranSans', fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  /* void onData(ScreenStateEvent event) async {
    if (event == ScreenStateEvent.SCREEN_ON) {
      final bool forceShowLogin = await prefRepository
          .getLoginStatusAtAppStarted(); //prefs.getBool('LOGINSTATUS');
      if (forceShowLogin == null) {
        _pushToLogin(context, LoginType.PASWWORD, '/login', RouteSettings());
      } else if ((forceShowLogin != null && forceShowLogin)) {
        int loginType = await prefRepository.getLoginStatusTypeAtAppStarted();
        if (loginType == null) {
          loginType = LoginType.PASWWORD.index;
        }
        //yield AuthenticationAuthenticated();
        _pushToLogin(
            context, LoginType.values[loginType], '/login', RouteSettings());
      } else if (forceShowLogin != null && !forceShowLogin) {}
    }
  }*/

//بدلیل سرعت بخشیدن در وب کامتی شد
  void startListening() {
    /*_screen = Screen();
    try {
      _subscription = _screen.screenStateStream.listen(onData);
    } on ScreenStateException catch (exception) {
      print(exception);
    }*/
  }

  void stopListening() {
    // _subscription?.cancel();
  }

  @override
  void initState() {
    //messageHandler.initMessageHandler();
    WidgetsBinding.instance.addObserver(this);
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _themeBloc = ThemeBloc();
    // _authenticationBloc.dispatch(AppStarted());
    super.initState();
    theme = Theme.of(context);
    // checkConnection();
    //startListening();
    /*  ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    initConnectivity();*/
    //FlashHelper.init(context);
    /* _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);*/
    local = prefRepository.fetchLocale();

    /*didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Container(
                      width: 0.0,
                      height: 0.0,
                    );
                  }
                      //  SecondScreen(receivedNotification.payload),
                      ),
                );
              },
            )
          ],
        ),
      );
    });
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Container(
            width: 0.0,
            height: 0.0,
          );
        }),
      );
    });*/

    FlashHelper.init(context);
  }

  void _pushToLogin(BuildContext context, LoginType loginType, String root,
      RouteSettings routeSettings) {
    MainNavigatorState.lastRouteSelected = '/first';
    _navigatorKey.currentState.pushReplacement(MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return LoginPage(
            messageHandler: null,
            showUserName: true,
            loginType: loginType,
            navigatorKey: _navigatorKey,
            userRepository: UserRepository(),
          );
        }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopListening();
    _authenticationBloc.close();
    _connectivitySubscription.cancel();
    /* didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();*/
    FlashHelper.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final bool forceShowLogin =
          await prefRepository.getLoginStatusAtAppStarted();

      if (forceShowLogin == null) {
        //   if (CenterRepository.isFromMapForGPSCheckForFirstTime == false) {
        //     //بدلیل مشکل در نقشه کامنت شد
        //    // _pushToLogin(context, LoginType.PASWWORD, '/login', RouteSettings());
        //   }
      } else if ((forceShowLogin != null && forceShowLogin)) {
        // int loginType = await prefRepository.getLoginStatusTypeAtAppStarted();
        // if (loginType == null) loginType = LoginType.PASWWORD.index;

        // if (CenterRepository.isFromMapForGPSCheckForFirstTime == false) {
        //   _pushToLogin(
        //       context, LoginType.values[loginType], '/login', RouteSettings());
        // }
      } else if (forceShowLogin != null && !forceShowLogin) {}
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
    } else if (state == AppLifecycleState.detached) {
      // app suspended (not used in iOS)
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale>(
        future: local,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              // Return some loading widget
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                // Return some error widget
                return Text('Error: ${snapshot.error}');
              } else {
                // Locale fetchedLocale = snapshot.data;

                return /*ScopedModelDescendant<AppModel>(
                    builder: (context, child, model) {*/
                    BlocBuilder<ChangeLocalBloc, ChangeLocalState>(
                        bloc: changeLocalBloc,
                        builder: (BuildContext context,
                            ChangeLocalState localState) {
                          return BlocProvider<AuthenticationBloc>(
                            create: (BuildContext context) =>
                                _authenticationBloc,
                            child: gbloc.BlocProvider<GlobalBloc>(
                              bloc: GlobalBloc(),
                              child: BlocBuilder<ChangeThemeBloc,
                                  ChangeThemeState>(
                                bloc: changeThemeBloc,
                                builder: (BuildContext context,
                                    ChangeThemeState state) {
                                  // return RefreshConfiguration(
                                  //   footerTriggerDistance: 15,
                                  //   dragSpeedRatio: 0.91,
                                  //   headerBuilder: () =>
                                  //       MaterialClassicHeader(),
                                  //   footerBuilder: () => ClassicFooter(),
                                  //   enableLoadingWhenNoData: false,
                                  //   shouldFooterFollowWhenNotFull: (state) {
                                  //     return false;
                                  //   },
                                  //   autoLoad: true,
                                  //   child:
                                  return MaterialApp(
                                    navigatorKey: _navigatorKey,

                                    builder: (context, child) {
                                      return child;
                                      // return ScrollConfiguration(
                                      //       child: child,
                                      //       behavior: RefreshScrollBehavior());
                                    },
                                    locale: localState.localData,
                                    localizationsDelegates: [
                                      _localeOverrideDelegate,
                                      GlobalMaterialLocalizations.delegate,
                                      GlobalWidgetsLocalizations.delegate,
                                    ],
                                    supportedLocales: [
                                      const Locale('fa', ''), // Farsi
                                      const Locale('en', ''), // English
                                    ],
                                    //supportedLocales: applic.supportedLocales(),
                                    onGenerateTitle: (BuildContext context) =>
                                        (CenterRepository.APP_TYPE_ADORA)
                                            ? Translations.of(context)
                                                .titleAdora()
                                            : Translations.of(context).title(),
                                    debugShowCheckedModeBanner: false,
                                    theme: state.themeData,
                                    //ThemeData(fontFamily: 'IranSans'),
                                    home: BlocBuilder<AuthenticationBloc,
                                        AuthenticationState>(
                                      //builder:(BuildContext context)=> _authenticationBloc,
                                      bloc: _authenticationBloc,
                                      builder: (BuildContext context,
                                          AuthenticationState state) {
                                        if (state
                                            is AuthenticationUninitialized) {
                                          return AnimatedSplashScreen(
                                              _authenticationBloc); //LoginPage(userRepository: UserRepository());
                                        }
                                        if (state
                                            is AuthenticationAuthenticated) {
                                          //Navigator.pushReplacementNamed(context, '/home');
                                          // return HomeScreen();
                                          return LoadingScreen(
                                            messageHandler: null,
                                            navigatorKey: _navigatorKey,
                                          );
                                        }
                                        if (state is AuthenticationLoading) {
                                          return LoadingIndicator();
                                        }
                                        if (state
                                            is AuthenticationUnauthenticated) {
                                          return LoginPage(
                                            messageHandler: null,
                                            loginType: state.loginType,
                                            navigatorKey: _navigatorKey,
                                            userRepository: UserRepository(),
                                          );
                                        }
                                        return new AnimatedSplashScreen(
                                            _authenticationBloc);
                                      },
                                    ),
                                    onGenerateRoute: (RouteSettings settings) {
                                      switch (settings.name) {
                                        case '/login':
                                          return new MyCustomRoute(
                                            builder: (_) => new LoginPage(
                                              messageHandler: null,
                                              navigatorKey: _navigatorKey,
                                              userRepository: UserRepository(),
                                              loginType: settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/first':
                                          return new MyCustomRoute(
                                            builder: (_) => new PageContent(
                                              navigatorKey: _navigatorKey,
                                            ),
                                            settings: settings,
                                          );
                                        case '/main':
                                          return new MyCustomRoute(
                                            builder: (_) => new MainNavigator(
                                                navigatorKey: _navigatorKey),
                                            settings: settings,
                                          );
                                        case '/register':
                                          return new MyCustomRoute(
                                            builder: (_) => new RegisterScreen(
                                              mobile: settings.arguments,
                                            ),
                                            // new RegisterScreen(),
                                            settings: settings,
                                          );
                                        case '/editprofile':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new EditProfileScreen(),
                                            // new RegisterScreen(),
                                            settings: settings,
                                          );
                                        case '/adduser':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new RegisterScreen(),
                                            // new RegisterScreen(),
                                            settings: settings,
                                          );
                                        case '/myprofile':
                                          return new MyCustomRoute(
                                            builder: (_) => new ProfileTwoPage(
                                                user: settings.arguments),
                                            settings: settings,
                                          );
                                        case '/addcar':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new RegisterCarScreen(
                                              addCarVM: settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/carpage':
                                          return new MyCustomRoute(
                                            builder: (_) => new CarPage(
                                              carPageVM: settings.arguments,
                                            ),
                                            settings: settings,
                                          );

                                        case '/messageapp':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new MessageAppPage(),
                                            settings: settings,
                                          );
                                        case '/messageappdetail':
                                          return new MyCustomRoute(
                                            builder: (_) => new NewMessageItem(
                                              detailVM: settings.arguments,
                                            ),
                                            settings: settings,
                                          );

                                        case '/servicetypepage':
                                          return new MyCustomRoute(
                                            builder: (_) => new ServiceTypePage(
                                              carId: settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/registerservicepage':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new RegisterServicePage(
                                              serviceVM: settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/registerservicetypepage':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new RegisterServiceTypePage(
                                              regServiceTypeVM:
                                                  settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/adddevice':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new RegisterDeviceScreen(
                                              hasConnection: true,
                                              userId:
                                                  CenterRepository.getUserId(),
                                              changeFormNotyBloc:
                                                  changeFormNotyBloc,
                                              fromMainApp: settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/fingerprint':
                                          return new MyCustomRoute(
                                            builder: (_) => new TouchID(),
                                            settings: settings,
                                          );
                                        case '/settings':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new SecuritySettingsScreen(
                                              fromMain: settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/appsettings':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new SettingsScreen() /*PreferencePage()*/,
                                            settings: settings,
                                          );
                                        case '/loadingscreen':
                                          return new MyCustomRoute(
                                            builder: (_) => new LoadingScreen(
                                              messageHandler: null,
                                            ),
                                            settings: settings,
                                          );
                                        case '/showusers':
                                          return new MyCustomRoute(
                                            builder: (_) => new UsersPage(),
                                            settings: settings,
                                          );
                                        case '/showuser':
                                          return new MyCustomRoute(
                                            builder: (_) => new UserAccessPage(
                                              accessableActionVM:
                                                  settings.arguments,
                                            ),
                                            settings: settings,
                                          );
                                        case '/logout':
                                          return new MyCustomRoute(
                                            builder: (_) => new LogoutForm(),
                                            settings: settings,
                                          );
                                        /*case '/plans':
                                              return new MyCustomRoute(
                                                builder: (_) => new InvoiceForm(),
                                                settings: settings,
                                              );*/
                                        case '/reset':
                                          return new MyCustomRoute(
                                            builder: (_) => new ResetScreen(),
                                            settings: settings,
                                          );

                                        case '/plugin_scalebar':
                                          return new MyCustomRoute(
                                            builder: (_) =>
                                                new PluginScaleBar(),
                                            settings: settings,
                                          );
                                      }
                                      return new MyCustomRoute(
                                        builder: (_) => new LoginPage(
                                          messageHandler: null,
                                          navigatorKey: _navigatorKey,
                                          loginType: settings.arguments,
                                          userRepository: UserRepository(),
                                        ),
                                        settings: settings,
                                      );
                                    },

                                    // },
                                    // ),
                                  );
                                },
                              ),
                            ),
                            // ),
                          );
                        });
              }
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
          }
          return CircularProgressIndicator();
        });
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          if (Theme.of(context).platform == TargetPlatform.iOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          if (Theme.of(context).platform == TargetPlatform.iOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
        });
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        RxBus.post(new ChangeEvent(type: 'INTERNET', message: 'NO_INTERNET'));
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    //if (settings.isInitialRoute) return child;

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
