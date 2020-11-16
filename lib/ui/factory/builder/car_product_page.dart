import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_builder.dart';
import 'package:anad_magicar/ui/factory/builder/car_page.dart';
import 'package:anad_magicar/ui/factory/builder/car_product.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/builder/panel.dart';

class CarProductPage extends CarPageBuilder{
  CarProduct carProduct;

  Body body;
  Panel panel;
  CarVM carVM;
  CarStateVM carStateVM;
  CarPage carPage;
  bool isCurrent=false;
  @override
  buildBody() {
    body=new Body();
    carProduct.setBody(body);
    return body;
  }

  @override
  buildCarPage() {
    carPage=new CarPage( carVM: null);
    carProduct.setPage(carPage);
    return carPage;
  }

  @override
  buildCarStateVM() {
   carStateVM=new CarStateVM();
   carProduct.setCarState(carStateVM);
    return carStateVM;
  }

  @override
  buildCarVM() {
    carVM=new CarVM();
    carProduct.setCarVM(carVM);
    return carVM;
  }

  @override
  buildCurrent() {
    carProduct.isCurrent=isCurrent;
    return isCurrent;
  }

  @override
  buildPanel() {
    panel=new Panel();
    carProduct.setPanel(panel);
    return panel;
  }

  @override
  CarProduct getCar() {
    return carProduct;
  }

}
