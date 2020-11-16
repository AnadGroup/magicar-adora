import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';




class LoginTwoPage extends StatelessWidget {

  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30.0,),
          CircleAvatar(child: Image.asset('assets/img/login-tick.png'), maxRadius: 50, backgroundColor: Colors.transparent,),
          SizedBox(height: 20.0,),
          _buildLoginForm(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: (){
                /*  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => SignupOnePage()
                  ));*/
                Navigator.pushReplacementNamed(context, '/register');
                },
                shape: Border.all(color: Colors.blueAccent,style: BorderStyle.solid,width: 1.0),
                color: Colors.transparent,
                child: Text(Translations.of(context).register(), style: TextStyle(color: Colors.blue, fontSize: 18.0)),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: RoundedDiagonalPathClipper(),
                child: Container(
                  height: 380,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90.0,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          style: TextStyle(color: Colors.blue),
                          decoration: InputDecoration(
                            hintText: Translations.of(context).userName(),
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.supervised_user_circle, color: Colors.blue,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.blue.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          style: TextStyle(color: Colors.blue),
                          decoration: InputDecoration(
                            hintText: Translations.of(context).password(),
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)),borderSide: BorderSide(color: Colors.blueAccent,width: 0.5,style: BorderStyle.solid)),
                            icon: Icon(Icons.lock, color: Colors.blue,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.blue.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(padding: EdgeInsets.only(right: 20.0),
                            child: Text("Forgot Password",
                              style: TextStyle(color: Colors.black45),
                            )
                          )
                        ],
                      ),
                      SizedBox(height: 10.0,),

                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.blue.shade600,
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              Container(
                height: 400,
                child: Stack(
                children: <Widget>[
                Row(
                  children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                    child: Text(Translations.of(context).login(), style: TextStyle(color: Colors.white70)),
                    color: Colors.blue,
                  ),
                ),

                ]
              ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    child:
                    /*Align(
                      alignment: Alignment.bottomRight,
                      child:*/ RaisedButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                      child: Text(Translations.of(context).register(), style: TextStyle(color: Colors.white70)),
                      color: Colors.greenAccent,
                      // ),
                    ),
                  ),
                    ]
                )
              )
            ],
          ),
        );
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _buildPageContent(context),
      );
    }
}
