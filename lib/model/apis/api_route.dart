import 'package:flutter/material.dart';

class ApiRoute {
  int carId;
  String startDate;
  String endDate;
  String dateTime;
  String time;
  int speed;
  String lat;
  String long;
  String enterTime;
  String gpsDateTime;
  String createdDateTime;
  List<int> carIds;
  String cioBinary;

  //int CarId
  int DeviceId;
  String Latitude;
  String Longitude;
  //Int Speed
  String Date;
  String Time;
  String CreatedDateTime;
  String GPSDateTimeGregorian;

  ApiRoute(
      {@required this.carId,
      @required this.startDate,
      @required this.endDate,
      @required this.dateTime,
      @required this.speed,
      @required this.lat,
      @required this.long,
      @required this.enterTime,
      @required this.carIds,
      @required this.cioBinary,
      @required this.DeviceId,
      @required this.Latitude,
      @required this.Longitude,
      @required this.Date,
      @required this.Time,
      @required this.CreatedDateTime,
      @required this.gpsDateTime,
      @required this.GPSDateTimeGregorian});

  factory ApiRoute.fromJson(Map<String, dynamic> json) {
    return ApiRoute(
      carId: json["CarId"],
      startDate: json["StartDate"],
      endDate: json["EndDate"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CarId": this.carId,
      "StartDate": this.startDate,
      "EndDate": this.endDate,
    };
  }

  Map<String, dynamic> toJsonLastPosition() {
    return {
      "CarIds": this.carIds.map<int>((c) => c).toList(),
    };
  }

  Map<String, dynamic> toMapResult() {
    return {
      'DateTime': this.dateTime,
      'Speed': this.speed,
      'Latitude': this.lat,
      'Longitude': this.long,
      'EnterTime': this.enterTime,
    };
  }

  Map<String, dynamic> toMapLastPositionResult() {
    return {
      'CarId': this.carId,
      'DeviceId': this.DeviceId,
      'Time': this.Time,
      'Date': this.Date,
      'Speed': this.speed,
      'Latitude': this.lat,
      'Longitude': this.long,
      'CreatedDateTime': this.enterTime,
      'GPSDateTime': this.gpsDateTime,
      'GPSDateTimeGregorian': this.GPSDateTimeGregorian
    };
  }

  factory ApiRoute.fromMapResult(Map<String, dynamic> map) {
    return new ApiRoute(
      dateTime: map['DateTime'],
      speed: map['Speed'],
      lat: map['Latitude'],
      long: map['Longitude'],
      enterTime: map['EnterTime'],
    );
  }
  factory ApiRoute.fromMapLastPositionResult(Map<String, dynamic> map) {
    return new ApiRoute(
        dateTime: map['Date'],
        speed: map['Speed'],
        Latitude: map['Latitude'],
        Longitude: map['Longitude'],
        Time: map['Time'],
        Date: map['Date'],
        DeviceId: map['DeviceId'],
        CreatedDateTime: map['CreatedDateTime'],
        carId: map['CarId'],
        gpsDateTime: map['GPSDateTime'],
        GPSDateTimeGregorian: map['GPSDateTimeGregorian']);
  }

  factory ApiRoute.fromJsonResult(Map<String, dynamic> json) {
    return ApiRoute(
      dateTime: json["DateTime"],
      speed: json["Speed"],
      lat: json["Latitude"],
      long: json["Longitude"],
      enterTime: json["EnterTime"],
    );
  }
  factory ApiRoute.fromJsonLastPositionResult(Map<String, dynamic> json) {
    return ApiRoute(
        Date: json["Date"],
        speed: json["Speed"],
        Latitude: json["Latitude"],
        Longitude: json["Longitude"],
        Time: json["Time"],
        carId: json["CarId"],
        DeviceId: json["DeviceId"],
        CreatedDateTime: json["CreatedDateTime"],
        gpsDateTime: json["GPSDateTime"],
        cioBinary: json["CIOBinary"],
        GPSDateTimeGregorian: json["GPSDateTimeGregorian"]);
  }

  Map<String, dynamic> toJsonForFetchOpenRouteService() {
    return {
      "Latitude": this.lat,
      "Longitude": this.long,
    };
  }

  Map<String, dynamic> toJsonResult() {
    return {
      "DateTime": this.dateTime,
      "Speed": this.speed,
      "Latitude": this.lat,
      "Longitude": this.long,
      "EnterTime": this.enterTime,
    };
  }

  Map<String, dynamic> toJsonLastPositionResult() {
    return {
      "CarId": this.carId,
      "Time": this.Time,
      "Date": this.Date,
      "DeviceId": this.DeviceId,
      "Speed": this.speed,
      "Latitude": this.Longitude,
      "Longitude": this.Longitude,
      "CreatedDateTime": this.CreatedDateTime,
      "GPSDateTimeGregorian": this.GPSDateTimeGregorian
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'CarId': this.carId,
      'StartDate': this.startDate,
      'EndDate': this.endDate,
    };
  }

  factory ApiRoute.fromMap(Map<String, dynamic> map) {
    return new ApiRoute(
      carId: map['CarId'],
      startDate: map['StartDate'],
      endDate: map['EndDate'],
    );
  }
}
