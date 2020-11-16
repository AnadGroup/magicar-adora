import 'package:anad_magicar/ui/state/istate.dart';
import 'package:anad_magicar/ui/state/loading_state.dart';
import 'package:anad_magicar/ui/state/state_context.dart';
import 'package:flutter/material.dart';



abstract class LoadedState<T> implements IState<T> {
  final List<T> datas;
  const LoadedState(this.datas);

  LoadingState loadingState();
  Widget renderLoadedWidget();

  @override
  Future nextState(StateContext context) async {
    context.setState(loadingState());
  }

  @override
  Widget render() {
    return renderLoadedWidget();
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
