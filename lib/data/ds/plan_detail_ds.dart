import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/plan_detail_model.dart';

class PlanDetailDS extends BaseRestDS<PlanDetailModel>
{
  @override
  RestDatasource() {
    // TODO: implement RestDatasource
    return null;
  }

  @override
  Future<List<PlanDetailModel>> getAll(String url) {
    // TODO: implement getAll
    return null;
  }

  @override
  Future<PlanDetailModel> getById(String url, int id) {

    return netUtil.post(url,).then(( res) {
      return   PlanDetailModel.fromJson (res);
    });
  }

  @override
  Future<PlanDetailModel> send(PlanDetailModel model) {
    // TODO: implement send
    return null;
  }

  @override
  Future<PlanDetailModel> sendAll(List<PlanDetailModel> models) {
    // TODO: implement sendAll
    return null;
  }

}