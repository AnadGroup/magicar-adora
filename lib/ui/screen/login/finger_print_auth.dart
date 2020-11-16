import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TouchID extends StatefulWidget {
  @override
  _TouchIDState createState() => _TouchIDState();
}

class _TouchIDState extends State<TouchID> {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool _canCheckBiometric = false;
  bool _hasFingerPrintSupport = false;
  String _authorizeText = 'Not Authorized!';
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBiometrics = List<BiometricType>();

  Future<void> _getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await localAuth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
      await localAuth.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = availableBuimetricType;
    });
  }

  Future<void> authenticateMe() async {

    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticateWithBiometrics(
        localizedReason: Translations.current.authToAccess(),
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _authorizedOrNot = authenticated ? Translations.current.authorized()
          : Translations.current.notAuthorized();
    });
  }

  Future<void> _authorize() async {
    bool _isAuthorized = false;
    try {
      _isAuthorized = await localAuth.authenticateWithBiometrics(
        localizedReason: Translations.current.authToAccess(),
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: centerRepository.androidAuthMessages,
        iOSAuthStrings: centerRepository.iosAuthMessages

      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (_isAuthorized) {
        _authorizeText = Translations.current.authorizedSuccessfull();
        Navigator.pushReplacementNamed(context, '/loadingscreen');
      } else {
        _authorizeText = Translations.current.authorizedFaild();
      }
    });
  }


  @override
  void initState() {
    _getBiometricsSupport();
    _getAvailableSupport();
    super.initState();
    _authorize();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_hasFingerPrintSupport ? Translations.of(context).hasFinger() :
                Translations.of(context).noFinger()),
              ),
              FlatButton(
                child: Icon(Icons.fingerprint,size: 45.0,),
                color: Colors.pinkAccent,
                onPressed: () { _authorize(); },
              ),
              FlatButton(
                child: Button(title: Translations.current.loginWithPassword(),wid: 100.0,color: Colors.white.value,clr:Colors.pinkAccent,),
               // color: Colors.red,
                onPressed: () { Navigator.of(context).pushReplacementNamed('/login',arguments: LoginType.PASWWORD);
                },
              )
            ],
          ),
    );
  }
}
