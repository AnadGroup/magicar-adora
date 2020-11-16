import 'dart:async';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:anad_magicar/bloc/register/register.dart';


class RegisterBloc extends Bloc<RegisterEvent,RegisterState>
{
  static final RegisterBloc _registerBlocSingleton = new RegisterBloc._internal();
  var currentObj;
  factory RegisterBloc() {
    return _registerBlocSingleton;
  }
  RegisterBloc._internal();

  RegisterState get initialState => new UnRegisterState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {


     if(event is LoadRegisterEvent){
       yield LoadRegisterState();
       try{
       if((event.isEdit!=null && !event.isEdit) || event.isEdit==null) {
         UserRepository userRepository = new UserRepository();
         SaveMagicarResponeQuery result = await userRepository.register(
             user: event.user);
         if (result != null &&
             result.isSuccessful) {
           if (result.carId != null &&
               result.carId > 0) {
             centerRepository.setCarIds(result.carId);

           }

           if (result.userId != null &&
               result.userId > 0) {
             centerRepository.setUserIds(result.userId);
             prefRepository.setLoginedUserId(result.userId);
             prefRepository.setLoginedUserName(event.user.UserName);
             prefRepository.setLoginedFirstName(event.user.FirstName);
             prefRepository.setLoginedLastName(event.user.LastName);
             prefRepository.setLoginedMobile(event.user.MobileNo);
             prefRepository.setLoginedPassword(event.user.Password);
             prefRepository.setUserRoleId(result.roleId);
           }
           // return new InRegisterSMSAuthState();
          yield RegisteredState();
         }else {
           yield ErrorRegisterState(result.message);
         }
       }
       else
       {
         if(event.isEdit!=null && event.isEdit)
         {
           ServiceResult result= await restDatasource.editUserProfile(event.user);
           if(result!=null)
           {
             if(result.IsSuccessful)
             {
               yield RegisteredState();
             }
             else
             {
               yield ErrorRegisterState(result.Message);
             }
           }
           else
           {
             yield ErrorRegisterState(result.Message);
           }
         }
       }
     } catch (_, stackTrace) {
     yield ErrorRegisterState(_?.toString());
   }
     }
     if(event is RegisteredEvent){
       yield RegisteredState();
     }
     if(event is InRegisterEvent){
       yield InRegisterState();
     }

      //yield  event.applyAsync(currentState: state, bloc: this);



  }


}
