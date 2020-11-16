import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show visibleForTesting;

/// The response object of [Location.getLocation] and [Location.onLocationChanged]
///
/// speedAccuracy cannot be provided on iOS and thus is always 0.
class LocationDataLocator {
  /// Latitude in degrees
   double latitude;

  /// Longitude, in degrees
   double longitude;

  /// Estimated horizontal accuracy of this location, radial, in meters
   double accuracy;

  /// In meters above the WGS 84 reference ellipsoid
   double altitude;

  /// In meters/second
   double speed;

  /// In meters/second, always 0 on iOS
   double speedAccuracy;

  /// Heading is the horizontal direction of travel of this device, in degrees
   double heading;

  /// timestamp of the LocationData
   double time;

   LocationDataLocator._(this.latitude, this.longitude, this.accuracy, this.altitude,
      this.speed, this.speedAccuracy, this.heading, this.time);

  factory LocationDataLocator.fromMap(Map<String, double> dataMap) {
    return LocationDataLocator._(
      dataMap['latitude'],
      dataMap['longitude'],
      dataMap['accuracy'],
      dataMap['altitude'],
      dataMap['speed'],
      dataMap['speed_accuracy'],
      dataMap['heading'],
      dataMap['time'],
    );
  }

  @override
  String toString() {
    return "LocationData<lat: $latitude, long: $longitude>";
  }
}

/// Precision of the Location. A lower precision will provide a greater battery life.
///
/// https://developers.google.com/android/reference/com/google/android/gms/location/LocationRequest
/// https://developer.apple.com/documentation/corelocation/cllocationaccuracy?language=objc
enum LocationAccuracy {
  /// To request best accuracy possible with zero additional power consumption
  POWERSAVE,

  /// To request "city" level accuracy
  LOW,

  /// To request "block" level accuracy
  BALANCED,

  /// To request the most accurate locations available
  HIGH,

  /// To request location for navigation usage (affect only iOS)
  NAVIGATION
}

// Status of a permission request to use location services.
enum PermissionStatus {
  /// The permission to use location services has been granted.
  GRANTED,

  /// The permission to use location services has been denied by the user. May have been denied forever on iOS.
  DENIED,

  /// The permission to use location services has been denied forever by the user. No dialog will be displayed on permission request.
  DENIED_FOREVER
}


