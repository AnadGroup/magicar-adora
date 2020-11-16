import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/fancy_popup/main.dart';
import 'package:anad_magicar/components/material_button.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/content_pager/page_container.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/login/fancy_login/src/widgets/animated_text_form_field.dart';
import 'package:anad_magicar/ui/screen/login/reset/fancy_login/src/models/login_data.dart';
import 'package:anad_magicar/ui/screen/login/reset/reset_password_form.dart';
import 'package:anad_magicar/ui/theme/app_themes.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_list.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_section.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_tile.dart';
import 'package:anad_magicar/widgets/range_slider/flutter_range_slider.dart' as frs;
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  SettingsScreen({this.scaffoldKey});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends MainPage<SettingsScreen> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final String CHARGE_AMUONT_TAG = 'CHARGE_AMUONT';
  static final String CHARGE_SIMCARD_TAG = 'CHARGE_SIMCARD';
  static final String SEND_INFO_ACCURACY_TAG = 'GETSEND_INFO_ACCURACY';
  static final String GET_HARDWARE_VERSION_TAG = 'GET_HARDWARE_VERSION';

  static final String MINMAX_SPEED_TAG = 'MINMAX_SPEED';
  static final String MIN_SPEED_TAG = 'MIN_SPEED';
  static final String MAX_SPEED_TAG = 'MAX_SPEED';

  static final String PERIODIC_TIME_TAG = 'PERIODIC_TIME';
  static final String PERIODIC_UPDTAE_TIME_TAG = 'PERIODIC_UPDTAE_TIME';

  static final highLevelText1 =
      'در این وضعیت : ارسال اطلاعات هر 20 دقیقه انجام میشود.';
  static final highLevelText2 = 'ارسال اطلاعات هر 40 متر انجام میشود';
  static final highLevelText3 = 'ارسال اطلاعات براساس 5 درجه تغییر زاویه است';
  static final highLevelText4 =
      'ارسال اطلاعات در سرعت 110 کیلومتر بر ساعت انجام میشود';
  static final mediumLevelText1 = 'در این وضعیت';
  static final mediumLevelText2 = 'ارسال اطلاعات هر 30 دقیقه انجام می شود.';
  static final mediumLevelText3 = 'ارسال اطلاعات هر 100 متر انجام می شود.';
  static final mediumLevelText4 =
      'ارسال اطلاعات براساس 15 درجه تغییر زاویه است';
  static final mediumLevelText5 = 'ارسال اطلاعات براساس سرعت غیرفعال است.';

  static final lowLevelText1 = 'در این وضعیت';
  static final lowLevelText2 = 'ارسال اطلاعات هر 20 دقیقه انجام می شود.';
  static final lowLevelText3 = 'ارسال اطلاعات هر 40 متر انجام می شود.';
  static final lowLevelText4 = 'ارسال بر اساس 5 درجه تغییر زاویه است.';
  static final lowLevelText5 =
      'ارسال اطلاعات در سرعت 110 کیلومتر بر ساعت انجام می شود.';

  static final chargeAmountText1 = ' میزان شارژ شمادر تاریخ ';
  static final chargeAmountText2 = 'و در ساعت ';
  static final chargeAmountText3 = 'به میزان ';
  static final chargeAmountText4 = 'ریال است';
  static final chargeAmountText =
      'با فشردن کلید زیر و ارسال دستور میزان شارژ<آخرین میزان شارژ سیم کارت خودرو استخراج و در صفحه هشدارها نمایش داده می شود.';
  static final chargePasswordText1 = 'لطفا رمز شارژ را وارد نمایید';
  static final hardwareText1 =
      'با فشردن کلید زیر نسخه سخت افزار دریافت می شود.';

  String finalText = lowLevelText1 +
      '\\n' +
      lowLevelText2 +
      '\\n' +
      lowLevelText3 +
      '\\n' +
      lowLevelText4 +
      '\\n' +
      lowLevelText5;
  List<RangeSliderData> rangeSliders;
  NotyBloc<Message> changeLevel = new NotyBloc<Message>();
  double _lowerValue = 0.0;
  double _upperValue = 60.0;
  double _lowerValueFormatter = 20.0;
  double _upperValueFormatter = 20.0;

  String userName = '';
  String imageUrl = '';

  static int lowLevel = 5;
  static int mLevel = 15;
  static int hLevel = 30;
  static int level = 5;

  static final route = '/appsettings';
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
  LoginType loginType;
  int themeOption;
  String mobile;
  bool isDark = false;
  int userId;

  String maxSpeed = '';
  String minSpeed = '';
  String periodicUpdateTime = '';
  String periodicSend = '';
  String chargePassword = '';
  String resultValue = '';
  String resultValueh = '';
  int defaultPeriodicvalue = 60;
  AnimationController _loadingController;
  Interval _nameTextFieldLoadingAnimationInterval;

  String mobileNo = '';
  final _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<bool> getAppTheme() async {
    int dark = await changeThemeBloc.getOption();
    setState(() {
      if (dark == 1)
        isDark = true;
      else
        isDark = false;
    });
  }

  Future<String> _onSignUp(LoginData data) {
    return Future.delayed(new Duration(microseconds: 100)).then((_) {
      if (data.password != null &&
          data.currentPassword != null &&
          data.confrimPassword != null &&
          data.password.isNotEmpty &&
          data.currentPassword.isNotEmpty &&
          data.confrimPassword.isNotEmpty) {}
      return '';
    });
  }

  Future<String> _onReset(LoginData data) {
    return Future.delayed(new Duration(microseconds: 100)).then((_) {
      if (data.password != null &&
          data.currentPassword != null &&
          data.confrimPassword != null &&
          data.password.isNotEmpty &&
          data.currentPassword.isNotEmpty &&
          data.confrimPassword.isNotEmpty) {}
      return '';
    });
  }

  chargeSimCard() async {
    int actionId = 115;
    String command = '';
    if (resultValue != null && resultValue.isNotEmpty) {
      command = '*141*#' + resultValue + '#';
    } else if (resultValueh != null && resultValueh.isNotEmpty) {
      command = '*140*#' + resultValueh + '#';
    }
    var result = await restDatasource.sendCommand(new SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: CenterRepository.getCurrentCarId(),
        Command: command));
    if (result != null) {
      centerRepository.showFancyToast('دستور شارژ ارسال شد', true);
      Navigator.pop(context);
    } else {
      centerRepository.showFancyToast('خطا در ارسال دستور شارژ', false);
    }
  }

  sendLevel() async {
    int actionId = 46;
    String command = level.toString();

    var result = await restDatasource.sendCommand(new SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: CenterRepository.getCurrentCarId(),
        Command: command));
    if (result != null) {
      centerRepository.showFancyToast('دستور ارسال شد', true);
    } else {
      centerRepository.showFancyToast('خطا در ارسال دستور ', false);
    }
  }

  setLevel(int l) {
    if (l == 1) {
      level = 5;
      finalText = lowLevelText1 +
          '\\n' +
          lowLevelText2 +
          '\\n' +
          lowLevelText3 +
          '\\n' +
          lowLevelText4 +
          '\\n' +
          lowLevelText5;
      changeLevel.updateValue(new Message(type: 'LEVEL_CHANGED'));
    }
    if (l == 2) {
      level = 15;
      finalText = mediumLevelText1 +
          '\\n' +
          mediumLevelText2 +
          '\\n' +
          mediumLevelText3 +
          '\\n' +
          mediumLevelText4 +
          '\\n' +
          mediumLevelText5;
      changeLevel.updateValue(new Message(type: 'LEVEL_CHANGED'));
    }
    if (l == 3) {
      level = 30;
      finalText = highLevelText1 +
          '\\n' +
          highLevelText2 +
          '\\n' +
          highLevelText3 +
          '\\n' +
          highLevelText4;
      changeLevel.updateValue(new Message(type: 'LEVEL_CHANGED'));
    }
  }

  getHardWareVersion() async {
    int actionId = ActionsCommand
        .actionCommandsMap[ActionsCommand.HARDWARE_VERSION_NANO_CODE];
    var result = await restDatasource.sendCommand(new SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: CenterRepository.getCurrentCarId(),
        Command: null));
    if (result != null) {
      centerRepository.showFancyToast('عملیات با موفقیت انجام شد', true);
      Navigator.pop(context);
    } else {
      centerRepository.showFancyToast('عملیات با مشکل مواجه شد', false);
      Navigator.pop(context);
    }
  }

  getChargeAmount() async {
    int actionId = ActionsCommand
        .actionCommandsMap[ActionsCommand.ChargeSimCardCredit_Nano_CODE];
    var result = await restDatasource.sendCommand(new SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: CenterRepository.getCurrentCarId(),
        Command: '*141*1#'));
    if (result != null) {
      centerRepository.showFancyToast('عملیات با موفقیت انجام شد', true);
      Navigator.pop(context);
    } else {
      centerRepository.showFancyToast('عملیات با مشکل مواجه شد', false);
      Navigator.pop(context);
    }
  }

  _doAction(String action) async {
    // Navigator.pop(context);
    if (action == GET_HARDWARE_VERSION_TAG) {
      await animated_dialog_box.showScaleAlertBox(
          title: Center(child: Text(Translations.current.hardWareVersion())),
          context: context,
          firstButton: MyMaterialButton(
            onTap: () {
              getHardWareVersion();
            },
            title: Translations.current.gethHrdwareVersion(),
            isCancel: false,
          ),
          /*MaterialButton(
            elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Text(Translations.current.gethHrdwareVersion()),
              onPressed: () async {
                getHardWareVersion();
              }
          ),*/
          secondButton: MyMaterialButton(
            title: Translations.current.cancel(),
            onTap: null,
            isCancel: true,
          ),
          /*MaterialButton(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Text(Translations.current.cancel()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),*/
          icon: Icon(
            Icons.info_outline,
            color: Colors.red,
          ),
          yourWidget: Container(
            child: Text(hardwareText1),
          ));
    } else if (action == SEND_INFO_ACCURACY_TAG) {
      _showSendingLevelSheet(context);
    } else if (action == CHARGE_SIMCARD_TAG) {
      await animated_dialog_box.showScaleAlertBox(
        title: Center(child: Text(Translations.current.chargeSimCard())),
        context: context,
        firstButton: MyMaterialButton(
            isCancel: false,
            title: Translations.current.chargeSimCard(),
            onTap: () {
              chargeSimCard();
            }),
        /*MaterialButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Text(Translations.current.chargeSimCard()),
              onPressed: () async {
                _formKey.currentState.save();
                chargeSimCard();
              }
          ),*/
        secondButton: MyMaterialButton(
          isCancel: true,
          title: Translations.current.cancel(),
          onTap: null,
        ),
        /*MaterialButton(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Text(Translations.current.cancel()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),*/
        icon: Icon(
          Icons.info_outline,
          color: Colors.red,
        ),
        yourWidget: Form(
          key: _formKey,
          child: Container(
              child: _buildTextField(
                  Translations.current.plzEnterChargePassword(),
                  150.0,
                  chargePassword)),
        ),
      );
    } else if (action == CHARGE_AMUONT_TAG) {
      await animated_dialog_box.showScaleAlertBox(
          title: Center(child: Text(Translations.current.chargeAmount())),
          context: context,
          firstButton: MyMaterialButton(
            isCancel: false,
            title: Translations.current.getChargeAmount(),
            onTap: () {
              getChargeAmount();
            },
          ),
          /*MaterialButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Text(Translations.current.getChargeAmount()),
              onPressed: () async {
                getChargeAmount();
              }
          ),*/
          secondButton: MyMaterialButton(
            isCancel: true,
            title: Translations.current.cancel(),
            onTap: null,
          ),
          /*MaterialButton(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Text(Translations.current.cancel()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),*/
          icon: Icon(
            Icons.info_outline,
            color: Colors.red,
          ),
          yourWidget: Container(
            child: Text(Translations.current.forGetChargeAmount()),
          ));
    }
  }

  _onConfirmDefaultSettings(String type, BuildContext context) async {
    _formKey.currentState.save();
    if (type == MINMAX_SPEED_TAG) {
      prefRepository.setMinMaxSpeed(MIN_SPEED_TAG, int.tryParse(minSpeed));
      prefRepository.setMinMaxSpeed(MAX_SPEED_TAG, int.tryParse(maxSpeed));
      centerRepository.showFancyToast('اطلاعات با موفقیت ذخیره شد.', true);
    } else if (type == PERIODIC_TIME_TAG) {
      prefRepository.setPeriodicTime(
          PERIODIC_TIME_TAG, int.tryParse(resultValue));
      centerRepository.showFancyToast('اطلاعات با موفقیت ذخیره شد.', true);
    } else if (type == PERIODIC_UPDTAE_TIME_TAG) {
      prefRepository.setPeriodicUpdate(
          PERIODIC_UPDTAE_TIME_TAG, int.tryParse(resultValue));
      centerRepository.showFancyToast('اطلاعات با موفقیت ذخیره شد.', true);
    }

    Navigator.pop(context);
  }

  _showSendingLevelSheet(BuildContext context) {
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.70,
        builder: (BuildContext context) {
          return StreamBuilder<Message>(
              stream: changeLevel.noty,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      finalText,
                      style: TextStyle(fontSize: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            setLevel(1);
                          },
                          child: Button(
                            wid: 35,
                            clr: level == 5 ? Colors.blueAccent : Colors.white,
                            title: 'پایین',
                            color: Colors.black.value,
                          ),
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            setLevel(2);
                          },
                          child: Button(
                              wid: 35,
                              clr: level == 15 ? Colors.amber : Colors.white,
                              title: 'متوسط',
                              color: Colors.black.value),
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            setLevel(3);
                          },
                          child: Button(
                              wid: 35,
                              clr: level == 30 ? Colors.red : Colors.white,
                              title: 'بالا',
                              color: Colors.black.value),
                        )
                      ],
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        sendLevel();
                        Navigator.pop(context);
                      },
                      child: Button(
                          wid: 80,
                          clr: Colors.blueAccent,
                          title: 'ارسال اطلاعات',
                          color: Colors.black.value),
                    )
                  ],
                );
              });
        });
  }

  _showSendingCommandSheet(BuildContext context) {
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.70,
        builder: (BuildContext context) {
          return Container(
            height: 350.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                      onPressed: () {
                        _doAction(CHARGE_AMUONT_TAG);
                      },
                      child: Text(Translations.current.chargeAmount()),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                      onPressed: () {
                        _doAction(CHARGE_SIMCARD_TAG);
                      },
                      child: Text(Translations.current.chargeSimCard()),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                      onPressed: () {
                        _doAction(GET_HARDWARE_VERSION_TAG);
                      },
                      child: Text(Translations.current.getHardwareVersion()),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                      onPressed: () {
                        _doAction(SEND_INFO_ACCURACY_TAG);
                      },
                      child: Text(Translations.current.sendInfoAccuracy()),
                    ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTextField(String hint, double width, String result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: width,
          height: 50.0,
          child: AnimatedTextFormField(
              enabled: true,
              width: width,
              loadingController: _loadingController,
              interval: _nameTextFieldLoadingAnimationInterval,
              labelText: 'رمز شارژ ایرانسل',
              // prefixIcon: Icon(Icons.confirmation_number),
              keyboardType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                // FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) {
                return null;
              },
              onSaved: (value) async {
                resultValue = value;
              }),
        ),
        Container(
          width: width,
          height: 50.0,
          child: AnimatedTextFormField(
              enabled: true,
              width: width,
              loadingController: _loadingController,
              interval: _nameTextFieldLoadingAnimationInterval,
              labelText: 'رمز شارژ همراه اول',
              // prefixIcon: Icon(Icons.confirmation_number),
              keyboardType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                // FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) {
                return null;
              },
              onSaved: (value) async {
                resultValueh = value;
              }),
        ),
      ],
    );
  }

  Widget _buildTextField2(
      String hint, double width, String result, String initVal) {
    loadDefaultSettings();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: width,
          height: 70.0,
          child: AnimatedTextFormField(
              initValue: defaultPeriodicvalue.toString(),
              enabled: true,
              width: width,
              loadingController: _loadingController,
              interval: _nameTextFieldLoadingAnimationInterval,
              labelText: hint,
              // prefixIcon: Icon(Icons.confirmation_number),
              keyboardType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                // FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) {
                return null;
              },
              onSaved: (value) async {
                resultValue = value;
              }),
        ),
      ],
    );
  }

  Widget _buildMaxTextField(String hint, double width, String result) {
    return new TextFormField(
      decoration: new InputDecoration(
        labelText: "حداکثر سرعت",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(2.0),
          borderSide: new BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        if (val.length == 0) {
          return "نمیتواند خالی باشد";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        maxSpeed = value;
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
      decoration: new InputDecoration(
        labelText: "حداقل سرعت",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(2.0),
          borderSide: new BorderSide(),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        if (val.length == 0) {
          return "نمیتواند خالی باشد";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        minSpeed = value;
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

  _showDefaultSettingsSheet(BuildContext context, String type) async {
   await loadDefaultSettings();
    showModalBottomSheetCustom(
        context: context,
        mHeight: 0.90,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child:
           Builder(
            builder: (context) {
              return Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 450.0,
                  child: Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  //height: 450.0,
                  child: Column(
                   // mainAxisAlignment: MainAxisAlignment.center,
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      type == MINMAX_SPEED_TAG
                          ? Column(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.center,
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
                                          maxSpeed),
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
                                          minSpeed),
                                    )
                                  ],
                                )
                              ],
                            )
                          : type == PERIODIC_UPDTAE_TIME_TAG
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: _buildTextField2(
                                          Translations.current
                                              .periodicSendTime(),
                                          150.0,
                                          resultValue,
                                          defaultPeriodicvalue.toString()),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: _buildTextField2(
                                          Translations.current
                                              .periodicAccuracy(),
                                          150.0,
                                          resultValue,
                                          ''),
                                    ),
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
                              color: Colors.white.value,
                              clr: Colors.green,
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
                ),
              );
            },
           ),
          );
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
              height: 100.0,
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

  setAppLogin() {
    prefRepository.setLoginStatus(loginRequiered);
    prefRepository.setLoginTypeStatus(loginType);
  }

  getUserMobile() async {
    //showPopUp(Translations.current.resetPassword());
    userId = await prefRepository.getLoginedUserId();
    mobile = await prefRepository.getLoginedMobile();
    if (mobile != null) {
      setState(() {});
    }
  }

  Future<int> loadDefaultSettings() async {
    defaultPeriodicvalue =
        await prefRepository.getPeriodicUpdate(PERIODIC_UPDTAE_TIME_TAG);
    if (defaultPeriodicvalue == null || defaultPeriodicvalue == 0)
      defaultPeriodicvalue = 60;
    return defaultPeriodicvalue;
  }

  onCarPageTap() {
    Navigator.of(context).pushNamed('/carpage',
        arguments: new CarPageVM(
            userId: userId, isSelf: true, carAddNoty: valueNotyModelBloc));
  }

  getThemeoption() async {
    changeThemeBloc.getOption().then((value) {
      setState(() {
        themeOption = value;
        if (themeOption == 0)
          lightAppTheme = true;
        else
          lightAppTheme = false;
      });
    });
  }

  List<Widget> _buildRangeSliders() {
    List<Widget> children = <Widget>[];
    for (int index = 0; index < rangeSliders.length; index++) {
      children
          .add(rangeSliders[index].build(context, (double lower, double upper) {
        // adapt the RangeSlider lowerValue and upperValue
        setState(() {
          rangeSliders[index].lowerValue = lower;
          rangeSliders[index].upperValue = upper;
        });
      }));
      // Add an extra padding at the bottom of each RangeSlider
      children.add(SizedBox(height: 8.0));
    }

    return children;
  }

  List<RangeSliderData> _rangeSliderDefinitions() {
    return <RangeSliderData>[
      RangeSliderData(
          min: 0.0, max: 100.0, lowerValue: 10.0, upperValue: 100.0),
      RangeSliderData(
          min: 0.0,
          max: 100.0,
          lowerValue: 25.0,
          upperValue: 75.0,
          divisions: 20,
          overlayColor: Colors.red[100]),
      RangeSliderData(
          min: 0.0,
          max: 100.0,
          lowerValue: 10.0,
          upperValue: 30.0,
          showValueIndicator: false,
          valueIndicatorMaxDecimals: 0),
      RangeSliderData(
          min: 0.0,
          max: 100.0,
          lowerValue: 10.0,
          upperValue: 30.0,
          showValueIndicator: true,
          valueIndicatorMaxDecimals: 0,
          activeTrackColor: Colors.red,
          inactiveTrackColor: Colors.red[50],
          valueIndicatorColor: Colors.green),
      RangeSliderData(
          min: 0.0,
          max: 100.0,
          lowerValue: 25.0,
          upperValue: 75.0,
          divisions: 20,
          thumbColor: Colors.grey,
          valueIndicatorColor: Colors.grey),
    ];
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
          widget.scaffoldKey.currentState.openDrawer();
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
      'تنظیمات',
      style: TextStyle(fontSize: 12, color: Colors.blueAccent),
    );
  }

  @override
  initialize() {
    // TODO: implement initialize
    scaffoldKey = widget.scaffoldKey;
    getAppTheme();
    getThemeoption();
    getUserMobile();
    loadDefaultSettings();
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
  Widget pageContent() {
    // TODO: implement pageContent
    return /*Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(userName: userName,imageUrl: imageUrl,currentRoute: route,carPageTap: onCarPageTap,carId: CenterRepository.getCurrentCarId(),) ,//buildDrawer(context, route,userName,imageUrl,null,''),
      body:*/
        Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        /* Align(
            alignment: Alignment(1,-1),
            child:
            Container(
              height:70.0,
              child:
              AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions:null, */ /*<Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward,color: Colors.indigoAccent,),
              onPressed: (){
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],*/ /*
                leading: IconButton(
                  icon: Icon(Icons.menu,color: Colors.indigoAccent,),
                  onPressed: (){
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
            ),
          ),*/
        new Padding(
          padding: EdgeInsets.only(top: 80.0),
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'عمومی',
                tiles: [
                  SettingsTile(
                    title: 'زبان',
                    subtitle: 'فارسی',
                    leading: Icon(Icons.language),
                    onTap: () {
                      /* Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));*/
                    },
                  ),
                  SettingsTile(
                    title: 'زمان دریافت اطلاعات خودرو برحسب ثانیه',
                    subtitle: 'تنظیمات اطلاعات دریافت',
                    leading: Icon(Icons.update),
                    onTap: () {
                      _showDefaultSettingsSheet(
                          context, PERIODIC_UPDTAE_TIME_TAG);
                    },
                  ),
                  /* SettingsTile(
                title: 'زمان دریافت وضعیت خودرو',
                subtitle: 'تنظیمات وضعیت خودرو',
                leading: Icon(Icons.update),
                onTap: () {
                  _showDefaultSettingsSheet(context,PERIODIC_UPDTAE_TIME_TAG);
                },
              ),*/
                  /*SettingsTile(
                title: 'تنظیمات سرعت',
                subtitle: 'حداقل حداکثر سرعت',
                leading: Icon(Icons.shutter_speed),
                onTap: () {
                  _showDefaultSettingsSheet(context,MINMAX_SPEED_TAG);
                },
              ),*/
                  SettingsTile.switchTile(
                      leftPadding: 25.0,
                      rightPadding: 2.0,
                      title: Translations.current.appTheme(),
                      subtitle: lightAppTheme
                          ? Translations.current.lightTheme()
                          : Translations.current.darkTheme(),
                      switchValue: lightAppTheme,
                      onTap: () {
                        setState(() {
                          lightAppTheme = !lightAppTheme;
                          _toggle();
                          // BlocProvider.of<ThemeBloc>(context).add(new ThemeChanged(theme: itemAppTheme));
                          changeThemeBloc.onLightThemeChange();
                        });
                      },
                      onToggle: (bool value) {
                        setState(() {
                          lightAppTheme = value;
                          _toggle();
                          //BlocProvider.of<ThemeBloc>(context).add(new ThemeChanged(theme: itemAppTheme));
                          if (lightAppTheme)
                            changeThemeBloc.onLightThemeChange();
                          else
                            changeThemeBloc.onDarkThemeChange();
                        });
                      },
                      leading: Icon(Icons.ac_unit)),
                ],
              ),
              SettingsSection(
                title: 'کاربری',
                tiles: [
                  SettingsTile(
                      title: 'شماره همراه',
                      subtitle: mobile == null ? '' : mobile,
                      leading: Icon(Icons.phone)),
                  //SettingsTile(title: 'ایمیل', leading: Icon(Icons.email)),
                  /*SettingsTile(title: 'خروج از حساب کاربری',
                  leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.of(context).pushNamed('/logout');
              },),*/
                ],
              ),
              SettingsSection(
                title: 'ارسال فرمان',
                tiles: [
                  SettingsTile(
                    title: Translations.current.sendCommand(),
                    leading: Icon(Icons.phonelink_lock),
                    onTap: () {
                      _showSendingCommandSheet(context);
                    },
                  ),
                ],
              ),
              /* SettingsTile.switchTile(
                  title: Translations.current.useFingerPrint(),
                  leading: Icon(Icons.fingerprint),
                  onToggle: (bool value) {
                    setState(() {
                      useFinger=value;
                      usePattern=!value;
                      usePassword=!value;
                      loginType=LoginType.FINGERPRINT;
                      setAppLogin();
                    });
                  },
                  switchValue: useFinger),
              SettingsTile.switchTile(
                  title: Translations.current.usePattern(),
                  leading: Icon(Icons.apps),
                  onToggle: (bool value) {
                    setState(() {
                        usePattern=value;
                        usePassword=!value;
                        useFinger=!value;
                        loginType=LoginType.PATTERN;
                        setAppLogin();

                    });
                  },
                  switchValue: usePattern),
              SettingsTile.switchTile(
                  title: Translations.current.usePassword(),
                  leading: Icon(Icons.apps),
                  onToggle: (bool value) {
                    setState(() {
                      usePattern=!value;
                      usePassword=value;
                      useFinger=!value;
                      loginType=LoginType.PASWWORD;
                      setAppLogin();

                    });
                  },
                  switchValue: usePassword),
              SettingsTile (
                title: 'تغییر رمز عبور',
                leading: Icon(Icons.lock),
                onTap: () {
                  _showResetPassword();
                },
              ),
            ],
          ),*/
              SettingsSection(
                title: 'درباره شرکت',
                tiles: [
                  SettingsTile(
                      title: 'توضیحات', leading: Icon(Icons.description)),
                  SettingsTile(
                      title: 'با مسئولیت محدود',
                      leading: Icon(Icons.collections_bookmark)),
                ],
              )
            ],
          ),
        ),
      ],
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
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    if (action == 1) {
      //if(widget.scaffoldKey.currentState.isDrawerOpen)
      widget.scaffoldKey.currentState.openDrawer();
    }
    return null;
  }

  @override
  bool showMenu() {
    // TODO: implement showMenu
    return false;
  }

  @override
  bool doBack() {
    // TODO: implement doBack
    return true;
  }

}

class RangeSliderData {
  double min;
  double max;
  double lowerValue;
  double upperValue;
  int divisions;
  bool showValueIndicator;
  int valueIndicatorMaxDecimals;
  bool forceValueIndicator;
  Color overlayColor;
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color thumbColor;
  Color valueIndicatorColor;
  Color activeTickMarkColor;

  static const Color defaultActiveTrackColor = const Color(0xFF0175c2);
  static const Color defaultInactiveTrackColor = const Color(0x3d0175c2);
  static const Color defaultActiveTickMarkColor = const Color(0x8a0175c2);
  static const Color defaultThumbColor = const Color(0xFF0175c2);
  static const Color defaultValueIndicatorColor = const Color(0xFF0175c2);
  static const Color defaultOverlayColor = const Color(0x290175c2);

  RangeSliderData({
    this.min,
    this.max,
    this.lowerValue,
    this.upperValue,
    this.divisions,
    this.showValueIndicator: true,
    this.valueIndicatorMaxDecimals: 1,
    this.forceValueIndicator: false,
    this.overlayColor: defaultOverlayColor,
    this.activeTrackColor: defaultActiveTrackColor,
    this.inactiveTrackColor: defaultInactiveTrackColor,
    this.thumbColor: defaultThumbColor,
    this.valueIndicatorColor: defaultValueIndicatorColor,
    this.activeTickMarkColor: defaultActiveTickMarkColor,
  });

  // Returns the values in text format, with the number
  // of decimals, limited to the valueIndicatedMaxDecimals
  //
  String get lowerValueText =>
      lowerValue.toStringAsFixed(valueIndicatorMaxDecimals);
  String get upperValueText =>
      upperValue.toStringAsFixed(valueIndicatorMaxDecimals);

  // Builds a RangeSlider and customizes the theme
  // based on parameters
  //
  Widget build(BuildContext context, frs.RangeSliderCallback callback) {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              minWidth: 40.0,
              maxWidth: 40.0,
            ),
            child: Text(lowerValueText),
          ),
          Expanded(
            child: SliderTheme(
              // Customization of the SliderTheme
              // based on individual definitions
              // (see rangeSliders in _RangeSliderSampleState)
              data: SliderTheme.of(context).copyWith(
                overlayColor: overlayColor,
                activeTickMarkColor: activeTickMarkColor,
                activeTrackColor: activeTrackColor,
                inactiveTrackColor: inactiveTrackColor,
                //trackHeight: 8.0,
                thumbColor: thumbColor,
                valueIndicatorColor: valueIndicatorColor,
                showValueIndicator: showValueIndicator
                    ? ShowValueIndicator.always
                    : ShowValueIndicator.onlyForDiscrete,
              ),
              child: frs.RangeSlider(
                min: min,
                max: max,
                lowerValue: lowerValue,
                upperValue: upperValue,
                divisions: divisions,
                showValueIndicator: showValueIndicator,
                valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                onChanged: (double lower, double upper) {
                  // call
                  callback(lower, upper);
                },
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minWidth: 40.0,
              maxWidth: 40.0,
            ),
            child: Text(upperValueText),
          ),
        ],
      ),
    );
  }
}
