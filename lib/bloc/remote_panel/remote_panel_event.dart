part of 'remote_panel_bloc.dart';

abstract class RemotePanelEvent extends Equatable {
  const RemotePanelEvent();
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LoadCommandsIconEvent extends RemotePanelEvent {}

class SelectedCommandsIconEvent extends RemotePanelEvent {
  final Map<String, dynamic> mapCommand;

  SelectedCommandsIconEvent(this.mapCommand);
  @override
  List<Object> get props => [mapCommand];
}
