import 'package:anad_magicar/widgets/func_type/result_func_type.dart';
import 'package:anad_magicar/widgets/magicar_appbar.dart';
import 'package:anad_magicar/widgets/magicar_appbar_title.dart';
import 'package:flutter/material.dart';

class BaseFormWidget<T> extends StatefulWidget {


  Widget body;
  Icon leftIcon;
  Icon rightIcon;
  AuthCallback<T> leftFunc;
  AuthCallback<T> rightFunc;
  BaseFormWidget({Key key,
    @required this.body,
    @required this.leftIcon,
    @required this.leftFunc,
    @required this.rightIcon,
    @required this.rightFunc}) : super(key: key);

  @override
  _BaseFormWidgetState createState() {
    return _BaseFormWidgetState();
  }
}

class _BaseFormWidgetState extends State<BaseFormWidget> {
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
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget> [
          widget.body,
          Positioned(
            child:
            new MagicarAppbar(
              backgroundColorAppBar: Colors.transparent,
              title: new MagicarAppbarTitle(
                currentColor: Colors.redAccent,
                actionIcon: widget.leftIcon,//Icon(Icons.add_circle_outline,color: Colors.redAccent,size: 20.0,),
                actionFunc: widget.leftFunc,
              ),
              actionsAppBar: null,
              elevationAppBar: 0.0,
              iconMenuAppBar: widget.rightIcon,//Icon(Icons.arrow_back,color: Colors.redAccent,),
              toggle: widget.rightFunc ,
            ),
          ),
        ],
      ),
    );
  }
}
