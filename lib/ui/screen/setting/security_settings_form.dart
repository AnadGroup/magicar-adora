import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/fancy_popup/main.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/home.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/content_pager/page_container.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/login/reset/fancy_login/src/models/login_data.dart';
import 'package:anad_magicar/ui/screen/login/reset/reset_password_form.dart';
import 'package:anad_magicar/ui/theme/app_themes.dart';
import 'package:anad_magicar/widgets/curved_navigation_bar.dart';
import 'package:anad_magicar/widgets/drawer/app_drawer.dart';
import 'package:anad_magicar/widgets/drawer/drawer.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_section.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_tile.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_list.dart';
import 'package:flutter/material.dart';

class SecuritySettingsForm extends StatefulWidget {
  bool fromMain = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  SecuritySettingsForm({
    @required this.fromMain,
    @required this.scaffoldKey,
  });

  @override
  SecuritySettingsFormState createState() => SecuritySettingsFormState();
}

class SecuritySettingsFormState extends MainPage<SecuritySettingsForm> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static final route = '/settings';
  String userName = '';
  String imageUrl = '';
  int userId;
  List<String> themeOptions = <String>[
    Translations.current.darkTheme(),
    Translations.current.lightTheme()
  ];
  String selectedThemeOption = Translations.current.lightTheme();
  var itemAppTheme = AppTheme.values[4];

  bool lockInBackground = true;
  bool lightAppTheme = true;
  bool loginRequiered = false;
  bool useFinger = false;
  bool usePattern = false;
  bool usePassword = true;
  bool isDark = false;
  LoginType loginType;
  int _currentIndex = 1;
  int showSelectedApiMapIndex = 1;
  NotyBloc<Message> changedRoutRadioBoxNoty = new NotyBloc<Message>();
  Future<bool> initLogindata;

  // List<GroupModel> _group = [
  //   GroupModel(
  //     text: "نقشه پیش فرض",
  //     index: 1,
  //   ),
  //   GroupModel(
  //     text: "نقشه ماجیکار",
  //     index: 2,
  //   ),
  //
  // ];

  getUserInfo() async {
    userId = await prefRepository.getLoginedUserId();
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

  Future<String> _onSignUp(LoginData data) {
    return Future.delayed(Duration(microseconds: 100)).then((_) {
      if (data.password != null &&
          data.currentPassword != null &&
          data.confrimPassword != null &&
          data.password.isNotEmpty &&
          data.currentPassword.isNotEmpty &&
          data.confrimPassword.isNotEmpty) {
        return '';
      }
      return 'NOTOK';
    });
  }

  Future<String> _onReset(LoginData data) {
    return Future.delayed(new Duration(microseconds: 100)).then((_) {
      if (data.password != null &&
          data.currentPassword != null &&
          data.confrimPassword != null &&
          data.password.isNotEmpty &&
          data.currentPassword.isNotEmpty &&
          data.confrimPassword.isNotEmpty) {
        return '';
      }
      return 'NoOK';
    });
  }

  showPopUp(String message) {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateAuthentication,
    );
    popup.show(
      title: Translations.current.resetPassword(),
      content: message,
      actions: [
        new Column(
          children: <Widget>[
            Container(
              height: 250.0,
              child: ResetPasswordForm(
                onCancel: _onSignUp,
                authUser: _onReset,
                onSubmit: () {},
                recoverPassword: null,
              ),
            ),
            popup.button(
              label: Translations.current.exit(),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        )
      ],
// bool barrierDismissible = false,
// Widget close,
    );
  }

  void _toggle() {
    selectedThemeOption = themeOptions[lightAppTheme ? 1 : 0];
    itemAppTheme = AppTheme.values[lightAppTheme ? 4 : 5];
  }

  onCarPageTap() {
    Navigator.of(context).pushNamed('/carpage',
        arguments: new CarPageVM(
            userId: userId, isSelf: true, carAddNoty: valueNotyModelBloc));
  }

  setAppLogin() {
    prefRepository.setLoginStatus(loginRequiered);
    prefRepository.setLoginTypeStatus(loginType);
  }

  _showResetPassword() {
    //showPopUp(Translations.current.resetPassword());
    Navigator.of(context).pushNamed('/reset');
  }

  setLoginType(LoginType loginType) {
    if (loginType == LoginType.PASWWORD) {
      usePassword = true;
      usePattern = false;
      useFinger = false;
    }
    if (loginType == LoginType.PATTERN) {
      usePassword = false;
      usePattern = true;
      useFinger = false;
    }
    if (loginType == LoginType.FINGERPRINT) {
      usePassword = false;
      usePattern = false;
      useFinger = true;
    }
  }

  Future<bool> getLoginStatus() async {
    bool loginStatus = await prefRepository.getLoginStatusAtAppStarted();
    if (loginStatus != null)
      loginRequiered = loginStatus;
    else
      loginRequiered = true;

    int loginType_temp = await prefRepository.getLoginStatusTypeAtAppStarted();
    if (loginType_temp != null) {
      if (loginType_temp == LoginType.PASWWORD.index) {
        loginType = LoginType.PASWWORD;
        setLoginType(loginType);
      }
      if (loginType_temp == LoginType.FINGERPRINT.index) {
        loginType = LoginType.FINGERPRINT;
        setLoginType(loginType);
      }
      if (loginType_temp == LoginType.PATTERN.index) {
        loginType = LoginType.PASWWORD;
        setLoginType(loginType);
      }
    } else {
      loginType = LoginType.PASWWORD;
    }
    return loginRequiered;
  }

  @override
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    if (action == 1) widget.scaffoldKey.currentState.openDrawer();
    return null;
  }

  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    var actions = [
      IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.indigoAccent,
        ),
        onPressed: () {
          // _scaffoldKey.currentState.openDrawer();
        },
      ),
    ];
    return null;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return null;
  }

  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return new Text(
      'تنظیمات امنیتی',
      style: TextStyle(fontSize: 12, color: Colors.blueAccent),
    );
  }

  @override
  initialize() {
    // TODO: implement initialize
    scaffoldKey = widget.scaffoldKey;
    getUserInfo();
    getAppTheme();
    initLogindata = getLoginStatus();
    userName = centerRepository.getUserCached() != null
        ? centerRepository.getUserCached().userName
        : '';
    imageUrl = centerRepository.getUserCached() != null
        ? centerRepository.getUserCached().imageUrl
        : '';
    return null;
  }

  @override
  Function onBack() {
    // TODO: implement onBack
    if (PageContentState.lastRouteSelected != null &&
        PageContentState.lastRouteSelected.isNotEmpty)
      Navigator.pushNamed(context, '/main');
    return null;
  }

  @override
  bool doBack() {
    // TODO: implement doBack
    return true;
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return /*Scaffold(
     key: _scaffoldKey,
      drawer: AppDrawer(userName: userName,imageUrl: imageUrl,currentRoute: route,carPageTap: onCarPageTap,carId: CenterRepository.getCurrentCarId(),) ,//buildDrawer(context, route,userName,imageUrl,null,''),
      body:*/
        FutureBuilder<bool>(
      future: initLogindata,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // loginRequiered=snapshot.data;

          return
              // Stack(
              //   alignment: Alignment.topCenter,
              //   overflow: Overflow.visible,
              //   children: <Widget>[
              //     Padding(
              //     padding: EdgeInsets.only(top: 80.0),
              // child: Container(
              //           height:20.0,
              //         child:Text('آدرس سرورهای نقشه',style: TextStyle(color: Colors.green,fontSize: 12),),),),
              //         Padding(
              //           padding: EdgeInsets.only(top: 145.0),
              //           child:
              //           Container(
              //             color: Color(0xfffefefe),
              //             height:150.0,
              //             child: Container(
              //               height: 150,
              //               color: Color(0xfffefefe),
              //               child: ListView(
              //                 padding:
              //                 EdgeInsets.all(8.0),
              //                 children: _group
              //                     .map((item) =>
              //                     Container(
              // color: Color(0xfffefefe),
              // child:
              //                     RadioListTile(
              //                       activeColor: Colors.green,
              //                       groupValue:
              //                       _currentIndex,
              //                       title: Text(
              //                           "${item.text}"),
              //                       value: item
              //                           .index,
              //                       onChanged:
              //                           (val) {
              //                         setState(() {
              //                         _currentIndex =
              //                             val;
              //                         showSelectedApiMapIndex =
              //                             _currentIndex;
              //                         /*changedRoutRadioBoxNoty.updateValue(
              //                              Message(
              //                                 type:
              //                                 'RADIO_VALUE_CHANGED'));*/
              //                          });
              //                       },
              //                     )))
              //                     .toList(),
              //               ),
              //             ),
              //
              //           ),
              //         ),
              Padding(
                  padding: EdgeInsets.only(top: 70.0),
                  child:
                      // SettingsList(
                      // sections: [

                      /* SettingsSection(
                    title: 'کاربری',
                    tiles: [
                      */ /*SettingsTile(
                          title: 'شماره همراه', leading: Icon(Icons.phone)),*/ /*
                     // SettingsTile(title: 'ایمیل', leading: Icon(Icons.email)),
                      SettingsTile(title: 'خروج از حساب کاربری',
                        leading: Icon(Icons.exit_to_app),
                        onTap: () {
                          Navigator.of(context).pushNamed('/logout');
                        },),
                    ],
                  ),*/

                      SettingsSection(
                    title: 'امنیتی',
                    tiles: [
                      SettingsTile.switchTile(
                        leftPadding: 25.0,
                        rightPadding: 2.0,
                        title: Translations.current.useLogin(),
                        leading: Icon(Icons.phonelink_lock),
                        switchValue: loginRequiered,
                        onTap: () {
                          setState(() {
                            loginRequiered = !loginRequiered;
                            if (loginRequiered) {
                              usePattern = !loginRequiered;
                              usePassword = loginRequiered;
                              useFinger = !loginRequiered;
                            } else {
                              usePattern = loginRequiered;
                              usePassword = loginRequiered;
                              useFinger = loginRequiered;
                            }
                            //if (loginRequiered)
                            setAppLogin();
                          });
                        },
                        onToggle: (bool value) {
                          setState(() {
                            loginRequiered = value;
                            if (value) {
                              usePattern = !value;
                              usePassword = value;
                              useFinger = !value;
                            } else {
                              usePattern = value;
                              usePassword = value;
                              useFinger = value;
                            }
                            //if (value)
                            setAppLogin();
                          });
                        },
                      ),
                      SettingsTile.switchTile(
                          leftPadding: 25,
                          rightPadding: 2,
                          title: Translations.current.useFingerPrint(),
                          leading: Icon(Icons.fingerprint),
                          onTap: () {
                            setState(() {
                              useFinger = !useFinger;
                              if (useFinger) {
                                usePattern = !useFinger;
                                usePassword = !useFinger;
                                loginType = LoginType.FINGERPRINT;
                              }
                              setAppLogin();
                            });
                          },
                          onToggle: (bool value) {
                            setState(() {
                              useFinger = value;
                              if (value) {
                                usePattern = !value;
                                usePassword = !value;
                                loginType = LoginType.FINGERPRINT;
                              }
                              setAppLogin();
                            });
                          },
                          switchValue: useFinger),
                      /* SettingsTile.switchTile(
                          leftPadding: 25,
                          rightPadding: 2,
                          title: Translations.current.usePattern(),
                          leading: Icon(Icons.apps),
                          onTap: () {
                            setState(() {
                              usePattern = !usePattern;
                              if (usePattern) {
                                usePassword = !usePattern;
                                useFinger = !usePattern;
                                loginType = LoginType.PATTERN;
                              }
                              setAppLogin();
                            });
                          },
                          onToggle: (bool value) {
                            setState(() {
                              usePattern = value;
                              if (value) {
                                usePassword = !value;
                                useFinger = !value;
                                loginType = LoginType.PATTERN;
                              }
                              setAppLogin();
                            });
                          },
                          switchValue: usePattern),*/
                      SettingsTile.switchTile(
                          leftPadding: 25,
                          rightPadding: 2,
                          title: Translations.current.usePassword(),
                          leading: Icon(Icons.security),
                          onTap: () {
                            setState(() {
                              usePassword = !usePassword;
                              if (usePassword) {
                                usePattern = !usePassword;
                                useFinger = !usePassword;
                                loginType = LoginType.PASWWORD;
                              } else {}
                              setAppLogin();
                            });
                          },
                          onToggle: (bool value) {
                            setState(() {
                              usePassword = value;
                              if (value) {
                                usePattern = !value;
                                useFinger = !value;
                                loginType = LoginType.PASWWORD;
                              } else {}
                              setAppLogin();
                            });
                          },
                          switchValue: usePassword),
                      SettingsTile(
                        title: 'تغییر رمز عبور',
                        leading: Icon(Icons.lock),
                        onTap: () {
                          _showResetPassword();
                        },
                      ),
                    ],
                  )
                  // ],
                  // ),
                  // ),
                  // ],
                  );
        } else {
          return Container();
        }
      },

      // ),
      // ),
    );
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 2;
  }

  @override
  bool showBack() {
    // TODO: implement showBack
    return false;
  }

  @override
  bool showMenu() {
    // TODO: implement showMenu
    return false;
  }
}
