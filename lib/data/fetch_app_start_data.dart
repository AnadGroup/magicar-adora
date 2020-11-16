import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/data/ds/car_brands_ds.dart';
import 'package:anad_magicar/data/ds/car_color_ds.dart';
import 'package:anad_magicar/data/ds/car_model_ds.dart';
import 'package:anad_magicar/data/fetch_data.dart';
import 'package:anad_magicar/model/viewmodel/init_data_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';

class AppInitData extends FetchData<InitDataVM> {


  CarBrandsDS carBrandsDS;
  CarColorsDS carColorsDS;
  CarModelDS carModelDS;

  @override
  Future<List<InitDataVM>> fetchAll() {

    return null;
  }

  @override
  Future<InitDataVM> init() async {
    carColorsDS=new CarColorsDS();
    carModelDS=new CarModelDS();
    carBrandsDS=new CarBrandsDS();

    return  await fetchOne();
  }

  @override
  remove(InitDataVM en) {
    // TODO: implement remove
    return null;
  }

  @override
  Future<InitDataVM> fetchOne() async {
    centerRepository.setCarBrands(await carBrandsDS.getAll(BaseRestDS.GET_BRANDS_URL));
    centerRepository.setCarColors(await carColorsDS.getAll(BaseRestDS.GET_CAR_COLORS_URL));
    centerRepository.setCarModels(await carModelDS.getAll(BaseRestDS.GET_CAR_MODELS_URL));

    if(centerRepository.getCarBrands()!=null &&
        centerRepository.getCarColors()!=null &&
        centerRepository.getCarModels()!=null)
      {
        InitDataVM resultModel=new InitDataVM(
            carColor: null,
            carModel: null,
            carBrand: null,
            carModels: centerRepository.getCarModels(),
            carColors: centerRepository.getCarColors(),
            carBrands: centerRepository.getCarBrands());
      return resultModel;
      }

    return null;
  }

}
