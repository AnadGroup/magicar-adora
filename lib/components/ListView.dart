
import 'package:flutter/material.dart';

class HorizontalListView extends StatefulWidget {

  HorizontalListView( {
      this.items,
      this.horizontal,
      this.width,
      this.height});

  final List<Widget> items;
  final bool horizontal;
  final double width;
  final double height;

  @override
  _HorizontalListState createState() {
    // TODO: implement createState
    return _HorizontalListState();
  }


}

class _HorizontalListState extends State<HorizontalListView>
{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: widget.height>0 ? widget.height : 200.0,
        child: new ListView(
          scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
          children: widget.items,
        )
    );
  }

  @override
  void initState() {
      super.initState();
  }

}



