
import 'package:flutter/material.dart';

class StatusNotiVM {
 bool arm;
 bool trunk;
 bool hood;
 bool door;
 bool engine;
 bool ignitionStatus;
 bool manualTransmission;
 bool parkingLights;
 bool manual;
 bool timerStart;
 bool siren;
 bool shockSensor;
 bool turbo;
 bool passiveArming;
 bool valet;
 bool driveLocked;
 bool lowBattery;
 bool reservation;
 int minuteTurbo;
 double lowBatteryStartValue;
 int startEngineMinute;
 int coldStart;
 int temp;
 int batteryValue;

 StatusNotiVM({
   @required this.arm,
   @required this.trunk,
   @required this.hood,
   @required this.door,
   @required this.engine,
   @required this.ignitionStatus,
   @required this.manualTransmission,
   @required this.parkingLights,
   @required this.manual,
   @required this.timerStart,
   @required this.siren,
   @required this.shockSensor,
   @required this.turbo,
   @required this.passiveArming,
   @required this.valet,
   @required this.driveLocked,
   @required this.lowBattery,
   @required this.minuteTurbo,
   @required this.lowBatteryStartValue,
   @required this.startEngineMinute,
   @required this.coldStart,
   @required this.temp,
   @required this.batteryValue,
   @required this.reservation
 });

}
