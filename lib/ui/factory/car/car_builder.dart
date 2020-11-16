/*
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/car/base_car.dart';
import 'package:anad_magicar/ui/factory/car/car.dart';
import 'package:flutter/material.dart';

class CarPageBuilder extends StatefulWidget{

  NotyBloc<ChangeEvent> _notySlideChanged;
  NotyBloc<CarStateVM> _notyUpdateCarState;
  int carId;
  int carIndex;

  @override
  _CarPageBuilderState createState() {
    return new _CarPageBuilderState();
  }

  CarPageBuilder({
    @required NotyBloc<ChangeEvent> notySlideChanged,
    @required NotyBloc<CarStateVM> notyUpdateCarState,
    @required this.carId,
    @required this.carIndex,
  }) : _notySlideChanged = notySlideChanged,
      _notyUpdateCarState = notyUpdateCarState;
}

class _CarPageBuilderState extends State<CarPageBuilder> {

  Car car;
 // NotyBloc<ChangeEvent> _notySlideChanged;
  _onSlideChanged(double pos)
  {
    setState((){
     widget._notySlideChanged.updateValue(new ChangeEvent(amount: pos));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CarStateVM>(
        stream: widget._notyUpdateCarState.noty,
        initialData: null,
        builder: (BuildContext c, AsyncSnapshot<CarStateVM> snapshot)
    {
      if(snapshot.hasData && snapshot.data!=null)
        {
          car.updateCarState(snapshot.data);
        }
      return car.createCarWidget();
    },
    );
  }

  @override
  void initState() {
    super.initState();

    car=new Car(
        onSlideChange: _onSlideChanged,
        contxt: context,
      carId: widget.carId,
      carIndex: widget.carIndex
    );
    car.init();
  }

}


*/
