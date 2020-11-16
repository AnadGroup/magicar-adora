import 'package:flutter/material.dart';

class SplashAnimation  {

  AnimationController _animationController;

  SplashAnimation({
    @required AnimationController animationController,
  }) : _animationController = animationController;

  static Widget relativePositionedTransitionAnim(BuildContext context,Widget child,Animation<Rect> rect,Size size)
  {
    Animation<Rect> anim;
    RelativeRectTween relativeRectTween= RelativeRectTween(
  begin: RelativeRect.fromLTRB(40, 40, 0, 0),
  end: RelativeRect.fromLTRB(0, 0, 40, 40),
  );

    if(rect==null)
      {
        //anim=new S(duration: new Duration(seconds: 3), vsync: this)
      }
    return RelativePositionedTransition(
      rect: rect,
      child: child,
      size: size,
    );
  }


}
