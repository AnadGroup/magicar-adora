
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_search_car_model.dart';
import 'package:anad_magicar/model/viewmodel/search_car_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/search/base_search.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
 class SearchCar extends BaseSearch<SearchCarVM> {

   SearchCarVM searchCarVM;
   Widget resultChild;
   BuildContext context;
   Function cancelFunc;
   SearchCar({
     @required this.context,
     @required this.searchCarVM,
     @required this.resultChild,
     @required this.cancelFunc,
   }) ;


   String pelakForSearch='';
   String mobileForSearch='';
   String carIdForSearch='';
   bool hasError=false;
   String errorMessage='';
   SearchCarModel result;

   final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
   bool _autoValidate=false;

   _onPelakChanged( value)
   {
     pelakForSearch=value.toString();
   }

   _onSerialChanged( value)
   {
     mobileForSearch=value.toString();
   }
   _onCarIdChanged( value)
   {
     carIdForSearch=value.toString();
   }

  searchCar() async{

      SearchCarModel searchCarModel=new SearchCarModel(
          AdminUserId: null,
          RequestFromThisUserId: null,
          CarId:searchCarVM.carId,
          Message: null,
          userId:searchCarVM.userId ,
          pelak: searchCarVM.pelakNo,
          DecviceSerialNumber: searchCarVM.serialNo);
      try {
        result = await restDatasource.searchCar(searchCarModel);
      }
      catch(error)
      {
        hasError=true;
        errorMessage=error.toString();
      }

      _showPopUpSearchcar(context,resultWidget());
  }

  @override
  Widget showSearchForm(SearchCarVM serchModel) {
    // TODO: implement showSearchForm
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
                               cancelFunc!=null ? cancelFunc() :
                                    Navigator.pop(context);
                              },
                              child:
                              Container(
                                width: 100.0,
                                height: 60.0,
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
  }

  @override
  Widget resultWidget() {
    // TODO: implement resultWidget


    final  resultUI=Stack(
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
                    width:MediaQuery.of(context).size.width*0.90,
                    child:

                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child:hasError ?
                      Text(errorMessage) :
                      new Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(Translations.current.description()),
                              Text(DartHelper.isNullOrEmptyString(result.Message)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(Translations.current.foundCar()),
                              Text(DartHelper.isNullOrEmptyString(result.BrandTitle)),
                            ],
                          ),
                          Text(Translations.current.carIsWaitingForConfirm()),
                          Text( DartHelper.isNullOrEmptyString(result.FirstName) + ' '+
                              DartHelper.isNullOrEmptyString(result.LastName)),

                          Container(
                            child:
                            new FlatButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text(Translations.current.exit())),
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

    //_showPopUpSearchcar(context,resultWidget);


    return resultChild!=null ? resultChild : resultUI;
  }

   _showPopUpSearchcar(BuildContext cntext, Widget content)
   {
     showModalBottomSheetCustom(context: cntext ,
         builder: (BuildContext context) {
           return content;
         });
   }

 }
