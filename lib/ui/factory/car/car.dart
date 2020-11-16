/*
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/ui/factory/car/base_car.dart';
import 'package:anad_magicar/ui/factory/car/body.dart';
import 'package:anad_magicar/ui/factory/car/car_body.dart';
import 'package:anad_magicar/ui/factory/car/car_commons.dart';
import 'package:anad_magicar/ui/factory/car/car_panel.dart';
import 'package:anad_magicar/ui/factory/car/car_widgets.dart';
import 'package:anad_magicar/ui/factory/car/pack.dart';
import 'package:anad_magicar/ui/factory/car/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

  class Car extends CarWidget with BaseCar<CarStateVM>{

   final double _initFabHeight = 30.0;
   double _fabHeight;
   double _panelHeightOpen = 180.0;
   double _panelHeightClosed = 35.0;
   Function(double pos) onSlideChange;
   NotyBloc<ChangeEvent> notySlideChanged;
   int carIndex;
   int carId;
   BuildContext contxt;

   Car({
     @required this.onSlideChange,
     @required this.notySlideChanged,
     @required this.contxt,
     @required this.carId,
     @required this.carIndex,

   });



  @override
  Body createCarBoy() {
    return new Body(context: contxt);
  }

  @override
  Panel createCarPanel() {
    return new Panel();
  }

  @override
  Widget createCar() {
    // TODO: implement createCar
    return null;
  }

  @override
  Widget createCarWidget() {

    return   Container(
      child:
      Material(
        child: StreamBuilder<ChangeEvent>(
            stream: notySlideChanged.noty,
            initialData: null,
            builder: (BuildContext c, AsyncSnapshot<ChangeEvent> data) {
              if(data.hasData &&
              data.data!=null) {
                ChangeEvent event = data.data;
                double pos = event.amount;
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              }
              return
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SlidingUpPanel(
                        renderPanelSheet: false,
                        maxHeight: _panelHeightOpen,
                        minHeight: _panelHeightClosed,
                        parallaxEnabled: true,
                        parallaxOffset: 0.2,
                        body: createCarBoy().creatWidget(),

                        panel: createCarPanel().creatWidget(),
                        collapsed: _floatingCollapsed(),

                        panelSnapping: true,
                        onPanelSlide: (double pos) {
                          onSlideChange(pos);
                        }
                    ),

                  ],
                );
            },
      ),
    ),
    );
  }

  @override
  List<Widget> createCarWidgets() {
    // TODO: implement createCarWidgets
    return null;
  }

  @override
  void init() {
    CarStateVM initCarStateVM = new CarStateVM(
      carId: carId,
      isDoorOpen: false,
      isTraunkOpen: false,
      isCaputOpen: false,
      carIndex: carIndex,
      color: centerRepository.getCurrentCarColor(
          Commons.colors[carIndex], carIndex),
      bothClosed: true,
    );
    carStateVM=initCarStateVM;
  }

  @override
  CarStateVM updateCarState(CarStateVM newState) {
    if(newState!=null)
      carStateVM.colorId=newState.colorId;
      carStateVM.isPowerOn=newState.isPowerOn;
      carStateVM.isTraunkOpen=newState.isPowerOn;
      carStateVM.isDoorOpen=newState.isPowerOn;
      carStateVM.isCaputOpen=newState.isPowerOn;
      carStateVM.carCaputImage=newState.carCaputImage;
      carStateVM.carTrunkImage=newState.carTrunkImage;
      carStateVM.carDoorImage=newState.carDoorImage;
      carStateVM.carStatus=newState.carStatus;

    return carStateVM;
  }

   Widget _floatingCollapsed(){
     return Container(
       // height: 260.0,
       decoration: BoxDecoration(
         color: Colors.white70,
         borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
       ),
       margin: const EdgeInsets.fromLTRB(50.0, 2.0, 50.0, 1.0),
       child:
       Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           Container(
             child:
             Image.asset('assets/images/car_remote_4.png',fit: BoxFit.cover,width: 28.0,height: 28.0,),
           ),
         ],
       ),
     );
   }

  @override
  Body createCarBody() {
    return new Body(context: contxt);
  }

  @override
  CarStateVM createCarState() {
    return carStateVM;
  }

  @override
  Body getCarBody() {
    return null;
  }

  @override
  int getCarID() {
    return carId;
  }

  @override
  int getCarIndex() {
    return carIndex;
  }

  @override
  Panel getCarPanel() {
    return new Panel();
  }

  @override
  CarStateVM getCarState() {
    return carStateVM;
  }

  @override
  PackWidgets packWidgets() {
    // TODO: implement packWidgets
    return null;
  }



 }
*/
