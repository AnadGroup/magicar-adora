import 'package:flutter/material.dart';

class BounceAnimationBuilder extends StatefulWidget {

  AnimationController animationController;
  Widget child;
  bool start;

  BounceAnimationBuilder({
    @required this.animationController,
    @required this.child,
    @required this.start,
  });

  @override
  _BounceAnimationBuilderState createState() {
    // TODO: implement createState
    return _BounceAnimationBuilderState();
  }

}
class _BounceAnimationBuilderState extends State<BounceAnimationBuilder> {


  bool tempStart=true;
  stopAnimationAfterDelayed(int delay)
  {
    Future.delayed(new Duration(milliseconds: delay)).then((value) {
      setState(() {
        tempStart=false;
      });
    });
  }


  @override
  void initState() {
    tempStart=widget.start;
    tempStart ?  widget.animationController.repeat(reverse: true) :
    widget.animationController.stop() ;
    stopAnimationAfterDelayed(3000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return tempStart ? ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.5)
        .animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.elasticOut
    )
    ),
    child: widget.child,
    ) :
    widget.child ;
  }


}
