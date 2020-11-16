/*
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_model.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';

import 'package:anad_magicar/ui/factory/builder/panel.dart';

import 'package:anad_magicar/ui/factory/car/car_commons.dart';

import 'package:anad_magicar/ui/factory/car/pack.dart';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


enum CarStateItems { DOOR,TRUNK,POWER,CAPUT }
class Car extends CarWidget {

   CarVM carVM;
   Car({
    this.carVM
   });


   CarVM getCarVM()
   {
     return this.carVM;
   }

  @override
  Body createCarBoy() {
    return new Body(context: carVM.context);
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
            stream: carVM.notySlideChanged.noty,
            initialData: null,
            builder: (BuildContext c, AsyncSnapshot<ChangeEvent> data) {
              if(data.hasData &&
              data.data!=null) {
                ChangeEvent event = data.data;
                double pos = event.amount;
                carVM.fabHeight = pos * (carVM.panelHeightOpen - carVM.panelHeightClosed) +
                    carVM.initFabHeight;
              }
              return
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SlidingUpPanel(
                        renderPanelSheet: false,
                        maxHeight: carVM.panelHeightOpen,
                        minHeight: carVM.panelHeightClosed,
                        parallaxEnabled: true,
                        parallaxOffset: 0.2,
                        body: createCarBoy().creatWidget(),

                        panel: createCarPanel().creatWidget(),
                        collapsed: _floatingCollapsed(),

                        panelSnapping: true,
                        onPanelSlide: (double pos) {
                          carVM.onSlideChange(pos);
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
      carId: carVM.carId,
      isDoorOpen: false,
      isTraunkOpen: false,
      isCaputOpen: false,
      carIndex: carVM.carIndex,
      color: centerRepository.getCurrentCarColor(
          Commons.colors[carVM.carIndex], carVM.carIndex),
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
    return new Body(context: carVM.context);
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
    return carVM.carId;
  }

  @override
  int getCarIndex() {
    return carVM.carIndex;
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


 class CarBuilder {

   BuildContext context;
   CarStateVM carStateVM;
   AnimationController rotationController;
   NotyBloc<Message> carPageChangedNoty;
   NotyBloc<CarStateVM> carStateNoty;
   NotyBloc<SendingCommandVM> sendCommandNoty;

   Color color;

   int index;
   bool lock_status=true;
   bool power_status=false;
   bool trunk_status=false;
   bool engine_status=false;

   CarVM carVM;

   CarBuilder({
     @required this.carVM,
   });

   CarBuilder setContext(BuildContext context)
   {
     this.carVM.context=context;
     return this;
   }

   CarBuilder setCarIndex(int carIndx)
   {
     this.carVM.carIndex=carIndx;
     return this;
   }

   CarBuilder setCarID(int carId)
   {
     this.carVM.carId=carId;
     return this;
   }
   CarBuilder setCarState(CarStateVM carStateVM)
   {
     this.carVM.carStateVM=carStateVM;
     return this;
   }
   CarBuilder setNoty<T>(NotyBloc<T> noty)
   {
     if(T is Message)
       this.carVM.carPageChangedNoty=noty as NotyBloc<Message>;
     if(T is CarStateVM)
       this.carVM.carStateNoty=noty as NotyBloc<CarStateVM>;
     if(T is SendingCommandVM)
       this.carVM.sendCommandNoty=noty as NotyBloc<SendingCommandVM>;
     if(T is ChangeEvent)
       this.carVM.notySlideChanged=noty as NotyBloc<ChangeEvent>;
     return this;
   }
   CarBuilder setAnimController(AnimationController animContoller)
   {
     this.carVM.rotationController=animContoller;
     return this;
   }
   CarBuilder setOnSlideChange(Function onChanged)
   {
     this.carVM.onSlideChange=onChanged;
     return this;
   }
   CarBuilder setItemState(CarStateItems item,
       bool state)
   {
     if(item==CarStateItems.DOOR)
     this.carVM.lock_status=state;
     if(item==CarStateItems.POWER)
       this.carVM.power_status=state;
     if(item==CarStateItems.TRUNK)
       this.carVM.trunk_status=state;

     return this;
   }

  Car build()
  {
    Car car=new Car(carVM: carVM);
    return car;
  }



 }
*/
