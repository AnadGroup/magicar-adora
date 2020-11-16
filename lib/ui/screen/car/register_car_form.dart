import 'package:anad_magicar/bloc/car/register.dart';
import 'package:anad_magicar/bloc/search/search_result_screen.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/DropDownButton.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/custom_progress_dialog.dart';
import 'package:anad_magicar/components/fancy_popup/main.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_car_mdel_detail.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/api_search_car_model.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/device_model.dart';
import 'package:anad_magicar/model/cars/brand.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/cars/car_color.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/cars/car_model_detail.dart';
import 'package:anad_magicar/model/cars/car_type.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/add_car_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/init_device_data.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/car/fancy_car/flutter_car.dart';
import 'package:anad_magicar/ui/screen/car/fancy_car_form.dart';
import 'package:anad_magicar/ui/screen/car/register_car_screen.dart';
import 'package:anad_magicar/ui/screen/device/add_device_form.dart';
import 'package:anad_magicar/ui/screen/device/register_device.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/login/confirm_login.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:anad_magicar/widgets/flutter_offline/flutter_offline.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anad_magicar/components/confirm_login_form.dart';
import 'package:anad_magicar/components/input_text.dart';
import 'package:anad_magicar/components/loading_indicator.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:anad_magicar/ui/login/confirm_login.dart';
import 'package:anad_magicar/ui/screen/home/index.dart' as home;


class RegisterCarForm extends StatefulWidget
{


  ValueChanged<String> onChanged;
  RegisterCarBloc registerCarBloc;
  NotyBloc<Message> changeFormNotyBloc;
  NotyBloc<ChangeEvent> carAddNotyBloc;
  bool editMode;
  bool fromMainApp;
  AddCarVM addCarVM;
  RegisterCarForm({
    this.registerCarBloc,
    this.onChanged,
    this.changeFormNotyBloc,
    this.carAddNotyBloc,
    this.fromMainApp,
    this.editMode,
  this.addCarVM});

  @override
  _RegisterCarFormState createState() {
    return _RegisterCarFormState();
  }


}
class _RegisterCarFormState extends State<RegisterCarForm> with TickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  AnimationController _controller;

  NotyBloc<NotyLoadingVM> loadingNoty;
  bool hasInternet=true;
  RegisterCarBloc registerCarBloc;
  ProgressDialog _progressDialog = ProgressDialog();
  static ValueChanged onChanged;
  AnimationController formAnimationController;
  List<Animation> formAnimations;
  Animation buttonAnimation;
  Animation<Offset> pulseAnimation;

  int index=1;
  User user;
  bool isRegisterBtnDisabled=false;
  var valueNotyBrandBloc=new NotyBloc<Brand>();
  var valueNotyModelBloc=new NotyBloc<CarModel>();
  var valueNotyTypeBloc=new NotyBloc<CarType>();
  var valueNotyColorBloc=new NotyBloc<CarColor>();

  List<CarModel> carModel=new List();
  List<Map<String,dynamic>> carModelMap=new List();

  List<Brand> carBrand=new List();
  List<Map<String,dynamic>> carBrandMap=new List();

  List<CarModel> carTip=new List();
  List<Map<String,dynamic>> carTipMap=new List();

  List<Brand> carColor=new List();
  List<Map<String,dynamic>> carColorMap=new List();

  CarModel _currentModel;
  Brand _currentBrand;
  CarType _currentCatType;
  CarColor _currentCarColor;

  String serialNumberForSearch='';
  String pelakForSearch='';
  String carIdForSearch='';
  bool _autoValidate=false;
  int userId=0;
  _onSerialChanged( value)
  {
    serialNumberForSearch=value.toString();
  }

  _onCarIdChanged( value)
  {
    carIdForSearch=value.toString();
  }
  _onPelakChanged( value)
  {
    pelakForSearch=value.toString();
  }

  Future<String> _authAddCar(CarData data) async
  {
    return Future.delayed(new Duration(microseconds: 200)).then((_) {
      if((data!=null &&
          data.pelak!=null &&
          data.tip>0) &&
      !data.cancel) {
        if(widget.addCarVM!=null && widget.addCarVM.editMode!=null &&
            widget.addCarVM.editMode ) {
          SaveCarModel carModel = new SaveCarModel(
            carId: widget.addCarVM.editCarModel.carId,
             /* brandId: data.brandId,
              modelId: data.modelId,*/
              tip: data.tip,
              pelak: data.pelak,
              colorId: data.colorId,
              distance: data.distance,
              ConstantId: null,
              DisplayName: null);
           restDatasource.editCarInfo(carModel).then((value){
              if(value.IsSuccessful){
                centerRepository.showFancyToast(Translations.current.editCarSuccessful(),true);
                CenterRepository.onCarPageTap(context, userId);
              }
              else{
                centerRepository.showFancyToast(Translations.current.editCarUnSuccessful(),true);
              }
            });

        }else {
          SaveCarModel carModel = new SaveCarModel(
              brandId: data.brandId,
              modelId: data.modelId,
              tip: data.tip,
              pelak: data.pelak,
              colorId: data.colorId,
              distance: data.distance,
              ConstantId: null,
              DisplayName: null);
          if (hasInternet) {
            /*loadingNoty.updateValue(new NotyLoadingVM(isLoading: true,
                hasLoaded: false,
                haseError: false,
                hasInternet: true));*/
            /*if (!isRegisterBtnDisabled) widget.registerCarBloc.add(
                new LoadRegisterEvent(user, carModel, context));*/
            CarDS carDS = new CarDS();
             carDS.send(carModel).then((result) {

               if (result != null) {
                 centerRepository.getCars()
                   ..add(new Car(carId: result.carId,
                       carModelDetailId: result.tip,
                       productDate: null,
                       colorTypeConstId: result.colorId,
                       pelaueNumber: result.pelak,
                       deviceId: 1,
                       totalDistance: result.distance,
                       carStatusConstId: null,
                       description: null,
                       isActive: null,
                       brandTitle: '',
                       businessUnitId: null,
                       owner: null,
                       version: null,
                       createdDate: null));
                 prefRepository.setCarId(result.carId);
                 centerRepository.setCarId(result.carId);
                 prefRepository.addCarsCount();
                 Navigator.pushReplacementNamed(context, '/adddevice',arguments: widget.addCarVM.fromMainApp);
               }
               else{

               }
                });

          }
          else {
            /*loadingNoty.updateValue(new NotyLoadingVM(
                isLoading: true,
                hasLoaded: false,
                haseError: false,
                hasInternet: false));*/

            centerRepository.getCars()
              ..add(new Car(carId: centerRepository
                  .getCars()
                  .length + 1,
                  carModelDetailId: data.tip,
                  productDate: null,
                  colorTypeConstId: data.colorId,
                  pelaueNumber: data.pelak,
                  deviceId: 1,
                  totalDistance: data.distance,
                  carStatusConstId: null,
                  description: null,
                  isActive: null,
                  brandTitle: 'brand title',
                  businessUnitId: null,
                  owner: null,
                  version: null,
                  createdDate: null));
            //centerRepository.dismissDialog(context);
            /*loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                hasLoaded: true,
                haseError: false,
                hasInternet: false));*/
            // Navigator.of(context).pushNamed('/adddevice');
            // loadDeviceModel(false);
            Navigator.of(context).pushReplacementNamed('/adddevice', arguments: true);
            // widget.changeFormNotyBloc.updateValue(new Message(type: 'DEVICE_FORM',index: 1,text: 'INTERNET',status: false));
          }

          isRegisterBtnDisabled = true;
        }
      }
      else if(data.cancel) {
        if(widget.addCarVM!=null && widget.addCarVM.fromMainApp!=null &&
            widget.addCarVM.fromMainApp) {
            Navigator.pop(context);
          }
        else {
           Navigator.pushReplacementNamed(context, '/login');
          return 'لطفا جهت ورود به برنامه نام کاربری و رمز عبور خود را وارد کنید';
        }

      }
      else {
        return 'لطفا اطلاعات را بطور کامل وارد نمایید!';
      }
      return null;
    });
  }
  _distanceChanged(value)
  {

  }

  _firstNameChanged(value)
  {

  }

   loadUserId() async {
    userId=await prefRepository.getLoginedUserId();
   }
  _passwordChanged(value)
  {

  }
  _buildBrand(){
    List<DropdownMenuItem<Map<String,dynamic>>> _getDropDownMenuBrandItems() {
      List<DropdownMenuItem<Map<String,dynamic>>> items = new List();
      for (Map<String,dynamic> c in carBrandMap) {
        items.add(new DropdownMenuItem<Map<String,dynamic>>(
          value: c,
          child: new Text(c['BrandTitle'],
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.redAccent),),
        ));
      }
      return items;
    }

    return  SlideTransition(
      position: pulseAnimation,
      child:     new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child:
              StreamBuilder<Brand>(
                  stream: valueNotyBrandBloc.noty,
                  initialData: null,
                  builder: (BuildContext c, AsyncSnapshot<Brand> data) {
                    if(data!=null && data.hasData)
                    {
                      _currentBrand=data.data;

                    }
                    return

                      new MyDropDownButton<Map<String,dynamic>>(_getDropDownMenuBrandItems(),onChanged,valueNotyBrandBloc,null);
                  }
              ),
            ),
          ]
      ),
    );
  }
  _buildCarModel(){
    List<DropdownMenuItem<Map<String,dynamic>>> _getDropDownMenuModelItems() {
      List<DropdownMenuItem<Map<String,dynamic>>> items = new List();
      for (Map<String,dynamic> c in carModelMap) {
        items.add(new DropdownMenuItem<Map<String,dynamic>>(
          value: c,
          child: new Text(c['CarModelTitle'],
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.redAccent),),
        ));
      }
      return items;
    }

    return  SlideTransition(
      position: pulseAnimation,
      child:     new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child:
              StreamBuilder<CarModel>(
                  stream: valueNotyModelBloc.noty,
                  initialData: null,
                  builder: (BuildContext c, AsyncSnapshot<CarModel> data) {
                    if(data!=null && data.hasData)
                    {
                      _currentModel=data.data;
                    }
                    return
                      new MyDropDownButton<Map<String,dynamic>>(_getDropDownMenuModelItems(),onChanged,valueNotyModelBloc,null);
                  }
              ),
            ),
          ]
      ),
    );
  }
  _buildCarTip(){
    List<DropdownMenuItem<Map<String,dynamic>>> _getDropDownMenuTypeItems() {
      List<DropdownMenuItem<Map<String,dynamic>>> items = new List();
      for (Map<String,dynamic> c in carTipMap) {
        items.add(new DropdownMenuItem<Map<String,dynamic>>(
          value: c,
          child: new Text(c['CarTypeTitle'],
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.redAccent),),
        ));
      }
      return items;
    }

    return  SlideTransition(
      position: pulseAnimation,
      child:     new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child:
              StreamBuilder<CarType>(
                  stream: valueNotyTypeBloc.noty,
                  initialData: null,
                  builder: (BuildContext c, AsyncSnapshot<CarType> data) {
                    if(data!=null && data.hasData)
                    {
                      _currentCatType=data.data;
                    }
                    return
                      new MyDropDownButton<Map<String,dynamic>>(_getDropDownMenuTypeItems(),onChanged,valueNotyTypeBloc,null);
                  }
              ),
            ),
          ]
      ),
    );
  }
  _buildCarColor(){
    List<DropdownMenuItem<Map<String,dynamic>>> _getDropDownMenuColorItems() {
      List<DropdownMenuItem<Map<String,dynamic>>> items = new List();
      for (Map<String,dynamic> c in carColorMap) {
        items.add(new DropdownMenuItem<Map<String,dynamic>>(
          value: c,
          child: new Text(c['CarMoColorTitle'],
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.redAccent),),
        ));
      }
      return items;
    }

    return  SlideTransition(
      position: pulseAnimation,
      child:     new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child:
              StreamBuilder<CarColor>(
                  stream: valueNotyColorBloc.noty,
                  initialData: null,
                  builder: (BuildContext c, AsyncSnapshot<CarColor> data) {
                    if(data!=null && data.hasData)
                    {
                      _currentCarColor=data.data;
                    }
                    return
                      new MyDropDownButton<Map<String,dynamic>>(_getDropDownMenuColorItems(),onChanged,valueNotyColorBloc,null);
                  }
              ),
            ),
          ]
      ),
    );
  }

  _buildPelaqeNumber(){
    List<DropdownMenuItem<Map<String,dynamic>>> _getDropDownMenuBrandItems() {
      List<DropdownMenuItem<Map<String,dynamic>>> items = new List();
      for (Map<String,dynamic> c in carBrandMap) {
        items.add(new DropdownMenuItem<Map<String,dynamic>>(
          value: c,
          child: new Text(c['BrandTitle'],
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.redAccent),),
        ));
      }
      return items;
    }

    return  SlideTransition(
      position: pulseAnimation,
      child:     new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child:
              StreamBuilder<Brand>(
                  stream: valueNotyBrandBloc.noty,
                  initialData: null,
                  builder: (BuildContext c, AsyncSnapshot<Brand> data) {
                    if(data!=null && data.hasData)
                    {
                      _currentBrand=data.data;

                    }
                    return

                      new MyDropDownButton<Map<String,dynamic>>(_getDropDownMenuBrandItems(),onChanged,valueNotyBrandBloc,null);
                  }
              ),
            ),
          ]
      ),
    );
  }
  _buildDistance(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: 45,
          margin: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          padding: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(10)
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0.0
                )
              ]
          ),
          child:
          InputText(
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintText:Translations.of(context).mobile() ,
            labelText: Translations.of(context).mobile(),
            errorText: null,
            onChangedValue: (value) => _distanceChanged(value),

          )
        //  TextField(
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
        //     border: InputBorder.none,
        //     icon: Icon(Icons.person_pin,
        //         color: Colors.blueAccent[100],
        //     ),
        //     hintStyle: TextStyle(color: Colors.pinkAccent[100]),
        //       hintText: Translations.of(context).mobile(),
        //   ),
        //   onChanged: (value){
        //     user.mobile=value;
        //   },
        // ),


      ),
    );
  }

  _buildPelaqueNo(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        margin: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).password(),
          ),
          onChanged: (value){
            user.passWord=value;
          },
        ),


      ),
    );
  }
  _buildRePassword(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        margin: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).reTypePassword(),
          ),
          onChanged: (value){
            user.reTypePassword=value;
          },
        ),


      ),
    );
  }


  _buildFirstName(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: 45,
          padding: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          margin: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(10)
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0.0
                )
              ]
          ),
          child:
          InputText(
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintText:Translations.of(context).firstName() ,
            labelText: Translations.of(context).firstName(),
            errorText: 'نام الزامی است',
            onChangedValue: (value) => _firstNameChanged(value),

          )

        //  TextField(
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
        //     border: InputBorder.none,
        //     icon: Icon(Icons.person_pin,
        //         color: Colors.blueAccent[100],
        //     ),
        //     hintStyle: TextStyle(color: Colors.pinkAccent[100]),
        //       hintText: Translations.of(context).firstName(),
        //   ),
        //   onChanged: (value){
        //     user.firstName=value;
        //   },
        // ),


      ),
    );
  }



  _buildTel(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        margin: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).phone(),
          ),
          onChanged: (value){
            // user.tel=value;
          },
        ),


      ),
    );
  }




  _buildRegister() {
    return SlideTransition(
        position: pulseAnimation,
        child:
        Container(
          margin: EdgeInsets.only(bottom: 2.0,left: 5.0,right: 5.0),
          height: 48,

          width: MediaQuery.of(context).size.width/3.5,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent
                ],
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(25.0)
              )
          ),
          child:
          Center(
            child:
            RaisedButton(
              onPressed: () {
                // ApiCustomer apiCustomer=new ApiCustomer();
                // apiCustomer=ApiCustomer.map(user);
                if(!isRegisterBtnDisabled)   widget.registerCarBloc.add(new LoadRegisterEvent(user,null, context));
                isRegisterBtnDisabled=true;

                //new SoapSaveCustomer(context: context).call(SoapConstants.METHOD_SAVE_CUSTOMER,  jsonEncode(apiCustomer));
              },
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              child: Text(Translations.of(context).register(), style: TextStyle(color: Colors.blueAccent)),
              color: Colors.transparent,
            ),
          ),
        )





    );
  }

  _buildExit() {
    return SlideTransition(
        position: pulseAnimation,
        child:
        Container(
          margin: EdgeInsets.only(bottom: 2.0,left: 5.0,right: 5.0),
          height: 48,
          width: MediaQuery.of(context).size.width/3.5,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent
                ],
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(25.0)
              )
          ),
          child:
          Center(
            child:
            RaisedButton(
              onPressed: (){
                Navigator.popAndPushNamed(context, '/home');
              },
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              child: Text(Translations.of(context).skip(), style: TextStyle(color: Colors.blueAccent)),
              color: Colors.transparent,
            ),
          ),
        )





    );
  }


  void _modalBottomSheet(User user){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return ConfirmLogin(user: user);
        }
    );
  }

  Widget get _animatedButtonUI => Container(
    height: 70,
    width: 100,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 30.0,
            offset: Offset(1, 5.5),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0000FF),
            Color(0xFFFF3500),
          ],
        )),
    child: Center(
      child: Text(
        Translations.current.searchCar(),
        style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  Future<InitDeviceData> loadDeviceModel(bool connection) async {
   // _progressDialog.showProgressDialog(context);
    loadingNoty.updateValue(new NotyLoadingVM(isLoading: true,
        hasLoaded: false,
        haseError: false, hasInternet: connection));
    if(connection) {
      RestDatasource restDatasource = new RestDatasource();
      List<DeviceModel> deviceModels = await restDatasource
          .getAllDeviceModels();
      centerRepository.setDeviceModels(deviceModels);
      InitDeviceData result = InitDeviceData(deviceModels: deviceModels);
      Navigator.of(context).pushReplacementNamed('/adddevice',);
      return result;
    }
    else
    {
      List<DeviceModel> deviceModels = centerRepository.getDeviceModels();
      InitDeviceData result = InitDeviceData(deviceModels: deviceModels);
      Navigator.of(context).pushReplacementNamed('/adddevice',);

      return result;
    }
  }

  onCarPageTap()
  {
    Navigator.of(context).pushNamed('/carpage',arguments: new CarPageVM(
        userId: userId,
        isSelf: true,
        carAddNoty: home.valueNotyModelBloc));
  }

  @override
  void initState() {
    super.initState();
    user=new User();

    loadUserId();
    _progressDialog=new ProgressDialog();
    valueNotyModelBloc=new NotyBloc<CarModel>();
    valueNotyColorBloc=new NotyBloc<CarColor>();
    valueNotyTypeBloc=new NotyBloc<CarType>();
    valueNotyBrandBloc=new NotyBloc<Brand>();
    loadingNoty=new NotyBloc<NotyLoadingVM>();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });

    formAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    double start = index * 0.1;
    double duration = 0.6;
    double end = duration + start;
    formAnimations=[new Tween<double>(begin: 800.0, end: 0.0).animate(
        new CurvedAnimation(
            parent: formAnimationController,
            curve: new Interval(start, end, curve: Curves.decelerate))),
      new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: formAnimationController,
              curve: new Interval(start*2, end, curve: Curves.decelerate)))];
    buttonAnimation = new CurvedAnimation(
        parent: formAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));


    pulseAnimation = Tween<Offset>(
      begin: Offset(6, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: formAnimationController,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.ease,
        ),
      ),
    );
    //formAnimationController.forward();
    //registerCarBloc=new RegisterCarBloc();
   // registerCarBloc.initialState;
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    //final RegisterBloc _registerBloc=BlocProvider.of<RegisterBloc>(context);
    return
     /* BlocListener(
        bloc: widget.registerCarBloc,
        listener: (BuildContext context, RegisterState state) {
      if(state is RegisteredState){
        _progressDialog.dismissProgressDialog(context);

        isRegisterBtnDisabled=false;
        loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
            hasLoaded: false,
            haseError: false,
            hasInternet: true));
        RxBus.post(new ChangeEvent(type: 'CAR_ADDED'));
        //Navigator.pushNamed(context, '/adddevice',arguments: true);
      }
    },
    child: BlocBuilder<RegisterCarBloc, RegisterState>(
        bloc: widget.registerCarBloc,
        builder: (
            BuildContext context,
            RegisterState currentState,
            ) {

          if(currentState is InRegisterState)
          {
            _progressDialog.showProgressDialog(context);
          }
          if(currentState is RegisteredState)
          {

            return new AddDeviceForm(userId: widget.addCarVM.userId,fromMainApp: widget.addCarVM.fromMainApp,
                hasConnection: true,carNoty: widget.addCarVM.notyBloc,
            changeFormNotyBloc: changeFormNotyBloc,);

          }
          if(currentState is ErrorRegisterState)
          {
            isRegisterBtnDisabled=false;
            _progressDialog.dismissProgressDialog(context);
            //showPopUp(currentState.errorMessage);
            loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                hasLoaded: false,
                haseError: true,
                hasInternet: true));
            centerRepository.showFancyToast(currentState.errorMessage);
          }*/
            Stack(
              overflow: Overflow.visible,
              children: <Widget> [
          new Padding(padding: EdgeInsets.only(top: 75.0),
          child:  new FancyCarForm(addCarVM: widget.addCarVM,
              authUser: _authAddCar, recoverPassword: null, onSubmit: () { }),
          ),
                FormsAppBar(
                  onIconFunc: () {
                    showSearchCar();
                  },
                  actionIcon: (widget.addCarVM!=null && widget.addCarVM.editMode!=null && widget.addCarVM.editMode) ? null :
                  Icon(Icons.search,color: Colors.indigoAccent,size: 28.0,),
                  loadingNoty: loadingNoty,
                  onBackPress:() {onCarPageTap();} ,)
          ],
      );


  }


  @override
  void dispose() {
    //registerCarBloc.close();
    valueNotyModelBloc.dispose();
    valueNotyBrandBloc.dispose();
    valueNotyColorBloc.dispose();
    valueNotyTypeBloc.dispose();
    super.dispose();
  }

  showSearchCar() {
      _showBottomSheetSearchCar(context);
    }

  _showBottomSheetSearchCar(BuildContext cntext,)
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              new Center(
                child:
                          new ListView (
                            children: <Widget>[
                              Column(
                                //margin: EdgeInsets.symmetric(horizontal: 20.0),
                                children: <Widget>[
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                                    width:MediaQuery.of(context).size.width*0.70,
                                    child:
                                    Form(
                                      key: _formKey,
                                      autovalidate: _autoValidate,
                                      child:
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        physics: BouncingScrollPhysics(),
                                        child: new Column(
                                          children: <Widget>[

                                            Container(
                                              //height: 45,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0, horizontal: 2.0),
                                              child:
                                              FormBuilderTextField(
                                                initialValue: '',
                                                attribute: "CarId",
                                                decoration: InputDecoration(
                                                  labelText: Translations.current.carId(),
                                                ),
                                                onChanged: (value) => _onCarIdChanged(value),
                                                valueTransformer: (text) => num.tryParse(text),
                                                validators: [
                                                  FormBuilderValidators.required(),
                                                  FormBuilderValidators.numeric(),
                                                  FormBuilderValidators.max(70),
                                                ],
                                                keyboardType: TextInputType.number,
                                              ),

                                            ),
                                            Container(
                                              // height: 45,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0, horizontal: 2.0),
                                              child:
                                              FormBuilderTextField(
                                                initialValue: '',
                                                attribute: "SerialNumber",
                                                decoration: InputDecoration(
                                                  labelText: Translations.current.serialNumber(),
                                                ),
                                                onChanged: (value) => _onSerialChanged(value),
                                                valueTransformer: (text) => num.tryParse(text),
                                                validators: [
                                                  FormBuilderValidators.required(),
                                                  FormBuilderValidators.numeric(),
                                                  FormBuilderValidators.max(70),
                                                ],
                                                keyboardType: TextInputType.number,
                                              ),
                                            ),
                                            Container(
                                              // height: 45,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0, horizontal: 2.0),
                                              child:
                                              FormBuilderTextField(
                                                initialValue: '',
                                                attribute: "Pelak",
                                                decoration: InputDecoration(
                                                  labelText: Translations.current.carpelak(),
                                                ),
                                                onChanged: (value) => _onPelakChanged(value),
                                                valueTransformer: (text) => text,
                                                validators: [
                                                  FormBuilderValidators.required(),
                                                ],
                                                keyboardType: TextInputType.text,
                                              ),
                                            ),


                                            new GestureDetector(
                                              onTap: () {
                                                searchCar();
                                              },
                                              child:
                                              Container(

                                                child:
                                                new SendData(),
                                              ),
                                            ),
                                            new GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child:
                                              Container(

                                                child:
                                                new Button(title: Translations.current.cancel(),
                                                color: Colors.white.value,
                                                clr: Colors.amber,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

              ),
            ],
    );
                            });
  }

  searchCar() async{
    bool hasError=false;
    String errorMessage='';
      RestDatasource restDS=new RestDatasource();
      try {
        var result = await restDS.searchCars(
            int.tryParse(carIdForSearch), pelakForSearch, serialNumberForSearch);

        if (result != null && result.length>0) {
          Navigator.pop(context);
          Car car=result.first;
          final resultWidget = Stack(
            children: <Widget>[
              new Center(
                child:
                new ListView (
                  children: <Widget>[
                    Column(
                      //margin: EdgeInsets.symmetric(horizontal: 20.0),
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.90,
                          child:

                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            child: hasError ?
                            Text(errorMessage) :
                            new Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text(Translations.current.description()),
                                    Text(DartHelper.isNullOrEmptyString(
                                        car.description)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text(Translations.current.foundCar()),
                                    Text(DartHelper.isNullOrEmptyString(
                                        car.brandTitle)),
                                  ],
                                ),
                                Text(Translations.current
                                    .carIsWaitingForConfirm()),
                                Text(DartHelper.isNullOrEmptyString(
                                    car.carModelTitle) + ' ' +
                                    DartHelper.isNullOrEmptyString(
                                        car.carModelDetailTitle)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text(Translations.current.carpelak()),
                                    Text(DartHelper.isNullOrEmptyString(
                                        car.pelaueNumber)),
                                  ],
                                ),
                                Container(
                                  child:
                                  new FlatButton(onPressed: () {
                                    /*int brandId=0;
                                    int carModelId=0;
                                    int detailId=0;
                                    var mDetail=centerRepository.getCarModelDetails().where((c)=>c.carModelDetailId==car.carModelDetailId).toList();
                                    if(mDetail!=null && mDetail.length>0){
                                      CarModelDetail carModelDetail=mDetail.first;
                                      var carModel=centerRepository.getCarModels().where((c)=>c.carModelId==carModelDetail.carModelId).toList();
                                      if(carModel!=null && carModel.length>0){
                                        var brands=centerRepository.getCarBrands().where((c)=>c.brandId==carModel.first.brandId).toList();
                                        if(brands!=null && brands.length>0){
                                          BrandModel brand=brands.first;
                                          brandId=brand.brandId;
                                          carModelId=carModel.first.carModelId;
                                        }
                                      }
                                    }
                                    CarData data=new CarData(brandId: brandId,
                                        modelId: carModelId,
                                        tip: car.carModelDetailId, pelak: car.pelaueNumber,
                                        colorId: car.colorTypeConstId,
                                        distance: car.totlaDistance,
                                        cancel: false);*/
                                    _addCarToUser(null, car.carId);

                                  }, child: Button(title: Translations.current.addCar(),
                                    color: Colors.lightGreen.value,clr: Colors.lightGreen,backTransparent: true,
                                    wid: 120.0,)),
                                ),

                                Container(
                                  child:
                                  new FlatButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Button(title: Translations.current.exit(),
    color: Colors.redAccent.value,clr: Colors.redAccent,backTransparent: true,
    wid: 120.0,)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          );

          _showPopUpSearchcar(context, resultWidget);
        } else {
          FlashHelper.errorBar(
              context, message: Translations.current.carNotFound());
        }
      }
      catch(error)
      {
        hasError=true;
        errorMessage=error.toString();
      }
  }
  _addCarToUser(CarData data,int carId) async {
    if(carId!=null){
      int userId=CenterRepository.getUserId();
     var result=await restDatasource.saveCarToUser(userId,carId);
     if(result!=null){
       if(result.IsSuccessful){
         centerRepository.showFancyToast('خودرو با موفقیت افزوده شد.',true);
         Navigator.pop(context);
       }else
         {
           centerRepository.showFancyToast('خودرو با مشکل مواجه شد.',false);
         }
     }
    }
  }
  showExitDialog()
  {
    if(widget.fromMainApp==null ||
    !widget.fromMainApp)
      Navigator.of(context).pushReplacementNamed('/login');
    else
      Navigator.of(context).pop();
  }


  _showPopUpSearchcar(BuildContext cntext, Widget content)
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return content;
        });
  }

  showPopUp(String message)
  {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateFail,
    );
    popup.show(
      title: Translations.current.errorFetchData(),
      content: message,
      actions: [
        new Column(
          children: <Widget>[
            Container(
              height: 100.0,
              child:
              new Center(
                child: new Text(message),
              ),
            ),
            popup.button(
              label: Translations.current.exit(),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        )
      ],
// bool barrierDismissible = false,
// Widget close,
    );
  }



}
