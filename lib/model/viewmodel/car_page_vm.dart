import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:flutter/material.dart';

class CarPageVM {
  int userId;
  bool isSelf;
  NotyBloc<ChangeEvent> carAddNoty;

  CarPageVM({
    @required this.userId,
    @required this.isSelf,
    @required this.carAddNoty,
  });

}