import 'package:anad_magicar/components/liquid_progress/liquid_progress_indicator.dart';
import 'package:flutter/material.dart';

class AnimatedLiquidCircularProgressIndicator extends StatefulWidget {

  int remaintValue;


  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidCircularProgressIndicatorState();

  AnimatedLiquidCircularProgressIndicator({
    @required this.remaintValue,
  });
}

class _AnimatedLiquidCircularProgressIndicatorState
    extends State<AnimatedLiquidCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    /*_animationController.addListener(() => setState(() {
      if(_animationController.value==100)
        _animationController.stop();
    }));*/
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.remaintValue;//_animationController.value * 100;
    return Center(
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: LiquidCircularProgressIndicator(
          value: _animationController.value/2,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          center: Text(
            "${percentage.toStringAsFixed(0)}",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
