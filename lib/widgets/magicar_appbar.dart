import 'package:flutter/material.dart';

class MagicarAppbar extends StatefulWidget {
  Color backgroundColorAppBar;
  double elevationAppBar;
  List<Widget> actionsAppBar;
  Widget title;
  Icon iconMenuAppBar;
  Function toggle;


  @override
  _MagicarAppbarState createState() {
    return _MagicarAppbarState();
  }

  MagicarAppbar({
    @required this.backgroundColorAppBar,
    @required this.elevationAppBar,
    @required this.actionsAppBar,
    @required this.title,
    @required this.iconMenuAppBar,
    @required this.toggle,
  });
}

class _MagicarAppbarState extends State<MagicarAppbar> {
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
    return Container(
        color: Colors.blueAccent.withOpacity(0.0),
    height: 88.0,
    child:
      AppBar(
      flexibleSpace: Container(
        height: 2.0,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.0),
        ),
      ),
      brightness: Brightness.light,
      backgroundColor: widget.backgroundColorAppBar,
      elevation: widget.elevationAppBar,
      title: widget.title,
      titleSpacing: 0.0,
      actions: widget.actionsAppBar,
      leading: new IconButton(
          icon:widget.iconMenuAppBar,
          onPressed: widget.toggle,
          ),
      ),
    );
  }
}