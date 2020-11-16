import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/fancy_service/flutter_car_service.dart';
import 'package:flutter/material.dart';



class FancyRegisterServiceForm extends StatelessWidget {

  FancyRegisterServiceForm({
    @required Function authUser,
    @required Function recoverPassword,
    @required Function onSubmit,
    @required this.editMode,
    @required this.service,
    @required this.serviceVM,
  })
      : _authUser = authUser,
        _recoverPassword = recoverPassword,
        _onSubmit=onSubmit;

  Duration get loginTime => Duration(milliseconds: 2250);

  Function _authUser;
  Function _recoverPassword;
  Function _onSubmit;
  bool editMode;
  ApiService service;
  ServiceVM serviceVM;

  @override
  Widget build(BuildContext context) {

    return FlutterCar(
      messages: new CarServiceMessages(
          confirmButton: Translations.current.confirm(),
          cancelButton: Translations.current.cancel(),
          actionDateHint: Translations.current.actionDate(),
          distanceHint: Translations.current.distance(),
          goBackButton: Translations.current.goBack(),
        alarmCountHint: Translations.current.alarmCount(),
        alarmDateHint: Translations.current.alarmDate(),
        descriptionHint: Translations.current.description(),
        serviceCostHint: Translations.current.serviceCost(),
        serviceDateHint: Translations.current.serviceDate()

      ),
      title: '',
      mobileValidator: null,
      onConfirm: _authUser,
      onCancel: _authUser,
      editMode: editMode,
      service: service,
      serviceVM: serviceVM,
      onSubmitAnimationCompleted: _onSubmit,
      onRecoverPassword: _recoverPassword,
    );
  }

}
