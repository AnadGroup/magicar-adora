part of 'car_status_setting_bloc.dart';

abstract class CarStatusSettingEvent extends Equatable {
  const CarStatusSettingEvent();
  @override
  List<Object> get props => [];
}

class LoadCarStatusInitial extends CarStatusSettingEvent {}

class CarstatusIconSelectedextends extends CarStatusSettingEvent {
  final CarSelectedStatusIconModel model;
  CarstatusIconSelectedextends(this.model);
  @override
  List<Object> get props => [model];
}
