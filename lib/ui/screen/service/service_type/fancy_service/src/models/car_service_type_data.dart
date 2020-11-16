import 'package:flutter/foundation.dart';

class CarServiceTypeData {
  String serviceTypeCode;
  String serviceTypeTitle;
  int durationValue;
  int durationType;
  int serviceType;
  int durationCountValue;
  int durationTypeConstId;
  int serviceTypeConstId;
  int alarmDurationDay;
  String alarmCount;
  bool automationInsert;
  String description;
  bool cancel;
  CarServiceTypeData({
    @required this.serviceTypeCode,
    @required this.serviceTypeTitle,
    @required this.alarmDurationDay,
    @required this.alarmCount,
    @required this.automationInsert,
    @required this.durationCountValue,
    @required this.description,
    @required this.cancel,
    @required this.durationValue,
    @required this.durationType,
    @required this.serviceType,
    @required this.durationTypeConstId,
    @required this.serviceTypeConstId
  });

  @override
  String toString() {
    return '$runtimeType($serviceTypeTitle, $serviceTypeCode)';
  }
}
