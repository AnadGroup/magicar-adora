import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/apis/api_user_role.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/user/role.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';

class ChangeRoleSheet extends StatelessWidget {

  Function changeRole;
  ApiRelatedUserModel user;
  int userId;
  ChangeRoleSheet({Key key,this.changeRole,
  this.user,
  this.userId}) : super(key: key);

  int selectedRoleId;

  Future<bool> _changeRole(int userId, int roleId) async {

    ServiceResult result=await restDatasource.changeUserRole(new UserRoleModel(userId: userId, roleId: roleId));
    if(result!=null &&
        result.IsSuccessful)
    {
      centerRepository.showFancyToast(Translations.current.changeRoleSuccessful(),true);
      return true;
    }
    else
    {
      centerRepository.showFancyToast(Translations.current.changeRoleUnSuccessful(),false);
      return false;
    }
  }

  List<Widget> createRolesList(BuildContext context,int userId)  {
    List<Role> roles=new List();
    List<Widget> list = [];
    centerRepository.showProgressDialog(context, Translations.current.loadingdata());
    restDatasource.getAllRoles().then((res) {
      if (res != null && res.length > 0) {
        centerRepository.dismissDialog(context);
        roles = res;

        for (var role in roles) {
          String name = role.roleName;
          String desc = role.description;
          selectedRoleId=role.roleId;
          list.add( Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            color: Colors.white70,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(3.0)),
            ),
            child:
            ListTile(
              title: Text(name, style: TextStyle(fontSize: 16.0,)),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Translations.current.description(),style: TextStyle(fontSize: 16.0,),),
                  Text(desc,
                    style: TextStyle(fontSize: 20.0,),),
                ],
              ),
              leading: FlatButton(
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Icon(Icons.done_outline, size: 28.0, color: Colors.green),
                onPressed: () {
                  changeRole(userId,role.roleId);
                /*  _changeRole(user.userId, role.roleId).then((value) {
                    if (value)
                      Navigator.pop(context);
                  });*/
                },
              ),
              /* trailing:  FlatButton(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Text(Translations.current.cancel()),
              onPressed: () {
                Navigator.pop(context);
              },
            )*/
            ),
          ));
        }

      }

    });
    return list;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(16),
      child:
      Column(children: [
        Expanded(
          child: ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Text(Translations.current.rolesTitle(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .subhead),
                  trailing: Text(" ",
                      style:
                      Theme
                          .of(context)
                          .textTheme
                          .headline),
                  onTap: () {
                  },
                ),

              ),
              Card(
                child: ExpansionTile(

                    title: Text(
                        Translations.current.plzSelectNewRole()),
                    children: createRolesList(context,userId)),
              )
            ],
          ),
        ),
      ],
      ),
    );
  }
}
