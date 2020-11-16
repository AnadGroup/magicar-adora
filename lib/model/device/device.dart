import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DeviceInfo {
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

 DeviceInfo({
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

 Map<String, dynamic> toMap() {
   return {
     'DeviceId': this.deviceId,
     'SerialNumber': this.serialNumber,
     'SimCard': this.simCard,
     'Password': this.password,
     'DeviceStatusConstId': this.deviceStatusConstId,
     'DeviceTypeConstId': this.deviceTypeConstId,
     'IsActive': this.isActive,
     'Description': this.description,
     'BusinessUnitId': this.businessUnitId,
     'Owner': this.owner,
     'Version': this.version,
     'CreatedDate': this.createdDate,
   };
 }

 factory DeviceInfo.fromMap(Map<String, dynamic> map) {
   return new DeviceInfo(
     deviceId: map['DeviceId'] ,
     serialNumber: map['SerialNumber'] ,
     simCard: map['SimCard'],
     password: map['Password'] ,
     deviceStatusConstId: map['DeviceStatusConstId'] ,
     deviceTypeConstId: map['DeviceTypeConstId'] ,
     isActive: map['IsActive'],
     description: map['Description'],
     businessUnitId: map['BusinessUnitId'] ,
     owner: map['Owner'] ,
     version: map['Version'] ,
     createdDate: map['CreatedDate'] ,
   );
 }

 factory DeviceInfo.fromJson(Map<String, dynamic> json) {
   return DeviceInfo(deviceId: json["DeviceId"],
     serialNumber: json["SerialNumber"],
     simCard: json["SimCard"],
     password: json["Password"],
     deviceStatusConstId: json["DeviceStatusConstId"],
     deviceTypeConstId: json["DeviceTypeConstId"],
     isActive: json["IsActive"],
     description: json["Description"],
     businessUnitId: json["BusinessUnitId"],
     owner: json["Owner"],
     version: json["Version"],
     createdDate: json["CreatedDate"],);
 }

 Map<String, dynamic> toJson() {
   return {
     "DeviceId": this.deviceId,
     "SerialNumber": this.serialNumber,
     "SimCard": this.simCard,
     "Password": this.password,
     "DeviceStatusConstId": this.deviceStatusConstId,
     "DeviceTypeConstId": this.deviceTypeConstId,
     "IsActive": this.isActive,
     "Description": this.description,
     "BusinessUnitId": this.businessUnitId,
     "Owner": this.owner,
     "Version": this.version,
     "CreatedDate": this.createdDate,
   };
 }


}
