
import 'package:anad_magicar/ui/state/state_context.dart';
import 'package:flutter/material.dart';


abstract class IState<T> {
  Future nextState(StateContext context);
  Future<List<T>> fetchList();
  Future<T> fetchOne();
  Widget render();
}
