/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/widget_events/button_selection_message.dart';
import 'package:rxdart/rxdart.dart';

class ButtonBloc
{
  PublishSubject<BuildContext> _contextController = PublishSubject<BuildContext>();
  Sink<BuildContext> get inPointerContext => _contextController.sink;
  Observable<BuildContext> get outPointerContext =>
      _contextController.stream;



      PublishSubject<ButtonSelectionMessage> _buttonSelectionController =
      PublishSubject<ButtonSelectionMessage>();
  Sink<ButtonSelectionMessage> get inButtonSelection =>
      _buttonSelectionController.sink;
  Stream<ButtonSelectionMessage> get outButtonSelection =>
      _buttonSelectionController.stream;

  //
  // Dispose the resources
  //
  void dispose() {
    _buttonSelectionController.close();
    _contextController.close();
  }
}*/
