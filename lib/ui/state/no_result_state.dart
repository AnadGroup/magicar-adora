import 'package:anad_magicar/ui/state/istate.dart';
import 'package:anad_magicar/ui/state/loading_state.dart';
import 'package:anad_magicar/ui/state/state_context.dart';
import 'package:flutter/material.dart';


abstract class NoResultsState<T> implements IState<T> {

  Widget renderNoResultWidget(){
    return Container();
  }
  LoadingState<T> loadingState();
  @override
  Future nextState(StateContext context) async {
    context.setState(loadingState());
  }

  @override
  Widget render() {
    return renderNoResultWidget();
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
