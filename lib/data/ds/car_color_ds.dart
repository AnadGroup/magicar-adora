import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/apis/api_car_color.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/cars/car_color.dart';
import 'package:anad_magicar/utils/network_util.dart';

class CarColorsDS extends BaseRestDS<ApiCarColor>{
  @override
  RestDatasource() {
    // TODO: implement RestDatasource
    return null;
  }

  @override
  Future<List<ApiCarColor>> getAll(String url) {
    netUtil=new NetworkUtil();
    return netUtil.get(url,).then(( res) {
      if(res!=null && res.length>0) {
        List<ApiCarColor> colorsResult = res.map<ApiCarColor>(
                (carModel) => ApiCarColor.fromJsonForColor(carModel)).toList();
        return colorsResult;
      }
      return null;
    });
  }

  @override
  Future<ApiCarColor> getById(String url, int id) {
    // TODO: implement getById
    return null;
  }

  @override
  Future<ApiCarColor> send(ApiCarColor model) {
    // TODO: implement send
    return null;
  }

  @override
  Future<ApiCarColor> sendAll(List<ApiCarColor> models) {
    // TODO: implement sendAll
    return null;
  }

}
