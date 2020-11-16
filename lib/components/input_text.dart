import 'package:flutter/material.dart';

class InputText extends StatefulWidget {

  TextEditingController _textEditingController;
  bool _validate=true;
  String errorText='';
  String hintText='';
  String labelText='';
  Icon icon;

  Function onChangedValue;
  InputText({this.labelText,this.hintText,this.errorText,this.icon,this.onChangedValue})
  {
    _textEditingController=new TextEditingController();
  }


  @override
  InputTextState createState() {

    return InputTextState();
  }


}

class InputTextState extends State<InputText>
{
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._textEditingController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
        border: InputBorder.none,
        icon: widget.icon,
        hintStyle: TextStyle(color: Colors.pinkAccent[100],fontSize: 12.0),
        hintText: widget.hintText,
        errorText: widget._validate ? null : widget.errorText,
        //labelText: widget.labelText

      ),

      onChanged: (value){

        setState(() {
          if(widget._textEditingController.text.isEmpty)
            widget._validate=false;
          else
            widget._validate=true;
        });
        widget.onChangedValue(value);
      },
    );
  }

}


