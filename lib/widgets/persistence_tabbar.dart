import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/service/main_service_page.dart';
import 'package:anad_magicar/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';


class MainPersistentTabBar extends StatelessWidget {

  Widget page1;
  Widget page2;
  Widget fab;
  List<Widget> actions;
  TabController tabController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  MainPersistentTabBar({
    @required this.page1,
    @required this.page2,
    @required this.tabController,
    @required this.actions,
    @required this.scaffoldKey,
    @required this.fab
  });

  String route=MainPageServiceState.route;
  final String imageUrl = 'assets/images/user_profile.png';
  String userName='';
  int userId=0;
  bool isDark=false;
  int _selectedIndex = 2;
  int _currentCarId=0;

  getUserName() async {
    userName=await prefRepository.getLoginedUserName();
    userId=await prefRepository.getLoginedUserId();
    CenterRepository.setUserId(userId);
    centerRepository.setUserCached(new User(userName: userName,
        imageUrl: imageUrl,id: userId),);
  }

  onCarPageTap(BuildContext context) {
    Navigator.of(context).pushNamed('/carpage',arguments: new CarPageVM(
        userId: userId,
        isSelf: true,
        carAddNoty: valueNotyModelBloc));
  }

  Widget getTitle() {
    return new Text(Translations.current.services(),style: TextStyle(fontSize: 12,color: Colors.blueAccent),);
  }

  @override
  Widget build(BuildContext context) {
    getUserName();
   // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
       // key: scaffoldKey,
        floatingActionButton: fab,
        /*drawer: AppDrawer(
          userName: userName,
          currentRoute: route,
          imageUrl: imageUrl,
          carPageTap: () { onCarPageTap(context);},
          carId: _currentCarId,),*/
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
          icon: Icon(Icons.menu,color: Colors.blueAccent,),
        onPressed: (){
          scaffoldKey.currentState.openDrawer();
        },
      ),
          actions: actions,
          bottom: TabBar(
            labelColor:  Colors.blueAccent,
            unselectedLabelColor: Colors.black38,
            isScrollable: false,
            tabs: [
              Tab(
                icon: Icon(Icons.done_all,color: Colors.blueAccent,),
                text: Translations.current.done(),
              ),
              Tab(icon: Icon(Icons.close,color: Colors.blueAccent), text: Translations.current.notDone()),

            ],
          ),
          centerTitle: true,
          title: MainPage.createCarInfoWidget(context,getTitle()), //Text(Translations.current.services()),
        ),
        body: TabBarView(
         // controller: tabController,
          physics: BouncingScrollPhysics(),
          children: [
            page1,
            page2
          ],
        ),
      ),
    );
  }


}
