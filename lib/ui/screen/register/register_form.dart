import 'dart:convert';

import 'package:anad_magicar/components/add_car_button.dart';
import 'package:anad_magicar/components/flushbar/flushbar.dart';
import 'package:anad_magicar/components/skip_button.dart';
import 'package:anad_magicar/components/slide_button.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/add_car_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/ui/screen/car/register_car_screen.dart';
import 'package:anad_magicar/ui/screen/login/confirm_login.dart';
import 'package:anad_magicar/ui/screen/profile/profile2.dart';
import 'package:anad_magicar/ui/screen/register/confirm_car_form.dart';
import 'package:anad_magicar/ui/screen/register/fancy_register/src/models/login_data.dart';
import 'package:anad_magicar/ui/screen/register/fancy_register_form.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:anad_magicar/widgets/flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anad_magicar/bloc/register/register.dart';
import 'package:anad_magicar/bloc/register/register_bloc.dart';
import 'package:anad_magicar/components/confirm_login_form.dart';
import 'package:anad_magicar/components/input_text.dart';
import 'package:anad_magicar/components/loading_indicator.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
//import 'package:slide_button/slide_button.dart';
//import 'package:anad_magicar/ui/login/confirm_login.dart';



class RegisterForm extends StatefulWidget
{

  String mobile;
  bool isEdit;
  ValueChanged<String> onChanged;
  RegisterBloc bloc;

  RegisterForm({this.bloc,this.mobile,this.isEdit});

  @override
  _RegisterContainerState createState() {
    return _RegisterContainerState();
  }


}
class _RegisterContainerState extends State<RegisterForm> with TickerProviderStateMixin {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _controller;
  AnimationController formAnimationController;
  List<Animation> formAnimations;
  Animation buttonAnimation;
  Animation<Offset> pulseAnimation;

  //RegisterBloc registerBloc;
  int index=1;
  User user;
  bool isRegisterBtnDisabled=false;
  _lastNameChanged(value)
  {
    user.lastName=value;
  }

  _mobileChanged(value)
  {
    user.mobile= value;//UserRepository.convertArabicToEnglish(value);
  }
  _firstNameChanged(value)
  {
    user.firstName=value;
  }
 _passwordChanged(value)
 {
   user.passWord=value;
 }
  _buildLastName(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: 45,
          margin: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          padding: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(10)
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0.0
                )
              ]
          ),
          child:
          InputText(
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintText:Translations.of(context).lastName() ,
            labelText: Translations.of(context).lastName(),
            errorText: 'نام خانوادگی الزامی است',
            onChangedValue: (value) => _lastNameChanged(value),

          )

        //  TextField(

        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
        //     border: InputBorder.none,
        //     icon: Icon(Icons.person_pin,
        //         color: Colors.blueAccent[100],
        //     ),
        //     hintStyle: TextStyle(color: Colors.pinkAccent[100]),
        //       hintText: Translations.of(context).lastName(),

        //   ),

        //   onChanged: (value){
        //     user.lastName=value;
        //   },
        // ),


      ),
    );
  }

  _buildMobile(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: 45,
          margin: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          padding: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(10)
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0.0
                )
              ]
          ),
          child:
          InputText(
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintText:Translations.of(context).mobile() ,
            labelText: Translations.of(context).mobile(),
            errorText: 'موبایل الزامی است',
            onChangedValue: (value) => _mobileChanged(value),

          )
        //  TextField(
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
        //     border: InputBorder.none,
        //     icon: Icon(Icons.person_pin,
        //         color: Colors.blueAccent[100],
        //     ),
        //     hintStyle: TextStyle(color: Colors.pinkAccent[100]),
        //       hintText: Translations.of(context).mobile(),
        //   ),
        //   onChanged: (value){
        //     user.mobile=value;
        //   },
        // ),


      ),
    );
  }

  _buildPassword(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        margin: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).password(),
          ),
          onChanged: (value){
            user.passWord=value;
          },
        ),


      ),
    );
  }
  _buildRePassword(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        margin: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).reTypePassword(),
          ),
          onChanged: (value){
            user.reTypePassword=value;
          },
        ),


      ),
    );
  }


  _buildFirstName(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: 45,
          padding: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          margin: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(10)
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0.0
                )
              ]
          ),
          child:
          InputText(
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintText:Translations.of(context).firstName() ,
            labelText: Translations.of(context).firstName(),
            errorText: 'نام الزامی است',
            onChangedValue: (value) => _firstNameChanged(value),

          )

        //  TextField(
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
        //     border: InputBorder.none,
        //     icon: Icon(Icons.person_pin,
        //         color: Colors.blueAccent[100],
        //     ),
        //     hintStyle: TextStyle(color: Colors.pinkAccent[100]),
        //       hintText: Translations.of(context).firstName(),
        //   ),
        //   onChanged: (value){
        //     user.firstName=value;
        //   },
        // ),


      ),
    );
  }



  _buildTel(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 45,
        margin: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0
              )
            ]
        ),
        child:
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4.0,bottom: 0.0,),
            border: InputBorder.none,
            icon: Icon(Icons.person_pin,
              color: Colors.blueAccent[100],
            ),
            hintStyle: TextStyle(color: Colors.pinkAccent[100]),
            hintText: Translations.of(context).phone(),
          ),
          onChanged: (value){
           // user.tel=value;
          },
        ),


      ),
    );
  }




  _buildRegister() {
    return SlideTransition(
        position: pulseAnimation,
        child:
        Container(
          margin: EdgeInsets.only(bottom: 2.0,left: 5.0,right: 5.0),
          height: 48,

          width: MediaQuery.of(context).size.width/3.5,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent
                ],
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(25.0)
              )
          ),
          child:
          Center(
            child:
            RaisedButton(
              onPressed: () {
                SaveUserModel userModel=new SaveUserModel(UserName: user.userName,
                    FirstName: user.firstName, LastName: user.lastName,
                    MobileNo: user.mobile,
                    Password: user.passWord,
                    SimCard: null, UserId: null);
                if(!isRegisterBtnDisabled)   BlocProvider.of<RegisterBloc>(context).add(new LoadRegisterEvent(userModel,context,false));
                isRegisterBtnDisabled=true;

              },
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              child: Text(Translations.of(context).register(), style: TextStyle(color: Colors.blueAccent)),
              color: Colors.transparent,
            ),
          ),
        )





    );
  }

  _buildExit() {
    return SlideTransition(
        position: pulseAnimation,
        child:
        Container(
          margin: EdgeInsets.only(bottom: 2.0,left: 5.0,right: 5.0),
          height: 48,
          width: MediaQuery.of(context).size.width/3.5,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent
                ],
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(25.0)
              )
          ),
          child:
          Center(
            child:
            RaisedButton(
              onPressed: (){
                Navigator.popAndPushNamed(context, '/login');
              },
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              child: Text(Translations.of(context).exit(), style: TextStyle(color: Colors.blueAccent)),
              color: Colors.transparent,
            ),
          ),
        )





    );
  }


  void _modalBottomSheet(User user){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return ConfirmLogin(user: user);
        }
    );
  }

  Future<String> _addUser(LoginData data) async{
    return Future.delayed(new Duration(microseconds: 200)).then((_) {
      if(data!=null &&
          data.name.isNotEmpty &&
          data.firstName.isNotEmpty &&
          data.lastName.isNotEmpty &&
          data.mobile.isNotEmpty)
      {
        SaveUserModel user=new SaveUserModel(
          UserName: data.name,
            FirstName:  data.firstName,
            LastName:  data.lastName,
            MobileNo: data.mobile,
            Password: data.password
        );


        try {
          centerRepository.showProgressDialog(
              context, Translations.current.loadingdata());
          if ((widget.isEdit != null && !widget.isEdit) ||
              widget.isEdit == null) {
            UserRepository userRepository = new UserRepository();
            userRepository.register(
                user: user).then((result) {
              SaveMagicarResponeQuery savedUser=result;
              centerRepository.dismissDialog(context);

              if (savedUser != null &&
                  savedUser.isSuccessful) {
                centerRepository.showFancyToast(savedUser.message,true);
                if (savedUser.carId != null &&
                    savedUser.carId > 0) {
                  centerRepository.setCarIds(savedUser.carId);
                }

                if (savedUser.userId != null &&
                    savedUser.userId > 0) {
                  CenterRepository.setUserId(savedUser.userId);
                  centerRepository.setUserIds(savedUser.userId);
                  prefRepository.setLoginedUserId(savedUser.userId);
                  prefRepository.setLoginedUserName(user.UserName);
                  prefRepository.setLoginedFirstName(user.FirstName);
                  prefRepository.setLoginedLastName(user.LastName);
                  prefRepository.setLoginedMobile(user.MobileNo);
                  prefRepository.setLoginedPassword(user.Password);
                  prefRepository.setUserRoleId(savedUser.roleId);
                }

                Navigator.pushNamed(context,'/addcar',arguments:  new AddCarVM(
                    notyBloc: null,
                    fromMainApp: false) );

              }
              else {
                centerRepository.showFancyToast(savedUser.message,false);
              }
            });
          }
          else {
            restDatasource.editUserProfile(user).then((result) {
              if (result != null) {
                centerRepository.showFancyToast(result.Message,true);
                if (result.IsSuccessful) {
                  Navigator.pushNamed(context, ProfileTwoPageState.route,
                      arguments: centerRepository.getUserInfo());
                }
                else {
                  Navigator.pushReplacementNamed(context, '/myprofile');
                  return result.Message;

                }
              }
            });
          }
        }
        catch(ex) {}
      }
      else
      {
        return 'لطفا اطلاعات را بطور کامل وارد نمایید!';
      }
      return null;
    });
  }


  Future<Widget> loadNextScreen() async{
    var result=await centerRepository.loadInitData(true);
   if(result!=null) {
     centerRepository.dismissDialog(context);
     return RegisterCarScreen(fromMainApp: false, addCarVM: new AddCarVM(

         notyBloc: null,
         fromMainApp: false));
   }
   else {
     return centerRepository.showProgressDialog(context, Translations.current.loadingdata());
   }
  }
  @override
  void dispose() {
    //registerBloc.close();
    formAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
    user=new User();
   // FlashHelper.init(context);
    //registerBloc=new RegisterBloc();
    formAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    double start = index * 0.1;
    double duration = 0.6;
    double end = duration + start;
    formAnimations=[new Tween<double>(begin: 800.0, end: 0.0).animate(
        new CurvedAnimation(
            parent: formAnimationController,
            curve: new Interval(start, end, curve: Curves.decelerate))),
      new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: formAnimationController,
              curve: new Interval(start*2, end, curve: Curves.decelerate)))];
    buttonAnimation = new CurvedAnimation(
        parent: formAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));


    pulseAnimation = Tween<Offset>(
      begin: Offset(6, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: formAnimationController,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.ease,
        ),
      ),
    );
    formAnimationController.forward();

  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return /*BlocListener(
        bloc: widget.bloc,
        listener: (BuildContext context, RegisterState state) {
      if(state is RegisteredState){
       if(widget.isEdit!=null && widget.isEdit) {
         centerRepository.dismissDialog(context);
         centerRepository.showFancyToast(
             Translations.current.editProfileSuccessful());
         Navigator.pushNamed(context, ProfileTwoPageState.route,
             arguments: centerRepository.getUserInfo());
       }
      }
    },
    child:
      BlocBuilder<RegisterBloc, RegisterState>(
        bloc: widget.bloc,
        builder: (
            BuildContext context,
            RegisterState currentState,
            ) {
          if(currentState is InRegisterState ||
          currentState is LoadRegisterState)
          {
            isRegisterBtnDisabled=true;
            centerRepository.showProgressDialog(context, Translations.current.plzWaiting());
            //RxBus.post(new ChangeEvent(type: 'REGISTER_LOADING',message: ''));

          }
          else if(currentState is InRegisterSMSAuthState)
            {
              _modalBottomSheet(new User());
            }
         else if(currentState is RegisteredState) {
            isRegisterBtnDisabled=false;
            centerRepository.dismissDialog(context);
            if(widget.isEdit==null || (widget.isEdit!=null && !widget.isEdit)) {
                  return RegisterCarScreen(
                      fromMainApp: false, addCarVM: new AddCarVM(
                      notyBloc: null,
                      fromMainApp: false));
            }
            else{
            // FlashHelper.successBar(context, message: Translations.current.editProfileSuccessful());
             //centerRepository.showFancyToast(Translations.current.editProfileSuccessful());
            }
          }
        else  if(currentState is ErrorRegisterState)
          {
            centerRepository.dismissDialog(context);
            isRegisterBtnDisabled=false;
            //RxBus.post(new ChangeEvent(type: 'REGISTER_FAILED',message: currentState.errorMessage));
           // FlashHelper.errorBar(context, message: currentState.errorMessage);
            centerRepository.showFancyToast(currentState.errorMessage);
          }*/
            FancyRegisterForm(
            isEdit: widget.isEdit,
            mobile: widget.mobile,
            authUser: _addUser,
            recoverPassword: null,
            onSubmit: () { /*gotoAddCar();*/ },


    );

  }


  goBack()
  {
    Navigator.of(context).pushReplacementNamed('/login');
  }
 Widget showLoading()
  {
    return new Stack(
      children: [
        new Center(
            child: new SpinKitCubeGrid(color: Colors.blueAccent,size: 80.0,)
        ),

      ],
    );
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(context: context,
        builder: (BuildContext context) {
          return
            new Container(
              //height: 350.0,
              color: Colors.transparent,
              child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child:
                new Column(
                 // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ListTile(leading: new Icon(Icons.close),
                      title: new Text(Translations.current.addCarFormTitle()),
                      onTap: () => null,
                    ),
                    GestureDetector(
                      onTap: () {/*onAddCarTap();*/},
                      child:
                    new AddCarButton(),
                    ),
                    new GestureDetector(
                      onTap: () {/*onSkipTap();*/},
                      child:
                    new SkipButton(),
                    ),
                  ],
                ),
              ),
            );

        });
  }

   _showModalBottomSheetCar(BuildContext context) {
    //var myModel=Provider.of(context).value;
   // _controller =  _scaffoldKey.currentState.showBottomSheet(
     return BlocProvider.value
       (
        value: BlocProvider.of<RegisterBloc>(context),
       child:ConfirmCarForm(),
     );
        /*builder: (context){
          return  ConfirmCarForm(); *//**//*
        }
    );*/
  }

  showSnackLogin(BuildContext context,String message,bool isLoading)
  {
    Scaffold.of(context).showSnackBar(
        new SnackBar(duration: new Duration(seconds: 1), content:
        new Row(
          children: <Widget>[
            isLoading ?  new CircularProgressIndicator() :
            new Icon(Icons.error_outline,color: Colors.amber,),
            new Text(message)
          ],
        ),
        ));
  }

}
