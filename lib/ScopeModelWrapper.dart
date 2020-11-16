import 'package:anad_magicar/Routes.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import 'application.dart';

class ScopeModelWrapperState extends StatefulWidget {
  final UserRepository userRepository;
  // final GlobalKey<NavigatorState> navigatorKey;
  ScopeModelWrapperState({Key key, this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<ScopeModelWrapperState> {
  SpecificLocalizationDelegate _localeOverrideDelegate;
  AppModel appModel;
  //AuthenticationBloc _authenticationBloc;
  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    super.initState();
    _localeOverrideDelegate = SpecificLocalizationDelegate(null);

    applic.onLocaleChanged = onLocaleChange;

    appModel = AppModel(appLocale: Locale('fa'));
    appModel.saveLocal('fa', 'IR');
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
        model: appModel,
        child: MyApp(
          userRepository: _userRepository,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AppModel extends Model {
  Locale _appLocale = Locale('fa');
  Locale get appLocal => _appLocale ?? Locale("fa");

  void saveLocal(String lang_code, String country_code) {
    prefRepository.setLocale(lang_code, country_code);
  }

  void changeDirection() {
    if (_appLocale == Locale("fa")) {
      saveLocal('en', 'US');
      _appLocale = Locale("en");
    } else {
      saveLocal('fa', 'IR');
      _appLocale = Locale("fa");
    }
    notifyListeners();
  }

  AppModel({
    @required Locale appLocale,
  }) : _appLocale = appLocale;
}
