

import 'package:anad_magicar/model/user/user.dart';

class AppState {

  bool isLoading;
  User user;
  AppState({
    this.user,
    this.isLoading = false,

  });

  // A constructor for when the app is loading.
  factory AppState.loading() => new AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.userName ?? 'null'}}';
  }
}
