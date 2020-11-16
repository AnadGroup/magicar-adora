import 'package:flutter/foundation.dart';

class DeviceData {
  int deviceId;
  String serialNumber;
  String simCard;
  String password;
  int deviceStatusConstId;
  int deviceTypeConstId;
  bool isActive;
  String description;
  int businessUnitId;
  int owner;
  String version;
  String createdDate;


  @override
  String toString() {
    return '$runtimeType($serialNumber, $description)';
  }

  DeviceData({
    @required this.deviceId,
    @required this.serialNumber,
    @required this.simCard,
    @required this.password,
    @required this.deviceStatusConstId,
    @required this.deviceTypeConstId,
    @required this.isActive,
    @required this.description,
    @required this.businessUnitId,
    @required this.owner,
    @required this.version,
    @required this.createdDate,
  });
}
