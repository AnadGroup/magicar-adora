import 'package:anad_magicar/service/locator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';
import 'package:flutter/material.dart';
class NetworkCheck {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  dynamic checkInternet(Function func) {
    check().then((internet) {
      if (internet != null && internet) {
        func(true);
      }
      else{
        func(false);
      }
    });
  }

  static Future<bool> getGPSStatus() async {
    //GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    Location location = new Location();
    CenterRepository.GPS_STATUS_CONFIRMED=false;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    //location.serviceEnabled().asStream().listen((data))
    _serviceEnabled = await location.serviceEnabled();
    CenterRepository.GPS_STATUS=_serviceEnabled;
    return _serviceEnabled;
    /*  Geolocator().checkGeolocationPermissionStatus().asStream().listen((data) {
      if(data!=null ) {
        if(data==GeolocationStatus.disabled ||
            data==GeolocationStatus.denied) {
          CenterRepository.GPS_STATUS=false;
        } else {
          CenterRepository.GPS_STATUS=true;
        }
      }
      CenterRepository.GPS_STATUS=false;
    });*/

  }

  static void showGPSStatusDialog(BuildContext context) async {
    bool enabled=await getGPSStatus();
    if(!enabled) {
      showSystemMessage(context,'هشدار','GPS دستگاه شما خاموش  است.لطفا بررسی نمایید',
          false,
          'تنظیمات دستگاه',
          'ادامه',
              () {

          });
    }
  }

  void checkPermission() {
    Geolocator _geolocator;
    _geolocator = Geolocator();
    _geolocator.checkGeolocationPermissionStatus().then((status) { print('status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) { print('always status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status) { print('whenInUse status: $status'); });
  }

  static Future<bool> checkGPSMethod2(BuildContext context) async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    CenterRepository.GPS_STATUS_CONFIRMED=false;
    bool _serviceEnabled;
    Location location=Location();
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    //location.serviceEnabled().asStream().listen((data))
   // _serviceEnabled = await location.serviceEnabled();
    _serviceEnabled=(geolocationStatus==GeolocationStatus.granted ||
        geolocationStatus==GeolocationStatus.restricted);
    if (!_serviceEnabled) {
      showSystemMessage(context, 'هشدار','GPS دستگاه شما خاموش  است.لطفا بررسی نمایید',
          false,
          'تنظیمات دستگاه',
          'ادامه',
              () async {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              return;
            }
          });
      // _serviceEnabled = await location.requestService();
      return false;
    } else {
      return _serviceEnabled;
    }
    /*_permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }*/
  }
  static void showSystemMessage(BuildContext context,
      String title,
      String message,
      bool oneButton,
      String okTitle,
      String noTitle,
      VoidCallback onTap) async {
    await animated_dialog_box.showScaleAlertBox(
        title:Center(child: Text(title)) ,
        context: context,
        firstButton:  Builder(
            builder: (context) {
              return MaterialButton(
                // FIRST BUTTON IS REQUIRED
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                color: Colors.amber,
                child: Text(okTitle),
                onPressed: () {
                  onTap();
                },
              );
            } ) ,
        secondButton: !oneButton ? Builder(
          builder:(contxt) {
            return
              MaterialButton(
                // OPTIONAL BUTTON
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                color: Colors.amber,
                child: Text(noTitle),
                onPressed: () {
                  CenterRepository.GPS_STATUS_CONFIRMED=true;
                  Navigator.of(contxt).pop();
                },
              );
          },
        ) : null,
        icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
        yourWidget: Container(
          child: Text(message),
        ));
  }
}
