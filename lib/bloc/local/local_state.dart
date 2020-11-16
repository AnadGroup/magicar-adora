import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class LocalState extends Equatable {
  final Locale localData;

  LocalState({
    @required this.localData,
  }) : super();
  @override
  // TODO: implement props
  List<Object> get props => null;
}
