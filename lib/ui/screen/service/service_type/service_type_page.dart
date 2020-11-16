import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/viewmodel/reg_service_type_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/factory/builder/builder.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/service/service_item.dart';
import 'package:anad_magicar/ui/screen/service/service_type/register_service_type_page.dart';
import 'package:anad_magicar/ui/screen/service/service_type/service_type_item.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';


class ServiceTypePage extends StatefulWidget {
  int carId;
  ServiceTypePage({Key key,this.carId}) : super(key: key);


  @override
  ServiceTypePageState createState() {
    return ServiceTypePageState();
  }
}

class ServiceTypePageState extends MainPage<ServiceTypePage> {

  static final String route='/servicetypepage';

  String serviceDate='';
  String alarmDate='';

  Future<List<ServiceType>>  fServices;
  List<ServiceType> servcies=new List();

  NotyBloc<ChangeEvent> notyDateBloc;
  NotyBloc<ChangeEvent> notyChangeItemsBloc;

  Future<List<ServiceType>> loadCarServiceTypes() async {
    centerRepository.showProgressDialog(context, '');
    var result=await restDatasource.getCarServiceTypes();
    if(result!=null && result.length>0)
      return result;
    return null;
  }


  _showBottomSheetPlans(BuildContext cntext)
  {
    showModalBottomSheetCustom(context: cntext ,
        mHeight: 0.40,
        builder: (BuildContext context) {
          return StreamBuilder<ChangeEvent>(
            initialData: new ChangeEvent(
                fromDate:DateTimeUtils.getDateJalali(),
                toDate: DateTimeUtils.getDateJalali()),
            stream: notyDateBloc.noty ,
            builder: (context,snapshot) {
              if(snapshot.hasData && snapshot.data!=null) {
                var data = snapshot.data;
                serviceDate = data.fromDate;
                alarmDate = data.toDate;
              }
              return
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Button(wid: 120.0,color: Colors.indigoAccent.value,backTransparent: true,title: (serviceDate==null || serviceDate.isEmpty) ? Translations.current.serviceDate() : serviceDate,),
                          onPressed: (){
                          serviceDate= centerRepository.showFilterDate(context, true);
                          notyDateBloc.updateValue(new ChangeEvent(fromDate: serviceDate));
                          },
                        ),
                        FlatButton(
                          child: Button(wid: 120.0,color: Colors.indigoAccent.value,backTransparent: true,title: (alarmDate==null || alarmDate.isEmpty) ? Translations.current.alarmDate() : alarmDate,),
                          onPressed: (){
                            alarmDate= centerRepository.showFilterDate(context, false);
                            notyDateBloc.updateValue(new ChangeEvent(toDate: alarmDate));
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Button(wid: 140.0,color: Colors.pinkAccent.value,backTransparent: true,title: Translations.current.confirm(),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Button(wid: 140.0,color: Colors.pinkAccent.value,backTransparent: true,title: Translations.current.confirm(),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                );
            },
          );
        });
  }

  addServiceType() async {
    Navigator.pushNamed(context, RegisterServicePageTypeState.route,
        arguments: new RegServiceTypeVM(carId: widget.carId, route: route));
  }

  @override
  void dispose() {
    notyChangeItemsBloc.dispose();
    notyDateBloc.dispose();
    super.dispose();
  }

  @override
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    if(action==1)
      scaffoldKey.currentState.openDrawer();
    return null;
  }

  @override
  String getCurrentRoute() {
    return route;
  }

  @override
  FloatingActionButton getFab() {
    return FloatingActionButton(
      onPressed: (){ addServiceType(); },
      child: Icon(Icons.add,color: Colors.white,
      size: 30.0,),
      backgroundColor: Colors.blueAccent,
      elevation: 0.0,

    );
  }

  @override
  initialize() {

    fServices=loadCarServiceTypes();
    notyChangeItemsBloc=new NotyBloc<ChangeEvent>();
    notyDateBloc=new NotyBloc<ChangeEvent>();

    return null;
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return FutureBuilder<List<ServiceType>>(
      future: fServices,
      builder: (context,snapshot) {
        if(snapshot.hasData && snapshot.data!=null) {
          centerRepository.dismissDialog(context);
          servcies=snapshot.data;
          return StreamBuilder<ChangeEvent>(
            stream: notyChangeItemsBloc.noty,
            builder: (context,snapshot) {
               if(snapshot.hasData && snapshot.data!=null) {
                 if(servcies!=null && servcies.length > 0)
                    servcies.removeWhere((s)=> s.ServiceTypeId ==snapshot.data.id);
               }
              return new Padding(padding: EdgeInsets.only(top: 80.0),
            child:
            Container(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: servcies.length,
                  itemBuilder: (context, index) {
                    return ServiceTypeItem(serviceItem: servcies[index],notyChangeEvent: notyChangeItemsBloc,);
                  }),
            ),
            );
          },);
        }
        else {
          return NoDataWidget();
        }
    },
    );
  }

  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    List<Widget> actions = [
      IconButton(
        icon: Icon(Icons.arrow_forward,color: Colors.indigoAccent,),
        onPressed: (){
          Navigator.pushNamed(context, '/servicepage');
        },
      ),
    ];
    return actions;
  }
  @override
  bool doBack() {
    // TODO: implement doBack
    return true;
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 0;
  }
  @override
  bool showMenu() {
    // TODO: implement showMenu
    return false;
  }
  @override
  onBack() {
    // TODO: implement onBack
     Navigator.pushNamed(context, '/servicepage');
     //return ;
  }

  @override
  bool showBack() {
    // TODO: implement showBack
    return true;
  }

  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return null;
  }
}