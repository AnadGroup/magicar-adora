import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AutoScrollText extends StatefulWidget {
  final double height;
  final List<Widget> items;

  AutoScrollText({this.height = 24.0, this.items});
  @override
  State<StatefulWidget> createState() => new _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText>
    with SingleTickerProviderStateMixin {
  ScrollController scrollCtrl = new ScrollController();
  AnimationController animateCtrl;

  @override
  void dispose() {
    animateCtrl.dispose();
    super.dispose();
  }

  @override
  initState() {
    double offset = 0.0;
    super.initState();
    animateCtrl =
        new AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..addListener(() {
            if (animateCtrl.isCompleted) animateCtrl.repeat();
            offset += 1.0;
            if (offset - 1 > scrollCtrl.offset) {
              offset = 0.0;
            }
            setState(() {
              scrollCtrl.jumpTo(offset);
            });
          });
    animateCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      color: Colors.blueGrey.shade800,
      height: widget.height,
      padding: EdgeInsets.all(4.0),
      child: Center(
        child: ListView(
          controller: scrollCtrl,
          children: widget.items,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}