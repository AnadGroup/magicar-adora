import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/circular_progress_bar.dart';
import 'package:anad_magicar/components/countdowntimer/progress_card.dart';
import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/listener/listener_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/home/engine_status_widgets.dart';
import 'package:anad_magicar/ui/screen/home/home.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

enum MaterialColor { RED, BLUE, GREEN, YELLOW, BLACK, WHITE, GREY }

class EngineStatus extends StatefulWidget {
  bool engineStatus;
  bool lockStatus;
  Color color;
  CarStateVM carStateVM;
  NotyBloc<Message> carPageNoty;
  NotyBloc<CarStateVM> carStateNoty;
  NotyBloc<SendingCommandVM> sendCommandNoty;

  EngineStatus(
      {Key key,
      this.engineStatus,
      this.lockStatus,
      this.color,
      this.carPageNoty,
      this.carStateVM,
      this.carStateNoty,
      this.sendCommandNoty})
      : super(key: key);

  @override
  _EngineStatusState createState() {
    return _EngineStatusState();
  }
}

class _EngineStatusState extends State<EngineStatus>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  int userId;
  int carId;
  bool hasInternet = true;
  static bool getStatusExecuted = false;
  static bool onTapRaised = false;
  RestDatasource restDS;
  bool isDoorOpen;
  static String lastActionCode;
  AudioCache player = AudioCache();
  AudioPlayer advancedPlayer;

  Animation animation, transformationAnim;
  AnimationController animationController;

  AnimationController controller;
  AnimationController _controller;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  var squareScaleA = 1.0;
  var squareScaleB = 0.5;
  AnimationController _controllerA;
  AnimationController _controllerB;

  String engineImageUrl = 'assets/images/stop_engine.png';
  static bool temp_engineStatus = false;
  static bool confirm_engineStatus = false;

  bool commandSuccess = false;
  bool isDark = false;
  bool trunk_status;
  bool caput_status;
  bool lock_status;
  bool reservation;
  bool door_status;
  bool aux1;
  bool aux2;
  bool siren = false;
  bool _buttonPressed = false;
  bool _loopActive = false;
  int _counter = 0;
  double percentage = 0;
  double percentage_compeleted = 1.0;
  bool isEngineOn = false;
  bool isEngineOff = true;
  Color _currentColor;

  double iconSizeWidth = kIsWeb ? 28.0 : 48.0;
  double iconSizeHeight = kIsWeb ? 28.0 : 48.0;

  registerRxBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event) {
      if (event != null && event.type == 'COMMAND_SUCCESS') {
        /*widget.sendCommandNoty.updateValue(
             new SendingCommandVM(sending: false,
                 sent: true, hasError: false));*/
        commandSuccess = true;

        if (lastActionCode != null) {
          if (lastActionCode == ActionsCommand.LockAndArm_Nano_CODE) {
            updateLockStatus(true);
          } else if (lastActionCode ==
              ActionsCommand.UnlockAndDisArm_Nano_CODE) {
            updateLockStatus(false);
          } else if (lastActionCode ==
              ActionsCommand.RemoteTrunk_Release_CODE) {
            updateTrunkStatus(true);
          } else if (lastActionCode ==
              ActionsCommand.DriveLock_ONOrOFF_Nano_CODE) {
            updateTrunkStatus(false);
          } else if (lastActionCode == ActionsCommand.SirenOn_ON_TAG) {
            updateSirenStatus(true);
          } else if (lastActionCode == ActionsCommand.SirenOn_OFF_TAG) {
            updateSirenStatus(false);
          } else if (lastActionCode == ActionsCommand.AUX1_Output_ON_CODE) {
            updateAUX1Status(true);
          } else if (lastActionCode == ActionsCommand.AUX1_Output_OFF_CODE) {
            updateAUX1Status(false);
          } else if (lastActionCode == ActionsCommand.AUX2_Output_ON_CODE) {
            updateAUX2Status(true);
          } else if (lastActionCode == ActionsCommand.AUX2_Output_OFF_CODE) {
            updateAUX1Status(false);
          }

          play('', lastActionCode);
        }
        updateCarStatusAfterCommands();
      }
    });
  }

  Future<bool> getAppTheme() async {
    bool value = await centerRepository.getAppTheme();
    if (value != null) {
      return value;
    }
    return null;
  }

  createEngineOnOffBorder() {
    Color forground = Colors.lightGreenAccent;
    if (percentage_compeleted >= 1.0) if (temp_engineStatus)
      forground = Colors.lightGreenAccent;
    else
      forground = Colors.redAccent;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: CircleProgressBar(
                backgroundColor: forground,
                foregroundColor: forground.withOpacity(0.3),
                value: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<int> fetchUserId() async {
    userId = await prefRepository.getLoginedUserId();
    return userId;
  }

  void updateLockStatus(bool status) {
    setState(() {
      lock_status = status;
    });
  }

  void updateAUX1Status(bool status) {
    setState(() {
      aux1 = status;
    });
  }

  void updateAUX2Status(bool status) {
    setState(() {
      aux2 = status;
    });
  }

  void updateSirenStatus(bool status) {
    setState(() {
      siren = status;
    });
  }

  void updateTrunkStatus(bool status) {
    setState(() {
      trunk_status = status;
    });
  }

  void updateCaputStatus(bool status) {
    setState(() {
      caput_status = status;
    });
  }

  updateCarStatusAfterCommands() {
    widget.carStateVM.setCarStatusImages();
    centerRepository.updateCarStateVMMap(widget.carStateVM);
    widget.carStateNoty.updateValue(widget.carStateVM);
  }

  sendCommand(String actionCode) async {
    int actionId = ActionsCommand.actionCommandsMap[actionCode];

    String command = '';
    if (actionCode == ActionsCommand.AUX1_Output_ON_CODE ||
            actionCode ==
                ActionsCommand
                    .AUX2_Output_ON_CODE /*||
    actionCode==ActionsCommand.SirenOn_ON_TAG*/
        )
      command = '1';
    else if (actionCode == ActionsCommand.AUX1_Output_OFF_CODE ||
            actionCode ==
                ActionsCommand
                    .AUX2_Output_OFF_CODE /*||
        actionCode==ActionsCommand.SirenOn_OFF_TAG*/
        ) command = '0';
    SendCommandModel sendCommand = SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: widget.carStateVM.carId,
        Command: command);
    // centerRepository.showProgressDialog(context, Translations.current.sendingCommand());
    widget.sendCommandNoty.updateValue(
        SendingCommandVM(sending: true, sent: false, hasError: false));
    try {
      if (hasInternet) {
        ServiceResult result = await restDS.sendCommand(sendCommand);
        if (result != null) {
          if (result.IsSuccessful) {
            commandSuccess = false;
            lastActionCode = actionCode;

            widget.sendCommandNoty.updateValue(
                SendingCommandVM(sending: false, sent: true, hasError: false));
          } else {
            widget.sendCommandNoty.updateValue(
                SendingCommandVM(sending: false, sent: false, hasError: true));
          }
        } else {
          widget.sendCommandNoty.updateValue(
              SendingCommandVM(sending: false, sent: false, hasError: true));
        }
      } else {
        widget.sendCommandNoty.updateValue(
            SendingCommandVM(sending: false, sent: true, hasError: false));
        play('', actionCode);
      }
    } catch (error) {
      widget.sendCommandNoty.updateValue(
          SendingCommandVM(sending: false, sent: false, hasError: true));
    }
    Future.delayed(Duration(milliseconds: 3000)).then((value) {
      widget.sendCommandNoty.updateValue(
          SendingCommandVM(sending: false, sent: false, hasError: false));
    });
    // }
  }

  void releaseTapRaised(bool tapRaised) {
    Future.delayed(Duration(milliseconds: 5000)).then((value) {
      if (onTapRaised) onTapRaised = false;
    });
  }

  void _decreaseCounterWhilePressed() async {
    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;

    if (!_buttonPressed) {
      controller.stop();
    }
    while (_buttonPressed) {
      if (controller.isAnimating) {
        //controller.stop();
      } else if (controller.isCompleted) {
      } else {
        // _buttonPressed=false;
        controller.reverse(
            from: controller.value == 0.0 ? 1.0 : controller.value);
      }

      // do your thing

      setState(() {
        if (percentage >= 1.0) {
          _buttonPressed = false;
          _loopActive = false;
          percentage = 0.0;

          controller.stop();
          //تصویر اگر موتور روشن است باید خاموش باشد اگر موتور خاموش است با ید تصویر روشن باشد
          if (temp_engineStatus) {
            engineImageUrl = 'assets/images/stop_engine.png';
            /*BlocProvider
                .of<GlobalBloc>(context)
                .messageBloc
                .addition
                .add(new Message(
                text: 'assets/images/engine_start.png',
                type: 'POWER',
                status: false));*/
          } else {
            engineImageUrl = 'assets/images/start_engine.png';
            /* BlocProvider
                .of<GlobalBloc>(context)
                .messageBloc
                .addition
                .add(new Message(
                text: 'assets/images/engine_start.png',type: 'POWER',
                status: true));*/
          }

          //confirm_engineStatus=confirm_engineStatus;
          if (temp_engineStatus)
            temp_engineStatus = false;
          else
            temp_engineStatus = true;
          listenerRepository.onPowerTap(context, temp_engineStatus);
          widget.carStateVM.isPowerOn = temp_engineStatus;
          //widget.carStateVM.setCarStatusImages();
          centerRepository.updateCarStateVMMap(widget.carStateVM);
          widget.carStateNoty.updateValue(widget.carStateVM);

          _counter++;
          percentage_compeleted = 1.0;
          if (temp_engineStatus) {
            isEngineOn = true;
            isEngineOff = false;
            //play(Constants.POWER_ENGINE_START_SOUND);
            sendCommand(ActionsCommand.RemoteStartOn_Nano_CODE);
          } else {
            isEngineOn = false;
            isEngineOff = true;
            //play(Constants.POWER_ENGINE_OFF_SOUND);
            sendCommand(ActionsCommand.RemoteStartOff_Nano_CODE);
          }
        } else {
          percentage += 0.25;
        }
      });
      RxBus.post(
          new ChangeEvent(message: 'UPDATE_PROGRESS', amount: percentage));

      // wait a bit
      await Future.delayed(Duration(milliseconds: 1000));
    }

    _loopActive = false;
  }

  showWaitingFlash() {
    FlashHelper.successBarInCenter(context,
        duration: new Duration(seconds: 3),
        message: ' زمان باقیمانده تا اجرا 3  ثانیه',
        body: '',
        moreInfo: '');
  }

  setEngineImage(bool status) {
    if (status) {
      engineImageUrl = 'assets/images/start_engine.png';
    } else {
      engineImageUrl = 'assets/images/stop_engine.png';
    }
  }

  doAfterValidation() {
    if (reservation != null && reservation) {
      percentage_compeleted = 1.0;
      _buttonPressed = true;
      _decreaseCounterWhilePressed();
    } else {
      FlashHelper.successBar(
        context,
        message: Translations.current.reservationIsDisabled(),
      );
    }
  }

  Widget buildControlRow(BuildContext context, String startImgPath,
      NotyBloc<Message> noty, bool engineStatus, bool lockStatus) {
    lock_status = widget.carStateVM.arm;
    isDoorOpen = widget.carStateVM.isDoorOpen;
    trunk_status = widget.carStateVM.isTraunkOpen;
    caput_status = widget.carStateVM.isCaputOpen;
    reservation = widget.carStateVM.reservation;

    // _currentColor=widget.carStateVM.getCurrentColor();
    double h = MediaQuery.of(context).size.height * 0.28;
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return StreamBuilder<Message>(
            stream: widget.carPageNoty.noty,
            initialData: null,
            builder: (BuildContext c, AsyncSnapshot<Message> data) {
              if (data != null && data.hasData) {
                Message msg = data.data;
                if (msg.type == 'CARPAGE') {
                  //_currentColor = colors[msg.index];

                }
              }
              return StreamBuilder<CarStateVM>(
                stream: widget.carStateNoty.noty,
                initialData: widget.carStateVM,
                builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
                  if (data != null && data.hasData) {
                    CarStateVM carState = data.data;
                    //currentState2=carState;
                    getStatusExecuted = true;
                    lock_status = carState.arm;
                    isDoorOpen = carState.isDoorOpen;
                    trunk_status = carState.isTraunkOpen;
                    siren = carState.siren;
                    commandSuccess = true;
                    temp_engineStatus =
                        carState.isPowerOn != null ? carState.isPowerOn : false;
                    setEngineImage(temp_engineStatus);
                  }
                  return Stack(
                    alignment: new Alignment(0, 0),
                    overflow: Overflow.visible,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: Container(
                          //alignment: Alignment.topCenter,
                          width: MediaQuery.of(context).size.width,
                          height: h + 20,
                          child: new Card(
                            margin: new EdgeInsets.only(
                                left: 2.0, right: 2.0, top: 4.0, bottom: 1.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: !isDark
                                      ? Color(0xFF000000)
                                      : Color(0xFFFFFFFF),
                                  width:
                                      0.0 /*MediaQuery
                          .of(context)
                          .size
                          .width / 500*/
                                  ),
                              borderRadius: new BorderRadius.all(
                                  Radius.elliptical(10, 10)),
                            ),
                            color:
                                !isDark ? Color(0xFFeceff1) : Color(0xFF212121),
                            elevation: 0.0,
                            child: Text(''),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 1.0,
                        top: 0.0,
                        child: EngineStatusWidgets.done(
                          selected: lock_status,
                          imagePath: 'assets/images/unlock_22.png',
                          counter: _counter,
                          currentColor: _currentColor,
                          height: h,
                          isEngine: false,
                          width: 0,
                          onTap: () {
                            showWaitingFlash();
                            Future.delayed(Duration(seconds: 3)).then((value) {
                              if (!onTapRaised) {
                                sendCommand(
                                    ActionsCommand.UnlockAndDisArm_Nano_CODE);
                                onTapRaised = true;
                                releaseTapRaised(onTapRaised);
                              }
                            });
                          },
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     Align(
                        //       alignment: Alignment.topLeft,
                        //       child:  Container(
                        //         margin: EdgeInsets.only(left: 25.0, top: 10.0),
                        //         //width: 64.0,
                        //         child:  GestureDetector(
                        //           onTap: () {
                        //             // listenerRepository.onLockTap(context, false);
                        //             // updateLockStatus(false);
                        //             showWaitingFlash();
                        //             Future.delayed(Duration(seconds: 3))
                        //                 .then((value) {
                        //               if (!onTapRaised) {
                        //                 //  widget.carStateVM.isDoorOpen = true;
                        //                 /* widget.carStateVM.setCarStatusImages();
                        //     centerRepository.setCarStateVMMap(widget.carStateVM);
                        //     widget.carStateNoty.updateValue(widget.carStateVM);*/
                        //                 // play(Constants.DOOR_OPEN_SOUND);
                        //                 sendCommand(ActionsCommand
                        //                     .UnlockAndDisArm_Nano_CODE);
                        //                 onTapRaised = true;
                        //                 releaseTapRaised(onTapRaised);
                        //               }
                        //             });
                        //           },
                        //           child:
                        //               // AvatarGlow(
                        //               //   startDelay: Duration(milliseconds: 1000),
                        //               //   glowColor: Colors.redAccent,
                        //               //   endRadius: 40.0,
                        //               //   duration: Duration(milliseconds: 2000),
                        //               //   repeat: true,
                        //               //   showTwoGlows: true,
                        //               //   repeatPauseDuration:
                        //               //       Duration(milliseconds: 100),
                        //               //   child:
                        //               Material(
                        //             elevation: 0.0,
                        //             shape: CircleBorder(),
                        //             child: CircleAvatar(
                        //               backgroundColor: Colors
                        //                   .white12 /*Colors.black12.withOpacity(
                        //             0.0)*/
                        //               ,
                        //               //Colors.grey[100] ,
                        //               child: (lock_status != null &&
                        //                       !lock_status &&
                        //                       getStatusExecuted)
                        //                   ? ImageNeonGlow(
                        //                       imageUrl:
                        //                           'assets/images/unlock_22.png',
                        //                       counter: _counter,
                        //                       color: _currentColor,
                        //                       scale: 2.5,
                        //                     )
                        //                   : Image.asset(
                        //                       'assets/images/unlock_22.png',
                        //                       color: _currentColor,
                        //                       scale: 2.5,
                        //                     ),

                        //               radius: 24.0,
                        //               //shape: BoxShape.circle
                        //             ),
                        //           ),
                        //           //   shape: BoxShape.circle,
                        //           //   animate:
                        //           //       (lock_status != null && !lock_status),
                        //           //   curve: Curves.fastOutSlowIn,
                        //           // ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                      new Positioned(
                        top: -8.0,
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: new Container(
                                color: Colors.transparent,
                                margin: EdgeInsets.only(right: 0.0, top: 10),
                                child: new GestureDetector(
                                  onTap: () {},
                                  child:
                                      /* AvatarGlow(
                              startDelay: Duration(milliseconds: 1000),
                              glowColor: Colors.transparent,
                              endRadius: 40.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child:*/
                                      Material(
                                    elevation: 0.0,
                                    //shape: CircleBorder(),
                                    color: !isDark
                                        ? Color(0x00eceff1)
                                        : Color(0x00eceff1),
                                    child: (reservation != null &&
                                            reservation &&
                                            getStatusExecuted)
                                        ? Text('reservation',
                                            style: new TextStyle(
                                                backgroundColor:
                                                    Colors.transparent,
                                                color: Colors.greenAccent,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))
                                        : Text('reservation',
                                            style: new TextStyle(
                                                backgroundColor:
                                                    Colors.transparent,
                                                color: Colors.redAccent,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal)),
                                  ),
                                  /* shape: BoxShape.circle,
                              animate: reservation,
                              curve: Curves.fastOutSlowIn,
                            ),*/
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Positioned(
                        right: 1.0,
                        top: 0.0,
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: new Container(
                                margin: EdgeInsets.only(right: 25.0, top: 10),
                                width: iconSizeWidth,
                                height: iconSizeHeight,
                                child: new GestureDetector(
                                  onTap: () {
                                    //listenerRepository.onLockTap(context, true);
                                    // updateLockStatus(true);
                                    showWaitingFlash();
                                    Future.delayed(Duration(seconds: 3))
                                        .then((value) {
                                      if (!onTapRaised) {
                                        widget.carStateVM.isDoorOpen = false;
                                        sendCommand(ActionsCommand
                                            .LockAndArm_Nano_CODE);
                                        onTapRaised = true;
                                        releaseTapRaised(onTapRaised);
                                      }
                                    });

                                    //play(Constants.DOOR_LOCK_SOUND,);
                                  },
                                  child:
                                      // AvatarGlow(
                                      //   startDelay: Duration(milliseconds: 1000),
                                      //   glowColor: Colors.redAccent,
                                      //   endRadius: 40.0,
                                      //   duration: Duration(milliseconds: 2000),
                                      //   repeat: true,
                                      //   showTwoGlows: true,
                                      //   repeatPauseDuration:
                                      //       Duration(milliseconds: 100),
                                      //   child:
                                      Material(
                                    elevation: 0.0,
                                    shape: CircleBorder(),
                                    //child:
                                    //  CircleAvatar(
                                    //   backgroundColor: Colors
                                    //       .transparent

                                    //   ,

                                    child: (lock_status != null &&
                                            lock_status &&
                                            getStatusExecuted)
                                        ? kIsWeb
                                            ? Container(
                                                width: 28,
                                                height: 28,
                                                child: ImageNeonGlow(
                                                  imageUrl:
                                                      'assets/images/lock_11.png',
                                                  counter: _counter,
                                                  color: _currentColor,
                                                ))
                                            : ImageNeonGlow(
                                                imageUrl:
                                                    'assets/images/lock_11.png',
                                                counter: _counter,
                                                color: _currentColor,
                                                scale: 2.0,
                                              )
                                        : kIsWeb
                                            ? Container(
                                                width: 28,
                                                height: 28,
                                                child: Image.asset(
                                                  'assets/images/lock_11.png',
                                                  color: _currentColor,
                                                ),
                                              )
                                            : Image.asset(
                                                'assets/images/lock_11.png',
                                                scale: 2.0,
                                                color: _currentColor,
                                              ),
                                    // radius: 24.0,
                                  ),
                                ),
                                //   shape: BoxShape.circle,
                                //   animate:
                                //       (lock_status != null && lock_status),
                                //   curve: Curves.fastOutSlowIn,
                                // ),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: -37.0,
                        bottom: 0.0,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 4.0,
                                  left: 0.0,
                                  right: 25.0,
                                ),
                                child: Container(
                                  height: 0.0,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                            new GestureDetector(
                              onTapDown: (details) {},

                              onLongPress: () {
                                doAfterValidation();
                              },

                              onTapCancel: () {
                                if (reservation != null && reservation) {
                                  _buttonPressed = false;
                                  //stop(Constants.POWER_ENGINE_SOUND);
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  } else {
                                    controller.stop();
                                  }
                                  if (percentage < 1.0) {
                                    setState(() {
                                      percentage = 0.0;
                                    });
                                    RxBus.post(new ChangeEvent(
                                        message: 'UPDATE_PROGRESS',
                                        amount: percentage));
                                  }
                                }
                              },
                              onLongPressUp: () {
                                // stop(Constants.POWER_ENGINE_SOUND);
                                if (reservation != null && reservation) {
                                  _buttonPressed = false;
                                  percentage_compeleted = 1.0;
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  } else {
                                    controller.stop();
                                  }
                                  if (percentage < 1.0) {
                                    setState(() {
                                      percentage = 0.0;
                                      percentage_compeleted = 1.0;
                                    });
                                    RxBus.post(new ChangeEvent(
                                        message: 'UPDATE_PROGRESS',
                                        amount: percentage));
                                  }
                                }
                              },
                              onTapUp: (details) {
                                if (reservation != null && reservation) {
                                  _buttonPressed = false;
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  } else {
                                    controller.stop();
                                  }
                                  if (percentage < 1.0) {
                                    setState(() {
                                      percentage = 0.0;
                                      percentage_compeleted = 1.0;
                                    });
                                    RxBus.post(new ChangeEvent(
                                        message: 'UPDATE_PROGRESS',
                                        amount: percentage));
                                  }
                                }
                              },
                              child: new Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  // AvatarGlow(
                                  //   startDelay: Duration(milliseconds: 1000),
                                  //   glowColor: Colors.pink,
                                  //   endRadius:
                                  //       MediaQuery.of(context).size.width * 0.2,
                                  //   duration: Duration(milliseconds: 2000),
                                  //   repeat: true,
                                  //   showTwoGlows: true,
                                  //   repeatPauseDuration:
                                  //       Duration(milliseconds: 100),
                                  //   child:
                                  Material(
                                    elevation: 0.0,
                                    shape: CircleBorder(),
                                    // child: CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //Colors.grey[100] ,
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 700),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return ScaleTransition(
                                            child: child, scale: animation);
                                      },
                                      child: new Container(
                                          width: h * 0.60,
                                          height: h * 0.60,
                                          key: ValueKey<int>(_counter),
                                          child: (temp_engineStatus != null &&
                                                  temp_engineStatus &&
                                                  getStatusExecuted)
                                              ? Container(
                                                  key: ValueKey(_counter),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .pinkAccent
                                                              .withAlpha(80),
                                                          blurRadius: 7.0,
                                                          spreadRadius: 0.0,
                                                          offset: Offset(
                                                            0.0,
                                                            6.0,
                                                          ),
                                                        ),
                                                      ]),
                                                  child: Container(
                                                    key: ValueKey(_counter),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .pinkAccent
                                                                .withAlpha(80),
                                                            blurRadius: 7.0,
                                                            spreadRadius: 0.0,
                                                            offset: Offset(
                                                              0.0,
                                                              6.0,
                                                            ),
                                                          ),
                                                        ]),
                                                    child: Image.asset(
                                                      startImgPath,
                                                      scale: 1,
                                                    ),
                                                  ),
                                                )
                                              : Image.asset(
                                                  startImgPath,
                                                  scale: 1,
                                                )),
                                    ),
                                    //radius: h * 0.30,
                                    //shape: BoxShape.circle
                                    // ),
                                  ),
                                  //   shape: BoxShape.circle,
                                  //   animate:
                                  //       (engineStatus != null && engineStatus),
                                  //   curve: Curves.fastOutSlowIn,
                                  // ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 700),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return ScaleTransition(
                                          child: child, scale: animation);
                                    },
                                    child: (temp_engineStatus != null &&
                                            temp_engineStatus &&
                                            getStatusExecuted)
                                        ? Container(
                                            key: ValueKey(_counter),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.pinkAccent
                                                        .withOpacity(0.6),
                                                    blurRadius: 6.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(
                                                      0.0,
                                                      3.0,
                                                    ),
                                                  ),
                                                ]),
                                            child: Text(
                                              ''
                                              /*Translations.current.engineStart()*/,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 25.0,
                                                  color: Colors.greenAccent
                                                      .withOpacity(1.0)),
                                            ))
                                        : Text(
                                            ''
                                            /*Translations.current.engineStart()*/,
                                            key: ValueKey(_counter),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 25.0,
                                                color: Colors.black26
                                                    .withOpacity(0.5)),
                                          ),
                                  ),
                                  //),
                                  new Align(
                                    alignment: Alignment.center,
                                    child: new ProgressCard(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      isOn: isEngineOn,
                                      isOff: isEngineOff,
                                    ),
                                  ),
                                ],
                              ),
                              // ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 4.0,
                                  left: 25.0,
                                  right: 0.0,
                                ),
                                child: Container(
                                  height: 0.0,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Positioned(
                        right: -10.0,
                        bottom: h * 0.40,
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: new Container(
                                margin: EdgeInsets.only(
                                    right: 25.0, bottom: 5, top: 1.0),
                                width: iconSizeWidth,
                                height: iconSizeHeight,
                                child: new GestureDetector(
                                  onTap: () {
                                    showWaitingFlash();
                                    Future.delayed(Duration(seconds: 3))
                                        .then((value) {
                                      if (!onTapRaised) {
                                        trunk_status = !trunk_status;
                                        // updateTrunkStatus(trunk_status);
                                        /*listenerRepository.onTrunkTap(
                                context, trunk_status);*/
                                        widget.carStateVM.isTraunkOpen =
                                            trunk_status;

                                        /*widget.carStateVM.setCarStatusImages();
                            centerRepository.setCarStateVMMap(widget.carStateVM);
                            widget.carStateNoty.updateValue(widget.carStateVM);*/
                                        if (trunk_status) {
                                          //play(Constants.TRUNK_OPEN_SOUND);
                                          sendCommand(ActionsCommand
                                              .RemoteTrunk_Release_CODE);
                                        } else {
                                          //play(Constants.TRUNK_CLOSE_SOUND);
                                          sendCommand(ActionsCommand
                                              .DriveLock_ONOrOFF_Nano_CODE);
                                        }
                                        onTapRaised = true;
                                        releaseTapRaised(onTapRaised);
                                      }
                                    });
                                  },
                                  child:
                                      // AvatarGlow(
                                      //   startDelay: Duration(milliseconds: 1000),
                                      //   glowColor: Colors.white,
                                      //   endRadius: 40.0,
                                      //   duration: Duration(milliseconds: 2000),
                                      //   repeat: true,
                                      //   showTwoGlows: true,
                                      //   repeatPauseDuration:
                                      //       Duration(milliseconds: 100),
                                      //   child:
                                      Material(
                                    elevation: 0.0,
                                    shape: CircleBorder(),
                                    // child:
                                    //  CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //Colors.grey[100] ,
                                    child: (trunk_status != null &&
                                            trunk_status &&
                                            commandSuccess &&
                                            getStatusExecuted)
                                        ? ImageNeonGlow(
                                            imageUrl: 'assets/images/trunk.png',
                                            counter: _counter,
                                            color: _currentColor,
                                          )
                                        : Image.asset(
                                            'assets/images/trunk.png',
                                            scale: 2.0,
                                            color: _currentColor,
                                          ),
                                    // radius: 24.0,
                                    //shape: BoxShape.circle
                                    // ),
                                  ),
                                  //   shape: BoxShape.circle,
                                  //   animate:
                                  //       (trunk_status != null && trunk_status),
                                  //   curve: Curves.fastOutSlowIn,
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Positioned(
                        left: -10.0,
                        bottom: h * 0.40,
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: new Container(
                                margin: EdgeInsets.only(
                                    left: 25.0, bottom: 5, top: 10.0),
                                width: iconSizeWidth,
                                height: iconSizeHeight,
                                child: new GestureDetector(
                                  onTap: () {
                                    showWaitingFlash();
                                    Future.delayed(Duration(seconds: 3))
                                        .then((value) {
                                      if (!onTapRaised) {
                                        //listenerRepository.onTap(context, true);
                                        siren = !siren;

                                        widget.carStateVM.siren = siren;
                                        // updateSirenStatus(siren);
                                        sendCommand(siren
                                            ? ActionsCommand.SirenOn_ON_TAG
                                            : ActionsCommand.SirenOn_OFF_TAG);
                                        onTapRaised = true;
                                        releaseTapRaised(onTapRaised);
                                      }
                                    });
                                  },
                                  child:
                                      // AvatarGlow(
                                      //   startDelay: Duration(milliseconds: 1000),
                                      //   glowColor:
                                      //       Colors.indigoAccent.withOpacity(0.5),
                                      //   endRadius: 40.0,
                                      //   duration: Duration(milliseconds: 2000),
                                      //   repeat: true,
                                      //   showTwoGlows: true,
                                      //   repeatPauseDuration:
                                      //       Duration(milliseconds: 100),
                                      //   child:
                                      Material(
                                    elevation: 0.0,
                                    shape: CircleBorder(),
                                    // child: CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //Colors.grey[100] ,
                                    child: (siren != null &&
                                            siren &&
                                            commandSuccess &&
                                            getStatusExecuted)
                                        ? ImageNeonGlow(
                                            imageUrl: 'assets/images/horn.png',
                                            counter: _counter,
                                            color: _currentColor,
                                          )
                                        : Image.asset(
                                            'assets/images/horn.png',
                                            scale: 2.0,
                                            color: _currentColor,
                                          ),
                                    //   radius: 24.0,
                                    // ),
                                  ),
                                  //   shape: BoxShape.circle,
                                  //   animate: (siren != null && siren),
                                  //   curve: Curves.fastOutSlowIn,
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Positioned(
                        right: 35.0,
                        bottom: 10.0,
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomRight,
                              child: new Container(
                                margin: EdgeInsets.only(
                                    left: 25.0, bottom: 5, top: 1.0),
                                width: iconSizeWidth,
                                height: iconSizeHeight,
                                child: new GestureDetector(
                                  onTap: () {
                                    showWaitingFlash();
                                    Future.delayed(Duration(seconds: 3))
                                        .then((value) {
                                      if (!onTapRaised) {
                                        aux2 = !aux2;

                                        widget.carStateVM.AUX2_On = aux2;
                                        // updateAUX2Status(aux2);
                                        sendCommand(aux2
                                            ? ActionsCommand.AUX2_Output_ON_CODE
                                            : ActionsCommand
                                                .AUX2_Output_OFF_CODE);
                                        onTapRaised = true;
                                        releaseTapRaised(onTapRaised);
                                      }
                                    });
                                  },
                                  child:
                                      // AvatarGlow(
                                      //   startDelay: Duration(milliseconds: 1000),
                                      //   glowColor:
                                      //       Colors.redAccent.withOpacity(0.5),
                                      //   endRadius: 40.0,
                                      //   duration: Duration(milliseconds: 2000),
                                      //   repeat: true,
                                      //   showTwoGlows: true,
                                      //   repeatPauseDuration:
                                      //       Duration(milliseconds: 100),
                                      //   child:
                                      Material(
                                    elevation: 0.0,
                                    shape: CircleBorder(),
                                    // child: CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //Colors.grey[100] ,
                                    child: (aux2 != null &&
                                            aux2 &&
                                            commandSuccess &&
                                            getStatusExecuted)
                                        ? ImageNeonGlow(
                                            imageUrl: 'assets/images/aux2.png',
                                            counter: _counter,
                                            color: widget.color,
                                          )
                                        : Image.asset(
                                            'assets/images/aux2.png',
                                            scale: 2.0,
                                            color: _currentColor,
                                          ),
                                    // radius: 24.0,
                                    //shape: BoxShape.circle
                                    //),
                                  ),
                                  //   shape: BoxShape.circle,
                                  //   animate: (aux2 != null && aux2),
                                  //   curve: Curves.fastOutSlowIn,
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Positioned(
                        //left: 0.0,
                        bottom: 5.0,
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: new Container(
                                margin: EdgeInsets.only(
                                    right: 0.0, bottom: 0, top: 0.0),
                                width: iconSizeWidth,
                                height: iconSizeHeight,
                                child: new GestureDetector(
                                  onTap: () {},
                                  child:
                                      // AvatarGlow(
                                      //   startDelay: Duration(milliseconds: 1000),
                                      //   glowColor: Colors.white,
                                      //   endRadius: 40.0,
                                      //   duration: Duration(milliseconds: 2000),
                                      //   repeat: true,
                                      //   showTwoGlows: true,
                                      //   repeatPauseDuration:
                                      //       Duration(milliseconds: 100),
                                      //   child:
                                      Material(
                                    elevation: 0.0,
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            width: 2.0, color: Colors.white30)),

                                    // child: CircleAvatar(
                                    //   backgroundColor:
                                    //       Colors.white30.withOpacity(0.5),
                                    //Colors.grey[100] ,
                                    child: Padding(
                                        padding: EdgeInsets.all(1.0),
                                        child: Text(
                                          'Cut Off',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 10.0),
                                        )),
                                    // radius: 24.0,
                                    //shape: BoxShape.circle
                                    // ),
                                  ),
                                  //   shape: BoxShape.circle,
                                  //   animate:
                                  //       (caput_status != null && caput_status),
                                  //   curve: Curves.fastOutSlowIn,
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Positioned(
                        left: 35.0,
                        bottom: 10.0,
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomRight,
                              child: new Container(
                                margin: EdgeInsets.only(
                                    right: 25.0, bottom: 5, top: 1.0),
                                width: iconSizeWidth,
                                height: iconSizeHeight,
                                child: new GestureDetector(
                                  onTap: () {
                                    showWaitingFlash();
                                    Future.delayed(Duration(seconds: 3))
                                        .then((value) {
                                      if (!onTapRaised) {
                                        aux1 = !aux1;

                                        widget.carStateVM.AUX1_On = aux1;
                                        // updateAUX1Status(aux1);
                                        sendCommand(aux1
                                            ? ActionsCommand.AUX1_Output_ON_CODE
                                            : ActionsCommand
                                                .AUX1_Output_OFF_CODE);
                                        onTapRaised = true;
                                        releaseTapRaised(onTapRaised);
                                      }
                                    });
                                  },
                                  child:
                                      // AvatarGlow(
                                      //   startDelay: Duration(milliseconds: 1000),
                                      //   glowColor:
                                      //       Colors.redAccent.withOpacity(0.5),
                                      //   endRadius: 40.0,
                                      //   duration: Duration(milliseconds: 2000),
                                      //   repeat: true,
                                      //   showTwoGlows: true,
                                      //   repeatPauseDuration:
                                      //       Duration(milliseconds: 100),
                                      //   child:
                                      Material(
                                    elevation: 0.0,
                                    shape: CircleBorder(),

                                    // child: CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //Colors.grey[100] ,
                                    child: (aux1 != null &&
                                            aux1 &&
                                            commandSuccess &&
                                            getStatusExecuted)
                                        ? ImageNeonGlow(
                                            imageUrl: 'assets/images/aux1.png',
                                            counter: _counter,
                                            color: widget.color,
                                          )
                                        : Image.asset(
                                            'assets/images/aux1.png',
                                            scale: 2.0,
                                            color: _currentColor,
                                          ),
                                    // radius: 24.0,
                                    //shape: BoxShape.circle
                                    //),
                                  ),
                                  //   shape: BoxShape.circle,
                                  //   animate: (aux1 != null && aux1),
                                  //   curve: Curves.fastOutSlowIn,
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        });
  }

  delayAfterTouchStartEngine() {
    Future.delayed(Duration(seconds: 4)).then((value) {});
  }

  animateEngineStatus() {
    /*animationController =
        AnimationController(duration: Duration(seconds: 8), vsync: this);

    animation = Tween(begin: 10.0, end: 200.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    transformationAnim = BorderRadiusTween(
        begin: BorderRadius.circular(150.0),
        end: BorderRadius.circular(0.0))
        .animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward();

    */

    _controllerA = AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 2.0,
        duration: Duration(seconds: 1));
    _controllerA.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        temp_engineStatus = !temp_engineStatus;
        if (temp_engineStatus) {
          engineImageUrl = 'assets/images/start_engine.png';
        } else {
          engineImageUrl = 'assets/images/stop_engine.png';
        }
        _controllerA.reverse();
      }
      if (status == AnimationStatus.forward) {
        // engineImageUrl = 'assets/images/car_start_3_1.png';
      }
    });
    _controllerA.addListener(() {
      setState(() {
        squareScaleA = _controllerA.value;
      });
    });
  }

  play(String sound, String actionCode) async {
    player.play(Constants.soundToActionMap[actionCode]);

    if (await Vibration.hasVibrator()) {
      if (await Vibration.hasAmplitudeControl()) {
        //if(actionCode==Con)
        //Vibration.vibrate(duration: 500, amplitude: 128);
      } else {
        //Vibration.vibrate(duration: 500);
      }
    }
  }

  stop(String sound) {
    player.clear(sound);
  }

  @override
  void initState() {
    registerRxBus();
    // getAppTheme();
    restDS = new RestDatasource();
    Constants.createSoundToActionMap();
    ActionsCommand.createActionsMap();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _currentColor = widget.carStateVM.getCurrentColor();
    advancedPlayer = new AudioPlayer();
    player = new AudioCache();
    player.load(Constants.DOOR_OPEN_SOUND);
    player.load(Constants.TRUNK_CLOSE_SOUND);
    player.load(Constants.POWER_ENGINE_START_SOUND);
    player.load(Constants.POWER_ENGINE_OFF_SOUND);
    player.load(Constants.TRUNK_OPEN_SOUND);
    player.load(Constants.DOOR_LOCK_SOUND);

    controller.addListener(() {
      setState(() {
        RxBus.post(
            new ChangeEvent(message: 'UPDATE_PROGRESS', amount: percentage));
      });
    });

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed &&
          status != AnimationStatus.reverse) {}
    });

    animateEngineStatus();
    fetchUserId();

    super.initState();
  }

  @override
  void dispose() {
    _controllerA.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      initialData: false,
      future: getAppTheme(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          bool value = snapshot.data;

          if (value) {
            if (_currentColor == Colors.black ||
                _currentColor == Colors.black38 ||
                _currentColor == Colors.black54) {
              _currentColor = Colors.white;
            }
          }
        }
        return buildControlRow(context, engineImageUrl, null,
            widget.engineStatus, widget.lockStatus);
      },
    );
  }
}
