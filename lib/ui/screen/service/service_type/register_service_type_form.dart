import 'package:anad_magicar/bloc/service_type/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/model/viewmodel/reg_service_type_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/main_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_page.dart';



import 'package:anad_magicar/ui/screen/service/service_type/fancy_register_service_type_form.dart';
import 'package:anad_magicar/ui/screen/service/service_type/fancy_service/flutter_car_service.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterServiceTypeForm extends StatefulWidget {

  RegServiceTypeVM serviceTypeVM;
  RegisterServiceTypeForm({Key key,this.serviceTypeVM}) : super(key: key);

  @override
  RegisterServiceTypeFormState createState() {
    return RegisterServiceTypeFormState();
  }
}

class RegisterServiceTypeFormState extends State<RegisterServiceTypeForm> {

 // final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  RegisterServiceTypeBloc registerServiceTypeBloc;
  User user;
  int userId;

  NotyBloc<NotyLoadingVM> loadingNoty;

  Future<String> _authAddCarServiceType(CarServiceTypeData data)
  {
    return Future.delayed(new Duration(microseconds: 200)).then((_) {
      if(data!=null &&
          !data.cancel) {
        int stId=  (widget.serviceTypeVM.editMode==null || widget.serviceTypeVM.editMode==false) ? 0 :
          widget.serviceTypeVM.serviceType.ServiceTypeId;
        int rowState = (widget.serviceTypeVM.editMode==null || widget.serviceTypeVM.editMode==false) ? Constants.ROWSTATE_TYPE_INSERT :
            Constants.ROWSTATE_TYPE_UPDATE;
        ServiceType service=new ServiceType(
            ServiceTypeId: stId,
           AlarmCount:int.tryParse( data.alarmCount),
            AlarmDurationDay: data.alarmDurationDay,
            AutomaticInsert: data.automationInsert,
            DurationCountValue: data.durationCountValue,
            DurationTypeConstId: data.durationType,
            DurationValue: data.durationValue,
            ServiceTypeCode: data.serviceTypeCode,
            ServiceTypeConstId: data.serviceTypeConstId,
            ServiceTypeTitle: data.serviceTypeTitle,
            UserId: userId,
            Description: data.description,
            RowStateType: rowState);

          loadingNoty.updateValue(new NotyLoadingVM(isLoading: true,
              hasLoaded: false,
              haseError: false,
              hasInternet: true));

        if(service!=null) {
          centerRepository.showProgressDialog(context, Translations.current.loadingdata());
          restDatasource.saveServiceType(service).then((result) {
            if (result != null) {
              centerRepository.dismissDialog(context);
              centerRepository.showFancyToast(result.Message,true);
              if (result.IsSuccessful) {

                loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                    hasLoaded: false,
                    haseError: false,
                    hasInternet: true));

                Navigator.pushReplacementNamed(context, widget.serviceTypeVM.route,
                    arguments: widget.serviceTypeVM.carId);
              }
              else{
                loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                    hasLoaded: false,
                    haseError: true,
                    hasInternet: true));
              }
            }
          });

          /* registerServiceTypeBloc.add(
              new LoadRegisterServiceTypeEvent(user, service, context));*/
        }
      }
      else if(data.cancel) {
          Navigator.pop(context);
      }
      else {
        return 'لطفا اطلاعات را بطور کامل وارد نمایید!';
      }
      return null;
    });
  }

  loadUserId() async {
    userId=await prefRepository.getLoginedUserId();
  }

  @override
  void initState() {
    super.initState();
    registerServiceTypeBloc=new RegisterServiceTypeBloc();
    loadingNoty=new NotyBloc<NotyLoadingVM>();
  }

  @override
  void dispose() {
    registerServiceTypeBloc.close();
    loadingNoty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return /*BlocListener(
        bloc: registerServiceTypeBloc,
        listener: (BuildContext context, RegisterServiceTypeState state) {
      if(state is RegisteredServiceTypeState){
        centerRepository.dismissDialog(context);
        loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
            hasLoaded: false,
            haseError: false,
            hasInternet: true));

        Navigator.pushReplacementNamed(context, ServicePageState.route,arguments: new ServiceVM(carId: widget.carId,refresh: false));
        //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {return SecondScreen();}));
      }
    },
    child:*/
      Stack(
      overflow: Overflow.visible,
      children: <Widget> [
        new Padding(padding: EdgeInsets.only(top: 65.0),
          child:

         /* BlocBuilder<RegisterServiceTypeBloc, RegisterServiceTypeState>(
              bloc: registerServiceTypeBloc,
              builder: (
                  BuildContext context,
                  RegisterServiceTypeState currentState,) {

                if(currentState is InRegisterServiceTypeState)
                {
                  centerRepository.showProgressDialog(context, '');
                }
                if(currentState is RegisteredServiceTypeState)
                {



                }
                if(currentState is ErrorRegisterServiceTypeState)
                {

                  centerRepository.dismissDialog(context);
                  loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                      hasLoaded: false,
                      haseError: true,
                      hasInternet: true));
                  centerRepository.showFancyToast(currentState.errorMessage);
                }
                return*/  new FancyRegisterServiceTypeForm(
            serviceTypeVM: widget.serviceTypeVM,
                  onSubmit: null,
                authUser: _authAddCarServiceType,
                recoverPassword: null,),),


      ],
    );
  }
}