import 'package:anad_magicar/utils/utils.dart';
import 'package:flutter/material.dart';

class ChangeLocalState {
  final Locale localData;

  ChangeLocalState({@required this.localData});

  factory ChangeLocalState.persianLocal() {
    return ChangeLocalState(localData: persianLocal);
  }

  factory ChangeLocalState.englishLocal() {
    return ChangeLocalState(localData: englishLocal);
  }
}
