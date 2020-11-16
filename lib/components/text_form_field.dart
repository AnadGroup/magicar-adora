

import 'package:flutter/material.dart';
import 'package:anad_magicar/components/form_field_state_persister.dart';
import 'package:anad_magicar/components/text_input_form_field.dart';

class MyTextFormField extends StatefulWidget {

  FormFieldStatePersister formFieldStatePersister;
  TextEditingController textEditingController;
  bool _validate=true;
  String errorText='';
  String labelText;
  String hintText;
  double width;
  double height;

  TextInputType type;
  Function onChangedValue;
  Function validate;
  MyTextFormField({Key key,
    this.labelText,
    this.hintText,
    this.width = 80.0,
    this.height = 40.0,
    this.type = TextInputType.text,
    this.onChangedValue,
    this.textEditingController,
  this.validate}) : super(key: key) {
    textEditingController=new TextEditingController();
  }

  @override
  _MyTextFormFieldState createState() {
    return _MyTextFormFieldState();
  }
}

class _MyTextFormFieldState extends State<MyTextFormField> with AutomaticKeepAliveClientMixin {

  String isValidEmail(String input) {
  final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  if(regex.hasMatch(input))
  return null;
  return widget.errorText;
  }

  String isValidEmpty(String input) {
  if(input.isNotEmpty) {
  widget._validate=true;
  return null;
  }
  else {
  widget._validate=false;
  return widget.errorText;
  }
  }

  @override
  void initState() {
  super.initState();

  }


  @override
  void dispose() {
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  // TODO: implement build
  return
     new TextInputFormField(
      controller: widget.textEditingController,
      decoration:  new InputDecoration(

        contentPadding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        labelText: widget.labelText,
        hintText: widget.hintText,
        //filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
        icon: const Icon(Icons.info,color: Colors.blueAccent,),
        labelStyle:
        new TextStyle(decorationStyle: TextDecorationStyle.solid),

        errorText: 'errorText',
      ),
      validator: widget.validate );


  }

@override
// TODO: implement wantKeepAlive
bool get wantKeepAlive => true;
}