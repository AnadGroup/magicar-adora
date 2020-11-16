import 'dart:async';

import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/widget_events/ButtonDefinition.dart';
import 'package:anad_magicar/bloc/widget_events/bloc/button_bloc.dart';
import 'package:anad_magicar/bloc/widget_events/button_selection_message.dart';
import 'package:anad_magicar/components/UploadImage.dart';

 typedef void ButtonSelectedCallback(ButtonDefinition selectedButton);
 //VoidCallback  OnTapCallback;
class BorderedButton extends StatefulWidget {

  String _title;
  double width;
  double height;
  double h_w;
  double v_w;
  final ButtonSelectedCallback onSelected;
  final VoidCallback onTap;
  BorderedButton(this.width,this.height,this.h_w,this.v_w, this._title,this.onTap,this.onSelected);



  @override
  _BorderedButtonState createState() {

    return _BorderedButtonState();
  }




}


class _BorderedButtonState extends State<BorderedButton>
{

//ButtonBloc bloc;
StreamSubscription streamSubscription;
ButtonDefinition _selectedButton;


@override
void initState()
{
  super.initState();
 // bloc=ButtonBloc();

  //streamSubscription = bloc.outButtonSelection.listen(_onButtonSelection);
}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
        child:
    Container(
      //width: widget.width,
      height: widget.height,
      margin: EdgeInsets.symmetric(horizontal: widget.h_w,vertical: widget.v_w),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
        border: Border.all(color: Colors.blueAccent,width: 0.5,style: BorderStyle.solid),
      ),
      child: new Text(
        widget._title,
        style: new TextStyle(
          color: Colors.blueAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),

    ),
      onTap:  widget.onTap ,
    );
  }

  @override
  void dispose()
  {
    streamSubscription?.cancel();
   // bloc?.dispose();
    super.dispose();
  }

   _onTap(BuildContext context)
  {
    if(widget.onTap!=null)
    {
      ButtonDefinition btnDefinition=ButtonDefinition(selectedId: 1,selectedTitle: widget._title,message: "Selected",taskId: 1);
      ButtonSelectionMessage btnSelectionMessage=ButtonSelectionMessage( btnDefinition,  true);
      //widget.onTap(context);
     // bloc.inPointerContext.add(context);
      //bloc.inButtonSelection.add(btnSelectionMessage);
    }
  }

   _onButtonSelection(ButtonSelectionMessage message)
  {
    if(identical(_selectedButton, message.buttonDefinition))
    {
      if(!message.isSelected)
      {
        _selectedButton=null;
      }
      else {
        if(message.isSelected)
        {
          _selectedButton=message.buttonDefinition;
        }
      }
    }
  }
}
