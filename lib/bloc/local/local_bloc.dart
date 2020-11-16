import 'dart:async';

import 'package:anad_magicar/bloc/local/local_event.dart';
import 'package:anad_magicar/bloc/local/local_state.dart';
import 'package:anad_magicar/model/AppLocal.dart';
import 'package:bloc/bloc.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  @override
  LocalState get initialState =>
      LocalState(localData: appLocalData[AppLocal.PERSIAN]);

  @override
  Stream<LocalState> mapEventToState(
    LocalEvent event,
  ) async* {
    if (event is LocalChanged) {
      yield LocalState(localData: appLocalData[event.local]);
    }
  }
}
