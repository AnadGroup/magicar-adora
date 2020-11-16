
import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/dropdown_bloc/ValueProvider.dart';
import 'package:anad_magicar/bloc/dropdown_bloc/dropdown_changed_bloc.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/data/rxbus.dart';


class  MyDropDownButton<T> extends StatefulWidget{
  List<DropdownMenuItem<T>> _dropDownMenuItems;
  final onChanged;
  T value;
  NotyBloc notyBloc;

  MyDropDownButton(this._dropDownMenuItems,this.onChanged,this.notyBloc,this.value);

  @override
  _MyDropDownButtonState createState() {
    // TODO: implement createState
    return _MyDropDownButtonState<T>(null);
  }

}
class _MyDropDownButtonState<T> extends State<MyDropDownButton>
{
  double width=0.0;
  _MyDropDownButtonState(this.onChanged);

  final onChanged;
  var _value;

  @override
  void initState() {

    if(widget.value!=null)
      {
        _value=  widget.value;
      }
    else
      _value=  widget._dropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {

    width=MediaQuery.of(context).size.width-40.0;

      //_value=_dropDownMenuItems[0].value;
    return

      new Container(

        padding: new EdgeInsets.all(5.0),
        margin: new EdgeInsets.all(5.0),
        height: 48.0,
        width:width ,
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.blueAccent,width: 0.5),
            borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            gradient: new LinearGradient(
              colors: <Color>[
                const Color.fromRGBO(255,559,255, 0.8),
                const Color.fromRGBO(255,255,255, 0.9),
              ],
              stops: [0.2, 1.0],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 0.0),
            )),
        child:

      new DropdownButton(
        isExpanded: true,
        iconSize: 18.0,
        style: new TextStyle(color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,),
        elevation: 0,
        value: widget.value!=null ? widget.value : _value,
        items: widget._dropDownMenuItems,
        onChanged: (data) {
          _value = data;
          // onChanged(data);
          setNewValue(data);
        },
      ),
      );
  }


  void setNewValue(T data)
  {
    setState(() {
    _value=data;
    });
    widget.notyBloc.updateValue(data);
    //coachBloc.updateCount(data);
  }
}
