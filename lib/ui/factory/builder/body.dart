
import 'package:anad_magicar/ui/factory/builder/car_body.dart';
import 'package:anad_magicar/ui/factory/car/pack.dart';
import 'package:flutter/src/widgets/framework.dart';

class Body extends PackWidgets {

  CarBody carBodyWidget;
  BuildContext context;

  @override
  Widget carBody() {
    return null;
  }

  @override
  List<Widget> carBodyWidgets() {

    return null;
  }

  @override
  Widget carPanel() {

    return null;
  }

  @override
  List<Widget> carPanelWidgets() {

    return null;
  }

  @override
  Widget creatWidget() {
    return carBodyWidget.createCarWidget();
  }

  @override
  List<Widget> createWidgets() {
    return carBodyWidget.createCarWidgets();
  }

  Body({
     this.carBodyWidget,
    @required this.context,
  }) ;

  @override
  init() {
    carBodyWidget=new CarBody(contxt: this.context);
    carBodyWidget.init();
    return null;
  }

}
