import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/viewmodel/reg_service_type_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/service/main_service_page.dart';
import 'package:anad_magicar/ui/screen/service/register_service_form.dart';
import 'package:anad_magicar/ui/screen/service/service_type/register_service_type_page.dart';

import 'package:flutter/material.dart';

class RegisterServicePage extends StatefulWidget {

  ServiceVM serviceVM;
  GlobalKey<ScaffoldState> scaffoldKey;
  RegisterServicePage({Key key,this.serviceVM,this.scaffoldKey}) : super(key: key);

  @override
  RegisterServicePageState createState() {
    return RegisterServicePageState();
  }
}

class RegisterServicePageState extends MainPage<RegisterServicePage> {

  static final String route='/registerservicepage';

  loadServiceTypes() async{
    List<ServiceType> sTypes=new List();
    sTypes=await restDatasource.getCarServiceTypes();
    if(sTypes!=null && sTypes.length>0)
      centerRepository.setServiceTypes(sTypes);
  }

  addServiceType() async {
    Navigator.pushNamed(context,RegisterServicePageTypeState.route ,arguments: new RegServiceTypeVM(carId: widget.serviceVM.carId,
        route: route));
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    List<Widget> actions=<Widget>[
      IconButton(
        icon: Icon(Icons.arrow_forward,color: Colors.indigoAccent,),
        onPressed: (){
          Navigator.pushNamed(context, MainPageServiceState.route,arguments: widget.serviceVM);
        },
      ),
    ];
    return actions;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return null; /*FloatingActionButton(
      onPressed: (){ addServiceType(); },
      child: Icon(Icons.add,color: Colors.white,
        size: 30.0,),
      backgroundColor: Colors.blueAccent,
      elevation: 0.0,

    );*/
  }
  @override
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    if(action==1)
      widget.scaffoldKey.currentState.openDrawer();
    return null;
  }
  @override
  bool doBack() {
    // TODO: implement doBack
    return true;
  }

  @override
  bool showMenu() {
    // TODO: implement showMenu
    return false;
  }

  @override
  initialize() {
    // TODO: implement initialize
    loadServiceTypes();
    return null;
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return new RegisterServiceForm(
      serviceVM: widget.serviceVM,
      editMode: widget.serviceVM.editMode,
      service: widget.serviceVM.service!=null ? widget.serviceVM.service : null,
      carId: widget.serviceVM.carId,);
  }

  @override
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
    return true;
  }

  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return null;
  }

}