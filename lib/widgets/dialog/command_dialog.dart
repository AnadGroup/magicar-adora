import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

typedef CommandDialogBuilder = Widget Function(
    BuildContext context, Widget child);

class CommandDialog extends StatefulWidget {
  final CommandDialogBuilder builder;
  final Widget child;
  final double width;
  final double height;
  CommandDialog(
      {@required this.builder,
      @required this.child,
      @required this.width,
      @required this.height})
      : assert(builder != null),
        assert(child != null);

  @override
  _CommandDialogState createState() => _CommandDialogState();
}

class _CommandDialogState extends State<CommandDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              width: widget.width ?? 300,
              height: widget.height ?? 300,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: widget.builder(context, widget.child)),
        ),
      ),
    );
  }
}
