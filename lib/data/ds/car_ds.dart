import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart' as prefix1;
import 'package:anad_magicar/model/cars/car.dart'  ;
import 'package:anad_magicar/model/cars/car.dart' as prefix0;


class CarDS extends BaseRestDS<SaveCarModel>{

  @override
  RestDatasource() {
    return null;
  }

  @override
  Future<List<SaveCarModel>> getAll(String url) async{
    return netUtil.post(url,).then(( res) {
      if(res!=null && res.length>0)
      return res.map((c) => SaveCarModel.fromJson (c)).toList();
      else
         return null;
    });
  }

  @override
  Future<SaveCarModel> getById(String url, int id) {

    return null;
  }

  @override
  Future<SaveCarModel> send(SaveCarModel model) {

    return netUtil.post(BaseRestDS.SAVE_CAR_URL,body: model.toJson()).then((res) {
      SaveMagicarResponeQuery  result= SaveMagicarResponeQuery.fromJsonForSaveCarResult(res);
      if(result!=null &&
      result.isSuccessful)
        {
          if(result.userId!=null ||
              (result.returnValue!=null &&
              result.returnValue.CarId!=null))
            {
            return new SaveCarModel(
              userId: result.userId,
              carId: result.returnValue.CarId,
                brandId: model.brandId,
            distance: model.distance,
            colorId: model.colorId,
            modelId: model.modelId,
            pelak: model.pelak,
            tip: model.tip);
            }
        }
      return null;

    }) ;
  }

  @override
  Future<SaveCarModel> sendAll(List<SaveCarModel> models) {

    return null;
  }

}
