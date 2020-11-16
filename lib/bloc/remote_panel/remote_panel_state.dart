part of 'remote_panel_bloc.dart';

abstract class RemotePanelState extends Equatable {
  const RemotePanelState();
  @override
  List<Object> get props => [];
}

class RemotePanelInitial extends RemotePanelState {}

class LoadedCommandsIconState extends RemotePanelState {
  final List<String> iconsCommand;

  LoadedCommandsIconState({this.iconsCommand});

  @override
  List<Object> get props => [iconsCommand];
}
