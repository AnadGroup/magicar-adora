part of 'car_status_setting_bloc.dart';

abstract class CarStatusSettingState extends Equatable {
  const CarStatusSettingState();
  @override
  List<Object> get props => [];
}

class CarStatusSettingLoading extends CarStatusSettingState {}

class CarStatusSettingLoaded extends CarStatusSettingState {
  final List<CarSelectedStatusIconModel> models;

  CarStatusSettingLoaded(this.models);
  @override
  List<Object> get props => [models];
}
