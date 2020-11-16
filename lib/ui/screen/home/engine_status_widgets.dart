import 'package:anad_magicar/components/image_neon_glow.dart';
import 'package:flutter/material.dart';

class EngineStatusWidgets extends StatefulWidget {
  EngineStatusWidgets({Key key}) : super(key: key);
  bool selected;
  String imagePath;
  double width;
  double height;
  int counter;
  Color currentColor;
  VoidCallback onTap;
  bool isEngine;
  EngineStatusWidgets.done(
      {this.selected = false,
      this.imagePath,
      this.width,
      this.height,
      this.counter,
      this.currentColor,
      this.onTap,this.isEngine = false});

  @override
  _EngineStatusWidgetsState createState() {
    return _EngineStatusWidgetsState();
  }
}

class _EngineStatusWidgetsState extends State<EngineStatusWidgets> {
  _buildEngineStatusItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(left: 25.0, top: 10.0),
            //width: 64.0,
            child: GestureDetector(
              onTap: () => widget.onTap,
              child: Material(
                elevation: 0.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors
                      .white12 /*Colors.black12.withOpacity(
                                    0.0)*/
                  ,
                  //Colors.grey[100] ,
                  child: (widget.selected != null && !widget.selected)
                      ? ImageNeonGlow(
                          imageUrl: widget.imagePath,
                          counter: widget.counter,
                          color: widget.currentColor,
                          scale: 2.5,
                        )
                      : Image.asset(
                          widget.imagePath,
                          color: widget.currentColor,
                          scale: 2.5,
                        ),

                  radius: 24.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildEngineWidget() {
    return Material(
      elevation: 0.0,
      shape: CircleBorder(),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        //Colors.grey[100] ,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: new Container(
              width: widget.height,
              height: widget.height * 0.45,
              key: ValueKey<int>(widget.counter),
              child: (widget.selected != null && widget.selected)
                  ? Container(
                      key: ValueKey(widget.counter),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pinkAccent.withAlpha(80),
                              blurRadius: 7.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                0.0,
                                6.0,
                              ),
                            ),
                          ]),
                      child: Container(
                        key: ValueKey(widget.counter),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pinkAccent.withAlpha(80),
                                blurRadius: 7.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                  0.0,
                                  6.0,
                                ),
                              ),
                            ]),
                        child: Image.asset(
                          widget.imagePath,
                          scale: 1,
                        ),
                      ),
                    )
                  : Image.asset(
                      widget.imagePath,
                      scale: 1,
                    )),
        ),
        radius: widget.height * 1.1,
        //shape: BoxShape.circle
      ),
    );
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
    
    return widget.isEngine ?
    _buildEngineWidget() :
    _buildEngineStatusItem();
  }
}
