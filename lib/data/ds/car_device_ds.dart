import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/model/apis/api_device_model.dart';
import 'package:anad_magicar/utils/network_util.dart';

class CarDevicesDS extends BaseRestDS<ApiDeviceModel>{
  @override
  RestDatasource() {
    // TODO: implement RestDatasource
    return null;
  }

  @override
  Future<List<ApiDeviceModel>> getAll(String url) {
    netUtil=new NetworkUtil();
    return netUtil.get(url,).then((data) {
      if(data!=null && data.length>0) {
        List<ApiDeviceModel> resultBrands = data.map<ApiDeviceModel>((d) =>
            ApiDeviceModel.fromJsonForGetAll(d)).toList();
        return resultBrands;
      }
      return null;
    });
  }

  @override
  Future<ApiDeviceModel> getById(String url, int id) {
    // TODO: implement getById
    return null;
  }

  @override
  Future<ApiDeviceModel> send(ApiDeviceModel model) {
    // TODO: implement send
    return null;
  }

  @override
  Future<ApiDeviceModel> sendAll(List<ApiDeviceModel> models) {
    // TODO: implement sendAll
    return null;
  }

}
