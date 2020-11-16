import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/model/plan_model.dart';

class PlanDS extends BaseRestDS<PlanModel>
{

  @override
  RestDatasource() {
    // TODO: implement RestDatasource
    return null;
  }

  @override
  Future<List<PlanModel>> getAll(String url) {
    return netUtil.get(url,).then(( res) {
      if(res!=null && res.length>0) {
        List<PlanModel> resultPlans=new List();
        resultPlans=res.map<PlanModel>((c) => PlanModel.fromJson(c)).toList();
        return resultPlans;
      }
      else
        return null;
    });
  }

  @override
  Future<PlanModel> getById(String url, int id) {

    return netUtil.post(url,body: {
      "planId": id,
    }).then(( res) {
      if(res!=null && res.length>0) {

       return PlanModel.fromJson(res);
      }
      else
        return null;
    });
  }

  @override
  Future<PlanModel> send(PlanModel model) {
    // TODO: implement send
    return null;
  }

  @override
  Future<PlanModel> sendAll(List<PlanModel> models) {
    // TODO: implement sendAll
    return null;
  }

}
