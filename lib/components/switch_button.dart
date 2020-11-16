import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:math';

class SwitchlikeCheckbox extends StatelessWidget {
  final bool checked;

  SwitchlikeCheckbox({this.checked});

  @override
  Widget build(BuildContext context) {
    var tween = MultiTrackTween([
      Track("paddingLeft")
          .add(Duration(milliseconds: 1000), Tween(begin: 0.0, end: 20.0)),
      Track("color").add(Duration(milliseconds: 1000),
          ColorTween(begin: Colors.black54, end: Colors.blue)),
      Track("text")
          .add(Duration(milliseconds: 500), ConstantTween(Translations.current.off()))
          .add(Duration(milliseconds: 500), ConstantTween(Translations.current.on())),
      Track("rotation")
          .add(Duration(milliseconds: 1000), Tween(begin: -2 * pi, end: 0.0))
    ]);

    return ControlledAnimation(
      playback: checked ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
      startPosition: checked ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(context, animation) {
    return Container(
      decoration: _outerBoxDecoration(animation["color"]),
      width: 50,
      height: 30,
      padding: const EdgeInsets.all(1.0),
      child: Stack(
        children: [
          Positioned(
              child: Padding(
                padding: centerRepository.getCachedLangCode()=='fa' ?
                EdgeInsets.only(right: animation["paddingLeft"]) :
                EdgeInsets.only(left: animation["paddingLeft"]),
                child: Transform.rotate(
                  angle: animation["rotation"],
                  child: Container(
                    decoration: _innerBoxDecoration(animation["color"]),
                    width: 25,
                    child:
                    Center(child: Text(animation["text"], style: labelStyle)),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)), color: color);

  BoxDecoration _outerBoxDecoration(color) => BoxDecoration(
    color: checked ? Colors.amberAccent : Colors.black54,
    borderRadius: BorderRadius.all(Radius.circular(30)),
    border: Border.all(
      width: 1,
      color: color,
    ),
  );

  static final labelStyle = TextStyle(
      height: 1.2,
      fontWeight: FontWeight.bold,
      fontSize: 8,
      color: Colors.white);
}
