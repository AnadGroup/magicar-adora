import 'package:flutter/material.dart';

class CustomDropDownButton<T> extends DropdownButton<T>
{

  CustomDropDownButton({
    Key key, @required List<DropdownMenuItem<T>> items, value, hint, disabledHint,
    @required onChanged, elevation = 0, style, iconSize = 24.0, isDense = false,
    isExpanded = true, }) :
    super(
      key: key,
      items: items,
      value: value, hint: hint, disabledHint: disabledHint, onChanged: onChanged,
      elevation: elevation, style: style, iconSize: iconSize, isDense: isDense,
      isExpanded: isExpanded,
    );

  /*List<DropdownMenuItem<T>> getDropDownMenuItems(List<T> items) {
    List<DropdownMenuItem<T>> result = new List();
    for (T city in items) {
      result.add(new DropdownMenuItem<T>(
        value:  city,
        child: new Text(city,
          textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.redAccent),),
      ));
    }
    return result;
  }*/


  }


