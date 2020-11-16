import 'dart:async';


import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/pull_refresh/pull_to_refresh.dart' ;
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:flutter/rendering.dart';
import 'package:anad_magicar/ui/screen/home/home.dart';
import 'package:anad_magicar/widgets/transform_page_utils.dart';


import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';





/*class AppBarCollaps extends StatefulWidget {
  ScrollController _controller;
  Color clr;
  List menus=new List();
  //List<Container> homePages;
  bool engineStatus;
  bool lockStatus;
  AppBarCollaps(this._controller, this.clr,this.menus,this.engineStatus,this.lockStatus);

  @override
  AppBarCollapsState createState() {
    return new AppBarCollapsState();
  }

}*/

class AppBarCollaps extends StatelessWidget {


  RefreshController _refreshController = RefreshController(initialRefresh: false);

  ScrollController _controller;
  Color clr;
  static Size screenSize;
  //List menus=new List();
  List<Container> carPages;
  bool engineStatus;
  bool lockStatus;
  int currentIndex;
  NotyBloc<Message> carPageNoty;
  Color currentColor;
  AppBarCollaps(this._controller,
      this.clr,
      this.carPages,
      this.engineStatus,
      this.lockStatus,
      this.carPageNoty,
      this.currentColor,
      this.currentIndex,
      this.carCount);
 // static Size screenSize;
  List<String> mItems=['>','<',];

  int carCount;


  @override
  Widget build(BuildContext context) {
    centerRepository.fetchGPSStatus();
    return
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.82,
              margin: EdgeInsets.only(top: 1.0),
              child: carCount > 0 ?
              new Swiper(
                loop: false,
                itemCount: carCount,
                scale: 1.0,
                curve: Curves.bounceInOut,
                outer: true,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1.0,
                duration: 3,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return carPages[index];
                },
                index: currentIndex > -1 ? currentIndex : 0,
                autoplay: false,
                controller: new SwiperController(),
                fade: 0.4,
                transformer: new ThreeDTransformer(),
                pagination: new SwiperPagination(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.all(5.0),
                    builder: SwiperPagination.dots),


                onIndexChanged: (index) {
                  carPageNoty.updateValue(
                      new Message(type: 'CARPAGE', index: index,));
                },
              ) :
              NoDataWidget(noCarCount: true,),
            ),
            /*Positioned(
              child: Container(
                color: Colors.blueAccent.withOpacity(0.0),
                height: 68.0,
            child:
              AppBar(
                flexibleSpace: Container(
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.0),
                  ),
                ),
                brightness: Brightness.light,
                title: Text("Transparent AppBar"),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                    tooltip: 'Share',
                  ),
                ],
              ),
            ),
            ),*/
            //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ],
       // ),
   // },
       // ),
        //),
          );
    //);
/*
      },
    );*/

  }
  pageChangeCallback(int page) {
    print(page);
  }
  updateTypeCallback(UpdateType updateType) {
    print(updateType);
  }

}


