import 'package:anad_magicar/bloc/local/change_local_event.dart';
import 'package:anad_magicar/bloc/local/change_local_state.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLocalBloc extends Bloc<ChangeLocalEvent, ChangeLocalState> {
  void onPersianLocalChange() => add(PersianLocal());
  void onEnglishLocalChange() => add(EnglishLocal());
  void onDecideLocalChange() => add(DecideLocal());
  @override
  ChangeLocalState get initialState => ChangeLocalState.persianLocal();

  @override
  Stream<ChangeLocalState> mapEventToState(ChangeLocalEvent event) async* {
    if (event is DecideLocal) {
      final int optionValue = await getOption();
      if (optionValue == 0) {
        yield ChangeLocalState.persianLocal();
      } else if (optionValue == 1) {
        yield ChangeLocalState.englishLocal();
      }
    }

    if (event is EnglishLocal) {
      yield ChangeLocalState.englishLocal();
      try {
        _saveOptionValue(1);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
    if (event is PersianLocal) {
      yield ChangeLocalState.persianLocal();
      try {
        _saveOptionValue(0);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
  }

  Future<Null> _saveOptionValue(int optionValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('local_option', optionValue);
  }

  Future<int> getOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int option = preferences.get('local_option') ?? 0;
    return option;
  }
}

final ChangeLocalBloc changeLocalBloc = ChangeLocalBloc()
  ..onDecideLocalChange();
