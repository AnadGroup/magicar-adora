import 'package:flutter/material.dart';

class SafeBuilder extends StatelessWidget {
  SafeBuilder({
    Key key,
    this.builder,
  }) : super(key: key);
  final WidgetBuilder builder;
  @override
  Widget build(BuildContext context) {
    try {
      return builder(context);
    } catch (error) {
      return ErrorWidget(error);
    }
  }
}
