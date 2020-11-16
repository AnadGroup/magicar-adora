import 'package:anad_magicar/ui/factory/builder/car_builder.dart';
import 'package:anad_magicar/ui/factory/builder/car_factory.dart';
import 'package:anad_magicar/ui/factory/builder/car_product.dart';
import 'package:anad_magicar/ui/factory/builder/car_product_page.dart';

class Builder {

  CarPageBuilder carPageBilder;
  CarFactory carFactory;

  Builder()
  {
    carPageBilder =new CarProductPage();
    carFactory=new CarFactory(carPageBuilder: carPageBilder);
  }

  createCarPage(){
    carFactory.createCarPage();
  }
  CarProduct getCarPage()
  {
    return carFactory.getCarPage();
  }
}
