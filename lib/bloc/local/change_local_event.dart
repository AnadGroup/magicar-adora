abstract class ChangeLocalEvent {}

class DecideLocal extends ChangeLocalEvent {}

class PersianLocal extends ChangeLocalEvent {
  @override
  String toString() => 'Persian';
}

class EnglishLocal extends ChangeLocalEvent {
  @override
  String toString() => 'English';
}
