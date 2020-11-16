import 'package:anad_magicar/ui/state/error_state.dart';
import 'package:anad_magicar/ui/state/istate.dart';
import 'package:anad_magicar/ui/state/loaded_state.dart';
import 'package:anad_magicar/ui/state/no_result_state.dart';
import 'package:anad_magicar/ui/state/state_context.dart';
import 'package:flutter/material.dart';


abstract class LoadingState<T> implements IState<T> {

  var resultList;
  var result;

  Future<T> dofetchOne();
  Future<List<T>> dofetchList();
  LoadedState<T> loadedState(List<T> res);
  ErrorState<T> errorState();
  NoResultsState<T> noResultsState();
  @override
  Future nextState(StateContext context) async {
    try {

      if (resultList.isEmpty) {
        context.setState(noResultsState());
      } else {
        context.setState(loadedState(resultList));
      }
    } on Exception {
      context.setState(errorState());
    }
  }

  @override
  Widget render() {
    return CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.black,
      ),
    );
  }

  @override
  Future<List<T>> fetchList() async {
    // TODO: implement fetchList
    resultList=await dofetchList();
    return resultList;
  }

  @override
  Future<T> fetchOne() async{
    // TODO: implement fetchOne
    result=await dofetchOne();
    return result;
  }
}
