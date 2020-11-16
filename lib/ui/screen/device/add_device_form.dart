import 'package:anad_magicar/components/custom_progress_dialog.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/flutter_form_builder/src/form_builder_custom_field.dart';
import 'package:anad_magicar/components/flutter_form_builder/src/form_builder_validators.dart';
import 'package:anad_magicar/components/loading_indicator.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_device_model.dart';
import 'package:anad_magicar/model/apis/device_model.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/init_device_data.dart';
import 'package:anad_magicar/repository/fake_server.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/widgets/flutter_offline/flutter_offline.dart';
import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/bloc/widget_events/ButtonDefinition.dart';
import 'package:anad_magicar/components/BorderedButton.dart';
import 'package:anad_magicar/components/DropDownButton.dart';
import 'package:anad_magicar/components/RegisterButton.dart';
import 'package:anad_magicar/components/UploadImage.dart';
import 'package:anad_magicar/components/form_field_state_persister.dart';
import 'package:anad_magicar/components/text_form_field.dart';
import 'package:anad_magicar/components/text_input_form_field.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/bottom_sheet_fix.dart';

import 'package:anad_magicar/repository/pref_repository.dart';

class AddDeviceForm extends StatefulWidget {

  bool hasConnection;
  bool fromMainApp;
  int userId;
  NotyBloc<ChangeEvent> carNoty;
  NotyBloc<Message> changeFormNotyBloc;
  @override
  AddDeviceFormState createState() {
    return new AddDeviceFormState();
  }

  AddDeviceForm({key: Key,this.hasConnection,this.fromMainApp,this.carNoty,this.userId,this.changeFormNotyBloc});
}

class AddDeviceFormState extends State<AddDeviceForm> with SingleTickerProviderStateMixin
{
  bool hasInternet=true;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //static final _formKey = new GlobalKey<FormState>();
  static final int PASSWORD_TYPE=1;
  static final int SIMNUMBER_TYPE=2;
  static final int MODELID_TYPE=3;
  static final int SERIALNUMBER_TYPE=4;



  ProgressDialog _progressDialog;
  Future<InitDeviceData> initDeviceData;

  String simNumber='';
  //String modelId='';
  String serialNumber='';
  String password='';
  int modelId;

  List<CarModel> carModel=new List();
  List<Map<String,dynamic>> carModelMap=new List();
  CarModel _currentModel;


  //var valueNotyModelBloc=new NotyBloc<CarModel>();

  static ValueChanged onChanged;
  bool _autoValidate=false;
  ApiDeviceModel confirmDeviceModel;
  DeviceModel _currentDeviceModel;

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


  Future<InitDeviceData> loadDeviceModel(bool connection) async {
    //centerRepository.showProgressDialog(context,Translations.current.loadingdata());
    if(connection && widget.hasConnection) {
      RestDatasource restDatasource = new RestDatasource();
      List<DeviceModel> deviceModels =new List();
      deviceModels=  await restDatasource
          .getAllDeviceModels();
      if(deviceModels==null)
        {
          deviceModels=FakeServer.createDeviceModel();
          _currentDeviceModel=deviceModels.first;
        }
      _currentDeviceModel=deviceModels.first;
      InitDeviceData result = InitDeviceData(deviceModels: deviceModels);
      return result;
    }
    else
      {
        List<DeviceModel> deviceModels = centerRepository.getDeviceModels();
        if(deviceModels==null || deviceModels.length==0)
          deviceModels=FakeServer.createDeviceModel();
        _currentDeviceModel=deviceModels.first;
        InitDeviceData result = InitDeviceData(deviceModels: deviceModels);
        return result;
      }
  }
  _onSimChanged( value)
  {
    simNumber=value.toString();
    confirmDeviceModel.SimNumber=simNumber;
  }

  _onSerialChanged( value)
  {
    serialNumber=value.toString();
    confirmDeviceModel.SerialNumber=serialNumber;
  }

  _onPasswordChanged( value)
  {
    password=value.toString();
    confirmDeviceModel.password=password;
  }



  static FormFieldStatePersister fieldStatePersister;
  static bool _formWasEdited = false;
  //final _formKey = GlobalKey<FormState>();

  static double h=10;
  static double w=30;




  Widget createBody(bool connection,
      TextInputFormField simNumberField,
      TextInputFormField serialNumberField,
      TextInputFormField passwordField)
  {

    return Stack(
      children: <Widget>[
        new Center(
          child:
          FutureBuilder<InitDeviceData>(
              future: initDeviceData ,
              builder: ( context,snapshot)
              {
                if (snapshot.data != null &&
                    snapshot.hasData) {
                 // centerRepository.dismissDialog(context);
                  InitDeviceData result=snapshot.data;
                  return
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
                                        simNumberField,

                                      ),
                                      Container(
                                        // height: 45,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 2.0),
                                        child:
                                        serialNumberField,
                                      ),
                                      Container(
                                        // height: 45,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 2.0),
                                        child:
                                        passwordField,
                                      ),
                                      FormBuilderCustomField(
                                        initialValue: _currentDeviceModel ,
                                        attribute: "DisplayName",
                                        validators: [
                                          FormBuilderValidators.required(),
                                        ],
                                        formField: FormField(
                                          enabled: true,
                                          builder: (FormFieldState<DeviceModel> field) {
                                            return InputDecorator(
                                              decoration: InputDecoration(

                                                labelText: "لطفاو  دستگاه را انتخاب کنید",
                                                errorText: field.errorText,
                                                contentPadding:
                                                EdgeInsets.only(top: 10.0, bottom: 0.0),
                                                border: InputBorder.none,
                                              ),
                                              child: DropdownButton(
                                                isExpanded: true,
                                                items: result.deviceModels.map((m) {
                                                  return DropdownMenuItem(
                                                    child: Text(m.DisplayName),
                                                    value: m,
                                                  );
                                                }).toList(),
                                                value: _currentDeviceModel,
                                                onChanged: (value) {
                                                  _currentDeviceModel=value;
                                                  field.didChange(value);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      new GestureDetector(
                                        onTap: () {
                                          _sendData();
                                        },
                                        child:
                                        new SendData(),
                                      ),


                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                }
                return Container();
              }
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    TextInputFormField simNumberField = new TextInputFormField(
        controller: fieldStatePersister['SimNumber'].persister,
        keyboardType: TextInputType.number,
        decoration:  new InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: h,horizontal: w),
          labelText: Translations.current.pleaseEnterSimNumber(),
          hintText: Translations.current.simNumber(),
          //filled: true,
          border: OutlineInputBorder(gapPadding: 2.0, borderSide: BorderSide(color: Colors.blueAccent)),
          icon: const Icon(Icons.info,color: Colors.blueAccent,),
          labelStyle:
          new TextStyle(decorationStyle: TextDecorationStyle.solid),

          errorText: null,
        ),
        onSaved: (value)=> confirmDeviceModel.SimNumber=value,
        validator: _validateName);

    TextInputFormField serialNumberField = new TextInputFormField(
        controller: fieldStatePersister['SerialNumber'].persister,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: h,horizontal: w),
          labelText: Translations.current.serialNumber(),
          //filled: true,
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
          icon: const Icon(Icons.info,color: Colors.blueAccent,),
          labelStyle:
          new TextStyle(decorationStyle: TextDecorationStyle.solid),

          errorText: null,
        ),
        onSaved: (value)=> confirmDeviceModel.SerialNumber=value,
        validator: _validateName);

    TextInputFormField passwordField = new TextInputFormField(
        controller: fieldStatePersister['Password'].persister,
        keyboardType: TextInputType.visiblePassword,
        decoration: new InputDecoration(

          contentPadding: EdgeInsets.symmetric(vertical: h,horizontal: w),
          labelText: Translations.current.pleaseEnterPassword(),
          hintText: Translations.current.password(),
          //filled: true,
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
          icon: const Icon(Icons.info,color: Colors.blueAccent,),
          labelStyle:
          new TextStyle(decorationStyle: TextDecorationStyle.solid),

          errorText: null,
        ),
        onSaved: (value)=> confirmDeviceModel.password=value,
        validator: _validateName);
    return
      Stack(
        children: <Widget>[
          new Center(
            child:
            FutureBuilder<InitDeviceData>(
                future: initDeviceData ,
                builder: ( context,snapshot)
                {
                  if (snapshot.data != null &&
                      snapshot.hasData) {
                    centerRepository.dismissDialog(context);
                    InitDeviceData result=snapshot.data;
                    return
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
                                              vertical: 2.0, horizontal: 12.0),
                                          child:
                                          FormBuilderTextField(
                                            initialValue: '',
                                            attribute: "SimNumber",
                                            decoration: InputDecoration(
                                              labelText: Translations.current.simcartno(),
                                            ),
                                            onChanged: (value) => _onSimChanged(value),
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
                                              vertical: 2.0, horizontal: 12.0),
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
                                              vertical: 2.0, horizontal: 12.0),
                                          child:
                                          FormBuilderTextField(
                                            initialValue: '',
                                            attribute: "Password",
                                            decoration: InputDecoration(
                                              labelText: Translations.current.password(),
                                            ),
                                            onChanged: (value) => _onPasswordChanged(value),
                                            valueTransformer: (text) => num.tryParse(text),
                                            validators: [
                                              FormBuilderValidators.required(),
                                              FormBuilderValidators.numeric(),
                                              FormBuilderValidators.max(15),
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        FormBuilderCustomField(
                                          initialValue: _currentDeviceModel ,
                                          attribute: "DisplayName",
                                          validators: [
                                            FormBuilderValidators.required(),
                                          ],
                                          formField: FormField(
                                            enabled: true,
                                            builder: (FormFieldState<DeviceModel> field) {
                                              return InputDecorator(
                                                decoration: InputDecoration(

                                                  labelText: Translations.current.plzSelectDeviceModel(),
                                                  errorText: field.errorText,
                                                  contentPadding:
                                                  EdgeInsets.only(top: 10.0, bottom: 0.0,left: 10.0,right: 20.0),
                                                  border: InputBorder.none,
                                                ),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  items: result.deviceModels.map((m) {
                                                    return DropdownMenuItem(
                                                      child: Text(m.DisplayName),
                                                      value: m,
                                                    );
                                                  }).toList(),
                                                  value: _currentDeviceModel,
                                                  onChanged: (value) {
                                                    _currentDeviceModel=value;
                                                    field.didChange(value);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        new GestureDetector(
                                          onTap: () {
                                            _sendData();
                                          },
                                          child:
                                              Container(

                                                    child:
                                          new SendData(),
                                              ),
                ),
                                        new GestureDetector(
                                          onTap: () {
                                            _sendData();
                                          },
                                          child:
                                          new FlatButton(onPressed: (){
                                           if (widget.fromMainApp==null || widget.fromMainApp==false) {
                                            Navigator.pushReplacementNamed(context, '/login'); }
                                           else {
                                             /*widget.changeFormNotyBloc
                                                 .updateValue(
                                                 new Message(type: 'CAR_FORM'));*/
                                             Navigator.pushReplacementNamed(context, CarPageState.route,arguments: new CarPageVM(
                                                userId: widget.userId,
                                                isSelf: true,
                                                carAddNoty: valueNotyModelBloc));
                                           }
                                          },
                                              child: Text(Translations.current.goBack())),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                  }
                  return NoDataWidget();
                }
            ),
          ),
        ],
      );
   // );
  }





  onSelected(ButtonDefinition btnDefinition)
  {

  }
  _sendData() async
  {
    bool formIsValid=await _warnUserAboutInvalidData();
    if(formIsValid)
      {
       // centerRepository.goToHome(context);
        confirmDeviceModel.CarId=centerRepository.getCarId();
        if(confirmDeviceModel.CarId==null ||
            confirmDeviceModel.CarId==0)
          confirmDeviceModel.CarId=await prefRepository.getCarId();

        RestDatasource restDatasource=new RestDatasource();
       ServiceResult serviceResult= await restDatasource.checkDeviceAvailable(confirmDeviceModel);
       if(serviceResult!=null &&
       serviceResult.IsSuccessful)
         {
           if(serviceResult.Message!=null)
             centerRepository.showFancyToast(serviceResult.Message,true);
           else
              centerRepository.showFancyToast(Translations.current.registerSuccessful(),true);

           if(widget.fromMainApp==null || !widget.fromMainApp)
              centerRepository.goToLogin(context) ;
           else{
             widget.carNoty.updateValue(new ChangeEvent(type: 'CAR_ADD', message: 'UPDATE_CAR_PAGE'));
            centerRepository.goToHome(context) ;
           }
         }
       else
         {
           if(serviceResult.Message!=null)
            centerRepository.showFancyToast(serviceResult.Message,false);
           else
             centerRepository.showFancyToast(Translations.current.deviceNotAvailable(),false);

         }
      }
  }



  @override
  void initState() {
    super.initState();



   // _progressDialog=new ProgressDialog();
    fieldStatePersister = new FormFieldStatePersister(_update);


    fieldStatePersister.addSimplePersister('SimNumber', '');
    fieldStatePersister.addSimplePersister('Password', '');
    fieldStatePersister.addSimplePersister('SerialNumber', '');

    hasInternet=widget.hasConnection;
    confirmDeviceModel=new ApiDeviceModel();

    initDeviceData=loadDeviceModel(true);
  }
  void _update() {
    setState((){});
  }


  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate()) return true;

    return await showDialog<bool>(
      context: context,
      child: new AlertDialog(
        title:  Text(Translations.current.thisFormHasErrors()),
        content:  Text(Translations.current.doYouRealyWantToExit()),
        actions: <Widget>[
          new FlatButton(
            child:  Text(Translations.current.yes()),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          new FlatButton(
            child:  Text(Translations.current.no()),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    ) ??
        false;
  }

  void _reset() {
    fieldStatePersister.resetToInitialValues();
    _update();
    new Future.delayed(new Duration(milliseconds:50)).then((dynamic a) {
      _formKey.currentState.reset();
    });
  }



  static String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'erro';
    return null;
  }

  void showInSnackBar(String value) {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
