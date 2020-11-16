import 'package:anad_magicar/model/viewmodel/reg_service_type_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/service_type/fancy_service/flutter_car_service.dart';

import 'package:flutter/material.dart';



class FancyRegisterServiceTypeForm extends StatelessWidget {

  FancyRegisterServiceTypeForm({
    @required Function authUser,
    @required Function recoverPassword,
    @required Function onSubmit,
    @required RegServiceTypeVM serviceTypeVM,
  })
      : _authUser = authUser,
        _recoverPassword = recoverPassword,
        _onSubmit=onSubmit,
        regServiceTypeVM=serviceTypeVM;


  Duration get loginTime => Duration(milliseconds: 2250);

  Function _authUser;
  Function _recoverPassword;
  Function _onSubmit;
  RegServiceTypeVM regServiceTypeVM;
  @override
  Widget build(BuildContext context) {

    return FlutterCar(
      messages: new CarServiceTypeMessages(
          confirmButton: Translations.current.confirm(),
          cancelButton: Translations.current.cancel(),
         alarmDurationDayHint: Translations.current.alarmDurationDay(),
          automationInsertHint: Translations.current.automationInsert(),
          durationCountValueHint: Translations.current.durationCountValue(),
          durationValueHint: Translations.current.durationValue(),
          serviceTypeCodeHint: Translations.current.serviceTypeCode(),
          serviceTypeTitleHint: Translations.current.serviceTypeTitle(),
          distanceHint: Translations.current.distance(),
          goBackButton: Translations.current.goBack(),
        alarmCountHint: Translations.current.alarmCount(),

        descriptionHint: Translations.current.description(),


      ),
      serviceTypeVM: regServiceTypeVM,
      title: '',
      mobileValidator: null,
      onConfirm: _authUser,
      onCancel: _authUser,
      onSubmitAnimationCompleted: _onSubmit,
      onRecoverPassword: _recoverPassword,
    );
  }


}
