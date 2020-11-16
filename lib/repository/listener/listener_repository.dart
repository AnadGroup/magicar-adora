import 'package:anad_magicar/bloc/basic/bloc_provider.dart';
import 'package:anad_magicar/bloc/basic/global_bloc.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:flutter/material.dart';

class ListenerRepository {

  static final ListenerRepository _listenerRepository = new ListenerRepository._internal();

  factory ListenerRepository()
  {
    return _listenerRepository;
  }

  ListenerRepository._internal();

  onCaputTap(BuildContext context, bool status) async
  {
    bool temp_status = false;
    if (status == null) {
      temp_status = await prefRepository.getLockStatus();
    }
    else {
      temp_status = status;
    }
    //bool temp_status = await prefRepository.getLockStatus();
    RxBus.post(new ChangeEvent(message: 'STATUS_CHANGED',type: 'CAPUT',amount: !temp_status ? 0 : 1));
    if (temp_status != null &&
        temp_status)
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/trunk.png', type: 'CAPUT', status: false));
    else
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/trunk.png', type: 'TRUNK', status: true));
  }
  onTrunkTap(BuildContext context, bool status) async
  {
    bool temp_status = false;
    if (status == null) {
      temp_status = await prefRepository.getLockStatus();
    }
    else {
      temp_status = status;
    }
    //bool temp_status = await prefRepository.getLockStatus();
    RxBus.post(new ChangeEvent(message: 'STATUS_CHANGED',type: 'TRUNK',amount: !temp_status ? 0 : 1));
    if (temp_status != null &&
        temp_status)
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/trunk.png', type: 'TRUNK', status: false));
    else
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/trunk.png', type: 'TRUNK', status: true));
  }
  onLockTap(BuildContext context, bool status) async
  {
    bool temp_status = false;
    if (status == null) {
      temp_status = await prefRepository.getLockStatus();
    }
    else {
      temp_status = status;
    }
    //bool temp_status = await prefRepository.getLockStatus();
    RxBus.post(new ChangeEvent(message: 'STATUS_CHANGED',type: 'LOCK',amount: !temp_status ? 0 : 1));
    if (temp_status != null &&
        temp_status)
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/unlock_22.png', type: 'LOCK', status: temp_status));
    else
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/lock_11.png', type: 'LOCK', status: temp_status));
  }
  onPowerTap(BuildContext context,bool status) async
  {
    bool temp_status = false;
    if (status == null) {
      temp_status = await prefRepository.getPowerStatus();
    }
    else {
      temp_status = status;
    }
    if (temp_status != null &&
        temp_status)
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/assets/images/engine_start.png', type: 'POWER', status: temp_status));
    else
      BlocProvider
          .of<GlobalBloc>(context)
          .messageBloc
          .addition
          .add(new Message(
          text: 'assets/images/assets/images/engine_start.png', type: 'POWER', status: temp_status));
  }
}
ListenerRepository listenerRepository=new ListenerRepository();