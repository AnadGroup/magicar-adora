import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/reg_service_type_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_page_not_done.dart';
import 'package:anad_magicar/ui/screen/service/service_type/service_type_page.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';

import 'package:flutter/material.dart';
import 'package:anad_magicar/widgets/persistence_tabbar.dart';
class MainPageService extends StatefulWidget {

  ServiceVM serviceVM;
  final GlobalKey<ScaffoldState> scaffoldKey;
  MainPageService({Key key,this.serviceVM,this.scaffoldKey}) : super(key: key);

  @override
  MainPageServiceState createState() {
    return MainPageServiceState();
  }
}

class MainPageServiceState extends State<MainPageService>  with SingleTickerProviderStateMixin {

  static final String route='/servicepage';
  TabController tabController;
  ServiceType _valueCarServiceType;
  String tTtile='';
  bool serviceIndexChanged=false;
  NotyBloc<Message> filterNoty;
  List<ServiceType> serviceTypes=new List();
  Future<List<ApiService>> loadCarServices(int carId,int stId) async {
    centerRepository.showProgressDialog(context, Translations.current.loadingdata());
    List<ApiService> result=await restDatasource.getCarService(widget.serviceVM.carId);
    if(result!=null && result.length>0) {
      if(stId!=null && stId>0) {
          var newResult=result.where((s)=>s.ServiceTypeId==stId).toList();
          return newResult;
      }else {
        return result;
      }
    }
    return null;
  }

  loadServiceTypes() async{
    List<ServiceType> sTypes=new List();
    sTypes=await restDatasource.getCarServiceTypes();
    if(sTypes!=null && sTypes.length>0) {
      if(serviceTypes==null)
        serviceTypes=new List();
      serviceTypes=sTypes;
      centerRepository.setServiceTypes(sTypes);
    }
  }

  void _handleSelected() {
    setState(() {
      serviceIndexChanged = true;
    });
  }
  addService()  {
    loadServiceTypes();
    if(centerRepository.getServiceTypes()==null || centerRepository.getServiceTypes().length==0){
      FlashHelper.informationBar(context, message: Translations.current.noServiceTypes());
    }
    else {
      Navigator.pushNamed(context, RegisterServicePageState.route,
          arguments: new ServiceVM(carId: widget.serviceVM.carId,
              car: widget.serviceVM.car,
              editMode: false,
              service: null));
    }
  }

  Widget _buildServiceTypesField(double width, List<ServiceType> types,StateSetter setState) {
    /*if(_valueCarServiceType==null)
      _valueCarServiceType=types[0];*/
    return
    Container(
      height: 60.0,
    width: MediaQuery.of(context).size.width*0.60,
    child:
      DropdownButton<ServiceType>(
        itemHeight: 58.0,
        isDense: true,
          isExpanded: true,
          items: types.map((ServiceType val) {
            return new DropdownMenuItem<ServiceType>(
              value: val,
              child: new Text(val.ServiceTypeTitle),
            );
          }).toList(),
          value: _valueCarServiceType ,
          hint: Text("لطفا نوع سرویس را انتخاب کنید"),
          onChanged: (newVal) {

            setState(() {
              tTtile=newVal.ServiceTypeTitle;
              _valueCarServiceType = newVal;});
          }),
    );
  }

  _showBottomSheetListServiceTypes(BuildContext context,List<ServiceType> types) {
    _valueCarServiceType=types[0];
    showModalBottomSheetCustom(context: context ,
        mHeight: 0.50,
        builder: (BuildContext context)
    {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return
              Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(
                      right: 10.0, left: 10.0, bottom: 20.0),
                    child:
                    _buildServiceTypesField(120.0, types,state),),
                  FlatButton(
                    child:
                    Button(wid: 100.0,
                      color: Colors.white.value,
                      clr: Colors.pinkAccent,
                      title: Translations.current.doFilter(),),
                    onPressed: () {
                      if (_valueCarServiceType != null)
                        filterServices(_valueCarServiceType.ServiceTypeId);
                    },
                  )
                ],
              );
          });
    });
  }

  filterServices(int sTypeId) async {
        //loadCarServices(carId, sTypeId);
    filterNoty.updateValue(new Message(index: sTypeId));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

 /* @override
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    if(action==1)
      widget.scaffoldKey.currentState.openDrawer();
    return null;
  }*/
 /* @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    List<Widget> actions=[
      IconButton(
        icon: Icon(Icons.refresh,color: Colors.white,),
        onPressed: (){
          filterNoty.updateValue(new Message(type: 'REFRESH'));
        },
      ),
      IconButton(
        icon: Icon(Icons.filter_list,color: Colors.indigoAccent,),
        onPressed: (){
          _showBottomSheetListServiceTypes(context, serviceTypes);
        },
      ),
      IconButton(
        icon: Icon(Icons.directions_car,color: Colors.indigoAccent,),
        onPressed: (){
         Navigator.of(context).pushNamed(ServiceTypePageState.route,arguments: new RegServiceTypeVM(carId: widget.serviceVM.carId,
             route: route) );
        },
      ),

      *//*IconButton(
        icon: Icon(Icons.arrow_forward,color: Colors.indigoAccent,),
        onPressed: (){
          Navigator.pushNamed(context, '/home');
        },
      ),*//*
    ];
    return actions;
  }
*/
 /* @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }*/

/*  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){
        addService();
      },
      elevation: 0.0,
    );
  }*/

 /* @override
  initialize() {
    // TODO: implement initialize
   // tabController=TabController(vsync: this, length: 2);

    scaffoldKey=widget.scaffoldKey;
    filterNoty=new NotyBloc<Message>();
    loadServiceTypes();
    return null;
  }*/


  @override
  void initState() {
    filterNoty=new NotyBloc<Message>();
    loadServiceTypes();
    super.initState();
  }

  /*  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return new MainPersistentTabBar(
      scaffoldKey: widget.scaffoldKey ,
     // tabController: tabController,
      actions: <Widget> [
        IconButton(
          icon: Icon(Icons.refresh,color: Colors.blueAccent,),
          onPressed: (){
            filterNoty.updateValue(new Message(type: 'REFRESH'));
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list,color: Colors.blueAccent,),
          onPressed: (){
            _showBottomSheetListServiceTypes(context, serviceTypes);
          },
        ),
        IconButton(
          icon: Icon(Icons.directions_car,color: Colors.blueAccent,),
          onPressed: () {
            Navigator.of(context).pushNamed(ServiceTypePageState.route,arguments: widget.serviceVM.carId);
          },
        ),

      ],
      page1: ServicePage(serviceVM: widget.serviceVM,filterNoty: filterNoty,),
      page2: ServicePageNotDone(serviceVM: widget.serviceVM,filterNoty: filterNoty,),
    );
  }*/

 /* @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 0;
  }

  @override
  onBack() {
    // TODO: implement onBack
    return null;
  }

  @override
  bool showBack() {
    // TODO: implement showBack
    return false;
  }

  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return null;
  }*/

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new MainPersistentTabBar(
      scaffoldKey: widget.scaffoldKey ,
     fab: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          addService();
        },
        elevation: 0.0,
      ),
      // tabController: tabController,
      actions: <Widget> [
        IconButton(
          icon: Icon(Icons.refresh,color: Colors.blueAccent,),
          onPressed: (){
            filterNoty.updateValue(new Message(type: 'REFRESH'));
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list,color: Colors.blueAccent,),
          onPressed: (){
            _showBottomSheetListServiceTypes(context, serviceTypes);
          },
        ),
        IconButton(
          icon: Icon(Icons.directions_car,color: Colors.blueAccent,),
          onPressed: () {
            Navigator.of(context).pushNamed(ServiceTypePageState.route,arguments: widget.serviceVM.carId);
          },
        ),

      ],
      page1: ServicePage(serviceVM: widget.serviceVM,filterNoty: filterNoty,),
      page2: ServicePageNotDone(serviceVM: widget.serviceVM,filterNoty: filterNoty,),
    );
  }


}
