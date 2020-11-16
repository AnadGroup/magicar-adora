import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier {
  Counter(this._value);
  int _value = 0;

  int get value => _value;

  set value(int value) {
    _value = value;
    notifyListeners();
  }

  increment() {
    value++;
  }

  decrement() {
    value--;
  }
}
