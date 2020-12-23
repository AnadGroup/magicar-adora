import 'package:anad_magicar/model/viewmodel/car_state.dart';

class Message {
  String text;
  String type;
  int index;
  int id;
  double value;
  CarStateVM currentCarState;
  bool status = false;
  List<int> Ids = List();
  Message(
      {this.text,
      this.type,
      this.status,
      this.index,
      this.currentCarState,
      this.id,
      this.value,
      this.Ids});
}
