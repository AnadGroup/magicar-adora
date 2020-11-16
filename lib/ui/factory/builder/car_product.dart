import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_page.dart';
import 'package:anad_magicar/ui/factory/builder/car_product_plan.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/builder/panel.dart';

class CarProduct extends CarProductPlan {

  Body body;
  Panel panel;
  CarVM carVM;
  CarStateVM carStateVM;
  CarPage carPage;
  bool isCurrent;
  @override
  setBody(Body body) {
      this.body=body;
    return body;
  }

  @override
  setCarState(CarStateVM carStateVM) {
   this.carStateVM=carStateVM;
    return carStateVM;
  }

  @override
  setCarVM(CarVM carVM) {
    this.carVM=carVM;
    return carVM;
  }

  @override
  setIsCurrent(bool current) {
    this.isCurrent=current;
    return current;
  }

  @override
  setPage(CarPage carPage) {
    this.carPage=carPage;
    return carPage;
  }

  @override
  setPanel(Panel panel) {
    this.panel=panel;
    return panel;
  }

}
