import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:flutter/material.dart';

class AddCarVM {
  NotyBloc<ChangeEvent> notyBloc;
  NotyBloc<Message> addNotyBloc;

  SaveCarModel editCarModel;
  bool fromMainApp;
  bool editMode;
  int userId;
  AddCarVM({
    @required this.notyBloc,
    @required this.fromMainApp,
    @required this.editMode,
    @required this.editCarModel,
    @required this.addNotyBloc
  });

}
