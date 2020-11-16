import 'dart:io';
import 'dart:typed_data';

import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/map_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/home.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/plugin_scalebar.dart';
import 'package:anad_magicar/ui/screen/adora_car_status_setting/car_status_setting_screen.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/car/register_car_screen.dart';
import 'package:anad_magicar/ui/screen/device/register_device.dart';
import 'package:anad_magicar/ui/screen/help/help_screen.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/login/finger_print_auth.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_page.dart';
import 'package:anad_magicar/ui/screen/message_app/new_message_item.dart';
import 'package:anad_magicar/ui/screen/profile/profile2.dart';
import 'package:anad_magicar/ui/screen/register/edit_profile.dart';
import 'package:anad_magicar/ui/screen/register/register_screen.dart';
import 'package:anad_magicar/ui/screen/remote_setting/remote_setting.dart';
import 'package:anad_magicar/ui/screen/service/service_type/register_service_type_page.dart';
import 'package:anad_magicar/ui/screen/service/service_type/service_type_page.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/ui/screen/setting/security_screen.dart';
import 'package:anad_magicar/ui/screen/setting/security_settings_form.dart';
import 'package:anad_magicar/ui/screen/user/user_access_detail.dart';
import 'package:anad_magicar/ui/screen/user/users_page.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/persian_datepicker/persian_datepicker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

String _documentPath = 'help.pdf';

class AppDrawer extends StatefulWidget {
  String currentRoute;
  String userName;
  String imageUrl;
  Function carPageTap;
  int carId;
  int userId;
  GlobalKey<ScaffoldState> scafoldKey;
  GlobalKey<NavigatorState> navigatStateKey;
  AppDrawer(
      {Key key,
      this.userId,
      this.scafoldKey,
      this.userName,
      this.imageUrl,
      this.currentRoute,
      this.carPageTap,
      this.carId,
      this.navigatStateKey})
      : super(key: key);

  @override
  AppDrawerState createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  String days = '3';
  final TextEditingController textEditingController = TextEditingController();
  String fromDate = '';
  String toDate = '';
  PersianDatePickerWidget persianDatePicker;

  String imagePath = '';
  File _image;
  NotyBloc<Message> refreshPic;

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

  Future<File> copyAsset() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/copy.pdf');
    ByteData bd = await rootBundle.load('assets/help.pdf');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }

  _showBottomSheetDates(BuildContext cntext) {
    showModalBottomSheetCustom(
        context: cntext,
        mHeight: 0.95,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Translations.current.fromDate(),
                style: TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: initDatePicker(textEditingController, 'From'),
              ),
              Text(
                Translations.current.toDate(),
                style: TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: initDatePicker(textEditingController, 'To'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Button(
                      wid: 140.0,
                      color: Colors.pinkAccent.value,
                      title: Translations.current.doFilter(),
                    ),
                    onPressed: () {
                      //notyDateFilterBloc.updateValue(new ChangeEvent(fromDate: fromDate,toDate: toDate));
                      Navigator.pushNamed(context, MapPageState.route,
                          arguments: new MapVM(
                              carId: widget.carId,
                              carCounts: null,
                              cars: null,
                              fromDate: fromDate,
                              toDate: toDate,
                              forReport: true));
                    },
                  )
                ],
              )
            ],
          );
        });
  }

  Future<String> prepareHelpPdf(BuildContext context) async {
    final ByteData bytes =
        await DefaultAssetBundle.of(context).load(_documentPath);
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$_documentPath';

    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return tempDocumentPath;
  }

  loadProfileImage() async {
    refreshPic = new NotyBloc<Message>();
    String path = await prefRepository.getProfileImagePath();
    if (!DartHelper.isNullOrEmpty(path)) {
      imagePath = path;
      _image = File(path);
      refreshPic.updateValue(new Message(type: 'PIC_READY'));
    } else {
      imagePath = '';
      _image = null;
    }
  }

  showFilterDate(BuildContext context, bool from) {
    return _showBottomSheetDates(context);
  }

  _onValueChanged(String value) {
    days = value;
  }

  _loadHelpPage(BuildContext context) {
    /*prepareHelpPdf(context).then((path){
      Navigator.pushNamed(context, '/help',arguments: path);
    });*/
    copyAsset().then((file) {
      String path = file.path;
      //Navigator.pushReplacementNamed(context, '/help', arguments: path);
      _push(context, '/help', new RouteSettings(arguments: path));
    });
  }

  _logout(BuildContext context) async {
    ServiceResult result = await restDatasource.logoutUser();
    if (result != null) {
      if (result.IsSuccessful) {
        centerRepository.showFancyToast(
            Translations.current.logoutSuccessful(), true);
        UserRepository userRepo = new UserRepository();
        userRepo
            .deleteToken(); //(username: widget.user.mobile,password: widget.user.password,code: widget.user.code);
        await prefRepository.setLoginStatus(true);
        await prefRepository.setLoginTypeStatus(LoginType.PASWWORD);

        Navigator.pushReplacementNamed(context, '/login');
      } else {
        if (result.Message != null)
          centerRepository.showFancyToast(result.Message, false);
        else
          centerRepository.showFancyToast(
              Translations.current.hasErrors(), false);
      }
    }
  }

  _showReportBasedOnDays(BuildContext context, String dys) {
    fromDate = DateTimeUtils.getDateJalaliWithAddDays((-1) * int.tryParse(dys));
    toDate = DateTimeUtils.getDateJalali();
    Navigator.pushNamed(context, MapPageState.route,
        arguments: new MapVM(
            carId: widget.carId,
            carCounts: null,
            cars: null,
            fromDate: fromDate,
            toDate: toDate,
            forReport: true));
  }

  _showBottomSheetReport(BuildContext cntext) {
    double wid = MediaQuery.of(cntext).size.width * 0.75;
    showModalBottomSheetCustom(
        context: cntext,
        mHeight: 0.75,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          margin:
                              EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                          constraints: new BoxConstraints.expand(
                            height: 48.0,
                            width: wid,
                          ),
                          decoration: BoxDecoration(
                            //color: Colors.pinkAccent,
                            border: Border(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              showFilterDate(context, true);
                            },
                            child: Button(
                              title: Translations.current.fromDateToDate(),
                              wid: wid,
                              color: Colors.blueAccent.value,
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 250,
                        child: new ListView(
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.all(0.0),
                              width: MediaQuery.of(context).size.width * 0.80,
                              height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                //margin: EdgeInsets.symmetric(horizontal: 20.0),
                                children: <Widget>[
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Form(
                                      key: _formKey,
                                      autovalidate: _autoValidate,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        physics: BouncingScrollPhysics(),
                                        child: new Column(
                                          children: <Widget>[
                                            Container(
                                              //height: 45,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0,
                                                  horizontal: 2.0),
                                              child: FormBuilderTextField(
                                                initialValue: '3',
                                                attribute: "Days",
                                                decoration: InputDecoration(
                                                  labelText: Translations
                                                      .current
                                                      .fromLastDays(),
                                                ),
                                                onChanged: (value) =>
                                                    _onValueChanged(value),
                                                valueTransformer: (text) =>
                                                    text,
                                                validators: [
                                                  FormBuilderValidators
                                                      .required(),
                                                ],
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        signed: false,
                                                        decimal: false),
                                              ),
                                            ),
                                            new GestureDetector(
                                              onTap: () {
                                                _showReportBasedOnDays(
                                                    context, days);
                                              },
                                              child: new Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5.0,
                                                      right: 5.0,
                                                      left: 5.0),
                                                  constraints:
                                                      new BoxConstraints.expand(
                                                    height: 48.0,
                                                    width: wid,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    //color: Colors.pinkAccent,
                                                    border: Border(),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0)),
                                                  ),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      _showReportBasedOnDays(
                                                          context, days);
                                                    },
                                                    child: Button(
                                                      title: Translations
                                                          .current
                                                          .showReportBaseOnDays(),
                                                      wid: wid,
                                                      color: Colors
                                                          .blueAccent.value,
                                                    ),
                                                  )),
                                            ),
                                            new GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: wid,
                                                height: 40.0,
                                                child: new Button(
                                                  title: Translations.current
                                                      .cancel(),
                                                  color: Colors.white.value,
                                                  clr: Colors.pinkAccent,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[],
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

  Widget _createHeader() {
    loadProfileImage();
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/login_back.jpg'))),
      child: Stack(children: <Widget>[
        Positioned(
          top: 20.0,
          right: 10.0,
          child: new Container(
            width: 80.0,
            height: 80.0,
            decoration: new BoxDecoration(
                // Circle shape
                shape: BoxShape.circle,
                color: Colors.transparent,
                // The border you want
                border: new Border.all(
                  width: 1.0,
                  color: Colors.white,
                ),
                // The shadow you want
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                  ),
                ]),
            child: ClipOval(
              child: Container(
                width: 100,
                height: 100,
                child: StreamBuilder<Message>(
                  stream: refreshPic.noty,
                  builder: (context, snapshot) {
                    if (snapshot.data != null && snapshot.hasData) {
                      return Image.file(
                        _image,
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.fill,
                      );
                    }
                    return Image.asset(widget.imageUrl,
                        width: 60.0, height: 60.0, fit: BoxFit.fill);
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 100.0,
            right: 10.0,
            child: new Container(
              //width: 80.0,
              height: 50.0,
              /*decoration: new BoxDecoration(
                  // Circle shape
                   // shape: BoxShape.circle,
                    color: Colors.transparent,
                    // The border you want
                    border: new Border.all(
                      width: 0.0,
                      color: Colors.white,
                    ),
                    // The shadow you want
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 0.0,
                      ),
                    ]
                ),*/
              child: Text(
                widget.userName,
                style: TextStyle(color: Colors.white, fontSize: 35.0),
              ),
            )),
      ]),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(
      BuildContext context, RouteSettings routeSettings,
      {int materialIndex: 500}) {
    return {
      '/help': (context) {
        return HelpScreen(
          pathPDF: routeSettings.arguments,
        );
      },
      /* '/home': (context) {
      return HomeScreen(scaffoldKey: _scaffoldKey,);},*/
      /* '/servicepage': (context) {
      return  createServiceWidget();},
      '/mappage': (context) {_onPageChanged(1);
      return  createMapPageWidget();},
      '/messages': (context) {  return  createMessagesWidget();},
      '/plans': (context) { return  createPlansWidget();},*/
      '/register': (context) {
        return new RegisterScreen(
          mobile: routeSettings.arguments,
        );
      },
      '/editprofile': (context) {
        return new EditProfileScreen();
      },
      '/adduser': (context) {
        return new RegisterScreen();
      },
      '/myprofile': (context) {
        return new ProfileTwoPage(user: routeSettings.arguments);
      },
      '/addcar': (context) {
        return new RegisterCarScreen(
          addCarVM: routeSettings.arguments,
        );
      },
      '/carpage': (context) {
        return new CarPage(
          carPageVM: routeSettings.arguments,
          scaffoldKey: widget.scafoldKey,
        );
      },
      '/messageapp': (context) {
        return new MessageAppPage(
          carId: routeSettings.arguments,
          scaffoldKey: widget.scafoldKey,
        );
      },
      '/messageappdetail': (context) {
        return new NewMessageItem(
          detailVM: routeSettings.arguments,
        );
      },
      '/servicetypepage': (context) {
        return new ServiceTypePage(
          carId: routeSettings.arguments,
        );
      },
      '/registerservicetypepage': (context) {
        return new RegisterServiceTypePage(
          regServiceTypeVM: routeSettings.arguments,
        );
      },
      '/adddevice': (context) {
        return new RegisterDeviceScreen(
          hasConnection: true,
          userId: CenterRepository.getUserId(),
          changeFormNotyBloc: changeFormNotyBloc,
          fromMainApp: routeSettings.arguments,
        );
      },
      '/fingerprint': (context) {
        return new TouchID();
      },
      '/settings': (context) {
        return new SecuritySettingsScreen(
          fromMain: routeSettings.arguments,
          scaffoldKey: widget.scafoldKey,
        );
      },
      '/appsettings': (context) {
        return new SettingsScreen(
          scaffoldKey: widget.scafoldKey,
        );
      },
      // '/loadingscreen': (context) { return  new LoadingScreen(messageHandler: null,);},
      '/showusers': (context) {
        return new UsersPage(
          scaffoldKey: widget.scafoldKey,
        );
      },
      '/showuser': (context) {
        return new UserAccessPage(
          accessableActionVM: routeSettings.arguments,
        );
      },
      '/plugin_scalebar': (context) {
        return new PluginScaleBar();
      },
    };
  }

  void _push(BuildContext context, String root, RouteSettings routeSettings,
      {int materialIndex: 500}) {
    var routeBuilders =
        _routeBuilders(context, routeSettings, materialIndex: materialIndex);

    Navigator.push(
        context,
        MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => routeBuilders[root](context)));
  }

  Widget _createDrawerItem(
      {BuildContext contextt,
      IconData icon,
      String text,
      bool isSelected,
      GestureTapCallback onTap}) {
    return ListTile(
      selected: isSelected,
      subtitle: null,
      title: Container(
        height: 38.0,
        color: isSelected
            ? Colors.blueAccent.withOpacity(0.5)
            : Theme.of(contextt).appBarTheme.color,
        child: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(text),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Builder(builder: (context) {
      return Drawer(
        //key: widget.scafoldKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            _createDrawerItem(
                contextt: context,
                icon: Icons.person_add,
                text: Translations.current.users(),
                isSelected: widget.currentRoute == UserPageState.route,
                onTap: () {
                  Navigator.pop(context);
                  _push(context, '/showusers',
                      new RouteSettings(arguments: widget.scafoldKey));
                  // Navigator.pushReplacementNamed(context, '/showusers',arguments: widget.scafoldKey);
                  // widget.navigatStateKey.currentState. push(MaterialPageRoute( builder: (context)=>new UsersPage()));
                }),
            _createDrawerItem(
                contextt: context,
                icon: Icons.directions_car,
                text: Translations.current.car(),
                isSelected: widget.currentRoute == CarPageState.route,
                onTap: () {
                  Navigator.pop(context);
                  _push(
                      context,
                      '/carpage',
                      new RouteSettings(
                          arguments: new CarPageVM(
                              userId: widget.userId,
                              isSelf: true,
                              carAddNoty: valueNotyModelBloc)));

                  // widget.carPageTap();
                }),
            _createDrawerItem(
                contextt: context,
                icon: Icons.security,
                text: Translations.current.security(),
                isSelected:
                    widget.currentRoute == SecuritySettingsFormState.route,
                onTap: () {
                  //widget.navigatStateKey.currentState.push(new MaterialPageRoute(builder: (context) => new SecuritySettingsScreen(fromMain: true,)));
                  Navigator.pop(context);
                  _push(context, SecuritySettingsFormState.route,
                      new RouteSettings(arguments: true));

                  /*  Navigator.pushReplacementNamed(
                          context, SecuritySettingsFormState.route,
                          arguments: true);*/
                }),
            Divider(),
            _createDrawerItem(
                contextt: context,
                icon: Icons.settings,
                text: Translations.current.settings(),
                isSelected: widget.currentRoute == SettingsScreenState.route,
                onTap: () {
                  Navigator.pop(context);

                  //widget.navigatStateKey.currentState.push(new MaterialPageRoute(builder: (context) => new SettingsScreen()));
                  _push(context, SettingsScreenState.route,
                      new RouteSettings(arguments: widget.scafoldKey));

                  /* Navigator.pushReplacementNamed(
                          context, SettingsScreenState.route);*/
                }),
              CenterRepository.APP_TYPE_ADORA ? 
              _createDrawerItem(
                contextt: context,
                icon: Icons.settings_applications,
                text: "تنظیمات ریموت",
                isSelected: widget.currentRoute == ProfileTwoPageState.route,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RemoteSetting(
                                status: RemoteStatus.edit,
                              )));
                }) : Container(),
                CenterRepository.APP_TYPE_ADORA ?  _createDrawerItem(
                contextt: context,
                icon: Icons.settings_applications,
                text: "تنظیمات وضعیت",
                isSelected: widget.currentRoute == ProfileTwoPageState.route,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarStatusSettingScreen(
                        status: CarIconsStatus.edit,
                      ),
                    ),
                  );
                }) : Container(),  
            _createDrawerItem(
                contextt: context,
                icon: Icons.person_pin,
                text: Translations.current.profile(),
                isSelected: widget.currentRoute == ProfileTwoPageState.route,
                onTap: () {
                  //widget.navigatStateKey.currentState.push(new MaterialPageRoute(builder: (context) => new ProfileTwoPage( user: centerRepository.getUserInfo())));
                  Navigator.pop(context);

                  _push(context, ProfileTwoPageState.route,
                      RouteSettings(arguments: centerRepository.getUserInfo()));
                  /* Navigator.push(
                          context, ProfileTwoPageState.route,
                          arguments: centerRepository.getUserInfo());*/
                }),
            /* _createDrawerItem(context: context,icon: Icons.report, text: Translations.current.report(),isSelected: currentRoute=='', onTap: (){
            //if(_scaffoldKey.currentState.isDrawerOpen){
              Navigator.pop(context);
            //}
            _showReportSheet(context);
          }),*/
            _createDrawerItem(
                contextt: context,
                icon: Icons.help_outline,
                isSelected: false,
                text: Translations.current.help(),
                onTap: () {
                  _loadHelpPage(context);
                }),
            _createDrawerItem(
                contextt: context,
                icon: Icons.exit_to_app,
                isSelected: false,
                text: Translations.current.exit(),
                onTap: () async {
                  await animated_dialog_box.showScaleAlertBox(
                      title: Center(
                          child: Text(Translations.current.logoutAccount())),
                      context: context,
                      firstButton: Builder(
                        builder: (contxt) {
                          return MaterialButton(
                            // FIRST BUTTON IS REQUIRED
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: Colors.white,
                            child: Text(Translations.current.yes()),
                            onPressed: () {
                              _logout(contxt);
                            },
                          );
                        },
                      ),
                      secondButton: Builder(
                        builder: (contxt) {
                          return MaterialButton(
                            // OPTIONAL BUTTON
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: Colors.white,
                            child: Text(Translations.current.no()),
                            onPressed: () {
                              Navigator.of(contxt).pop();
                            },
                          );
                        },
                      ),
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.red,
                      ),
                      // IF YOU WANT TO ADD ICON
                      yourWidget: Container(
                        child: Text(Translations.current.areYouSureToExit()),
                      ));
                }),
            Divider(),
            ListTile(
              title: Text('1.0.2'),
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }
}
