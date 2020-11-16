import 'package:anad_magicar/ui/state/istate.dart';
import 'package:anad_magicar/ui/state/state_context.dart';
import 'package:flutter/material.dart';


import 'loading_state.dart';

abstract class ErrorState<T> implements IState<T> {

  LoadingState<T> loadingState();
  Widget renderErrorState();

  @override
  Future nextState(StateContext context) async {
    context.setState(loadingState());
  }

  @override
  Widget render() {
    return renderErrorState();
  }

  @override
  Future<List<T>> fetchList() {
    // TODO: implement fetchList
    return null;
  }

  @override
  Future<T> fetchOne() {
    // TODO: implement fetchOne
    return null;
  }
}
