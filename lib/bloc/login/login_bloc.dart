import 'dart:async';

import 'package:anad_magicar/authentication/authentication.dart';
import 'package:anad_magicar/bloc/login/login.dart';
import 'package:anad_magicar/bloc/login/login_listener.dart';
import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/data/event_listener.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;


  LoginBloc({
     this.userRepository,
     this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {


    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {

          ServiceResult loginResult = await userRepository.login(
              username: event.username, password: event.password);
          if (loginResult != null &&
              loginResult.IsSuccessful) {
            //prefRepository.setLoggedIn(true);
            //prefRepository.setLoginStatus(false);
            prefRepository.setLoginedUserId(loginResult.returnValue.UserId);
            prefRepository.setLoginedUserName(loginResult.returnValue.UserName);
            CenterRepository.setUserId(loginResult.returnValue.UserId);
            centerRepository.setUserCached(new User(
              userName: loginResult.returnValue.UserName,
              id: loginResult.returnValue.UserId
            ));

            yield LoginDone();
          }
          else {
            yield LoginFailure(error: loginResult.Message);
          }

       // yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
    if(event is SignUpButtonPressed) {
        String securityCode='';
        yield SignUpLoading();
        try {
           securityCode = await userRepository.sendSMS(event.mobile);
        }
        catch(error){
      securityCode='123456';
    }
        if(securityCode!=null &&
        securityCode.isNotEmpty) {
            if(securityCode.contains('تکرار')){
              yield SignUpFaild(error: securityCode);
            }
            else
             yield SignUpDone(code: securityCode);
          }
        else
          yield SignUpFaild();
      }
    if(event is ReSignUpButtonPressed)
    {
      String securityCode='';
      try {
        securityCode = await userRepository.sendSMS(event.mobile);
      }
      catch(error)
      {
        securityCode='123456';
      }
      if(securityCode!=null &&
          securityCode.isNotEmpty)
      {
        if(securityCode.contains('تکرار')){
          yield SignUpFaild(error: securityCode);
        }
        else
        yield SignUpDone(code: securityCode);
      }
      else
        yield SignUpFaild();
    }
    if(event is LoginFailed)
      {
        yield LoginNoConnection(error: event.errorMessage);
      }
    if(event is SignUpFailed)
      {
        yield SigUpNoConnection(error: event.errorMessage);
      }

  }
}
