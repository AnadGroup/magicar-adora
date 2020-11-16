import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/apis/api_brand_model.dart';
import 'package:anad_magicar/utils/network_util.dart';

class CarBrandsDS extends BaseRestDS<BrandModel> {
  @override
  RestDatasource() {
    // TODO: implement RestDatasource
    return null;
  }

  @override
  Future<List<BrandModel>> getAll(String url) {
    netUtil = NetworkUtil();
    return netUtil
        .get(
      url,
    )
        .then((data) {
      if (data != null && data.length > 0) {
        List<BrandModel> resultBrands =
            data.map<BrandModel>((d) => BrandModel.fromJson(d)).toList();
        return resultBrands;
      } else
        return null;
    });
  }

  @override
  Future<BrandModel> getById(String url, int id) {
    // TODO: implement getById
    return null;
  }

  @override
  Future<BrandModel> send(BrandModel model) {
    // TODO: implement send
    return null;
  }

  @override
  Future<BrandModel> sendAll(List<BrandModel> models) {
    // TODO: implement sendAll
    return null;
  }
}
