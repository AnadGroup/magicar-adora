import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_page.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/builder/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

 class CarPageBuilder  {


   static CarPageBuilder _carPageBuilder=new CarPageBuilder._internal();

   CarPageBuilder._internal();

   factory CarPageBuilder()
   {
     return _carPageBuilder;
   }

   static int carCounts=0;
   static int currentCarID=0;
   static int currentCarIndex=0;

  final double _initFabHeight = 30.0;
  double _fabHeight;
  double _panelHeightOpen = 180.0;
  double _panelHeightClosed = 35.0;

  static Body body;
  static Panel panel;
  static BuildContext contxt;
  static CarVM carVM;

  ValueSetter<double> onSlideChanged;

  CarPageBuilder setCarVM(CarVM car_VM)
  {
    carVM=car_VM;
    return _carPageBuilder;
  }

   CarPageBuilder setBody(Body bdy)
   {
     body=bdy;
     return _carPageBuilder;
   }
   CarPageBuilder setPanel(Panel pnl)
   {
     panel=pnl;
     return _carPageBuilder;
   }



  CarPage build()
  {

    CarPage carPage=new CarPage(carVM: carVM,carPageBuilder: this);
    return carPage;
  }

  Widget createCarBody()
  {
    body=new Body(context: contxt);
    return body.creatWidget();
  }

  Widget createCarPanel()
  {
    panel=new Panel();
    return panel.creatWidget();
  }

  @override
  Widget createCarPage() {

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SlidingUpPanel(
            renderPanelSheet: false,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: 0.2,
            body: createCarBody(),

            panel: createCarPanel(),
            collapsed: _floatingCollapsed(),

            panelSnapping: true,
            onPanelSlide: (double pos) {
              onSlideChanged(pos);
            }
        ),

      ],
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

CarPageBuilder carPageBuilder=new CarPageBuilder();