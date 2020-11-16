import 'package:anad_magicar/bloc/service/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/fancy_register_service_form.dart';
import 'package:anad_magicar/ui/screen/service/fancy_service/src/models/car_service_data.dart';
import 'package:anad_magicar/ui/screen/service/main_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_form.dart';
import 'package:anad_magicar/ui/screen/service/service_page.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterServiceForm extends StatefulWidget {

  int carId;
  bool editMode;
  ApiService service;
  ServiceVM serviceVM;
  RegisterServiceForm({Key key,this.carId,this.editMode,this.service,this.serviceVM}) : super(key: key);

  @override
  RegisterServiceFormState createState() {
    return RegisterServiceFormState();
  }
}

class RegisterServiceFormState extends State<RegisterServiceForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  RegisterCarServiceBloc registerCarServiceBloc;
  User user;
  int userId;

  NotyBloc<NotyLoadingVM> loadingNoty;

  Future<String> _authAddCarService(CarServiceData data)
  {

    return Future.delayed(new Duration(microseconds: 200)).then((_) {
      if(data!=null &&
          !data.cancel) {
        int type=ApiService.ServiceStatusConstId_Tag;
        int rowState=Constants.ROWSTATE_TYPE_INSERT;
        if(widget.editMode!=null && widget.editMode){
          type=widget.service.ServiceStatusConstId;
          rowState=widget.service.RowStateType;
        }
        ApiService service=new ApiService(
            ServiceId: data.serviceId,
            CarId: widget.carId,
            ServiceTypeId: data.serviceTypeId,
            ServiceDate: DateTimeUtils.convertIntoDate( data.serviceDate),
            ActionDate: DateTimeUtils.convertIntoDate(data.actionDate),
            AlarmDate: DateTimeUtils.convertIntoDate(data.alarmDate),
            ServiceStatusConstId: type,
            ServiceCost: data.cost,
            AlarmCount: data.alarmCount,
            Description: data.description,
            CreatedDate: null,
            RowStateType: rowState
            );

        centerRepository.showProgressDialog(context, Translations.current.loadingdata());
          /*loadingNoty.updateValue(new NotyLoadingVM(isLoading: true,
              hasLoaded: false,
              haseError: false,
              hasInternet: true));*/

        //registerCarServiceBloc.add(new LoadRegisterServiceEvent(user, service, context));

        try {
           restDatasource.saveCarService(service).then((result){
             if (result != null) {
               centerRepository.showFancyToast(result.Message,true);
               if (result.IsSuccessful) {
                 centerRepository.dismissDialog(context);
                /* loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                     hasLoaded: false,
                     haseError: false,
                     hasInternet: true));*/
                 Navigator.pushReplacementNamed(context, MainPageServiceState.route,arguments: new ServiceVM(carId: widget.carId,refresh: false));
               }else{
                 centerRepository.dismissDialog(context);
                 /*loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                     hasLoaded: false,
                     haseError: true,
                     hasInternet: true));*/

               }
             }
           });

        } catch(ex){

        }


      }
      else if(data.cancel) {
        Navigator.pushReplacementNamed(context, MainPageServiceState.route,arguments: new ServiceVM(carId: widget.carId,refresh: false));

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
    loadUserId();
    registerCarServiceBloc=new RegisterCarServiceBloc();
    loadingNoty=new NotyBloc<NotyLoadingVM>();
  }

  @override
  void dispose() {
    registerCarServiceBloc.close();
    loadingNoty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return  /*BlocListener(
        bloc: registerCarServiceBloc,
        listener: (BuildContext context, RegisterServiceState state) {
          if(state is RegisteredServiceState){
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

          /*BlocBuilder<RegisterCarServiceBloc, RegisterServiceState>(
              bloc:  registerCarServiceBloc,
              builder: (
                  BuildContext context,
                  RegisterServiceState currentState,) {

                if(currentState is InRegisterServiceState)
                {
                  centerRepository.showProgressDialog(context, '');
                }
                if(currentState is RegisteredServiceState)
                {

                  //return ServiceForm(serviceVM: new ServiceVM(carId: widget.carId,refresh: true),);
                  //Navigator.pushReplacementNamed(context, ServicePageState.route,arguments: new ServiceVM(carId: widget.carId,refresh: false));
                  return Container();
                }
                if(currentState is ErrorRegisterServiceState)
                {

                  centerRepository.dismissDialog(context);
                  loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                      hasLoaded: false,
                      haseError: true,
                      hasInternet: true));
                  centerRepository.showFancyToast(currentState.errorMessage);
                }
                return*/  new FancyRegisterServiceForm(
            serviceVM: widget.serviceVM,
                  editMode: widget.editMode ,
                  service: widget.service,
                  onSubmit: (){},
                authUser: _authAddCarService,
                recoverPassword: null,),),

      ],

    );
  }
}