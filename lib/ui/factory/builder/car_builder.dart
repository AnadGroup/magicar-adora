import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/ui/factory/builder/car.dart';
import 'package:anad_magicar/ui/factory/builder/car_product.dart';



abstract class CarPageBuilder{

  buildBody();
  buildPanel();
  buildCarStateVM();
  buildCarVM();
  buildCurrent();
  buildCarPage();

  CarProduct getCar();
}


