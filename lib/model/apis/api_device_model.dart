import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';

class ApiDeviceModel {
  int modelId;
  String serialNumber;
  String password;
  String SimNumber;
  String SimCard;
  int ConstantId;
  String DisplayName;
  int DeviceId;
  String SerialNumber;
  int DeviceTypeConstI;
  int DeviceStatusConstI;
  String Description;
  bool IsActive;
  int CarId;
  ApiDeviceModel({
    @required this.CarId,
    @required this.modelId,
    @required this.serialNumber,
    @required this.password,
    @required this.SimNumber,
    @required this.SimCard,
    @required this.IsActive,
    @required this.ConstantId,
    @required this.DisplayName,
    @required this.DeviceId,
    @required this.SerialNumber,
    @required this.DeviceTypeConstI,
    @required this.DeviceStatusConstI,
    @required this.Description,
  });

  Map<String, dynamic> toMapForSave() {
    return {
      'ModelId': this.modelId,
      'SerialNumber': this.SerialNumber,
      'Password': this.password,
      'SimNumber': this.SimNumber,
    };
  }

  factory ApiDeviceModel.fromMapForSave(Map<String, dynamic> map) {
    return ApiDeviceModel(
      modelId: map['ModelId'],
      serialNumber: map['SerialNumber'],
      password: map['Password'],
      SimNumber: map['SimNumber'],
    );
  }

  factory ApiDeviceModel.fromJsonForSave(Map<String, dynamic> json) {
    return ApiDeviceModel(
      modelId: json["ModelId"],
      serialNumber: json["SerialNumber"],
      password: json["Password"],
      SimNumber: json["SimNumber"],
    );
  }

  Map<String, dynamic> toJsonForSave() {
    return {
      "ModelId": this.modelId,
      "SerialNumber": this.SerialNumber,
      "Password": this.password,
      "SimNumber": this.SimNumber,
    };
  }

  Map<String, dynamic> toJsonForCheckAvailable() {
    return {
      "CarId": this.CarId,
      "SerialNumber": this.SerialNumber,
      "SimNumber": this.SimNumber,
      "Password": this.password,
    };
  }

  Map<String, dynamic> toMapForGetModel() {
    return {
      'ConstantId': this.ConstantId,
      'DisplayName': this.DisplayName,
    };
  }

  factory ApiDeviceModel.fromMapForGetModel(Map<String, dynamic> map) {
    return ApiDeviceModel(
      ConstantId: map['ConstantId'],
      DisplayName: map['DisplayName'],
    );
  }

  factory ApiDeviceModel.fromJsonForGetModel(Map<String, dynamic> json) {
    return ApiDeviceModel(
      ConstantId: json["ConstantId"],
      DisplayName: json["DisplayName"],
    );
  }

  Map<String, dynamic> toJsonForGetModel() {
    return {
      "ConstantId": this.ConstantId,
      "DisplayName": this.DisplayName,
    };
  }

  Map<String, dynamic> toMapForGetAll() {
    return {
      'DeviceId': this.DeviceId,
      'SerialNumber': this.SerialNumber,
      'DeviceTypeConstId': this.DeviceTypeConstI,
      'DeviceStatusConstId': this.DeviceStatusConstI,
      'Description': this.Description,
    };
  }

  factory ApiDeviceModel.fromMapForGetAll(Map<String, dynamic> map) {
    return new ApiDeviceModel(
      DeviceId: map['DeviceId'],
      SerialNumber: map['SerialNumber'],
      DeviceTypeConstI: map['DeviceTypeConstId'],
      DeviceStatusConstI: map['DeviceStatusConstId'],
      Description: DartHelper.isNullOrEmptyString(map['Description']),
    );
  }

  factory ApiDeviceModel.fromJsonForGetAll(Map<String, dynamic> json) {
    return ApiDeviceModel(
      DeviceId: json["DeviceId"],
      SerialNumber: json["SerialNumber"],
      SimCard: json["SimCard"],
      password: json["Password"],
      IsActive: json["IsActive"],
      DeviceTypeConstI: json["DeviceTypeConstId"],
      DeviceStatusConstI: json["DeviceStatusConstId"],
      Description: DartHelper.isNullOrEmptyString(json["Description"]),
    );
  }

  Map<String, dynamic> toJsonForGetAll() {
    return {
      "DeviceId": this.DeviceId,
      "SerialNumber": this.SerialNumber,
      "DeviceTypeConstId": this.DeviceTypeConstI,
      "DeviceStatusConstId": this.DeviceStatusConstI,
      "Description": this.Description,
    };
  }

  Map<String, dynamic> toMapForGetById() {
    return {
      'DeviceId': this.DeviceId,
    };
  }

  factory ApiDeviceModel.fromMapForGetById(Map<String, dynamic> map) {
    return new ApiDeviceModel(
      DeviceId: map['DeviceId'],
    );
  }

  factory ApiDeviceModel.fromJsonForGetById(Map<String, dynamic> json) {
    return ApiDeviceModel(
      DeviceId: json["DeviceId"],
    );
  }

  Map<String, dynamic> toJsonForGetById() {
    return {
      "deviceId": this.DeviceId,
    };
  }

  Map<String, dynamic> toMapForResultGetById() {
    return {
      'DisplayName': this.DisplayName,
      'DeviceId': this.DeviceId,
      'SerialNumber': this.SerialNumber,
      'DeviceTypeConstId': this.DeviceTypeConstI,
      'DeviceStatusConstId': this.DeviceStatusConstI,
      'Description': this.Description,
    };
  }

  factory ApiDeviceModel.fromMapForResultGetById(Map<String, dynamic> map) {
    return new ApiDeviceModel(
      DisplayName: map['DisplayName'],
      DeviceId: map['DeviceId'],
      SerialNumber: map['SerialNumber'],
      DeviceTypeConstI: map['DeviceTypeConstId'],
      DeviceStatusConstI: map['DeviceStatusConstId'],
      Description: map['Description'],
    );
  }

  factory ApiDeviceModel.fromJsonForResultGetById(Map<String, dynamic> json) {
    return ApiDeviceModel(
      DisplayName: json["DisplayName"],
      DeviceId: json["DeviceId"],
      SerialNumber: json["SerialNumber"],
      DeviceTypeConstI: json["DeviceTypeConstId"],
      DeviceStatusConstI: json["DeviceStatusConstId"],
      Description: json["Description"],
    );
  }

  Map<String, dynamic> toJsonForResultGetById() {
    return {
      "DisplayName": this.DisplayName,
      "DeviceId": this.DeviceId,
      "SerialNumber": this.SerialNumber,
      "DeviceTypeConstI": this.DeviceTypeConstI,
      "DeviceStatusConstI": this.DeviceStatusConstI,
      "Description": this.Description,
    };
  }
}
