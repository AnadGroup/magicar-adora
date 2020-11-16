import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/bounce_animation.dart';
import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/car/base_car.dart';
import 'package:anad_magicar/ui/factory/car/car_commons.dart';
import 'package:flutter/material.dart';

class CarBody  extends BaseCar<CarStateVM> {


  CarVM carVM;
  List<Widget> bodyWidgets=new List();
  BuildContext contxt;
  CarBody({
    this.contxt,
    this.carVM
  }) ;
 Widget createCarRow()
  {
    return _carWidget(
      carPageChangedNoty: carVM.carPageChangedNoty,
        carStateNoty: carVM.carStateNoty,
        carStateVM: carVM.carStateVM,
        index: carVM.index,
        rotationController: carVM.rotationController,
    );
  }

  Widget createCarStatusRow()
  {
    return _carStatusWidget(
      carPageChangedNoty: carVM.carPageChangedNoty,
      carStateVM: carVM.carStateVM,
      carStatusNoty:carVM.carStateNoty ,
      animController: carVM.rotationController,
      lockStatus: carVM.lock_status,
      powerStatus: carVM.power_status,
    );
  }

  Widget createCarMapRow()
  {
    return _mapWidget(
      carPageChangedNoty: carVM.carPageChangedNoty,
    );
  }

  @override
  Widget createCarWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 60.0),
      alignment: Alignment.center,
      //color: Color(0xff757575),
      height: MediaQuery
          .of(carVM.context)
          .size
          .height-1.0,
      child:

      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              bodyWidgets[2],
              bodyWidgets [0],
              bodyWidgets[1],
            ],
          ),
        ],
      ),
    );
  }

  @override
  void init() {

    bodyWidgets=new List();
    bodyWidgets..add(createCarRow())
    ..add(createCarStatusRow())
    ..add(createCarMapRow());
  }

  @override
  List<Widget> createCarWidgets() {
    return bodyWidgets;
  }

  @override
  Widget createCar() {
    // TODO: implement createCar
    return null;
  }

  @override
  CarStateVM updateCarState(CarStateVM newState) {
    // TODO: implement updateCarState
    return null;
  }



}


class _carWidget extends StatelessWidget {

  CarStateVM carStateVM;

  CarStateVM currentState;

  AnimationController rotationController;
  NotyBloc<Message> carPageChangedNoty;
  NotyBloc<CarStateVM> carStateNoty;
  int index;
  int counter;

  _carWidget({
    @required this.carStateVM,
    @required this.rotationController,
    @required this.carPageChangedNoty,
    @required this.carStateNoty,
    @required this.index,
    @required this.counter,
  });

  Widget buildCarRow(BuildContext context,) {
    return
      StreamBuilder<CarStateVM>(
        stream: carStateNoty.noty,
        initialData: carStateVM,
        builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
          if (data != null && data.hasData) {
            currentState = data.data;
            rotationController.forward();
          }
          else
          {
            currentState=carStateVM;
          }
          return
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 3000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(child: child, opacity:animation);
              },
              child:
              Container(
                margin: EdgeInsets.all(0.0),
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width/1.8,
                height: MediaQuery.of(context).size.height/1.3,
                key: ValueKey(counter),
                //color: Color(0xff757575),
                child:

                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 100.0),
                      child:
                      new Image.asset(  currentState.carImage/*imgList[index]*/,
                        fit: BoxFit.cover,
                        scale: 1.0,),
                    )  ,

                    new Padding(padding: EdgeInsets.only(top: 100.0),
                      child: currentState.carCaputImage.isNotEmpty ?
                      new Image.asset( currentState.carCaputImage,
                        fit: BoxFit.cover,
                        scale: 1.0,) :
                      new Container(),

                    ) ,
                    new Padding(padding: EdgeInsets.only(top: 100.0),
                      child: currentState.carDoorImage.isNotEmpty ?
                      new Image.asset( currentState.carDoorImage,
                        fit: BoxFit.cover,
                        scale: 1.0,) :
                      new Container(),

                    ) ,
                    new Padding(padding: EdgeInsets.only(top: 80.0),
                      child:
                      currentState.carTrunkImage.isNotEmpty ?
                      new Image.asset( currentState.carTrunkImage,
                        fit: BoxFit.cover,
                        scale: 1.0,) :
                      new Container(),
                    ) ,
                    Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                            image: AssetImage(Commons.carNumbers[index]),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return _carWidget();
  }



}

class _carStatusWidget extends StatelessWidget {


  var _currentColor=Colors.redAccent;
  NotyBloc<Message> carPageChangedNoty;
  NotyBloc<CarStateVM> carStatusNoty;
  CarStateVM carStateVM;
  bool lockStatus;
  bool powerStatus;
  AnimationController animController;

  bool lock_status=true;
  bool power_status=false;
  bool trunk_status=false;

  _carStatusWidget({
    @required this.carPageChangedNoty,
    @required this.carStatusNoty,
    @required this.carStateVM,
    @required this.lockStatus,
    @required this.powerStatus,
    @required this.animController,
  });
  buildStatusRow(BuildContext context,) {

    double w=MediaQuery.of(context).size.width/8.5;
    return
      StreamBuilder<Message>(
        stream: carPageChangedNoty.noty,
        initialData: null,
        builder: (BuildContext c, AsyncSnapshot<Message> data) {
          if (data != null && data.hasData) {
            Message msg = data.data;
            if (msg.type == 'CARPAGE') {
              _currentColor = Commons.colors[msg.index];

            }
          }
          return
            StreamBuilder<CarStateVM>(
              stream: carStatusNoty.noty,
              initialData: carStateVM,
              builder: (BuildContext c, AsyncSnapshot<CarStateVM> data) {
                if(data!=null && data.hasData)
                {
                  CarStateVM carState=data.data;
                  //currentState2=carState;
                  lock_status=!carState.isDoorOpen;
                  trunk_status=carState.isTraunkOpen;
                  power_status=carState.isPowerOn!=null ? carState.isPowerOn : false;

                }
                return
                  Container(
                    margin: EdgeInsets.only(right: 10.0,top: 60.0),
                    width:MediaQuery.of(context).size.width/8.2,
                    height: MediaQuery.of(context).size.height/2.0,
                    child:
                    Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //color: Colors.white,
                          margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                          alignment: Alignment.center,
                          height:48,
                          width: 48,
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child:
                          Center(
                            child:

                            Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                              alignment: Alignment.center,
                              height:48,
                              width: 48,
                              child:  !lock_status ?

                              Image.asset('assets/images/lock_11.png',
                                fit: BoxFit.cover, color:  _currentColor  ,) :
                              BounceAnimationBuilder(
                                child:  ImageNeonGlow(imageUrl: 'assets/images/lock_11.png',counter: 0,color: _currentColor,),
                                animationController: animController,
                                start: lock_status,),
                            ),
                          ),

                        ),
                        Container(
                          //color: Colors.white,
                          margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                          alignment: Alignment.center,
                          height:48,
                          width: 48,
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child:
                          Center(
                            child:
                            Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                              alignment: Alignment.center,
                              height:48,
                              width: 48,
                              child:
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 48.0,
                                child:  !trunk_status ?
                                Image.asset('assets/images/trunk.png',
                                  fit: BoxFit.cover, color:  _currentColor ,) :
                                BounceAnimationBuilder(
                                  child: ImageNeonGlow(imageUrl: 'assets/images/trunk.png',counter: 0,color: _currentColor,),
                                  animationController: animController,
                                  start: trunk_status,),
                              ),
                            ),
                          ),

                        ),
                        Container(
                          //color: Colors.white,
                          alignment: Alignment.center,
                          height:48,
                          width: 48,
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child:
                          Center(
                            child:
                            Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                              alignment: Alignment.topCenter,
                              height:48.0,
                              width: 48.0,
                              child:
                              /* BounceAnimationBuilder(
                child:*/
                              Image.asset('assets/images/alarm_off_3.png',
                                  scale: 1.5,fit: BoxFit.cover,
                                  color: _currentColor) ,
                              /*animationController: animController,
   start: false,),*/
                            ),
                          ),
                        ),
                        Container(
                          //color: Colors.white,
                          alignment: Alignment.center,
                          height:48,
                          width: 48,
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child:
                          Center(
                            child:
                            Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                              alignment: Alignment.topCenter,
                              height:48,
                              width: 48,
                              child: !power_status ?
                              Image.asset('assets/images/power.png',
                                  scale: 1.5,fit: BoxFit.cover,
                                  color: _currentColor):
                              BounceAnimationBuilder(
                                child: ImageNeonGlow(imageUrl: 'assets/images/power.png',color: _currentColor,counter: 0,),
                                animationController: animController,
                                start: power_status,),
                            ),
                          ),
                        ),
                        Container(
                          //color: Colors.white,
                          alignment: Alignment.center,
                          height:78,
                          width: 78,
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child:
                          Center(
                            child:
                            Container(
                              //color: Colors.white,
                              margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                              alignment: Alignment.topCenter,
                              height:78,
                              width: 78,
                              child:
                              lock_status ?
                              Image.asset('assets/images/unlock_22.png',
                                  scale: 0.5,fit: BoxFit.cover,
                                  color: _currentColor) :
                              BounceAnimationBuilder(
                                child: ImageNeonGlow(imageUrl: 'assets/images/unlock_22.png',color: _currentColor,counter: 0,),
                                animationController: animController,
                                start: !lock_status,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              },
            );
        },

      );
  }

  @override
  Widget build(BuildContext context) {
    return buildStatusRow(context);
  }



}

class _mapWidget extends StatelessWidget{

  NotyBloc<Message> carPageChangedNoty;
  var _currentColor=Colors.redAccent;
  int _currentCarIndex=0;

  _mapWidget({
    @required this.carPageChangedNoty,
  });

  buildMapRow(BuildContext context,
      ) {
    return
      StreamBuilder<Message>(
        stream: carPageChangedNoty.noty,
        initialData: null,
        builder: (BuildContext c, AsyncSnapshot<Message> data) {
          if (data != null && data.hasData) {
            Message msg = data.data;
            if (msg.type == 'CARPAGE') {
              _currentCarIndex=msg.index;
              _currentColor = Commons.colors[msg.index];

            }
          }
          return
            Container(
              margin: EdgeInsets.only(top: 30.0),
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 8.5,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2.5,
              child:
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    // color: Color(0xff757575),
                    child:
                    Stack(

                      children: <Widget>[
                        new Align(
                          alignment: Alignment.center,
                          child: Container(
                            //color: Colors.white,
                            alignment: Alignment.center,
                            height: 38,
                            width: 38,
                            padding: EdgeInsets.symmetric(horizontal: 1.0),
                            child:
                            Center(
                              child:
                              Container(
                                //color: Colors.white,
                                  alignment: Alignment.topCenter,
                                  height: 38,
                                  width: 38,
                                  child:
                                  Image.asset('assets/images/battery_1.png',
                                    scale: 1.0, fit: BoxFit.cover,
                                    color: _currentColor,)
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),
                  //),
                  Container(
                    //color: Color(0xff757575),
                    child:
                    Stack(
                      children: <Widget>[
                        new Align(
                          alignment: Alignment.center,
                          child:
                          new
                          Container(
                            //color: Colors.white,
                            alignment: Alignment.center,
                            height: 48,
                            width: 48,
                            padding: EdgeInsets.symmetric(horizontal: 1.0),
                            child:
                            Center(
                              child:
                              Container(
                                //color: Colors.white,
                                alignment: Alignment.topCenter,
                                height: 48,
                                width: 48,
                                child:
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/mappage',arguments: _currentCarIndex);
                                    /*RxBus.post(new ChangeEvent(message: 'MAP_PAGE'));*/ /*Navigator.of(context).pushNamed('/map');*/
                                  },
                                  child:
                                  new Image.asset(
                                    'assets/images/find_car3.png',
                                    scale: 0.5,
                                    color: _currentColor ,),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return buildMapRow(context);
  }


}

