import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/cars/car_model.dart';
import 'package:anad_magicar/utils/network_util.dart';

class CarModelDS extends BaseRestDS<CarModel>{

  @override
  RestDatasource() {
    // TODO: implement RestDatasource
    return null;
  }

  @override
  Future<List<CarModel>> getAll(String url) {
    netUtil=new NetworkUtil();
    return netUtil.get(url,).then(( res) {
      if(res!=null && res.length>0) {
        List<CarModel> modelsResult = res.map<CarModel>((cm) =>
            CarModel.fromJson(cm)).toList();
        return modelsResult;
      }
      return null;
    });

  }

  @override
  Future<CarModel> getById(String url, int id) {
    // TODO: implement getById
    return null;
  }

  @override
  Future<CarModel> send(CarModel model) {
    // TODO: implement send
    return null;
  }

  @override
  Future<CarModel> sendAll(List<CarModel> models) {
    // TODO: implement sendAll
    return null;
  }

}
