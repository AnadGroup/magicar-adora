import 'package:flutter/foundation.dart';

class OpacityNotifier with ChangeNotifier {
  OpacityNotifier(this._value);
  double _value = 0;

  double get value => _value;

  set value(double value) {
    _value = value;
    notifyListeners();
  }

  increment() {
  /*  if(value<1.0)
      value=value+0.1;
    else*/
      value=1.0;
  }

  decrement() {
   /* if(value>0)
      value=value-0.1;
    else*/
      value=0.0;
  }
}
