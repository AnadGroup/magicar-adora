import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/cars/car_model_detail.dart';
import 'package:anad_magicar/utils/network_util.dart';

class CarModelDetaillDS extends BaseRestDS {

  @override
  RestDatasource() {

    return null;
  }

  @override
  Future<List<CarModelDetail>> getAll(String url) {
    netUtil=new NetworkUtil();
    return netUtil.get(url,).then(( res) {
      if(res!=null && res.length>0) {
        List<CarModelDetail> modelsResult = res.map<CarModelDetail>((cm) =>
            CarModelDetail.fromJson(cm)).toList();
        return modelsResult;
      }
      return null;
    });
  }

  @override
  Future getById(String url, int id) {
    // TODO: implement getById
    return null;
  }

  @override
  Future send(model) {
    // TODO: implement send
    return null;
  }

  @override
  Future sendAll(List models) {
    // TODO: implement sendAll
    return null;
  }


}
