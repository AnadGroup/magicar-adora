import 'package:flutter/foundation.dart';

class CarServiceData {
  int serviceId;
  String serviceDate;
  String alarmDate;
  String actionDate;
  int alarmCount;
  double cost;
  int distance;
  String description;
  int serviceTypeId;
  bool cancel;
  CarServiceData({
    @required this.serviceId,
    @required this.serviceDate,
    @required this.alarmDate,
    @required this.actionDate,
    @required this.alarmCount,
    @required this.cost,
    @required this.distance,
    @required this.description,
    @required this.serviceTypeId,
    @required this.cancel
  });

  @override
  String toString() {
    return '$runtimeType($serviceDate, $actionDate)';
  }
}
