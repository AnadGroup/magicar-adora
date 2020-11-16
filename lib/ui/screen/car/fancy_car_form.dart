import 'package:anad_magicar/model/viewmodel/add_car_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/car/fancy_car/flutter_car.dart';
import 'package:flutter/material.dart';




class FancyCarForm extends StatelessWidget {

  FancyCarForm({
    @required Function authUser,
    @required Function recoverPassword,
    @required Function onSubmit,
    @required bool editMode,
    @required AddCarVM addCarVM,
  })
      : _authUser = authUser,
        _recoverPassword = recoverPassword,
        _onSubmit=onSubmit,
          _editMode=editMode,
  _addCarVM=addCarVM;

  Duration get loginTime => Duration(milliseconds: 2250);

  Function _authUser;
  Function  _recoverPassword;
  Function _onSubmit;
  bool _editMode;
  AddCarVM _addCarVM;
  @override
  Widget build(BuildContext context) {

    return FlutterCar(
      messages: new LoginMessages(
        confirmButton: Translations.current.confirm(),
        cancelButton: Translations.current.cancel(),
        confirmPasswordHint: Translations.current.reTypePassword(),
        distanceHint: Translations.current.distance(),
        goBackButton: Translations.current.goBack(),
        passwordHint: Translations.current.password(),
        pelakHint: Translations.current.carpelak(),
        tipHint: Translations.current.carTip()
      ),
      editMode: _editMode,
      addCarVM: _addCarVM,
      title: '',
      mobileValidator: null,
      onConfirm: _authUser,
      onCancel: _authUser,
      onSubmitAnimationCompleted: _onSubmit,
      onRecoverPassword: _recoverPassword,
    );
  }


}
