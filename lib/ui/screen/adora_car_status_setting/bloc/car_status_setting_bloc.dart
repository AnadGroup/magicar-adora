import 'dart:async';
import 'dart:convert';

import 'package:anad_magicar/ui/screen/adora_car_status_setting/car_status_setting_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'car_status_setting_event.dart';
part 'car_status_setting_state.dart';

class CarSelectedStatusIconModel {
  String iconAdress;
  int position;
  bool selected;

  CarSelectedStatusIconModel({this.iconAdress, this.position, this.selected});

  CarSelectedStatusIconModel.fromJson(Map<String, dynamic> json) {
    iconAdress = json['IconAdress'];
    position = json['Position'];
    selected = json['Selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['IconAdress'] = this.iconAdress;
    data['Position'] = this.position;
    data['Selected'] = this.selected;
    return data;
  }
}

class CarStatusSettingBloc
    extends Bloc<CarStatusSettingEvent, CarStatusSettingState> {
  List<String> iconAddress = [];
  @override
  CarStatusSettingState get initialState => CarStatusSettingLoading();

  @override
  Stream<CarStatusSettingState> mapEventToState(
    CarStatusSettingEvent event,
  ) async* {
    if (event is LoadCarStatusInitial) {
      yield* getCarStatusModleFromPref();
    }
    if (event is CarstatusIconSelectedextends) {
      yield* saveIconStatus(event.model);
    }
  }

  Stream<CarStatusSettingState> getCarStatusModleFromPref() async* {
    SharedPreferences pref = await _getPref();

    String result = await pref.getString('carStatusIconModelKey');
    if (result != null) {
      yield CarStatusSettingLoaded(await _getIconModelFromPref());
    } else {
      // first initialize we store icon model into prefs
      await _saveIntoPref(_defaultIcons());
      yield CarStatusSettingLoaded(_defaultIcons());
    }
  }

  // defualt model icon to initialize first view
  List<CarSelectedStatusIconModel> _defaultIcons() {
    return [
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/r1_off.png',
        position: 0,
        selected: true,
      ),
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/r5_off.png',
        position: 1,
        selected: true,
      ),
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/sirenoff.png',
        position: 2,
        selected: false,
      ),
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/shock_sensoroff.png',
        position: 3,
        selected: false,
      ),
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/infra_sensor_off.png',
        position: 4,
        selected: false,
      ),
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/break_sensor_off.png',
        position: 5,
        selected: false,
      ),
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/r4_off.png',
        position: 6,
        selected: false,
      ),
      CarSelectedStatusIconModel(
        iconAdress: 'assets/images/adora/r3_off.png',
        position: 7,
        selected: false,
      ),
    ];
  }

  Stream<CarStatusSettingState> saveIconStatus(
      CarSelectedStatusIconModel model) async* {
    List<CarSelectedStatusIconModel> iconsmodels =
        await _getIconModelFromPref();
    var item = iconsmodels
        .where((element) => element.position == model.position)
        .first;
    item.selected = !model.selected;
    await _saveIntoPref(iconsmodels);
    yield CarStatusSettingLoaded(iconsmodels);
  }

  Future<List<CarSelectedStatusIconModel>> _getIconModelFromPref() async {
    List<CarSelectedStatusIconModel> iconsmodels = [];

    SharedPreferences pref = await _getPref();
    String result = await pref.getString('carStatusIconModelKey');
    List modelObj = json.decode(result);
    modelObj.forEach((element) {
      print(element);
      iconsmodels.add(CarSelectedStatusIconModel.fromJson(element));
    });
    return iconsmodels;
  }

  Future _saveIntoPref(List<CarSelectedStatusIconModel> iconsModel) async {
    SharedPreferences pref = await _getPref();
    String stringMap = json.encode(iconsModel);
    await pref.setString('carStatusIconModelKey', stringMap);
  }

  Future<SharedPreferences> _getPref() async {
    return await SharedPreferences.getInstance();
  }
}
