import 'dart:core';

import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();

  bool isAuthenticated = false;

  List<BiometricType> _availableBiometrics = List<BiometricType>();
  bool _hasFingerPrintSupport = false;

  List<BiometricType> get availableBiometrics => _availableBiometrics;

  set availableBiometrics(List<BiometricType> value) {
    _availableBiometrics = value;
  }

  Future<void> getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _auth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    _hasFingerPrintSupport = hasFingerPrintSupport;
  }

  Future<void> getAvailableSupport() async {
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType = await _auth.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    _availableBiometrics = availableBuimetricType;
  }

  Future<bool> init() async {
    await getAvailableSupport();
    await getBiometricsSupport();
    if (hasFingerPrintSupport &&
        availableBiometrics != null &&
        availableBiometrics.length > 0) {
      return true;
    } else {
      RxBus.post(
          ChangeEvent(message: 'FINGERPRINT_AUTH', type: 'FINGERPRINT_AUTH'));
      return false;
    }
  }

  Future<void> authenticate() async {
    try {
      isAuthenticated = await _auth.authenticateWithBiometrics(
        localizedReason: Translations.current.authToAccess(),
        useErrorDialogs: true,
        stickyAuth: false,
        androidAuthStrings: centerRepository.androidAuthMessages,
        iOSAuthStrings: centerRepository.iosAuthMessages,
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }

  bool get hasFingerPrintSupport => _hasFingerPrintSupport;

  set hasFingerPrintSupport(bool value) {
    _hasFingerPrintSupport = value;
  }
}
