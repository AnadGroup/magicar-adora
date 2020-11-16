import 'dart:async';

import 'package:anad_magicar/bloc/dropdown_bloc/ValueProvider.dart';

class NotyBloc<T> {
  T _value = null;

  // The controller to stream the final output to the required StreamBuilder
  final _newValueController = StreamController<T>.broadcast();
  Stream<T> get noty => _newValueController.stream.asBroadcastStream();

  WrapValueProvider<T> _wrapedValue=new WrapValueProvider<T>();

  void updateValue(T nVal) {
    _wrapedValue.newValue=nVal;
    _newValueController.sink.add(_wrapedValue.changedValue); // add whatever data we want into the Sink
  }
  // The controller to receive the input form the app elements
  final _query = StreamController<T>();
  Sink<T> get query => _query.sink;
  Stream<T> get result => _query.stream.asBroadcastStream();

  // The business logic
  CounterBloc() {
    result.listen((newVal) {     // Listen for incoming input
      _value = newVal;          // Process the required data
      _newValueController.add(_value);         // Stream the required output
    });
  }

  void dispose(){
    _query.close();
    _newValueController.close();
  }
}
