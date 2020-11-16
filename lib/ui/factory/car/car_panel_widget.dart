import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/countdowntimer/custom_timer_painter.dart';
import 'package:anad_magicar/components/countdowntimer/progress_card.dart';
import 'package:anad_magicar/components/hold_gesture/holding_gesture.dart';
import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/components/shimmer/myshimmer.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/actions.dart';
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
import 'package:anad_magicar/ui/factory/car/base_car.dart';
import 'package:anad_magicar/ui/screen/home/home.dart';
import 'package:anad_magicar/widgets/flutter_offline/flutter_offline.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';


enum MaterialColor {RED,BLUE,GREEN,YELLOW,BLACK,WHITE,GREY}

class CarPanelWidget extends StatefulWidget {


  bool engineStatus;
  bool lockStatus;
  Color color;
  CarStateVM carStateVM;
  NotyBloc<Message> carPageNoty;
  NotyBloc<CarStateVM> carStateNoty;
  NotyBloc<SendingCommandVM> sendCommandNoty;

  CarPanelWidget({Key key,
    this.engineStatus,
    this.lockStatus,
    this.color,
    this.carPageNoty,
    this.carStateVM,
    this.carStateNoty,
    this.sendCommandNoty}) : super(key: key);

  @override
  _CarPanelWidgetState createState() {
    return _CarPanelWidgetState();
  }
}


class _CarPanelWidgetState extends State<CarPanelWidget> with SingleTickerProviderStateMixin ,
    TickerProviderStateMixin{


  int userId;
  int carId;
  bool hasInternet=true;
  RestDatasource restDS;
  bool isDoorOpen=false;
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

  String engineImageUrl='assets/images/engine_start.png';
  bool temp_engineStatus=false;
  bool trunk_status=false;
  bool caput_status=false;
  bool lock_status=false;
  bool _buttonPressed = false;
  bool _loopActive = false;
  int _counter=0;
  double percentage=0;
  Color _currentColor;

  Future<int> fetchUserId() async{
    userId=await prefRepository.getLoginedUserId();
    return userId;
  }

  void updateLockStatus(bool status)
  {
    setState(() {
      lock_status=status;
    });
  }

  void updateTrunkStatus(bool status)
  {
    setState(() {
      trunk_status=status;
    });
  }
  void updateCaputStatus(bool status)
  {
    setState(() {
      caput_status=status;
    });
  }

  sendCommand(String actionCode) async {

    int actionId=ActionsCommand.actionCommandsMap[actionCode];
    //ActionModel actionModel=centerRepository.getActionByActionCode(actionId);
    //if(actionModel!=null) {
    SendCommandModel sendCommand = new SendCommandModel(
        UserId: userId,
        ActionId: actionId,
        CarId: widget.carStateVM.carId,
        Command: '');
    // centerRepository.showProgressDialog(context, Translations.current.sendingCommand());
    widget.sendCommandNoty.updateValue(new SendingCommandVM(sending: true,
        sent: false, hasError: false));
    try {
      if (hasInternet) {
        ServiceResult result = await restDS.sendCommand(sendCommand);
        if (result != null) {
          if (result.IsSuccessful) {
            //centerRepository.dismissDialog(context);
            widget.sendCommandNoty.updateValue(
                new SendingCommandVM(sending: false,
                    sent: true, hasError: false));
            play('', actionCode);
          }
          else {
            widget.sendCommandNoty.updateValue(
                new SendingCommandVM(sending: false,
                    sent: false, hasError: true));
          }
        } else {
          widget.sendCommandNoty.updateValue(
              new SendingCommandVM(sending: false,
                  sent: false, hasError: true));
        }
      }
      else {
        widget.sendCommandNoty.updateValue(
            new SendingCommandVM(sending: false,
                sent: true, hasError: false));
        play('', actionCode);
      }
    }
    catch (error) {
      widget.sendCommandNoty.updateValue(
          new SendingCommandVM(sending: false,
              sent: false, hasError: true));

    }
    Future.delayed(new Duration(milliseconds: 10000)).then((value){
      widget.sendCommandNoty.updateValue(
          new SendingCommandVM(sending: false,
              sent: false, hasError: false));
    });
    // }
  }
  void _decreaseCounterWhilePressed() async {
    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;

    if(!_buttonPressed)
    {
      controller.stop();
    }
    while (_buttonPressed) {

      if (controller.isAnimating) {
        //controller.stop();
      }
      else if(controller.isCompleted)
      {
        /* if (temp_engineStatus) {
          // engineImageUrl='assets/images/car_start_3_1.png';
          BlocProvider
              .of<GlobalBloc>(context)
              .messageBloc
              .addition
              .add(new Message(
              text: 'assets/images/car_start_3_1.png',
              status: false));
        }
        else {
          // engineImageUrl='assets/images/car_start_3.png';
          BlocProvider
              .of<GlobalBloc>(context)
              .messageBloc
              .addition
              .add(new Message(
              text: 'assets/images/car_start_3.png',
              status: true));
        }

        temp_engineStatus = !temp_engineStatus;
        setState(() {
          _counter++;
        });*/

      }
      else {
        // _buttonPressed=false;
        controller.reverse(
            from: controller.value == 0.0
                ? 1.0
                : controller.value);

      }

      // do your thing

      setState(() {

        if(percentage>=1.0)
        {
          _buttonPressed=false;
          if(temp_engineStatus) {
            engineImageUrl='assets/images/engine_start.png';
            /*BlocProvider
                .of<GlobalBloc>(context)
                .messageBloc
                .addition
                .add(new Message(
                text: 'assets/images/engine_start.png',
                type: 'POWER',
                status: false));*/
          }
          else {
            engineImageUrl='assets/images/engine_start.png';
            /* BlocProvider
                .of<GlobalBloc>(context)
                .messageBloc
                .addition
                .add(new Message(
                text: 'assets/images/engine_start.png',type: 'POWER',
                status: true));*/
          }

          temp_engineStatus = !temp_engineStatus;

          listenerRepository.onPowerTap(context, temp_engineStatus);
          widget.carStateVM.isPowerOn=temp_engineStatus;
          //widget.carStateVM.setCarStatusImages();
          centerRepository.updateCarStateVMMap(widget.carStateVM);
          widget.carStateNoty.updateValue(widget.carStateVM);
          _counter++ ;
          percentage=0.0;

          if(temp_engineStatus) {
            //play(Constants.POWER_ENGINE_START_SOUND);
            sendCommand(ActionsCommand.RemoteStartOn_Nano_CODE);
          }
          else {
            //play(Constants.POWER_ENGINE_OFF_SOUND);
            sendCommand(ActionsCommand.RemoteStartOff_Nano_CODE);
          }

        }
        else{
          percentage+=0.25;
        }

      });
      RxBus.post(new ChangeEvent(message: 'UPDATE_PROGRESS',amount:percentage));

      // }
      // wait a bit
      await Future.delayed(Duration(milliseconds: 1000));
    }


    _loopActive = false;
  }


  Widget buildControlRow(BuildContext context,
      String startImgPath,
      NotyBloc<Message> noty,
      bool engineStatus,
      bool lockStatus)  {

    lock_status=!widget.carStateVM.isDoorOpen;
    trunk_status=widget.carStateVM.isTraunkOpen;
    caput_status=widget.carStateVM.isCaputOpen;
    return
      AnimatedBuilder(
          animation: controller,
          builder: (context, child)
          {
            return
              StreamBuilder<Message>(
                stream: widget.carPageNoty.noty,
                initialData: null,
                builder: (BuildContext c, AsyncSnapshot<Message> data)
                {
                  if (data != null && data.hasData) {
                    Message msg = data.data;
                    if (msg.type == 'CARPAGE') {
                      //_currentColor = colors[msg.index];

                    }
                  }
                  return
                    Stack(
                      alignment: new Alignment(0, 0),
                      overflow: Overflow.visible,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.only(top: 2.0),
                          child:
                          Container(
                            //alignment: Alignment.topCenter,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 1,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 3.8,
                            child:

                            new Card(
                              margin: new EdgeInsets.only(
                                  left: 22.0, right: 22.0, top: 4.0, bottom: 5.0),
                              shape: RoundedRectangleBorder(

                                side: BorderSide(
                                    color: Color(0x00616161), width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 500),
                                borderRadius: new BorderRadius.all(
                                    Radius.elliptical(100, 50)),
                              ),
                              color: Color(0xffffffff),
                              elevation: 0.0,
                              child: Text(''),
                            ),
                          ),
                        ),
                        new Positioned(
                          left: 1.0,
                          top: -20.0,
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[


                              Align(
                                alignment: Alignment.topLeft,
                                child:
                                new Container(
                                  margin: EdgeInsets.only(left: 25.0, top: 10.0),
                                  //width: 64.0,
                                  child:
                                  new GestureDetector(
                                    onTap: () {
                                      // listenerRepository.onLockTap(context, false);
                                      updateLockStatus(false);
                                      widget.carStateVM.isDoorOpen=true;
                                      widget.carStateVM.setCarStatusImages();
                                      centerRepository.updateCarStateVMMap(widget.carStateVM);
                                      widget.carStateNoty.updateValue(widget.carStateVM);
                                      // play(Constants.DOOR_OPEN_SOUND);
                                      sendCommand(ActionsCommand.UnlockAndDisArm_Nano_CODE);
                                    },
                                    child:
                                    AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Colors.redAccent,
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black12.withOpacity(
                                              0.0),
                                          //Colors.grey[100] ,
                                          child: lock_status ? Image.asset(
                                            'assets/images/unlock_22.png',
                                            color: _currentColor,) :
                                          ImageNeonGlow(
                                            imageUrl: 'assets/images/unlock_22.png',
                                            counter: _counter,
                                            color: _currentColor,),
                                          /*Container(
                                key: ValueKey(_counter),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF76ff03).withAlpha(60),
                                        blurRadius: 6.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(
                                          0.0,
                                          3.0,
                                        ),
                                      ),
                                    ]),
                                child:
                              Image.asset(
                                'assets/images/unlock_22.png', scale: 1.0,),
                              ),*/
                                          radius: 24.0,
                                          //shape: BoxShape.circle
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: !lock_status,
                                      curve: Curves.fastOutSlowIn,
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Positioned(
                          right: 1.0,
                          top: -20.0,
                          child:
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child:
                                new Container(
                                  margin: EdgeInsets.only(right: 25.0, top: 10),
                                  child:
                                  new GestureDetector(
                                    onTap: () {
                                      //listenerRepository.onLockTap(context, true);
                                      updateLockStatus(true);
                                      widget.carStateVM.isDoorOpen=false;
                                      widget.carStateVM.setCarStatusImages();
                                      centerRepository.updateCarStateVMMap(widget.carStateVM);
                                      widget.carStateNoty.updateValue(widget.carStateVM);
                                      sendCommand(ActionsCommand.LockAndArm_Nano_CODE);
                                      //play(Constants.DOOR_LOCK_SOUND,);
                                    },
                                    child:
                                    AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Colors.redAccent,
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black12.withOpacity(
                                              0.0),
                                          //Colors.grey[100] ,
                                          child: lock_status ?
                                          ImageNeonGlow(
                                            imageUrl: 'assets/images/lock_11.png',
                                            counter: _counter,
                                            color: _currentColor,) :
                                          Image.asset(
                                            'assets/images/lock_11.png', scale: 0.5,
                                            color: _currentColor,),
                                          radius: 24.0,

                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: lock_status,
                                      curve: Curves.fastOutSlowIn,
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 0.0,
                          bottom: 0.0,
                          child:
                          Row(
                            children: <Widget>[
                              Expanded(
                                child:
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 4.0, left: 0.0, right: 25.0,),
                                  child:
                                  Container(
                                    height: 0.5,

                                    color: Colors.black26,),),
                              ),
                              new GestureDetector(

                                onTapDown: (details) {
                                  /* _buttonPressed=true;
                      _decreaseCounterWhilePressed();*/
                                },

                                onLongPress: () {
                                  _buttonPressed = true;
                                  // play(Constants.POWER_ENGINE_SOUND);
                                  _decreaseCounterWhilePressed();
                                },

                                onTapCancel: () {
                                  _buttonPressed = false;
                                  //stop(Constants.POWER_ENGINE_SOUND);
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  }
                                  else {
                                    controller.stop();
                                  }
                                  if (percentage < 1.0) {
                                    setState(() {
                                      percentage = 0.0;
                                      RxBus.post(new ChangeEvent(
                                          message: 'UPDATE_PROGRESS',
                                          amount: percentage));
                                    });
                                  }
                                },
                                onLongPressUp: () {
                                  // stop(Constants.POWER_ENGINE_SOUND);
                                  _buttonPressed = false;
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  }
                                  else {
                                    controller.stop();
                                  }
                                  if (percentage < 1.0) {
                                    setState(() {
                                      percentage = 0.0;
                                      RxBus.post(new ChangeEvent(
                                          message: 'UPDATE_PROGRESS',
                                          amount: percentage));
                                    });
                                  }
                                },
                                onTapUp: (details) {
                                  _buttonPressed = false;
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  }
                                  else {
                                    controller.stop();
                                  }
                                  if (percentage < 1.0) {
                                    setState(() {
                                      percentage = 0.0;
                                      RxBus.post(new ChangeEvent(
                                          message: 'UPDATE_PROGRESS',
                                          amount: percentage));
                                    });
                                  }
                                  /* if (_controllerA.isCompleted) {
                        _controllerA.reverse();
                      } else {
                        _controllerA.forward(from: 0.0);
                      }*/


                                  /* if (engineStatus) {
                        // engineImageUrl='assets/images/car_start_3_1.png';
                        BlocProvider
                            .of<GlobalBloc>(context)
                            .messageBloc
                            .addition
                            .add(new Message(
                            text: 'assets/images/car_start_3_1.png',
                            status: false));
                      }
                      else {
                        // engineImageUrl='assets/images/car_start_3.png';
                        BlocProvider
                            .of<GlobalBloc>(context)
                            .messageBloc
                            .addition
                            .add(new Message(
                            text: 'assets/images/car_start_3.png',
                            status: true));
                      }

                      engineStatus = !engineStatus;*/
                                },
                                child:
                                new Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[

                                    AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Colors.pink,
                                      endRadius: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.8,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.redAccent,
                                          //Colors.grey[100] ,
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 700),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return ScaleTransition(
                                                  child: child, scale: animation);
                                            },
                                            child:
                                            new Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 2.5,
                                              height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 2.5,
                                              key: ValueKey<int>(_counter),
                                              child: !temp_engineStatus ?
                                              Image.asset(startImgPath, scale: 1,
                                              ) :
                                              Container(
                                                key: ValueKey(_counter),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        200),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0xFF76ff03)
                                                            .withAlpha(80),
                                                        blurRadius: 7.0,
                                                        spreadRadius: 0.0,
                                                        offset: Offset(
                                                          0.0,
                                                          6.0,
                                                        ),
                                                      ),
                                                    ]), child:
                                              Container(
                                                key: ValueKey(_counter),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        200),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0xFF76ff03)
                                                            .withAlpha(80),
                                                        blurRadius: 7.0,
                                                        spreadRadius: 0.0,
                                                        offset: Offset(
                                                          0.0,
                                                          6.0,
                                                        ),
                                                      ),
                                                    ]), child:
                                              Image.asset(startImgPath, scale: 1,),
                                              ),
                                              ),
                                            ),
                                          ),
                                          radius: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 3.5,
                                          //shape: BoxShape.circle
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: engineStatus,
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                    AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 700),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return ScaleTransition(
                                              child: child, scale: animation);
                                        },
                                        child:
                                        !temp_engineStatus ? Text(
                                          Translations.current.engineStart(),
                                          key: ValueKey(_counter),
                                          style: TextStyle(fontWeight: FontWeight.w700,
                                              fontSize: 25.0,
                                              color: Colors.black26.withOpacity(0.5)),) :
                                        Container(
                                            key: ValueKey(_counter),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xFF76ff03).withAlpha(
                                                        60),
                                                    blurRadius: 6.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(
                                                      0.0,
                                                      3.0,
                                                    ),
                                                  ),
                                                ]),
                                            child: Text(
                                              Translations.current.engineStart(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 25.0,
                                                  color: Colors.greenAccent.withOpacity(
                                                      1.0)),))
                                    ),
                                    //),
                                    new Align(
                                      alignment: Alignment.center,
                                      child:
                                      new ProgressCard(width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.5),),
                                  ],
                                ),
                                // ),

                              ),
                              /*new HoldDetector(
                    onTap: () {
                      if (controller.isAnimating)
                        controller.stop();
                      else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
                    },
                    onHold: () {

                      if (controller.isAnimating)
                        controller.stop();
                      else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
                      if (_controllerA.isCompleted) {
                        _controllerA.reverse();
                      } else {
                        _controllerA.forward(from: 0.0);
                      }



                      if (engineStatus) {
                        // engineImageUrl='assets/images/car_start_3_1.png';
                        BlocProvider
                            .of<GlobalBloc>(context)
                            .messageBloc
                            .addition
                            .add(new Message(
                            text: 'assets/images/car_start_3_1.png',
                            status: false));
                      }
                      else {
                        // engineImageUrl='assets/images/car_start_3.png';
                        BlocProvider
                            .of<GlobalBloc>(context)
                            .messageBloc
                            .addition
                            .add(new Message(
                            text: 'assets/images/car_start_3.png',
                            status: true));
                      }

                      engineStatus = !engineStatus;
                    },
                    holdTimeout: Duration(milliseconds: 4000),
                    enableHapticFeedback: true,
                    child: Transform.scale(
                      scale: squareScaleA,
                      child:
                      new Padding(padding: EdgeInsets.only(top: 4.0),
                        child:
                        AvatarGlow(
                          startDelay: Duration(milliseconds: 1000),
                          glowColor: Colors.pink,
                          endRadius: MediaQuery
                              .of(context)
                              .size
                              .width / 4.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Material(
                            elevation: 0.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              //Colors.grey[100] ,
                              child: Image.asset(startImgPath, scale: 1,),
                              radius: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 5.0,
                              //shape: BoxShape.circle
                            ),
                          ),
                          shape: BoxShape.circle,
                          animate: engineStatus,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),),*/

                              /* new GestureDetector(
                  onTap: () {

                    if (_controllerA.isCompleted) {

                      _controllerA.reverse();
                    } else {
                      _controllerA.forward(from: 0.0);
                    }


                    if(engineStatus) {
                     // engineImageUrl='assets/images/car_start_3_1.png';
                      */ /*BlocProvider
                          .of<GlobalBloc>(context)
                          .messageBloc
                          .addition
                          .add(new Message(
                          text: 'assets/images/car_start_3_1.png',
                          status: false));*/ /*
                    }
                    else {
                     // engineImageUrl='assets/images/car_start_3.png';
                      */ /*BlocProvider
                          .of<GlobalBloc>(context)
                          .messageBloc
                          .addition
                          .add(new Message(
                          text: 'assets/images/car_start_3.png', status: true));*/ /*
                    }

                    engineStatus=!engineStatus;
                    //noty.updateValue(new Message(text: 'assets/images/car_start_3.png',status: true));
                  },
                  child:
                     Transform.scale(
                       scale: squareScaleA,
                        child:
                  new Padding(padding: EdgeInsets.only(top: 4.0) ,
                    child:

                    AvatarGlow(
                      startDelay: Duration(milliseconds: 1000),
                      glowColor: Colors.pink,
                      endRadius: MediaQuery.of(context).size.width/4.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: Material(
                        elevation: 0.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor:Colors.white, //Colors.grey[100] ,
                          child: Image.asset(startImgPath,scale: 1,),
                          radius:MediaQuery.of(context).size.width/5.0,
                          //shape: BoxShape.circle
                        ),
                      ),
                      shape: BoxShape.circle,
                      animate: engineStatus,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
    ),
                ),*/
                              Expanded(
                                child:
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 4.0, left: 25.0, right: 0.0,),
                                  child:
                                  Container(
                                    height: 0.5,
                                    color: Colors.black26,),),
                              ),
                            ],
                          ),
                        ),

                        new Positioned(
                          right: -10.0,
                          bottom: 25.0,
                          child:
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child:
                                new Container(
                                  margin: EdgeInsets.only(
                                      right: 25.0, bottom: 5, top: 10.0),
                                  child:
                                  new GestureDetector(
                                    onTap: () {
                                      trunk_status = !trunk_status;
                                      updateTrunkStatus(trunk_status);
                                      /*listenerRepository.onTrunkTap(
                                context, trunk_status);*/
                                      widget.carStateVM.isTraunkOpen=trunk_status;
                                      widget.carStateVM.setCarStatusImages();
                                      centerRepository.updateCarStateVMMap(widget.carStateVM);
                                      widget.carStateNoty.updateValue(widget.carStateVM);
                                      if(trunk_status) {
                                        //play(Constants.TRUNK_OPEN_SOUND);
                                        sendCommand(ActionsCommand.DriveLock_ONOrOFF_Nano_CODE);
                                      }
                                      else {
                                        //play(Constants.TRUNK_CLOSE_SOUND);
                                        sendCommand(ActionsCommand.DriveLock_ONOrOFF_Nano_CODE);
                                      }

                                    },
                                    child:
                                    AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Colors.white,
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black12,
                                          //Colors.grey[100] ,
                                          child: trunk_status ? ImageNeonGlow(
                                            imageUrl: 'assets/images/trunk.png',
                                            counter: _counter,
                                            color:_currentColor,) :
                                          Image.asset(
                                            'assets/images/trunk.png', scale: 2.0,
                                            color: _currentColor,),
                                          radius: 24.0,
                                          //shape: BoxShape.circle
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: trunk_status,
                                      curve: Curves.fastOutSlowIn,
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Positioned(
                          left: -10.0,
                          bottom: 25.0,
                          child:
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child:
                                new Container(
                                  margin: EdgeInsets.only(
                                      left: 25.0, bottom: 5, top: 10.0),
                                  child:
                                  new GestureDetector(
                                    onTap: () {
                                      //listenerRepository.onTap(context, true);
                                    },
                                    child:
                                    AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Colors.indigoAccent,
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black12,
                                          //Colors.grey[100] ,
                                          child: // ImageNeonGlow(imageUrl: 'assets/images/find_car_2.png',counter: _counter,color: widget.color,),
                                          Image.asset(
                                            'assets/images/find_car_3.png', scale: 2.0,
                                            color: _currentColor,),
                                          radius: 24.0,
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: false,
                                      curve: Curves.fastOutSlowIn,
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Positioned(
                          right: 35.0,
                          bottom: -25.0,
                          child:
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomRight,
                                child:
                                new Container(
                                  margin: EdgeInsets.only(
                                      left: 25.0, bottom: 5, top: 10.0),
                                  child:
                                  new GestureDetector(
                                    onTap: () {
                                      // listenerRepository.onLockTap(context, true);
                                    },
                                    child:
                                    AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Colors.redAccent.withOpacity(0.5),
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.redAccent.withOpacity(
                                              0.1),
                                          //Colors.grey[100] ,
                                          child: // ImageNeonGlow(imageUrl:'assets/images/aux2.png' ,counter: _counter,) ,
                                          Image.asset(
                                            'assets/images/aux2.png', scale: 2.0,
                                            color: _currentColor,),
                                          radius: 24.0,
                                          //shape: BoxShape.circle
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: false,
                                      curve: Curves.fastOutSlowIn,
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Positioned(
                          left: 35.0,
                          bottom: -25.0,
                          child:
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomRight,
                                child:
                                new Container(
                                  margin: EdgeInsets.only(
                                      right: 25.0, bottom: 5, top: 10.0),
                                  child:
                                  new GestureDetector(
                                    onTap: () {
                                      caput_status = !caput_status;
                                      updateCaputStatus(caput_status);
                                      /*listenerRepository.onCaputTap(
                                context, caput_status);*/
                                      widget.carStateVM.isCaputOpen=caput_status;
                                      widget.carStateVM.setCarStatusImages();
                                      centerRepository.updateCarStateVMMap(widget.carStateVM);
                                      widget.carStateNoty.updateValue(widget.carStateVM);
                                    },
                                    child:
                                    AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Colors.white,
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: Material(
                                        elevation: 0.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.redAccent.withOpacity(
                                              0.1),
                                          //Colors.grey[100] ,
                                          child: Image.asset(
                                            'assets/images/aux1.png', scale: 2.0,
                                            color: _currentColor,),
                                          radius: 24.0,
                                          //shape: BoxShape.circle
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: caput_status,
                                      curve: Curves.fastOutSlowIn,
                                    ),

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
          }
      );
  }


  delayAfterTouchStartEngine()
  {
    Future.delayed(Duration(seconds: 4)).then((value) {

    });
  }
  animateEngineStatus()
  {
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
      if(status==AnimationStatus.completed)
      {
        temp_engineStatus=!temp_engineStatus;
        if(temp_engineStatus) {
          engineImageUrl = 'assets/images/engine_start.png';
        }
        else
        {
          engineImageUrl='assets/images/engine_start.png';
        }
        _controllerA.reverse();
      }
      if(status==AnimationStatus.forward)
      {
        // engineImageUrl = 'assets/images/car_start_3_1.png';
      }
    });
    _controllerA.addListener(() {
      setState(() {
        squareScaleA = _controllerA.value;
      });
    });

    /*_controllerB = AnimationController(
        vsync: this,
        lowerBound: 0.5,
        upperBound: 1.0,
        duration: Duration(seconds: 1));
    _controllerB.addListener(() {
      setState(() {
        squareScaleB = _controllerB.value;
      });
    });*/

  }
  play(String sound,String actionCode)  {
    player.play(Constants.soundToActionMap[actionCode]);
  }

  stop(String sound)
  {
    player.clear(sound);
  }
  @override
  void initState() {

    restDS=new RestDatasource();
    Constants.createSoundToActionMap();
    ActionsCommand.createActionsMap();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );



    advancedPlayer=new AudioPlayer();
    player=new AudioCache();
    player.load(Constants.DOOR_OPEN_SOUND);
    player.load(Constants.TRUNK_CLOSE_SOUND);
    player.load(Constants.POWER_ENGINE_START_SOUND);
    player.load(Constants.POWER_ENGINE_OFF_SOUND);
    player.load(Constants.TRUNK_OPEN_SOUND);
    player.load(Constants.DOOR_LOCK_SOUND);



    controller.addListener(() {
      setState(() {
        RxBus.post(new ChangeEvent(message: 'UPDATE_PROGRESS',amount:percentage));
      });
    });

    controller.addStatusListener((AnimationStatus status) {
      if(status==AnimationStatus.completed &&
          status!=AnimationStatus.reverse)
      {
        /*if (temp_engineStatus) {
             engineImageUrl='assets/images/car_start_3_1.png';
            BlocProvider
                .of<GlobalBloc>(context)
                .messageBloc
                .addition
                .add(new Message(
                text: 'assets/images/car_start_3_1.png',
                status: false));
          }
          else {
             engineImageUrl='assets/images/car_start_3.png';
            BlocProvider
                .of<GlobalBloc>(context)
                .messageBloc
                .addition
                .add(new Message(
                text: 'assets/images/car_start_3.png',
                status: true));
          }


          setState(() {
            temp_engineStatus = !temp_engineStatus;
            _counter==0 ? _counter++ : _counter=0;
          });*/
      }
    });

    animateEngineStatus();
    _currentColor=widget.carStateVM.getColorFromIndexMap(widget.carStateVM.carIndex);

    fetchUserId();

    super.initState();
  }

  @override
  void dispose() {
    _controllerA.dispose();
    // _controllerB.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  /*OfflineBuilder(
        connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
    ) {
          hasInternet=connectivity != ConnectivityResult.none;
          if (connectivity == ConnectivityResult.none) {

          }
            return child;
        },
      child:*/
      buildControlRow(context,
          engineImageUrl, null,
          widget.engineStatus,
          widget.lockStatus);

  }
}
