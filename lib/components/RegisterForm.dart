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
import './InputFields.dart';


class RegisterContainer extends StatefulWidget {



  @override
  RegisterContainerState createState() {
    return new RegisterContainerState();
  }

  RegisterContainer({key: Key});
}

class RegisterContainerState extends State<RegisterContainer>
{

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //static final _formKey = new GlobalKey<FormState>();
  static final int FIRSTNAME_TYPE=1;
  static final int LASTNAME_TYPE=2;
  static final int EMAILNAME_TYPE=3;
  static final int GENDER_TYPE=4;
  static final int BIRTHDATE_TYPE=5;
  static final int MOBILE_TYPE=5;
  static final int PASSWORD_TYPE=5;


  String firstName='';
  String lastName='';
  String email='';
  String birthDate='';
  String mobile='';
  String password='';
  int gender;
  int bldType;

  var valueNotyGenderBloc=new NotyBloc<Map<String,dynamic>>();

  static ValueChanged onChanged;
  bool _autoValidate=false;

  static File profileImage;


  List<Map<String,dynamic>> _genders=centerRepository.getGendersMap();
  /*[
    {'title': 'مرد','value' : true},
    {'title':'زن','value': false}
  ];*/

  Map<String,dynamic> _currentGender;
  List<DropdownMenuItem<Map<String,dynamic>>> _getDropDownMenuGendersItems() {
    List<DropdownMenuItem<Map<String,dynamic>>> items = new List();
    for (Map<String,dynamic> c in _genders) {
      items.add(new DropdownMenuItem<Map<String,dynamic>>(
        value: c,
        child: new Text(c['title'],
          textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.redAccent),),
      ));
    }
    return items;
  }


  onValueChanged(String value,int type)
  {
    if(type==FIRSTNAME_TYPE)
      {
        firstName=value;
      }
    else if(type==LASTNAME_TYPE)
      {
        lastName=value;
      }
    else if(type==EMAILNAME_TYPE)
      {
        email=value;
      }
    else if(type==GENDER_TYPE)
      {
        gender=int.tryParse(value);
      }
    else if(type==BIRTHDATE_TYPE)
      {
        birthDate=value;
      }
    else if(type==MOBILE_TYPE)
    {
      mobile=value;
    }else if(type==PASSWORD_TYPE)
    {
      password=value;
    }

  }


 static FormFieldStatePersister fieldStatePersister;
 static bool _formWasEdited = false;
  //final _formKey = GlobalKey<FormState>();

  double h=10;double w=30;

   @override
    Widget build(BuildContext context) {
    // TODO: implement build
     TextInputFormField firstNameField = new TextInputFormField(
         controller: fieldStatePersister['FirstName'].persister,
          keyboardType: TextInputType.text,
         decoration:  new InputDecoration(
           contentPadding: EdgeInsets.symmetric(vertical: h,horizontal: w),
           labelText: Translations.current.pleaseEnterFirstName(),
           hintText: Translations.current.firstName(),
           //filled: true,
           border: OutlineInputBorder(gapPadding: 2.0, borderSide: BorderSide(color: Colors.blueAccent)),
           icon: const Icon(Icons.info,color: Colors.blueAccent,),
           labelStyle:
           new TextStyle(decorationStyle: TextDecorationStyle.solid),

           errorText: null,
         ),
         validator: _validateName);

     TextInputFormField lastNameField = new TextInputFormField(
         controller: fieldStatePersister['LastName'].persister,
         keyboardType: TextInputType.text,
         decoration: new InputDecoration(
           contentPadding: EdgeInsets.symmetric(vertical: h,horizontal: w),
           labelText: Translations.current.lastName(),
           //filled: true,
           border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
           icon: const Icon(Icons.info,color: Colors.blueAccent,),
           labelStyle:
           new TextStyle(decorationStyle: TextDecorationStyle.solid),

           errorText: null,
         ),
         validator: _validateName);

     TextInputFormField mobileField = new TextInputFormField(
         controller: fieldStatePersister['Mobile'].persister,
         keyboardType: TextInputType.emailAddress,
         decoration: new InputDecoration(

           contentPadding: EdgeInsets.symmetric(vertical: h,horizontal: w),
           labelText: Translations.current.pleaseEnterMobile(),
           hintText: Translations.current.email(),
           //filled: true,
           border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
           icon: const Icon(Icons.info,color: Colors.blueAccent,),
           labelStyle:
           new TextStyle(decorationStyle: TextDecorationStyle.solid),

           errorText: null,
         ),
         validator: _validateName);

     TextInputFormField passwordField = new TextInputFormField(
         controller: fieldStatePersister['Password'].persister,
         keyboardType: TextInputType.datetime,
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
         validator: _validateName);
    return
   new ListView (
     children: <Widget>[
      Column(
        //margin: EdgeInsets.symmetric(horizontal: 20.0),
        children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Container (
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child:
        Form (
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
            padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 2.0),
            child:
            firstNameField,

          ),
        Container(
         // height: 45,
          padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 2.0),
      child:
      lastNameField,
        ),
        Container(
         // height: 45,
          padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 2.0),
          child:
      mobileField,
        ),
        Container(
         // height: 45,
          padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 2.0),
          child:
      passwordField,
        ),
      /* new MyTextFormField(labelText: Translations.current.pleaseEnterFirstName(),
         hintText: Translations.current.firstName(),
         type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,FIRSTNAME_TYPE); },width: 50.0 ,
         height: 20.0,),
       new MyTextFormField(labelText: Translations.current.pleaseEnterLastName(),
         hintText: Translations.current.lastName(),
         type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,LASTNAME_TYPE); },width: 50.0 ,
         height: 20.0,),
       new MyTextFormField(labelText: Translations.current.pleaseEnterBirthDate(),
         hintText: Translations.current.birthDate(),
         type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,BIRTHDATE_TYPE); },width: 50.0 ,
         height: 20.0,),
       new MyTextFormField(labelText: Translations.current.pleaseEnterEmail(),
         hintText: Translations.current.email(),
         type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,EMAILNAME_TYPE); },width: 50.0 ,
         height: 20.0,),*/
       new Column(

           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Container (
                 margin: EdgeInsets.symmetric(horizontal: 20.0),
                 child:
             StreamBuilder<Map<String,dynamic>>(
                 stream: valueNotyGenderBloc.noty,
                 initialData: null,
                 builder: (BuildContext c, AsyncSnapshot<Map<String,dynamic>> data) {
                   if(data!=null && data.hasData)
                   {
                     _currentGender=data.data;

                   }
                   return

                     new MyDropDownButton<Map<String,dynamic>>(_getDropDownMenuGendersItems(),onChanged,valueNotyGenderBloc,null);
                 }
             ),
             ),
           ]
       ),
       new Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Container (
                 margin: EdgeInsets.symmetric(horizontal: 20.0),
                 child:

                     new Text('data')

             ),
           ]
       ),
       new BorderedButton(60.0,48.0,60.0,10.0,Translations.current.profilePic(),_pickFrontImage,onSelected(new ButtonDefinition(selectedId: 1,selectedTitle: Translations.current.profilePic(),taskId: 1,message: "PROFILEPIC"))),
          new GestureDetector(
            onTap:() { },
            child:
          new SendRegister(),
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



  createFormList(int index)
  {
    if(index==0)
          return new MyTextFormField(labelText: Translations.current.pleaseEnterFirstName(),
            hintText: Translations.current.firstName(),
            type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,FIRSTNAME_TYPE); },width: MediaQuery.of(context).size.width ,
            height: 80.0,);
      if(index==1)
        new MyTextFormField(labelText: Translations.current.pleaseEnterLastName(),
          hintText: Translations.current.lastName(),
          type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,LASTNAME_TYPE); },width: MediaQuery.of(context).size.width ,
          height: 80.0,);
      if(index==2)
        new MyTextFormField(labelText: Translations.current.pleaseEnterPassword(),
          hintText: Translations.current.password(),
          type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,BIRTHDATE_TYPE); },width: MediaQuery.of(context).size.width ,
          height: 80.0,);
      if(index==3)
        new MyTextFormField(labelText: Translations.current.pleaseEnterMobile(),
          hintText: Translations.current.email(),
          type: TextInputType.text,onChangedValue:(value) { onValueChanged(value,EMAILNAME_TYPE); },width: MediaQuery.of(context).size.width ,
          height: 80.0,);
      if(index==4)
       return new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              StreamBuilder<Map<String,dynamic>>(
                  stream: valueNotyGenderBloc.noty,
                  initialData: null,
                  builder: (BuildContext c, AsyncSnapshot<Map<String,dynamic>> data) {
                    if(data!=null && data.hasData)
                    {
                      _currentGender=data.data;

                    }
                    return
                      new MyDropDownButton<Map<String,dynamic>>(_getDropDownMenuGendersItems(),onChanged,null,null);
                  }
              ),
            ]
        );
if(index==5)
       return new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              StreamBuilder<Map<String,dynamic>>(
                  stream: valueNotyGenderBloc.noty,
                  initialData: null,
                  builder: (BuildContext c, AsyncSnapshot<Map<String,dynamic>> data) {

                    return
                      new Text('data');
                  }
              ),
            ]
        );

  }
   onSelected(ButtonDefinition btnDefinition)
   {

   }
  _pickFrontImage()
  {


  }




   @override
   void initState() {
     super.initState();
     fieldStatePersister = new FormFieldStatePersister(_update);

      valueNotyGenderBloc=new NotyBloc<Map<String,dynamic>>();

     fieldStatePersister.addSimplePersister('FirstName', '');
     fieldStatePersister.addSimplePersister('LastName', '');
     fieldStatePersister.addSimplePersister('Mobile', '');
     fieldStatePersister.addSimplePersister('Password', '');



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
        title: const Text('This form has errors'),
        content: const Text('Really leave this form?'),
        actions: <Widget>[
          new FlatButton(
            child: const Text('YES'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          new FlatButton(
            child: const Text('NO'),
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

  void _handleSubmitted(FormFieldStatePersister fieldStatePersister) {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
      _update();
    } else {
      showInSnackBar('${fieldStatePersister['Name']} is a ${fieldStatePersister['Sex']},\n'
          '  eye color is ${fieldStatePersister['EyeColor']},\n'
          '  education level is ${fieldStatePersister['Education']}\n'
          '  can contact parents? ${fieldStatePersister['ContactParents']}');
    }
  }

  static String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  void showInSnackBar(String value) {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
