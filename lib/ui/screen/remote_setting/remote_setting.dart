import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/remote_panel/remote_panel_bloc.dart';
import '../../../bloc/values/notify_value.dart';
import '../../../common/actions_constants.dart';
import '../../../data/rest_ds.dart';
import '../../../model/apis/service_result.dart';
import '../../../model/send_command_model.dart';
import '../../../model/send_command_vm.dart';
import '../../../model/viewmodel/car_state.dart';
import '../../../repository/pref_repository.dart';
import '../../../widgets/dialog/remote_icon_command_dialog.dart';
import '../../../widgets/flash_bar/flash_helper.dart';

enum RemoteStatus { edit, done }

class RemoteSetting extends StatefulWidget {
  static final route = '/remote_setting';
  final RemoteStatus status;
  final CarStateVM carStateVM;
  final NotyBloc<SendingCommandVM> sendCommandNoty;

  const RemoteSetting({
    Key key,
    this.status,
    this.carStateVM = null,
    this.sendCommandNoty = null,
  }) : super(key: key);
  @override
  _RemoteSettingState createState() => _RemoteSettingState();
}

class _RemoteSettingState extends State<RemoteSetting> {
  RemotePanelBloc remoteBloc;
  int userId;
  RestDatasource restDS;
  static bool onTapRaised = false;

  @override
  void didUpdateWidget(RemoteSetting oldWidget) {
    remoteBloc.add(LoadCommandsIconEvent());
    print("-----> didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    remoteBloc = RemotePanelBloc();
    remoteBloc.add(LoadCommandsIconEvent());
    restDS = RestDatasource();
    getUserId();
    ActionsCommand.createActionsMap();
  }

  Future showChooseProfileScreen(int viewIndex) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) => WillPopScope(
              onWillPop: () async => true,
              child: RemoteIconCommandDialog("Enable outputs", viewIndex,
                  (result) {
                var resultMap = {
                  "itemIndex": viewIndex.toString(),
                  "iconAddress": result
                };
                remoteBloc.add(SelectedCommandsIconEvent(resultMap));
              }),
            ));
  }

  void getUserId() async {
    userId = await prefRepository.getLoginedUserId();
  }

  void sendCommand(int actionId) async {
    SendCommandModel sendCommand = SendCommandModel(
      UserId: userId,
      ActionId: actionId,
      CarId: widget.carStateVM.carId,
      Command: "",
      //Todo "DeviceSerialNumber": 700015
    );
    widget.sendCommandNoty.updateValue(
        SendingCommandVM(sending: true, sent: false, hasError: false));
    try {
      ServiceResult result = await restDS.sendCommand(sendCommand);
      if (result != null) {
        if (result.IsSuccessful) {
          // commandSuccess = false;
          // lastActionCode = actionCode;

          widget.sendCommandNoty.updateValue(
              SendingCommandVM(sending: false, sent: true, hasError: false));
        } else {
          widget.sendCommandNoty.updateValue(
              SendingCommandVM(sending: false, sent: false, hasError: true));
        }
      } else {
        widget.sendCommandNoty.updateValue(
            SendingCommandVM(sending: false, sent: false, hasError: true));
      }
    } catch (error) {
      widget.sendCommandNoty.updateValue(
          SendingCommandVM(sending: false, sent: false, hasError: true));
    }
  }

  void releaseTapRaised(bool tapRaised) {
    Future.delayed(Duration(milliseconds: 5000)).then((value) {
      if (onTapRaised) onTapRaised = false;
    });
  }

  showWaitingFlash() {
    FlashHelper.successBarInCenter(context,
        duration: Duration(seconds: 3),
        message: 'دستور شما ارسال شد',
        body: '',
        moreInfo: '');
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height * 0.35;
    return Container(
      child: Scaffold(
        appBar: widget.status == RemoteStatus.edit
            ? AppBar(
                elevation: 0,
                title: Text(
                  "تنظیمات کنترل",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: BackButton(color: Colors.indigoAccent),
              )
            : null,
        body: Center(
          child: BlocBuilder<RemotePanelBloc, RemotePanelState>(
            bloc: remoteBloc,
            builder: (context, state) {
              print("-----> $state");
              if (state is RemotePanelInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadedCommandsIconState) {
                return Stack(
                  children: <Widget>[
                    // Card widget
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Container(
                        width: w,
                        height: h,
                        child: Card(
                          margin: EdgeInsets.only(
                              left: 2.0, right: 2.0, top: 4.0, bottom: 1.0),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(10, 10))),
                          color: Color(0xFFeceff1),
                          elevation: 0.0,
                          child: Text(''),
                        ),
                      ),
                    ),
                    // top left icon
                    Positioned(
                      left: 1.0,
                      top: -20.0,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.status == RemoteStatus.edit) {
                            showChooseProfileScreen(0).then((val) {
                              if (val != null && val) {
                                print("------> $val");
                              }
                            });
                          } else {
                            if (!onTapRaised) {
                              showWaitingFlash();
                              sendCommand(54);
                              onTapRaised = true;
                              releaseTapRaised(onTapRaised);
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: AvatarGlow(
                            startDelay: Duration(microseconds: 1000),
                            glowColor: Colors.redAccent,
                            endRadius: 40.0,
                            duration: Duration(milliseconds: 2000),
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: Material(
                              elevation: 0.0,
                              shape: CircleBorder(),
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white12,
                              //   radius: 24.0,
                                child: Image.asset(
                                  state.iconsCommand[0],
                                  color: Colors.red,
                                  fit: BoxFit.cover,
                                ),
                             // ),
                            ),
                            shape: BoxShape.circle,
                            animate: false, // to see animation must be true
                            curve: Curves.bounceOut,
                          ),
                        ),
                      ),
                    ),
                    // top right icon
                    Positioned(
                      right: 10.0,
                      top: -20.0,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.status == RemoteStatus.edit) {
                            showChooseProfileScreen(1).then((val) {
                              if (val != null && val) {
                                print("------> $val");
                              }
                            });
                          } else {
                            if (!onTapRaised) {
                              showWaitingFlash();
                              sendCommand(57); //E02 -> 55
                              onTapRaised = true;
                              releaseTapRaised(onTapRaised);
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0, right: 10),
                          child: AvatarGlow(
                            startDelay: Duration(microseconds: 1000),
                            glowColor: Colors.redAccent,
                            endRadius: 40.0,
                            duration: Duration(milliseconds: 2000),
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: Material(
                              elevation: 0.0,
                              shape: CircleBorder(),
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white12,
                              //   radius: 24.0,
                                child: Image.asset(
                                  state.iconsCommand[1],
                                  color: Colors.red,
                                  fit: BoxFit.cover,
                                ),
                              //),
                            ),
                            shape: BoxShape.circle,
                            animate: false, // to see animation must be true
                            curve: Curves.bounceOut,
                          ),
                        ),
                      ),
                    ),
                    //Center image
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(130),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pinkAccent.withAlpha(80),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                    0.0,
                                    6.0,
                                  ),
                                ),
                              ]),
                          alignment: Alignment.center,
                          width: h * 0.55,
                          height: h * 0.55,
                          child: Image.asset(
                            'assets/images/adora/adora_remote_middle_brand_n.png',
                            scale: 1,
                          ),
                        ),
                      ),
                    ),
                    // bottom right icon
                    Positioned(
                      right: 10.0,
                      bottom: 10,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.status == RemoteStatus.edit) {
                            showChooseProfileScreen(2).then((val) {
                              if (val != null && val) {
                                print("------> $val");
                              }
                            });
                          } else {
                            if (!onTapRaised) {
                              showWaitingFlash();
                              sendCommand(55); // D01 -> 56
                              onTapRaised = true;
                              releaseTapRaised(onTapRaised);
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: AvatarGlow(
                            startDelay: Duration(microseconds: 1000),
                            glowColor: Colors.redAccent,
                            endRadius: 40.0,
                            duration: Duration(milliseconds: 2000),
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: Material(
                              elevation: 0.0,
                              shape: CircleBorder(),
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white12,
                              //   radius: 24.0,
                                child: Image.asset(
                                  state.iconsCommand[2],
                                  color: Colors.red,
                                  fit: BoxFit.cover,
                                ),
                              //),
                            ),
                            shape: BoxShape.circle,
                            animate: false, // to see animation must be true
                            curve: Curves.bounceOut,
                          ),
                        ),
                      ),
                    ),
                    // bottom left icon
                    Positioned(
                      left: 10.0,
                      bottom: 10,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.status == RemoteStatus.edit) {
                            showChooseProfileScreen(3).then((val) {
                              if (val != null && val) {
                                print("------> $val");
                              }
                            });
                          } else {
                            if (!onTapRaised) {
                              showWaitingFlash();
                              sendCommand(56); //D02 -> 57
                              onTapRaised = true;
                              releaseTapRaised(onTapRaised);
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: AvatarGlow(
                            startDelay: Duration(microseconds: 1000),
                            glowColor: Colors.redAccent,
                            endRadius: 40.0,
                            duration: Duration(milliseconds: 2000),
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: Material(
                              elevation: 0.0,
                              shape: CircleBorder(),
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white12,
                              //   radius: 24.0,
                                child: Image.asset(
                                  state.iconsCommand[3],
                                  color: Colors.red,
                                  fit: BoxFit.cover,
                                ),
                             // ),
                            ),
                            shape: BoxShape.circle,
                            animate: false, // to see animation must be true
                            curve: Curves.bounceOut,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
