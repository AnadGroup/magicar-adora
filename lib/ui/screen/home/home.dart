import 'dart:ui';

import 'package:anad_magicar/bloc/basic/bloc_provider.dart' as bp;
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/bounce_animation.dart';
import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/components/shimmer/myshimmer.dart';
import 'package:anad_magicar/components/switch_button.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/listener/listener_repository.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:provider/provider.dart';

final List<String> carNumbers = [
  "assets/images/one.png",
  "assets/images/two.png",
  "assets/images/three.png",
  "assets/images/four.png",
  "assets/images/four.png",
  "assets/images/four.png",
];

List<Color> colors = [
  Colors.redAccent,
  Colors.blueAccent,
  Colors.pinkAccent,
  Colors.purpleAccent,
  Colors.black,
  Colors.black38,
  Colors.black54,
];

enum CarStatus {
  ONLYDOOROPEN,
  ONLYTRUNKOPEN,
  BOTHOPEN,
  BOTHCLOSED,
  ONLYCAPUTOPNE,
  ALLOPEN
}

var _currentColor = Colors.redAccent;
var carStatus = CarStatus.BOTHCLOSED;
bool lock_status;
bool door_status;
bool shock_status;
bool power_status;
bool trunk_status;
bool isPark;
bool isGPSOn;
bool isGPRSOn;
bool isHighSpeed;
bool getStatusExecuted = false;
double opacityValue = 0.5;
bool kIsWeb = false;
Widget buildControlRow(
  BuildContext context,
  String startImgPath,
  NotyBloc<Message> noty,
  bool engineStatus,
  bool lockStatus,
) {
  kIsWeb = UniversalPlatform.isWeb;
  return Stack(
    alignment: new Alignment(0, 0),
    overflow: Overflow.visible,
    children: <Widget>[
      new Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 1,
          height: 180.0,
          child: new Card(
            margin: new EdgeInsets.only(
                left: 22.0, right: 22.0, top: 5.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 100.5),
              borderRadius: new BorderRadius.all(Radius.elliptical(100, 50)),
            ),
            elevation: 0.0,
            child: Text(''),
          ),
        ),
      ),
      new Positioned(
        left: 1.0,
        top: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: new Container(
                margin: EdgeInsets.only(left: 15.0, top: 10.0),
                //width: 64.0,
                child: new GestureDetector(
                  onTap: () {
                    listenerRepository.onLockTap(context, false);
                  },
                  child: AvatarGlow(
                    startDelay: Duration(milliseconds: 1000),
                    glowColor: Colors.blue,
                    endRadius: 40.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                      elevation: 0.0,
                      shape: CircleBorder(),
                      // child: CircleAvatar(
                      //   backgroundColor: Colors.black12, //Colors.grey[100] ,
                         child: 
                        Image.asset(
                          'assets/images/unlock_2.png',
                          scale: 0.5,
                        ),
                        //radius: 24.0,
                        //shape: BoxShape.circle
                     // ),
                    ),
                    shape: BoxShape.circle,
                    animate: !lockStatus,
                    curve: Curves.fastOutSlowIn,
                  ),

                  // new Image.asset('assets/images/unlock2.png',scale: 2.8,fit: BoxFit.cover,)
                ),
              ),
            ),
          ],
        ),
      ),
      new Positioned(
        right: 1.0,
        top: -1.0,
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: new Container(
                margin: EdgeInsets.only(right: 15.0, top: 10),
                child: new GestureDetector(
                  onTap: () {
                    listenerRepository.onLockTap(context, true);
                  },
                  child: AvatarGlow(
                    startDelay: Duration(milliseconds: 1000),
                    glowColor: Colors.blue,
                    endRadius: 48.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                      elevation: 0.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.black12, //Colors.grey[100] ,
                        child: Image.asset(
                          'assets/images/lock_2.png',
                          scale: 0.5,
                        ),
                        radius: 24.0,
                        //shape: BoxShape.circle
                      ),
                    ),
                    shape: BoxShape.circle,
                    animate: lockStatus,
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
                  height: 0.5,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            new GestureDetector(
              onTap: () {
                if (engineStatus)
                  bp.BlocProvider.of<GlobalBloc>(context)
                      .messageBloc
                      .addition
                      .add(new Message(
                          text: 'assets/images/car_start_3_1.png',
                          status: false));
                else
                  bp.BlocProvider.of<GlobalBloc>(context)
                      .messageBloc
                      .addition
                      .add(new Message(
                          text: 'assets/images/car_start_3.png', status: true));

                //noty.updateValue(new Message(text: 'assets/images/car_start_3.png',status: true));
              },
              child: new Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: AvatarGlow(
                  startDelay: Duration(milliseconds: 1000),
                  glowColor: Colors.pink,
                  endRadius: MediaQuery.of(context).size.width / 4.5,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 0.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.white, //Colors.grey[100] ,
                      child: Image.asset(
                        startImgPath,
                        scale: 1,
                      ),
                      radius: MediaQuery.of(context).size.width / 5.0,
                      //shape: BoxShape.circle
                    ),
                  ),
                  shape: BoxShape.circle,
                  animate: engineStatus,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 4.0,
                  left: 25.0,
                  right: 0.0,
                ),
                child: Container(
                  height: 0.5,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
      new Positioned(
        right: 1.0,
        bottom: 1.0,
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: new Container(
                margin: EdgeInsets.only(right: 25.0, bottom: 15),
                child: new GestureDetector(
                  onTap: () {
                    listenerRepository.onLockTap(context, true);
                  },
                  child: AvatarGlow(
                    startDelay: Duration(milliseconds: 1000),
                    glowColor: Colors.blue,
                    endRadius: 30.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                      elevation: 0.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.black12, //Colors.grey[100] ,
                        child: Image.asset(
                          'assets/images/dashboard.png',
                          scale: 3.5,
                        ),
                        radius: 18.0,
                        //shape: BoxShape.circle
                      ),
                    ),
                    shape: BoxShape.circle,
                    animate: lockStatus,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      new Positioned(
        left: -1.0,
        bottom: -1.0,
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: new Container(
                margin: EdgeInsets.only(left: 25.0, bottom: 5),
                child: new GestureDetector(
                  onTap: () {
                    listenerRepository.onLockTap(context, true);
                  },
                  child: AvatarGlow(
                    startDelay: Duration(milliseconds: 1000),
                    glowColor: Colors.blue,
                    endRadius: 40.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                      elevation: 0.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.black12, //Colors.grey[100] ,
                        child: Image.asset(
                          'assets/images/find_car.png',
                          scale: 3.5,
                        ),
                        radius: 18.0,
                        //shape: BoxShape.circle
                      ),
                    ),
                    shape: BoxShape.circle,
                    animate: lockStatus,
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
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      width: 0.5,
      color: Colors.pinkAccent,
    ),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );
}

CarStateVM currentState;
CarStateVM currentState2;

Widget buildCarRow(
    BuildContext context,
    NotyBloc<Message> carPageChangedNoty,
    NotyBloc<CarStateVM> carStateNoty,
    int index,
    CarStateVM statusVM,
    AnimationController rotationController,
    int counter) {
  kIsWeb = UniversalPlatform.isWeb;
  double angle = CenterRepository.APP_TYPE_ADORA ? 1.57 : 1.57;
  return StreamBuilder<CarStateVM>(
    stream: carStateNoty.noty,
    initialData: statusVM,
    builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
      if (data != null && data.hasData) {
        currentState = data.data;
        rotationController.forward();
      } else {
        currentState = statusVM;
      }
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 3000),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: Container(
          margin: EdgeInsets.all(0.0),
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width * 0.70,
          height: MediaQuery.of(context).size.height * 0.45,
          key: ValueKey(counter),
          //color: Color(0xff757575),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              /*statusVM.carStatus==CarStatus.BOTHCLOSED  ? */
              Align(
                alignment: Alignment(0, 0),
                child: Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Image.asset(
                    currentState.carImage,
                    fit: BoxFit.cover,
                    scale: 1.0,
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 1.0),
                child: currentState.carCaputImage.isNotEmpty
                    ? new Image.asset(
                        currentState.carCaputImage,
                        fit: BoxFit.cover,
                        scale: 1.0,
                      )
                    : new Container(),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 1.0),
                child: currentState.carDoorImage.isNotEmpty
                    ? new Image.asset(
                        currentState.carDoorImage,
                        fit: BoxFit.cover,
                        scale: 1.0,
                      )
                    : new Container(),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 1.0),
                child: currentState.carTrunkImage.isNotEmpty
                    ? new Image.asset(
                        currentState.carTrunkImage,
                        fit: BoxFit.cover,
                        scale: 1.0,
                      )
                    : new Container(),
              ),
              Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                      /*image: DecorationImage(
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    //image: AssetImage(carNumbers[index]),
                    fit: BoxFit.cover),*/
                      ),
                  child: CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 50.0,
                    child: Text(
                      statusVM.deviceId.toString(),
                      style: TextStyle(
                          color: Colors.pinkAccent.withOpacity(0.95),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      );
    },
  );
}

buildStatusRow(
    BuildContext context,
    NotyBloc<Message> carPageChangedNoty,
    NotyBloc<CarStateVM> carStatusNoty,
    CarStateVM carStateVM,
    bool lockStatus,
    bool shockStatus,
    bool powerStatus,
    AnimationController animController) {
  kIsWeb = UniversalPlatform.isWeb;
  // double w = MediaQuery.of(context).size.width / 8.0;
  var _currentColorRow = carStateVM.getCurrentColor();
  double i_w = 46.0;
  double i_h = 46.0;
  double m_top = 10.0;
  double m_bot = 10.0;
  return StreamBuilder<Message>(
    stream: carPageChangedNoty.noty,
    initialData: null,
    builder: (BuildContext c, AsyncSnapshot<Message> data) {
      if (data != null && data.hasData) {
        Message msg = data.data;
        if (msg.type == 'CARPAGE') {
          // _currentColor = colors[msg.index];

        }
      }
      return StreamBuilder<CarStateVM>(
        stream: carStatusNoty.noty,
        initialData: carStateVM,
        builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
          if (data != null && data.hasData) {
            getStatusExecuted = true;
            CarStateVM carState = data.data;
            //currentState2=carState;
            door_status = carState.isDoorOpen;
            lock_status = carState.arm;
            trunk_status = carState.isTraunkOpen;
            power_status =
                carState.isPowerOn != null ? carState.isPowerOn : false;
          }
          return Container(
            margin: EdgeInsets.only(right: 1.0, top: 1.0),
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.15
                : MediaQuery.of(context).size.width * 0.15,
            height: kIsWeb
                ? MediaQuery.of(context).size.height * 0.60
                : MediaQuery.of(context).size.height * 0.60,
            child: kIsWeb
                ?  Padding(padding:EdgeInsets.all(5.0) ,child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (shock_status != null &&
                                      shock_status &&
                                      getStatusExecuted)
                                  ?
                                  // ? BounceAnimationBuilder(
                                  //     child:

                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/shock.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )

                                  //   animationController: animController,
                                  //   start: shock_status,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/shock.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(0.5),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                            //color: Colors.white,
                            margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                            alignment: Alignment.center,
                            height: i_h,
                            width: i_w,
                            child: (lock_status != null &&
                                    !lock_status &&
                                    getStatusExecuted)
                                ?
                                // ? BounceAnimationBuilder(
                                //     child:

                                ImageNeonGlow(
                                    imageUrl: 'assets/images/unlock_22.png',
                                    counter: 0,
                                    scale: 0.5,
                                    color: _currentColorRow,
                                  )

                                //   animationController: animController,
                                //   start: lock_status,
                                // )
                                : Image.asset(
                                    'assets/images/lock_11.png',
                              scale: 0.5,
                                    fit: BoxFit.cover,
                        
                                    color: _currentColorRow.withOpacity(0.5),
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child:
                                  //  CircleAvatar(
                                  //   backgroundColor: Colors.transparent,
                                  //   radius: 48.0,
                                  //   child:
                                  (trunk_status != null &&
                                          trunk_status &&
                                          getStatusExecuted)
                                      ?

                                      // ? BounceAnimationBuilder(
                                      //     child:

                                      ImageNeonGlow(
                                          imageUrl: 'assets/images/trunk.png',
                                          counter: 0,
                                          color: _currentColorRow,
                                        )

                                      //   animationController: animController,
                                      //   start: trunk_status,
                                      // )

                                      : Container()
                              // Image.asset(
                              //     'assets/images/trunk.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(0.5),
                              //   ),
                              ),
                        ),
                        // ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                            //color: Colors.white,
                            margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                            alignment: Alignment.topCenter,
                            height: i_h,
                            width: i_w,
                            child:
                                /* BounceAnimationBuilder(
                child:*/
                                Image.asset('assets/images/horn.png',
                                    scale: 0.5,
                                    fit: BoxFit.cover,
                                    color: _currentColorRow
                                        .withOpacity(opacityValue)),
                            /*animationController: animController,
   start: false,),*/
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.topCenter,
                              height: i_h,
                              width: i_w,
                              child: (power_status != null &&
                                      power_status &&
                                      getStatusExecuted)
                                  ?
                                  // ? BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/power.png',
                                      color: _currentColorRow,
                                      counter: 0,
                                    )
                                  //   animationController: animController,
                                  //   start: power_status,
                                  // )
                                  : Container()

                              //       Image.asset('assets/images/power.png',
                              //           scale: 1.5,
                              //           fit: BoxFit.cover,
                              //           color: _currentColorRow.withOpacity(0.5)),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                            //color: Colors.white,
                            margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                            alignment: Alignment.topCenter,
                            height: i_h,
                            width: i_w,
                            child: (door_status != null &&
                                    door_status &&
                                    getStatusExecuted)
                                ?
                                // ? BounceAnimationBuilder(
                                //     child:
                                ImageNeonGlow(
                                    imageUrl: 'assets/images/door.png',
                                    color: _currentColorRow,
                                    counter: 0,
                                  )

                                //   animationController: animController,
                                //   start: !door_status,
                                // )
                                : Image.asset('assets/images/door_closed.png',
                                    fit: BoxFit.cover,
                                    color: _currentColorRow.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ) )
                : Padding(padding: EdgeInsets.all(5.0) ,child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (shock_status != null &&
                                      shock_status &&
                                      getStatusExecuted)
                                  ?
                                  // ? BounceAnimationBuilder(
                                  //     child:

                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/shock.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )

                                  //   animationController: animController,
                                  //   start: shock_status,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/shock.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(0.5),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                            //color: Colors.white,
                            margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                            alignment: Alignment.center,
                            height: i_h,
                            width: i_w,
                            child: (lock_status != null &&
                                    !lock_status &&
                                    getStatusExecuted)
                                ?
                                // ? BounceAnimationBuilder(
                                //     child:

                                ImageNeonGlow(
                                    imageUrl: 'assets/images/unlock_22.png',
                                    counter: 0,
                                    scale:0.5,
                                    color: _currentColorRow,
                                  )

                                //   animationController: animController,
                                //   start: lock_status,
                                // )
                                : Image.asset(
                                    'assets/images/lock_11.png',
                                    fit: BoxFit.cover,
                                    scale: 0.5,
                                    color: _currentColorRow.withOpacity(0.5),
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child:
                                  //  CircleAvatar(
                                  //   backgroundColor: Colors.transparent,
                                  //   radius: 48.0,
                                  //   child:
                                  (trunk_status != null &&
                                          trunk_status &&
                                          getStatusExecuted)
                                      ?

                                      // ? BounceAnimationBuilder(
                                      //     child:

                                      ImageNeonGlow(
                                          imageUrl: 'assets/images/trunk.png',
                                          counter: 0,
                                          color: _currentColorRow,
                                        )

                                      //   animationController: animController,
                                      //   start: trunk_status,
                                      // )

                                      : Container()
                              // Image.asset(
                              //     'assets/images/trunk.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(0.5),
                              //   ),
                              ),
                        ),
                        // ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                            //color: Colors.white,
                            margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                            alignment: Alignment.topCenter,
                            height: i_h,
                            width: i_w,
                            child:
                                /* BounceAnimationBuilder(
                child:*/
                                Image.asset('assets/images/horn.png',
                                    scale: 1.5,
                                    fit: BoxFit.cover,
                                    color: _currentColorRow
                                        .withOpacity(opacityValue)),
                            /*animationController: animController,
   start: false,),*/
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.topCenter,
                              height: i_h,
                              width: i_w,
                              child: (power_status != null &&
                                      power_status &&
                                      getStatusExecuted)
                                  ?
                                  // ? BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/power.png',
                                      color: _currentColorRow,
                                      counter: 0,
                                    )
                                  //   animationController: animController,
                                  //   start: power_status,
                                  // )
                                  : Container()

                              //       Image.asset('assets/images/power.png',
                              //           scale: 1.5,
                              //           fit: BoxFit.cover,
                              //           color: _currentColorRow.withOpacity(0.5)),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                            //color: Colors.white,
                            margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                            alignment: Alignment.topCenter,
                            height: i_h,
                            width: i_w,
                            child: (door_status != null &&
                                    door_status &&
                                    getStatusExecuted)
                                ?
                                // ? BounceAnimationBuilder(
                                //     child:
                                ImageNeonGlow(
                                    imageUrl: 'assets/images/door.png',
                                    color: _currentColorRow,
                                    counter: 0,
                                  )

                                //   animationController: animController,
                                //   start: !door_status,
                                // )
                                : Image.asset('assets/images/door_closed.png',
                                    fit: BoxFit.cover,
                                    color: _currentColorRow.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ), 
                ),
          );
        },
      );
    },
  );
}

buildLockPanelRow(
    BuildContext context, int carIndex, NotyBloc<Message> carLockNoty) {
  kIsWeb = UniversalPlatform.isWeb;
  bool lockPanelStatus = false;
  return StreamBuilder<Message>(
      stream: carLockNoty.noty,
      initialData: new Message(
        type: 'LOCK_PANEL',
        status: false,
      ),
      builder: (BuildContext c, AsyncSnapshot<Message> data) {
        if (data != null && data.hasData) {
          getStatusExecuted = true;
          lockPanelStatus = data.data.status;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Align(
              alignment: Alignment.centerLeft,
              child: new Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: new Shimmer.fromColors(
                  baseColor: Colors.redAccent,
                  highlightColor: Colors.white,
                  direction: ShimmerDirection.rtl,
                  period: new Duration(seconds: 3),
                  child: new Container(
                    margin: EdgeInsets.only(right: 5.0),
                    width: 18.0,
                    height: 18.0,
                    child: GestureDetector(
                      onTap: () {
                        lockPanelStatus = !lockPanelStatus;
                        carLockNoty.updateValue(new Message(
                            type: 'LOCK_PANEL',
                            status: lockPanelStatus,
                            index: carIndex));
                      },
                      behavior: HitTestBehavior.translucent,
                      child: SwitchlikeCheckbox(checked: lockPanelStatus),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

buildBottomRow(
  BuildContext context,
  int carIndex,
  CarStateVM carStateVM,
  bool left,
  NotyBloc<Message> carPageChangedNoty,
  NotyBloc<CarStateVM> statusChangedNoty,
) {
  var _currentColorRow = carStateVM.getCurrentColor();
  kIsWeb = UniversalPlatform.isWeb;
  bool valet = false;
  bool pass_mode = false;
  bool turbo = false;
  double i_w = 48.0;
  double i_h = 48.0;
  double m_top = 1.0;
  double m_bot = 1.0;
  return StreamBuilder<CarStateVM>(
    stream: statusChangedNoty.noty,
    initialData: carStateVM,
    builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
      if (data != null && data.hasData) {
        CarStateVM carState = data.data;
        turbo = carState != null ? carState.turbo : false;
        pass_mode = carState != null ? carState.pass_mode : false;
        valet = carState != null ? carState.valet : false;
        if (valet == null) valet = false;
        if (pass_mode == null) pass_mode = false;
        if (turbo == null) turbo = false;
      }
      return
          /*Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 28.0,
        child:*/
          /*Stack(
          overflow: Overflow.visible,
          children: <Widget>[*/

          Container(
        margin: EdgeInsets.only(right: 5.0, top: 0.0, left: 5.0),
        width: MediaQuery.of(context).size.width * 0.50,
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: m_top, bottom: m_bot),
                //color: Colors.white,
                alignment: Alignment.center,
                height: 48,
                width: i_w,
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Center(
                  child: Container(
                    //color: Colors.white,
                    margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                    alignment: Alignment.topCenter,
                    height: i_h,
                    width: i_w,
                    child:  Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: pass_mode
                            ? ImageNeonGlow(
                                imageUrl: 'assets/images/pass_mode.png',
                                color: _currentColorRow,
                                counter: 0,
                              )
                            :  Image.asset(
                                'assets/images/pass_mode.png',
                                color:
                                    _currentColorRow.withOpacity(opacityValue),
                                scale: 1,
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
            ),
            new Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: m_top, bottom: m_bot),
                //color: Colors.white,
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Center(
                  child: Container(
                    //color: Colors.white,
                    margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                    alignment: Alignment.topCenter,
                    height: i_h,
                    width: i_w,
                    child: new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: valet
                            ? ImageNeonGlow(
                                imageUrl: 'assets/images/valet.png',
                                color: _currentColorRow,
                                counter: 0,
                              )
                            : new Image.asset(
                                'assets/images/valet.png',
                                color:
                                    _currentColorRow.withOpacity(opacityValue),
                                scale: 1,
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
            ),
            new Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(top: m_top, bottom: m_bot),
                //color: Colors.white,
                alignment: Alignment.center,
                height: i_h,
                width: i_w,
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Center(
                  child: Container(
                    //color: Colors.white,
                    margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                    alignment: Alignment.topCenter,
                    height: i_h,
                    width: i_w,
                    child: new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: turbo
                            ? ImageNeonGlow(
                                imageUrl: 'assets/images/turbo.png',
                                counter: 0,
                                color: _currentColorRow,
                              )
                            : new Image.asset(
                                'assets/images/turbo.png',
                                color:
                                    _currentColorRow.withOpacity(opacityValue),
                                scale: 1,
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
              ),
            ),
          ],
          // ),
          /*],*/
        ),
      );
    },
  );
}

buildArrowRow(
    BuildContext context,
    int carIndex,
    CarStateVM carStateVM,
    bool left,
    NotyBloc<Message> carPageChangedNoty,
    NotyBloc<Message> opacityNotifier) {
  var _currentColorRow = carStateVM.getCurrentColor();
  double opacityValue = 0.0;
  kIsWeb = UniversalPlatform.isWeb;
  return
      /*Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 28.0,
        child:*/
      /*Stack(
          overflow: Overflow.visible,
          children: <Widget>[*/
      MultiProvider(
    providers: [
      StreamProvider<Message>(
        create: (context) => opacityNotifier.noty,
        initialData: Message(index: 0),
      ),
    ],
    child: StreamBuilder<Message>(
      stream: opacityNotifier.noty,
      initialData: Message(value: 0.0),
      builder: (BuildContext c, AsyncSnapshot<Message> data) {
        if (data.hasData && data.data != null) {
          opacityValue = data.data.value;
        }
        return AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: opacityValue,
          duration: Duration(milliseconds: 500),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Container(
            margin: EdgeInsets.only(right: 15.0, top: 1.0, left: 15.0),
            width: MediaQuery.of(context).size.width / 1.0,
            height: 38.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.indigoAccent,
                      highlightColor: Colors.white,
                      direction: ShimmerDirection.rtl,
                      period: new Duration(seconds: 3),
                      child: new Container(
                          margin: EdgeInsets.only(right: 1.0),
                          height: 30.0,
                          child: Text(
                              DartHelper.isNullOrEmptyString(
                                  carStateVM.brandTitle),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
                new Align(
                  alignment: Alignment.centerLeft,
                  child: new Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    child: new Shimmer.fromColors(
                      baseColor: Colors.indigoAccent,
                      highlightColor: Colors.white,
                      direction: ShimmerDirection.rtl,
                      period: new Duration(seconds: 3),
                      child: new Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width / 3.0,
                        height: 30.0,
                        child: Text(
                          DartHelper.isNullOrEmptyString(carStateVM.modelTitle),
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        //),
                      ),
                    ),
                  ),
                ),
                new Align(
                  alignment: Alignment.centerRight,
                  child: new Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    child: new Shimmer.fromColors(
                      baseColor: Colors.indigoAccent,
                      highlightColor: Colors.white,
                      direction: ShimmerDirection.ltr,
                      period: new Duration(seconds: 3),
                      child: new Container(
                        margin: EdgeInsets.only(left: 0.0),
                        height: 30.0,
                        child: new Text(
                            DartHelper.isNullOrEmptyString(
                                carStateVM.colorTitle),
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
              // ),
              /*],*/
            ),
          ),
        );
      },
    ),
  );
}

int _currebtCarIndex = 0;
buildMapRow(
    BuildContext context,
    CarStateVM carStateVM,
    NotyBloc<Message> carPageChangedNoty,
    NotyBloc<CarStateVM> carStateNoty,
    AnimationController animController) {
  var _currentColorRow = carStateVM.getCurrentColor();
  kIsWeb = UniversalPlatform.isWeb;
  double i_w = 32.0;
  double i_h = 32.0;
  double m_top = 10.0;
  double m_bot = 10.0;
  int temp = carStateVM.tempreture;
  String temp_str = temp.toString();
  if (temp == 255) temp_str = '-';
  return StreamBuilder<Message>(
    stream: carPageChangedNoty.noty,
    initialData: null,
    builder: (BuildContext c, AsyncSnapshot<Message> data) {
      if (data.data != null && data.hasData) {
        Message msg = data.data;
        if (msg.type == 'CARPAGE') {
          _currebtCarIndex = msg.index;
          // _currentColor = colors[msg.index];

        }
      }
      return StreamBuilder<CarStateVM>(
        stream: carStateNoty.noty,
        initialData: null,
        builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
          if (data.data != null && data.hasData) {
            getStatusExecuted = true;
            CarStateVM stateVM = data.data;
            isPark = stateVM.isPark;
            isGPSOn = stateVM.isGPSOn;
            isGPRSOn = stateVM.isGPRSON;
            isHighSpeed = stateVM.highSpeed;
          }
          return Container(
            margin: EdgeInsets.only(right: 1.0, top: 3.0),
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.12
                : MediaQuery.of(context).size.width * 0.12,
            height: kIsWeb
                ? MediaQuery.of(context).size.height * 0.60
                : MediaQuery.of(context).size.height * 0.60,
            child: kIsWeb
                ?  Padding(padding: EdgeInsets.all(5.0),child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Container(
                              margin: EdgeInsets.only(top: m_top, bottom: 0),
                              //color: Colors.white,
                              alignment: Alignment.center,
                              height: i_h - 10,
                              width: i_w,
                              padding: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Center(
                                child: Container(
                                  //color: Colors.white,
                                  margin:
                                      EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  alignment: Alignment.center,
                                  height: i_h - 10,
                                  width: i_w,
                                  child: (isHighSpeed != null &&
                                          isHighSpeed &&
                                          getStatusExecuted)
                                      ?
                                      // BounceAnimationBuilder(
                                      //     child:
                                      ImageNeonGlow(
                                          imageUrl: 'assets/images/speed.png',
                                          counter: 0,
                                          color: _currentColorRow,
                                        )
                                      //   animationController: animController,
                                      //   start: isHighSpeed,
                                      // )
                                      : Image.asset(
                                          'assets/images/speed.png',
                                          fit: BoxFit.cover,
                                          color: _currentColorRow,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Container(
                              width: i_w + 13,
                              height: 15.0,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(' km/h ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9.0,
                                            color: _currentColorRow)),
                                    Text(
                                        DartHelper.isNullOrEmptyString(
                                            carStateVM.carSpeed.toString()),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9.0,
                                            color: _currentColorRow)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (isPark != null &&
                                      isPark &&
                                      getStatusExecuted)
                                  ?
                                  // BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/park.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )
                                  //   animationController: animController,
                                  //   start: isPark,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/park.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(opacityValue),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: m_top, bottom: m_bot),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (isGPSOn != null &&
                                      isGPSOn &&
                                      getStatusExecuted)
                                  ?
                                  // BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/gps.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )
                                  //   animationController: animController,
                                  //   start: isGPSOn,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/gps.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(opacityValue),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: m_top, bottom: m_bot),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (isGPRSOn != null &&
                                      isGPRSOn &&
                                      getStatusExecuted)
                                  ?
                                  // BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/gprs.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )
                                  //   animationController: animController,
                                  //   start: isGPSOn,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/gprs.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(opacityValue),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        // color: Color(0xff757575),
                        margin: EdgeInsets.only(top: 1, bottom: 0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: new Align(
                                alignment: Alignment.center,
                                child: Container(
                                  //color: Colors.white,
                                  alignment: Alignment.center,
                                  height: i_h,
                                  width: i_w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Center(
                                    child: Container(
                                        //color: Colors.white,
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0),
                                        alignment: Alignment.centerRight,
                                        height: i_h,
                                        width: i_w,
                                        child: Image.asset(
                                          'assets/images/battery_1.png',
                                          fit: BoxFit.cover,
                                          color: _currentColorRow,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 32.0),
                              child: Container(
                                height: 22.0,
                                child: Center(
                                  child: Text(
                                    DartHelper.isNullOrEmptyString(
                                      (carStateVM.battery_value / 10)
                                          .toString(),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: _currentColorRow),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        // color: Color(0xff757575),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: new Align(
                                alignment: Alignment.center,
                                child: Container(
                                  //color: Colors.white,
                                  alignment: Alignment.center,
                                  height: i_h,
                                  width: i_w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, right: 0),
                                        //color: Colors.white,
                                        alignment: Alignment.center,
                                        height: i_h,
                                        width: i_w,
                                        child: Image.asset(
                                          'assets/images/celsius.png',
                                          fit: BoxFit.cover,
                                          scale: 1.0,
                                          color: _currentColorRow,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 35.0),
                              child: Container(
                                height: 15.0,
                                child: Center(
                                  child: Text(
                                      DartHelper.isNullOrEmptyString(temp_str),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: _currentColorRow)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) )
                : Padding(padding: EdgeInsets.all(5.0),child:
                 Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                      
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Container(
                              margin: EdgeInsets.only(top: m_top, bottom: 0),
                              //color: Colors.white,
                              alignment: Alignment.center,
                              height: i_h - 10,
                              width: i_w,
                              padding: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Center(
                                child: Container(
                                  //color: Colors.white,
                                  margin:
                                      EdgeInsets.only(top: 0.0, bottom: 0.0),
                                  alignment: Alignment.center,
                                  height: i_h - 10,
                                  width: i_w,
                                  child: (isHighSpeed != null &&
                                          isHighSpeed &&
                                          getStatusExecuted)
                                      ?
                                      // BounceAnimationBuilder(
                                      //     child:
                                      ImageNeonGlow(
                                          imageUrl: 'assets/images/speed.png',
                                          counter: 0,
                                          color: _currentColorRow,
                                        )
                                      //   animationController: animController,
                                      //   start: isHighSpeed,
                                      // )
                                      : Image.asset(
                                          'assets/images/speed.png',
                                          fit: BoxFit.cover,
                                          color: _currentColorRow,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Container(
                              width: i_w + 13,
                              height: 15.0,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(' km/h ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9.0,
                                            color: _currentColorRow)),
                                    Text(
                                        DartHelper.isNullOrEmptyString(
                                            carStateVM.carSpeed.toString()),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9.0,
                                            color: _currentColorRow)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (isPark != null &&
                                      isPark &&
                                      getStatusExecuted)
                                  ?
                                  // BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/park.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )
                                  //   animationController: animController,
                                  //   start: isPark,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/park.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(opacityValue),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: m_top, bottom: m_bot),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (isGPSOn != null &&
                                      isGPSOn &&
                                      getStatusExecuted)
                                  ?
                                  // BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/gps.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )
                                  //   animationController: animController,
                                  //   start: isGPSOn,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/gps.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(opacityValue),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: m_top, bottom: m_bot),
                        //color: Colors.white,
                        alignment: Alignment.center,
                        height: i_h,
                        width: i_w,
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Center(
                          child: Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              alignment: Alignment.center,
                              height: i_h,
                              width: i_w,
                              child: (isGPRSOn != null &&
                                      isGPRSOn &&
                                      getStatusExecuted)
                                  ?
                                  // BounceAnimationBuilder(
                                  //     child:
                                  ImageNeonGlow(
                                      imageUrl: 'assets/images/gprs.png',
                                      counter: 0,
                                      color: _currentColorRow,
                                    )
                                  //   animationController: animController,
                                  //   start: isGPSOn,
                                  // )
                                  : Container()
                              // Image.asset(
                              //     'assets/images/gprs.png',
                              //     fit: BoxFit.cover,
                              //     color: _currentColorRow.withOpacity(opacityValue),
                              //   ),
                              ),
                        ),
                      ),
                      Container(
                        // color: Color(0xff757575),
                        margin: EdgeInsets.only(top: 1, bottom: 0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: new Align(
                                alignment: Alignment.center,
                                child: Container(
                                  //color: Colors.white,
                                  alignment: Alignment.center,
                                  height: i_h,
                                  width: i_w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Center(
                                    child: Container(
                                        //color: Colors.white,
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0),
                                        alignment: Alignment.centerRight,
                                        height: i_h,
                                        width: i_w,
                                        child: Image.asset(
                                          'assets/images/battery_1.png',
                                          fit: BoxFit.cover,
                                          color: _currentColorRow,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 32.0),
                              child: Container(
                                height: 22.0,
                                child: Center(
                                  child: Text(
                                    DartHelper.isNullOrEmptyString(
                                      (carStateVM.battery_value / 10)
                                          .toString(),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: _currentColorRow),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1, bottom: 1),
                        // color: Color(0xff757575),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: new Align(
                                alignment: Alignment.center,
                                child: Container(
                                  //color: Colors.white,
                                  alignment: Alignment.center,
                                  height: i_h,
                                  width: i_w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, right: 0),
                                        //color: Colors.white,
                                        alignment: Alignment.center,
                                        height: i_h,
                                        width: i_w,
                                        child: Image.asset(
                                          'assets/images/celsius.png',
                                          fit: BoxFit.cover,
                                          scale: 1.0,
                                          color: _currentColorRow,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 35.0),
                              child: Container(
                                height: 15.0,
                                child: Center(
                                  child: Text(
                                      DartHelper.isNullOrEmptyString(temp_str),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: _currentColorRow)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
             ),
            // ],
            //),
          );
        },
      );
    },
  );
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}
