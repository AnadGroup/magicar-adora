import 'dart:async';

import 'package:anad_magicar/authentication/authentication_event.dart';
import 'package:anad_magicar/authentication/authentication_state.dart';
import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
   //ConstantRepository constantRepository;
   //ConstantTypeRepository constantTypeRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield AuthenticationLoading();
      databaseHelper.initAdapter();

      // final bool hasToken = await userRepository.hasToken();
      // SharedPreferences prefs = await prefRepository.getPrefs();
      final bool forceShowLogin = await prefRepository
          .getLoginStatusAtAppStarted(); //prefs.getBool('LOGINSTATUS');
      if (forceShowLogin == null ) {
        yield AuthenticationUnauthenticated(loginType: LoginType.PASWWORD);
      }
      else if (/*hasToken ||*/
      (forceShowLogin != null && forceShowLogin)) {
        // final bool forceShowLogin=await prefRepository.getLockStatus();
        // if(forceShowLogin) {
        int loginType = await prefRepository.getLoginStatusTypeAtAppStarted();
        if(loginType==null)
          loginType=LoginType.PASWWORD.index;
        //yield AuthenticationAuthenticated();
        yield AuthenticationUnauthenticated(loginType: LoginType.values[loginType]);
      }
      else if (forceShowLogin != null && !forceShowLogin) {
        yield AuthenticationAuthenticated();
        // yield AuthenticationUnauthenticated(loginType: LoginType.PASWWORD);

      }
    /*} else {
      yield AuthenticationUnauthenticated(loginType: LoginType.PASWWORD);
    }*/
  }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
