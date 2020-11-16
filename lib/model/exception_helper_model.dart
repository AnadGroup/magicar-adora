import 'package:anad_magicar/model/exceptions/authentication_exception.dart';
import 'package:anad_magicar/model/exceptions/load_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class ExceptionHelperModel<T> implements Exception {

  String message;
  int errorCode;
  Exception exception;
  bool _isExceptionHandled;
  tryException(T model);
  catchException(T model);

  setExceptionHandler(){

  }


  /*_shouldHandleException(
      {@required bool hasException, @required Exception handleException}) {
    if (hasException) {
      if (handleException is AuthenticationException) {
        _isExceptionHandled = true;
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          InfoDialog.showMessage(
              context: context,
              infoDialogType: DialogType.error,
              text: 'Please, do your login again.',
              title: 'Session expired')
              .then((val) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            this._showLogin();
          });
        });
      } else if (handleException is LoadException) {
        _isExceptionHandled = true;
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          InfoDialog.showMessage(
              context: context,
              infoDialogType: DialogType.alert,
              text: handleException.toString(),
              title: 'Verify your fields')
              .then((val) {
            _bloc.dispatch(CleanExceptionEvent());
            _isExceptionHandled = false;
          });
        });
      } else {
        _isExceptionHandled = true;
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          InfoDialog.showMessage(
              context: context,
              infoDialogType: DialogType.error,
              text: handleException.toString(),
              title: 'Error on request')
              .then((val) {
            _bloc.dispatch(CleanExceptionEvent());
            _isExceptionHandled = false;
          });
        });
      }
    }
  }*/
}
