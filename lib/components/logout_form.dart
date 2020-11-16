import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/translation_strings.dart';

import './InputFields.dart';

class LogoutForm extends StatefulWidget
{

  User user;
 LogoutForm({this.user});

  @override
  _LogoutFormState createState() {

    return _LogoutFormState();
  }

}

class _LogoutFormState extends State<LogoutForm>
              with TickerProviderStateMixin{

AnimationController formAnimationController;
Animation buttonAnimation;
Animation<Offset> pulseAnimation;
String message='';

  @override
  void initState() {

    super.initState();


    formAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

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

  _logout() async {
    ServiceResult result = await restDatasource.logoutUser();
    if (result != null) {

      if(result.IsSuccessful) {
        centerRepository.showFancyToast(Translations.current.logoutSuccessful(),true);
        UserRepository userRepo = new UserRepository();
        userRepo
            .deleteToken(); //(username: widget.user.mobile,password: widget.user.password,code: widget.user.code);
        await prefRepository.setLoginStatus(true);
        await prefRepository.setLoginedToken("", "");
        await prefRepository.setLoginedUserId(0);
        await prefRepository.setProfileImagePath("");
        await prefRepository.setLoginTypeStatus(LoginType.PASWWORD);

        Navigator.pushReplacementNamed(context, '/login');
      }
      else{
          if(result.Message!=null)
            centerRepository.showFancyToast(result.Message,false);
          else
            centerRepository.showFancyToast(Translations.current.hasErrors(),false);
      }
  }
  }

_buildLogout() {
    return SlideTransition(
      position: pulseAnimation,
      child:
        Container(
                    margin: EdgeInsets.only(bottom: 2.0,left: 5.0,right: 5.0),
                    height: 48,
                    width: MediaQuery.of(context).size.width/2.5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(23.0)
                      )
                    ),
                    child:
                    Center(
                      child:
                      RaisedButton(
                        onPressed: (){
                         _logout();
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                        child: Text(Translations.of(context).confirm(), style: TextStyle(color: Colors.blueAccent)),
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
                      width:MediaQuery.of(context).size.width/2.5,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.pinkAccent[100],style: BorderStyle.solid,width: 0.5),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.transparent
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(23.0)
                          )
                      ),
                      child: Center(
                        child:
                        RaisedButton(
                          onPressed: (){
                           // Navigator.pushReplacementNamed(context, '/home');
                            Navigator.of(context).pop();
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                          child: Text(Translations.of(context).cancel(), style: TextStyle(color: Colors.blueAccent)),
                          color: Colors.transparent,
                        ),
                      ),
                    ),





    );
  }


  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
      double h=MediaQuery.of(context).size.height;
    return (
Container(
  margin: EdgeInsets.only(top: 60.0),
  color: Colors.white,
  height: h-50.0,
        child: /*Column(
          children: <Widget>[*/
        ListView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            children: <Widget>[

Container(
              width: w,
              height: 175.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.blueAccent.withOpacity(0.4)
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [

                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.question_answer,
                      size: 25,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Spacer(),

                  Align(
                    alignment: Alignment.center,
                      child: Padding(

                        padding: const EdgeInsets.only(
                          bottom: 5,
                          right: 5
                        ),
                        child: Text(Translations.current.logoutAccount(),
                          style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                            fontSize: 18.0
                          ),
                        ),
                      ),
                  ),
                   Spacer(),

                  Align(
                    alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                          right: 5
                        ),
                        child: Text(Translations.current.doYouRealyWantToExit(),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline.color,
                            fontSize: 16.0
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),
             SizedBox(
               height: 90.0,

             ),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  _buildLogout(),
                    _buildExit(),
                    ],
              ),
          ],
        ),
      )
    );
  }
  @override
  void dispose() {
    formAnimationController.dispose();
    super.dispose();
  }
}
