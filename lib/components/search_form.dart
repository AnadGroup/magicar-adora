/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anad_magicar/bloc/search/index.dart';
import 'package:anad_magicar/translation_strings.dart';

import './InputFields.dart';

class SearchForm extends StatefulWidget
{


  SearchBloc searchBloc;
  SearchForm({this.searchBloc});

  @override
  SearchFormState createState() {
    
    return SearchFormState();
  }
  
}

class SearchFormState extends State<SearchForm> 
with TickerProviderStateMixin{

AnimationController formAnimationController;
Animation buttonAnimation;
Animation<Offset> pulseAnimation;
String message='';

String searchText='';
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

  _doSearch()
  {
    if(searchText.isNotEmpty)
    {
      widget.searchBloc.dispatch(new LoadSearchEvent(searchText));
      //BlocProvider.of<SearchBloc>(context).dispatch(new LoadSearchEvent(searchText));

    }
    else{
      Scaffold.of(context).showSnackBar(new SnackBar(
        content:new Text('Translations.current.noResultForSearch()') ,

      ));
    }
  }
_buildDoSearch() {
    return SlideTransition(
      position: pulseAnimation,
      child: 
        Container(
                    margin: EdgeInsets.only(bottom: 2.0,left: 5.0,right: 5.0),
                    height: 48,
                    width: MediaQuery.of(context).size.width/2.5,
                    */
/*decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent[100],style: BorderStyle.solid,width: 0.5),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0)
                      )
                    ),*//*

                    child: 
                    Center(
                      child:

                      IconButton(icon: Icon( Icons.search,size: 40.0,color: Colors.greenAccent,),color: Colors.redAccent,iconSize: 48.0,onPressed: () {
                        _doSearch();
                      },),
                      */
/*RaisedButton(
                        onPressed: (){
                         //new SoapCustomer(context: context).call(SoapConstants.METHOD_NAME_CUSTOMER_LOGIN, 'MobileNo', mobile);
                         _doSearch();
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                        child: Text(Translations.of(context).search(), style: TextStyle(color: Colors.blueAccent)),
                        color: Colors.transparent,
                      ),*//*

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
                      */
/*decoration: BoxDecoration(
                          border: Border.all(color: Colors.pinkAccent[100],style: BorderStyle.solid,width: 0.5),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.transparent
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(3.0)
                          )
                      ),*//*

                      child: Center(
                        child: IconButton(icon: Icon( Icons.close,size: 40.0,color: Colors.redAccent,),color: Colors.redAccent,iconSize: 48.0,onPressed: () {
                        Navigator.pushReplacementNamed(context,'/home');
                        },),
                        */
/*RaisedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                          child: Text(Translations.of(context).exit(), style: TextStyle(color: Colors.blueAccent)),
                          color: Colors.transparent,
                        )*//*

                      ),
                    ),
      
    );
  }

  _buildSearch(){
    return  SlideTransition(
      position: pulseAnimation,
      child:  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
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
                        icon: Icon(Icons.search,
                            color: Colors.blueAccent[100],
                        ),
                        hintStyle: TextStyle(color: Colors.pinkAccent[100]),
                          hintText: Translations.of(context).search(),
                      ),
                      onChanged: (value){
                        this.searchText=value;
                      },
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
  height: MediaQuery.of(context).size.height/2.9,
        child: 
        
        ListView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
          Container(
              width: w,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade900,
                    Colors.blueAccent
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
                    child: Icon(Icons.search,
                      size: 15,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                          right: 5
                        ),
                        child: Text(Translations.of(context).search(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),
            Container(
            
      height: 90.0,
              width: w,
              padding: EdgeInsets.only(top: 25),
              child:
            Column(
              children: <Widget> [
                    _buildSearch(),
                  ]
            ),
            ),     
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  _buildDoSearch(),
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
    widget.searchBloc.dispose();
    super.dispose();
  }
}
*/
