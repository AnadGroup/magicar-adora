/*

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:anad_magicar/bloc/search/index.dart';



class SearchBloc extends Bloc<SearchEvent<SearchBloc>, SearchState> {
  static final SearchBloc _searchBlocSingleton = new SearchBloc._internal();
  factory SearchBloc() {
    return _searchBlocSingleton;
  }
  SearchBloc._internal();
  
  SearchState get initialState => new UnSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent<SearchBloc> event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}

*/
