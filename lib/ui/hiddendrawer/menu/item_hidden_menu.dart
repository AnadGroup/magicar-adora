

import 'package:flutter/material.dart';

class ItemHiddenMenu extends StatelessWidget {

  /// name of the menu item
  final String name;

  /// callback to recibe action click in item
  final Function onTap;

  final Color colorLineSelected;

  /// Base style of the text-item.
  final TextStyle baseStyle;

   /// style to apply to text when item is selected
   final TextStyle selectedStyle;

  final bool selected;
  final Widget content;
  ItemHiddenMenu(
      {Key key,
        this.name,
        this.selected = false,
        this.onTap,
        this.colorLineSelected = Colors.blue,
        this.baseStyle,
        this.selectedStyle,
        this.content
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5.0),
      child:
      InkWell(
        onTap: onTap,
        child: content/*Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(4.0),bottomRight: Radius.circular(4.0)),
              child: Container(
                height: 40.0,
                color: selected ? colorLineSelected : Colors.transparent,
                width: 5.0,
              ),
            ),
             Expanded(
               child: Container(
                 margin: EdgeInsets.only(left: 20.0),
                 child: Text( name,
                     style: (this.baseStyle ?? TextStyle(color: Colors.grey, fontSize: 25.0)).merge(this.selected ? this.selectedStyle ?? TextStyle(color: Colors.white): null),
                 )
               ),
             ),
          ],
        ),*/
      ),
    );
  }
}