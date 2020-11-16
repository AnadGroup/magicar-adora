import 'package:anad_magicar/data/base_rest_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart' as rest;
import 'package:anad_magicar/model/actions.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';



class ActionDS extends BaseRestDS<ActionModel>{

  @override
  RestDatasource() {
    return null;
  }


  Future<List<ActionModel>> getAllActions() async{
    return netUtil.get(rest.RestDatasource.GET_ACTIONS_URL,).then(( res) {
      if(res!=null && res.length>0) {
        return res.map<ActionModel>((d) => ActionModel.fromJson(d)).toList();
      }
      else
        return null;
    });
  }

  @override
  Future<List<ActionModel>> getAll(String url) async{
    return  getAllActions();/*netUtil.post(url,).then(( res) {
      return res.map((c) => ActionModel.fromJson (c)).toList();*/
    //});
  }

  @override
  Future<ActionModel> getById(String url, int id) {
    return null;
  }

  @override
  Future<ActionModel> send(ActionModel model) {

    return netUtil.post(BaseRestDS.SAVE_CAR_URL,body: model.toJson()).then((res) {
      SaveMagicarResponeQuery  result= SaveMagicarResponeQuery.fromJson(res);
      if(result!=null &&
          result.isSuccessful)
      {

      }
      return null;

    }) ;
  }

  @override
  Future<ActionModel> sendAll(List<ActionModel> models) {

    return null;
  }

}
