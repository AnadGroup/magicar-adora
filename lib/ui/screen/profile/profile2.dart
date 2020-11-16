import 'dart:io';

import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/components/GMenu.dart';
import 'package:anad_magicar/components/image_picker_handler.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/content_pager/page_container.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/curved_navigation_bar.dart';
import 'package:flutter/material.dart';



class ProfileTwoPage extends StatefulWidget {
  SaveUserModel user;

  ProfileTwoPage({
    @required this.user,
  });

  @override
  ProfileTwoPageState createState() {
    return ProfileTwoPageState();
  }


}
class ProfileTwoPageState extends MainPage<ProfileTwoPage>
    with TickerProviderStateMixin,ImagePickerListener{

  static final route='/myprofile';
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  bool isDark=false;

  List<Map> collections =new List();


  User user2;
  String fullName="";
  Future<bool> getAppTheme() async{
    int dark=await changeThemeBloc.getOption();
    setState(() {
      if(dark==1)
        isDark=true;
      else
        isDark=false;
    });

  }
loaduser(Future<User> usr) async
{
    user2=await usr ;
    fullName=user2.userName;
}


  loadProfileImage() async
  {
    String path=await prefRepository.getProfileImagePath();
    if(!DartHelper.isNullOrEmpty(path))
      {
        setState(() {
          _image=File(path);
        });

      }
  }

/*  @override
  void initState() {
    super.initState();

    getAppTheme();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    loadProfileImage();
    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();
  }*/


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
}

 /* @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        body: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade300, Colors.indigo.shade500]
              ),
            ),
          ),
          ListView.builder(
            physics:new PageScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 3,
            itemBuilder: _mainListBuilder,
          ),

        ],
        ),

        *//*bottomNavigationBar: CurvedNavigationBar(
          index: 2,
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
            CenterRepository.onNavButtonTap(context, index);
          },
        ),*//*
    );
  }*/

  Widget _mainListBuilder(BuildContext context, int index) {
    if(index==0) return _buildHeader(context);
    if(index==1) return _buildSectionHeader(context);
    //if(index==2) return _buildCollectionsRow();
    if(index==3) return Container(
      //color: Colors.white,
      padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
      child: Text("",
        style: Theme.of(context).textTheme.title
      )
    );
    //return _buildListItem();
  }

  Widget _buildListItem() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: Image.asset('assets/images/user2.png', fit: BoxFit.fill),
      ),
    );
  }

  Container _buildSectionHeader(BuildContext context) {
    return Container(
      //color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: (){ centerRepository.goToPage(context, '/editprofile'); },
            child:Text(Translations.of(context).edit(), style: Theme.of(context).textTheme.title,),
          ),
          FlatButton(
            onPressed: (){
              if (PageContentState.lastRouteSelected != null &&
                PageContentState.lastRouteSelected.isNotEmpty)
              Navigator.pushNamed(context, '/main');
              },
            child: Text(Translations.of(context).goBack(), style: TextStyle(color: Colors.blue),),
          )
        ],
      ),
    );
  }

  Container _buildCollectionsRow() {
    return Container(
      color: Colors.white,
      height: 280.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            width: 150.0,
            height: 280.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(collections[index]['image'], fit: BoxFit.cover))
                ),
                SizedBox(height: 5.0,),
                Text(collections[index]['title'], style: Theme.of(context).textTheme.subhead.merge(TextStyle(color: Colors.grey.shade600)))
              ],
            )
          );
        },
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      height: 380.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 40.0, right: 40.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              //color: Colors.white,
              child: Column(
                children: <Widget>[
                  // SizedBox(height: 50.0,),
                  // Text(fullName, style: Theme.of(context).textTheme.title,),
                  // SizedBox(height: 5.0,),
                  // Text(user2!=null ? user2.mobile : ""),
                  // SizedBox(height: 5.0,),
                  // Text(user2!=null ? user2.code : ""),
                  // SizedBox(height: 16.0,),
                  SizedBox(height: 80.0,),
                  Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(widget.user!=null && !DartHelper.isNullOrEmpty(widget.user.MobileNo) ? widget.user.MobileNo : "موبایل",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,),),
                            subtitle: Text(Translations.of(context).mobile(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12.0,color: Colors.redAccent) ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(widget.user!=null ? widget.user.UserName : 'کد کاربری',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(Translations.current.userName().toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12.0) ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(widget.user!=null ? widget.user.FirstName : "نام",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,),),
                            subtitle: Text(Translations.of(context).firstName(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0,color: Colors.redAccent) ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(widget.user!=null ? widget.user.LastName : 'نام خانوادگی',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(Translations.current.lastName().toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0) ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  imagePicker.showDialog(context);
                },
              child: _image==null ?
              new ClipOval(
                child: new Container(
                  width: 180.0,
                  height: 120.0,
                child:
                new Image.asset( 'assets/images/user.jpg',),
              ),
              ) :
              new ClipOval(
                child: new Container(
                  width: 180.0,
                  height: 120.0,
                  child:
                  new  Image.file(_image),//Image.asset( 'assets/images/user.jpg',),
                ),
              )
              ),
            ],
          ),
        ],
      ),
    );
  }

  _editForm()
  {
    /*Widget _buildNameField(double width, LoginMessages messages) {
      return AnimatedTextFormField(
        width: width,
        loadingController: _loadingController,
        interval: _nameTextFieldLoadingAnimationInterval,
        labelText: messages.usernameHint,
        prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        //validator: widget.emailValidator,
        onSaved: (value) => _authData['userName'] = value,
      );
    }*/
  }

  _showBottomSheetCars(BuildContext cntext, SaveUserModel user)
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return null;
        });
  }

  @override
  userImage(File _image) {
    setState(() {
      prefRepository.setProfileImagePath(_image.path);
      this._image=_image;
    });
    return this._image;
  }

  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    return null;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }
  @override
  bool doBack() {
    // TODO: implement doBack
    return true;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return null;
  }

  @override
  getScafoldState(int action) {
    // TODO: implement getScafoldState
    return null;
  }

  @override
  Widget getTitle() {
    // TODO: implement getTitle
    return null;
  }

  @override
  initialize() {
    // TODO: implement initialize
    getAppTheme();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    loadProfileImage();
    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();
    return null;
  }

  @override
  Function onBack() {
    // TODO: implement onBack
    if (PageContentState.lastRouteSelected != null &&
        PageContentState.lastRouteSelected.isNotEmpty)
      Navigator.pushNamed(context, '/main');
    return null;
  }
  @override
  bool showMenu() {
    // TODO: implement showMenu
    return false;
  }
  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.indigo.shade300, Colors.indigo.shade500]
            ),
          ),
        ),
        ListView.builder(
          physics:new PageScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 3,
          itemBuilder: _mainListBuilder,
        ),

      ],
    );
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return CenterRepository.lastPageSelected;
  }

  @override
  bool showBack() {
    // TODO: implement showBack
    return false;
  }
}
