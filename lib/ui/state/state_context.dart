import 'dart:async';

import 'package:anad_magicar/ui/state/istate.dart';
import 'package:anad_magicar/ui/state/loading_state.dart';
import 'package:anad_magicar/ui/state/no_result_state.dart';


abstract class StateContext<T> {
  StreamController<IState<T>> _stateStream = StreamController<IState<T>>();
  Sink<IState<T>> get _inState => _stateStream.sink;
  Stream<IState<T>> get outState => _stateStream.stream;
  NoResultsState<T> noResultsState();
  IState<T> _currentState;

  StateContext() {
    _currentState = noResultsState();
    _addCurrentStateToStream();
  }

  void dispose() {
    _stateStream.close();
  }

  void setState(IState<T> state) {
    _currentState = state;
    _addCurrentStateToStream();
  }

  void _addCurrentStateToStream() {
    _inState.add(_currentState);
  }

  Future<void> nextState() async {
    await _currentState.nextState(this);

    if (_currentState is LoadingState) {
      await _currentState.nextState(this);
    }
  }
}
