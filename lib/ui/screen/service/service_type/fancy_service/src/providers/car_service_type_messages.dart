import 'package:flutter/material.dart';

class CarServiceTypeMessages with ChangeNotifier {
  CarServiceTypeMessages({
    this.serviceTypeCodeHint: defaultServiceTypeCodeHint,
    this.alarmDurationDayHint: defaultAlarmDurationDayHint,
    this.automationInsertHint: defaultAutomationInsertHint,
    this.descriptionHint: defaultDescriptionHint,
    this.alarmCountHint: defaultAlarmCountHint,
    this.distanceHint: defaultDistanceHint,
    this.durationCountValueHint: defaultDurationCountValueHint,
    this.confirmButton: defaultConfirmButton,
    this.cancelButton: defaultCancelButton,
    this.durationValueHint:defaultDurationValueHint,
    this.serviceTypeTitleHint:defaultServiceTypeTitleHint,
    this.goBackButton: defaultGoBackHint,

  });

  static const defaultServiceTypeCodeHint = 'ServiceTypeCode';
  static const defaultServiceTypeTitleHint = 'ServiceTypeTitle';
  static const defaultDurationValueHint = 'DurationValue';
  static const defaultDurationCountValueHint = 'DurationCountValue';
  static const defaultAlarmDurationDayHint = 'AlarmDurationDay';
  static const defaultDistanceHint = 'Distance';
  static const defaultDescriptionHint = 'Description';
  static const defaultGoBackHint = 'Go Back';
  static const defaultAlarmCountHint='Alarm Count';
  static const defaultAutomationInsertHint='AutomationInsert';

  static const defaultConfirmButton = 'Confirm';
  static const defaultCancelButton = 'Cancel';


  String serviceTypeCodeHint;
  String serviceTypeTitleHint;
  String durationValueHint;
  String durationCountValueHint;
  String alarmDurationDayHint;
  String alarmCountHint;
  String automationInsertHint;

/// Hint text of the password [TextField]
  final String descriptionHint;

  /// Hint text of the confirm password [TextField]
  final String distanceHint;



  /// Login button's label
  final String confirmButton;

  /// Signup button's label
  final String cancelButton;







  /// Go back button's label. Go back button is used to go back to to
  /// login/signup form from the recover password form
  final String goBackButton;


}
