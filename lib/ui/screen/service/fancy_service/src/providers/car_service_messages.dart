import 'package:flutter/material.dart';

class CarServiceMessages with ChangeNotifier {
  CarServiceMessages({
    this.serviceDateHint: defaultServiceDateHint,
    this.actionDateHint: defaultActionDateHint,
    this.alarmDateHint: defaultAlarmDateHint,
    this.descriptionHint: defaultDescriptionHint,
    this.alarmCountHint: defaultAlarmCountHint,
    this.distanceHint: defaultDistanceHint,
    this.serviceCostHint: defaultServiceCostHint,
    this.confirmButton: defaultConfirmButton,
    this.cancelButton: defaultCancelButton,

    this.goBackButton: defaultGoBackHint,

  });

  static const defaultServiceDateHint = 'ServiceDate';
  static const defaultAlarmDateHint = 'AlarmDate';
  static const defaultActionDateHint = 'ActionDate';
  static const defaultAlarmCountHint = 'AlarmCount';
  static const defaultServiceCostHint = 'ServiceCost';
  static const defaultDistanceHint = 'Distance';
  static const defaultDescriptionHint = 'Description';
  static const defaultGoBackHint = 'Go Back';

  static const defaultConfirmButton = 'Confirm';
  static const defaultCancelButton = 'Cancel';


  /// Hint text of the user name [TextField]
  final String serviceDateHint;
  final String serviceCostHint;

  /// Hint text of the first name [TextField]
  final String actionDateHint;
  /// Hint text of the last name [TextField]
  final String alarmDateHint;
  /// Hint text of the mobile [TextField]
  final String alarmCountHint;

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
