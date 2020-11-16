import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/send_command_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/builder/panel.dart';
import 'package:anad_magicar/ui/factory/car/pack.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

abstract class CarWidgets   {


  BuildContext context;
  Body body;
  Panel panel;
  CarVM carVM;
  ValueSetter<double> onSlideChange;


  Body createCarBody()
  {
    body=new Body(context: context);
    return body;
  }
  Panel createCarPanel(){
    panel=new Panel();
    return panel;
  }

  Widget getBody();
  Widget getPanel();
  CarStateVM createCarState();
  int getCarIndex();
  int getCarID();

  Body getCarBody();
  Panel getCarPanel();
  CarStateVM getCarState();

  Widget renderCarPage() {
    return Container(
      child:
      Material(
        child:
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SlidingUpPanel(
                renderPanelSheet: false,
                maxHeight: carVM.panelHeightOpen,
                minHeight: carVM.panelHeightClosed,
                parallaxEnabled: true,
                parallaxOffset: 0.2,
                body: getBody(),
                panel: getPanel(),
                collapsed: _floatingCollapsed(),
                panelSnapping: true,
                onPanelSlide: (double pos) {
                  onSlideChange(pos);
                }
            ),

          ],
        ),
      ),
    );
  }
  Widget _floatingCollapsed(){
    return Container(
      // height: 260.0,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      margin: const EdgeInsets.fromLTRB(50.0, 2.0, 50.0, 1.0),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child:
            Image.asset('assets/images/car_remote_4.png',fit: BoxFit.cover,width: 28.0,height: 28.0,),
          ),
        ],
      ),
    );
  }
}
