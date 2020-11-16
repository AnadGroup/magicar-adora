import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/shimmer/myshimmer.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';

abstract class MainPage<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  Widget pageContent();
  String getCurrentRoute();
  int setCurrentTab();
  FloatingActionButton getFab();
  Widget getTitle();
  getScafoldState(int action);
  List<Widget> actionIcons();
  initialize();
  Function onBack();
  bool showBack();
  bool doBack();
  bool showMenu();

  GlobalKey<ScaffoldState> scaffoldKey; // = GlobalKey<ScaffoldState>();
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String imageUrl = 'assets/images/user_profile.png';
  int userId = 0;
  int _currentCarId;

  String userName = '';
  bool isDark = false;

  getUserName() async {
    userName = await prefRepository.getLoginedUserName();
    userId = await prefRepository.getLoginedUserId();

    centerRepository.setUserCached(
      new User(userName: userName, imageUrl: imageUrl, id: userId),
    );
  }

  loadLoginedUserInfo(int userId) async {
    List<SaveUserModel> result =
        await restDatasource.getUserInfo(userId.toString());
    if (result != null && result.length > 0) {
      SaveUserModel user = result.first;
      await prefRepository.setLoginedPassword(user.Password);
      await prefRepository.setLoginedFirstName(user.FirstName);
      await prefRepository.setLoginedLastName(user.LastName);
      await prefRepository.setLoginedMobile(user.MobileNo);
      await prefRepository.setLoginedUserName(user.UserName);
    }
  }

  Future<bool> getAppTheme() async {
    int dark = await changeThemeBloc.getOption();
    setState(() {
      if (dark == 1)
        isDark = true;
      else
        isDark = false;
    });
  }

  onCarPageTap() {
    Navigator.of(context).pushNamed('/carpage',
        arguments: CarPageVM(
            userId: userId, isSelf: true, carAddNoty: valueNotyModelBloc));
  }

  static Widget createCarInfoWidget(BuildContext context, Widget title) {
    CarStateVM carStateVM = centerRepository
        .getCarStateVMByCarId(CenterRepository.getCurrentCarId());
    if (carStateVM == null) {
      return NoDataWidget();
    }
    var widget = Container(
      margin: EdgeInsets.only(right: 0.0, top: 1.0, left: 0.0),
      width: MediaQuery.of(context).size.width * 0.40,
      height: 60.0,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.indigoAccent,
                    highlightColor: Colors.white,
                    direction: ShimmerDirection.rtl,
                    period: Duration(seconds: 3),
                    child: Container(
                        margin: EdgeInsets.only(right: 1.0),
                        height: 30.0,
                        child: Text(
                            DartHelper.isNullOrEmptyString(
                                carStateVM.brandTitle),
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.indigoAccent,
                    highlightColor: Colors.white,
                    direction: ShimmerDirection.rtl,
                    period: Duration(seconds: 3),
                    child: Container(
                      alignment: Alignment.topCenter,
                      /*width: MediaQuery
                      .of(context)
                      .size
                      .width / 3.0,*/
                      height: 30.0,
                      child: Text(
                        DartHelper.isNullOrEmptyString(carStateVM.modelTitle),
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      //),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.indigoAccent,
                    highlightColor: Colors.white,
                    direction: ShimmerDirection.ltr,
                    period: Duration(seconds: 3),
                    child: Container(
                      margin: EdgeInsets.only(left: 0.0),
                      height: 30.0,
                      child: Text(
                          DartHelper.isNullOrEmptyString(carStateVM.colorTitle),
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          title == null ? Container() : title,
        ],
      ),
    );
    return widget;
  }

  @override
  void initState() {
    getAppTheme();
    getUserName();
    initialize();
    loadLoginedUserInfo(userId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return doBack() ? true : false;
      },
      child: Scaffold(
        //key: scaffoldKey,
        floatingActionButton: getFab() != null ? getFab() : null,
        //drawer: AppDrawer(carPageTap: onCarPageTap,userName: userName,imageUrl: imageUrl,currentRoute: getCurrentRoute(),carId: CenterRepository.getCurrentCarId(),),
        /*bottomNavigationBar: CurvedNavigationBar(
        index: setCurrentTab()!=null ? setCurrentTab() : 2,
        height: 60.0,
        color: centerRepository.getBackNavThemeColor(!isDark),
        backgroundColor: centerRepository.getBackNavThemeColor(isDark),
        items: <Widget>[
          Icon(Icons.build, size: 30,color: Colors.indigoAccent),
          Icon(Icons.pin_drop, size: 30,color: Colors.indigoAccent),
          Icon(Icons.directions_car , size: 30,color:  Colors.indigoAccent),
          Icon(Icons.message, size: 30,color: Colors.indigoAccent),
          Icon(Icons.payment, size: 30,color: Colors.indigoAccent,),
        ],
        onTap: (index) {
          //Handle button tap
          CenterRepository.onNavButtonTap(context, index,carId: CenterRepository.getCurrentCarId());
        },
      ),*/
        /*appBar: (widget.fromMain==null || !widget.fromMain) ?
      AppBar(title: Text(Translations.current.appSettings())) :
         null ,*/
        body: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Align(
              alignment: Alignment(1, -1),
              child: Container(
                height: 70.0,
                child: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(
                    color: (!showMenu() && !showBack())
                        ? Colors.indigoAccent
                        : Colors.transparent, //modify arrow color from here..
                  ),
                  title: createCarInfoWidget(context, getTitle()),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: actionIcons() != null
                      ? actionIcons()
                      : <Widget>[
                          showBack()
                              ? IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.indigoAccent,
                                  ),
                                  onPressed: () {
                                    // onBack !=null ? onBack() :
                                    onBack();
                                  },
                                )
                              : Container(),
                        ],
                  leading: showMenu()
                      ? IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.indigoAccent,
                          ),
                          onPressed: () {
                            getScafoldState(1);
                          },
                        )
                      : null,
                ),
              ),
            ),
            pageContent()
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
