
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/body.dart';
import 'package:anad_magicar/ui/factory/builder/car_page.dart';
import 'package:anad_magicar/ui/factory/builder/car_vm.dart';
import 'package:anad_magicar/ui/factory/builder/panel.dart';

abstract class CarProductPlan {

  setBody(Body body);
  setPanel(Panel panel);
  setCarState(CarStateVM carStateVM);
  setCarVM(CarVM carVM);
  setIsCurrent(bool current);
  setPage(CarPage carPage);
}
