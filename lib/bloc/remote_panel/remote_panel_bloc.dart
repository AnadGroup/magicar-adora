import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'remote_panel_event.dart';
part 'remote_panel_state.dart';

class RemotePanelBloc extends Bloc<RemotePanelEvent, RemotePanelState> {
  String defaultIconAddr = "assets/images/adora/r1_off.png";

  List<String> _iconsCommand = [
    "assets/images/adora/r1_off.png",
    "assets/images/adora/r1_off.png",
    "assets/images/adora/r1_off.png",
    "assets/images/adora/r1_off.png"
  ];

  // List<String> get getCommandsIcon => _iconsCommand;

  @override
  Stream<RemotePanelState> mapEventToState(
    RemotePanelEvent event,
  ) async* {
    if (event is SelectedCommandsIconEvent) {
      print(event.mapCommand["iconAddress"]);
      await saveViewIntoPrefs(event.mapCommand);
      yield* loadCommandsIconFromMap();
    }
    if (event is LoadCommandsIconEvent) {
      yield* loadCommandsIconFromMap();
    }
  }

  @override
  RemotePanelState get initialState => RemotePanelInitial();

  Future saveViewIntoPrefs(Map<String, dynamic> map) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = map["itemIndex"];
    String address = map["iconAddress"];
    await preferences.setString(key, address);
  }

  Stream<RemotePanelState> loadCommandsIconFromMap() async* {
    List<String> iconsAddress = List();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for (var i = 0; i <= 3; i++) {
      String icon = preferences.getString(i.toString());
      if (icon == null || icon.isEmpty) {
        iconsAddress.add(defaultIconAddr);
      } else {
        iconsAddress.add(icon);
      }
    }
    yield LoadedCommandsIconState(iconsCommand: iconsAddress);
  }
}
