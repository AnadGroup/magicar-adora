import 'dart:async';

import 'package:anad_magicar/bloc/dropdown_bloc/ValueProvider.dart';

class DropDownChangedBloc<T> {


  final changedController = StreamController<T>();


  Stream<T> get changedStream => changedController.stream;
  WrapValueProvider<T> _value=new WrapValueProvider<T>();

  void updateValue(T nVal) {
    _value.newValue=nVal;
    changedController.sink.add(_value.changedValue); // add whatever data we want into the Sink
  }

  void dispose() {
    changedController.close(); // close our StreamController to avoid memory leak
  }

   DropDownChangedBloc()
  {
    changedController.stream.listen(handleChangedValue);
  }

  void handleChangedValue(T data)
  {
    //changedController.add(data);
    //_value.newValue(data);
    updateValue(data);
    return;
  }
}
