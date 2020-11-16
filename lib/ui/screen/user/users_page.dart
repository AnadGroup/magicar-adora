import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/content_pager/page_container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:anad_magicar/components/car/car_utils.dart';
import 'package:anad_magicar/components/custom_progress_dialog.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_related_user_model.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/api_user_role.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/user/role.dart';
import 'package:anad_magicar/model/viewmodel/accessable_action_vm.dart';

import 'package:anad_magicar/model/viewmodel/car_info_vm.dart';
import 'package:anad_magicar/model/viewmodel/init_data_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {

  GlobalKey<ScaffoldState> scaffoldKey;

  UsersPage({this.scaffoldKey});

  @override
  UserPageState createState() {
    return UserPageState();
  }


}
class UserPageState extends MainPage<UsersPage> {
  static final route='/showusers';

  final GlobalKey<FormState> _formKey = GlobalKey();
  ProgressDialog _progressDialog;
  int _userCounts=0;
  RestDatasource restDatasource;
  Future<List<ApiRelatedUserModel>> users;
  List<ApiRelatedUserModel> relatedUsers=new List();
  List<SaveUserModel> userInfos=new List();
  List<ApiRelatedUserModel> relatedUsersResult=new List();
  List<CarInfoVM> carInfos=new List();
  Future<InitDataVM> initDataVM;
  InitDataVM resultData;
  Role _initRoleValue;
  int selectedRoleId=0;
  int roleId=0;
  Future<InitDataVM> getRelatedUsers() async
  {
    relatedUsers=new List();
    _progressDialog.showProgressDialog(context);
    int userId=await prefRepository.getLoginedUserId();
    roleId=await prefRepository.getUserRoleId();
    relatedUsers=await restDatasource.getRelatedUser(userId.toString());
    if(relatedUsers!=null) {
      _userCounts=relatedUsers.length;
      for(var us in relatedUsers) {
        List<SaveUserModel> usinfos=await restDatasource.getUserInfo(us.userId.toString());
        if(usinfos!=null &&
            usinfos.length>0)
        {
          userInfos.add(usinfos.first);
        }
      }
      resultData=new InitDataVM(
          carColor: null,
          carModel: null,
          carBrand: null,
          carDevice: null,
          carModels: null,
          carColors: null,
          carBrands: null,
          carDevices: null,
          carsToAdmin: null,
          relatedUsers: relatedUsers);
      if(userInfos!=null &&
          userInfos.length>0)
        return resultData;
    }
    else
    {
      relatedUsers=new List();
      userInfos=await restDatasource.getUserInfo(userId.toString());
      if(userInfos!=null &&
          userInfos.length>0)
      {
        _userCounts=1;
        roleId=await prefRepository.getUserRoleId();
        String roleTitle='';
        if(centerRepository.getRoles()!=null && centerRepository.getRoles().length>0) {
          var roles = centerRepository.getRoles().where((r) =>
          r.roleId == roleId).toList();
          if (roles != null && roles.length > 0) {
            roleTitle = roles.first.roleName;
          }

        }
        if(roleTitle==null || roleTitle.isEmpty){
          if(userInfos.first.roles!=null && userInfos.first.roles.length>0)
            roleTitle=userInfos.first.roles.first.RoleTitle;
        }
        relatedUsers.add(new ApiRelatedUserModel(userId: userInfos.first.UserId,
            userName: userInfos.first.UserName, roleTitle: roleTitle, roleId: roleId));
        resultData=new InitDataVM(
            carColor: null,
            carModel: null,
            carBrand: null,
            carDevice: null,
            carModels: null,
            carColors: null,
            carBrands: null,
            carDevices: null,
            carsToAdmin: null,
            relatedUsers: relatedUsers);
        return resultData;
      }
      return null;
    }
    return null;
  }

  loadCarToUser(int userId) {
    restDatasource.getAllCarsByUserId(userId).then((res){
      fillCarInfo(res);
      _showBottomSheetCars(context, carInfos);
      // return res;//.map<AdminCarModel>((r)=> AdminCarModel.fromJson(r)).toList();
    });

  }
  Future<InitDataVM> getRelatedUsersOffline() async
  {
    relatedUsers=new List();
    // _progressDialog.showProgressDialog(context);
    //int userId=await prefRepository.getLoginedUserId();
    relatedUsers= centerRepository.getRelatedUsers();
    if(relatedUsers!=null) {
      _userCounts=relatedUsers.length;

      resultData=new InitDataVM(
          carColor: null,
          carModel: null,
          carBrand: null,
          carDevice: null,
          carModels: null,
          carColors: null,
          carBrands: null,
          carDevices: null,
          carsToAdmin: null,
          relatedUsers: relatedUsers);
      return resultData;
    }
    return null;
  }
  /*getUserCounts() async {
    if(centerRepository.getCachedUserLoginedInfo()!=null)
      _userCounts=centerRepository.getCachedUserLoginedInfo().userCounts;
  }*/

  _toggle()
  {
    Navigator.of(context).pushNamed('/home');
  }

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


  fillCarInfo(List<AdminCarModel> carsToUser)
  {
    carInfos = new List();
    for (var car in carsToUser) {
      Car car_info = centerRepository
          .getCars()
          .where((c) => c.carId == car.CarId)
          .toList()
          .first;
      if (car_info != null){
        CarInfoVM carInfoVM = new CarInfoVM(
            brandModel: null,
            car: car_info,
            carColor: null,
            carModel: null,
            carModelDetail: null,
            brandTitle: car_info.brandTitle,
            modelTitle: car_info.carModelTitle,
            modelDetailTitle: car_info.carModelDetailTitle,
            color: '',
            carId: car_info.carId,
            Description: car_info.description,
            fromDate: car.FromDate,
            CarToUserStatusConstId: car.CarToUserStatusConstId,
            isAdmin: car.IsAdmin,
            userId: car.UserId);
        carInfos.add(carInfoVM);
      }
    }
  }

  showAccessableActions(int carId,int userId) {

    AccessableActionVM accessableActionVM=new AccessableActionVM(userModel: ApiRelatedUserModel(
        userId: userId,
        roleId: null,
        roleTitle: '',
        userName: ''
    ) , carId: carId);
    Navigator.of(context).pushNamed('/showuser' ,arguments: accessableActionVM);
  }

  toggle(){
    Navigator.pop(context);
  }

  _showBottomSheetCars(BuildContext cntext, List<CarInfoVM> carsVM)
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return CarWidgetFactory(cars: carInfos,carCounts: carInfos.length,
            isForAccessable: true,
            showAccessable:(carId,userId) { showAccessableActions(carId,userId); },
            toggle: toggle,
            addCar: null,) ;
        });
  }

  _showUser(AccessableActionVM accessableActionVM){
    // AccessableActionVM accessableActionVM=new AccessableActionVM(userModel: use, carId: null)
    Navigator.of(context).pushNamed('/showuser' ,arguments: accessableActionVM);
  }

  List<Widget> createRolesList(ApiRelatedUserModel user)  {
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
            //color: Colors.white70,
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
                child: Text(Translations.current.confirm(),style:TextStyle(fontSize: 10.0)),
                onPressed: () {
                  _changeRole(user.userId, role.roleId).then((value) {
                    if (value)
                      Navigator.pop(context);
                  });
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
  _showChangeRoleSheet(BuildContext cntext,ApiRelatedUserModel user )
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return  Container(
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
                          children: createRolesList(user)),
                    )
                  ],
                ),
              ),
            ],
            ),
          );
        });
  }

  List<Widget> getUsersTiles(List<ApiRelatedUserModel> users) {
    List<Widget> list = [];
    if (users != null) {

      for (ApiRelatedUserModel u in users) {

        SaveUserModel userInfo;
        if(userInfos!=null && userInfos.length>0)
          userInfo= userInfos.where((ui)=>ui.UserId==u.userId).toList().first;

        String name = userInfo!=null ? DartHelper.isNullOrEmptyString(userInfo.UserName)  : '';
        String roleTitle=u.roleTitle;
        list.add( Card(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          //color: Colors.white70,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(3.0)),
          ),
          child:
          new Column(
            children: <Widget>[
              ListTile(

                title: Text( name,style: TextStyle(fontSize: 20.0,)),
                subtitle:/*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text( Translations.current.roleTitle(),style: TextStyle(fontSize: 20.0,)),*/
                Text(roleTitle,style: TextStyle(fontSize: 20.0,),),
                /*],
          ),*/
                //leading: Container(width: 0.0,height: 0.0,),
                //leading:
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(
                        left: 2.0,
                        right: 5.0
                    ),
                    child:
                        Container(
                          width: 100.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            border: Border.all(color: Colors.pinkAccent,width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(25))
                          ),
                          child:
                    FlatButton(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(Translations.current.changeUserRole(),style: TextStyle(color: Colors.white, fontSize: 14.0,)),
                      onPressed: () {
                        _showChangeRoleSheet(context, u);
                      },
                    ),
                        ),
                  ),
                  Container(
                    width: 110.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(color: Colors.greenAccent,width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child:
                  FlatButton(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Text(Translations.current.showAccessablActions(),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),), //Icon(Icons.done_all,size: 28.0, color: Colors.red),
                    onPressed: () {
                      loadCarToUser(u.userId);
                    },
                  ),),
                ],
              ),
            ],
          ),
        ),
        );
      }
    }
    else
    {
      SaveUserModel userInfo;
      if(userInfos!=null && userInfos.length>0)
        userInfo= userInfos.first;
      ApiRelatedUserModel temp_user=new ApiRelatedUserModel(userId: userInfo.UserId,
          userName: userInfo.UserName,
          roleTitle: '', roleId: 0);
      String name = userInfo!=null ? DartHelper.isNullOrEmptyString(userInfo.UserName)  : '';
     var roles=centerRepository.getRoles().where((r)=>r.roleId==roleId);
      Role role=roles!=null ? roles.first : null;
      String roleTitle=role!=null ? role.roleName : 'نا مشخص';
      list.add( Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        // color: Colors.white70,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(3.0)),
        ),
        child:
        new Column(
          children: <Widget>[
            ListTile(

              title: Text( name,style: TextStyle(fontSize: 20.0,)),
              subtitle:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text( Translations.current.roleTitle(),style: TextStyle(fontSize: 20.0,)),
                  Text(roleTitle,style: TextStyle(fontSize: 20.0,),),
                ],
              ),
              //leading: Container(width: 0.0,height: 0.0,),
              //leading:
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /*new Padding(
                    padding: const EdgeInsets.only(
                        left: 2.0,
                        right: 5.0
                    ),
                    child:
                    FlatButton(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(Translations.current.changeUserRole(),style: TextStyle(fontSize: 14.0,)),
                      onPressed: () {
                        //_showChangeRoleSheet(context, );
                      },
                    ),
                  ),*/
                FlatButton(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: Text(Translations.current.showAccessablActions(),style: TextStyle(color: Colors.green,fontSize: 12.0),), //Icon(Icons.done_all,size: 28.0, color: Colors.red),
                  onPressed: () {
                    loadCarToUser(temp_user.userId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      );
    }
    return list;
  }

  Widget createBody(bool hasInternet)
  {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        new Card(
          margin: EdgeInsets.symmetric(vertical: 85.0, horizontal: 5.0),
          //color: Colors.white70,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(70.0),
                bottomLeft: Radius.circular(3.0)),
          ),
          child: _userCounts > 0 ? new Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 0.0,
              left: 2.0,
            ),
            child:
            Container(
              padding: EdgeInsets.all(16),
              child:
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            leading: Text(Translations.current.users(),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subhead),
                            trailing: Text(_userCounts.toString() + " ",
                                style:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .headline),
                            onTap: () {
                             /* Navigator.of(context).pushNamed('/addcar',arguments: new AddCarVM(notyBloc: null,
                                  fromMainApp: true));*/
                            },

                          ),

                        ),
                        hasInternet ? new Column(
                          children: <Widget>[
                            Card(
                              child: ExpansionTile(
                                  title: Text(
                                      Translations.current.userCounts() + " ( " +
                                          _userCounts.toString() +
                                          " ) "),
                                  children: getUsersTiles(relatedUsersResult)),
                            ),


                          ] ,) :
                        Card(
                          child: ExpansionTile(
                            initiallyExpanded: true,
                              title: Text(
                                  Translations.current.userCounts() + " ( " +
                                      _userCounts.toString() +
                                      " ) "),
                              children: getUsersTiles(relatedUsersResult)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ) :
          NoDataWidget(noCarCount: false,),
        ),
      /*  Positioned(
          child:
          new MagicarAppbar(
            backgroundColorAppBar: hasInternet ? Colors.transparent : Colors.transparent,
            title: new MagicarAppbarTitle(
              currentColor: Colors.indigoAccent,
              actionIcon: Icon(
                Icons.account_circle, color: Colors.indigoAccent,
                size: 20.0,),
              actionFunc: null,
            ),
            actionsAppBar: hasInternet ? null : [
              new Row(
                children: <Widget>[
                  Image.asset('assets/images/no_internet.png'),
                ],
              )
            ],
            elevationAppBar: 0.0,
            iconMenuAppBar: Icon(
              Icons.arrow_back, color: Colors.indigoAccent,),
            toggle: _toggle,
          ),
        ),*/
      ],
    );
  }


  @override
  String getCurrentRoute() {
    return '/showusers';
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return  FutureBuilder<InitDataVM>(
        future: initDataVM,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _progressDialog.dismissProgressDialog(context);
            relatedUsersResult = snapshot.data.relatedUsers;
            return
              createBody(true);
          }
          return NoDataWidget();
        }
    );
  }

  @override
  initialize() {
    scaffoldKey=widget.scaffoldKey;
    restDatasource=new RestDatasource();
    _progressDialog=new ProgressDialog();

    initDataVM=getRelatedUsers();
    return null;
  }

  @override
  FloatingActionButton getFab() {
    return null;
  }

  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    List<Widget> actions=<Widget>[
      IconButton(
        icon: Icon(Icons.arrow_forward,color: Colors.transparent,),
        onPressed: (){
          if(onBack !=null ) onBack();
          else
            Navigator.pushNamed(context, '/first');
        },
      ),
    ];
    return null;
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 2;
  }

  @override
  onBack() {
    // TODO: implement onBack
    if (PageContentState.lastRouteSelected != null &&
        PageContentState.lastRouteSelected.isNotEmpty)
      Navigator.pushNamed(context, '/main');
    return null;
  }
  @override
  bool doBack() {
    // TODO: implement doBack
    return true;
  }

  @override
  bool showBack() {
    // TODO: implement showBack
    return false;
  }
  @override
  bool showMenu() {
    // TODO: implement showMenu
    return false;
  }
  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return null;
  }
  @override
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    if(action==1) {
      widget.scaffoldKey.currentState.openDrawer();
    }
    return null;
  }
}
