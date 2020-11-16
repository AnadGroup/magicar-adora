/*


import 'package:flutter/material.dart';
import 'package:anad_magicar/components/ListView.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/home/home.dart';
import 'package:anad_magicar/ui/styles.dart';
import 'package:anad_magicar/widgets/slider/carousel_slider.dart';

class ScrollPageWithAppBar extends StatelessWidget {

  ScrollController _controller;
  Color clr;
  static Size screenSize;
  List<Widget> content;
  String title;
  ScrollPageWithAppBar(this.content, this._controller, this.clr,this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScrollView(
      controller: _controller,
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          expandedHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(this.title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                )),
            // background: Colors.blueAccent,
            collapseMode: CollapseMode.parallax,
          ),
          backgroundColor: clr,
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, pos) => _buildRows(this.content,context,pos),
              childCount:content.length,


            )

        ),

      ],
    );

  }

  List createScrollContents(BuildContext context) {
    final List scrollContents = [
      Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.grey[50],
                Colors.grey[50],
                Colors.grey[50],
                Colors.grey[50],
              ],
            ),
          ),
          child: new Center(
              child: new Column(

                  children: <Widget>[
                    CarouselSlider(
                      items: childTouch,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      pauseAutoPlayOnTouch: Duration(seconds: 3),
                      enlargeCenterPage: false,
                      aspectRatio: 2.0,
                      autoPlayCurve: Curves.easeIn,
                      */
/*onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },*//*

                    )
                  ]
              )
          )
      ),
      Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.grey[50],
              Colors.grey[50],
              Colors.grey[50],
              Colors.grey[50],
            ],
          ),
        ),

        child:
        new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.adjust, size: 35.0, color: Colors.pink),

              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    Translations.of(context).coach(),
                    style: TextStyle(color: Colors.pink,
                        fontSize: 15,

                        fontWeight: FontWeight.w400),

                  )
              )
            ]
        ),

      ),
      Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.grey[50],
                Colors.grey[50],
                Colors.grey[50],
                Colors.grey[50],
              ],
            ),
          ),

          child:
          HorizontalListView(
            items: childListView,
            horizontal: true,
            width: 150,
            height: 150,
          )

      ),
      Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.grey[50],
              Colors.grey[50],
              Colors.grey[50],
              Colors.grey[50],
            ],
          ),
        ),

        child:
        new Row(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Icon(Icons.adjust, size: 35.0, color: Colors.pink),
              Align(
                  alignment: Alignment.center,
                  child:
                  new Text(
                    Translations.of(context).product(),
                    style: TextStyle(color: Colors.pink,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  )
              )
            ]
        ),

      ),
      Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.grey[50],
                Colors.grey[50],
                Colors.grey[50],
                Colors.grey[50],
              ],
            ),
          ),
          child: new Center(
              child: new Column(

                  children: <Widget>[
                    HorizontalListView(
                      items: childListView,
                      horizontal: true,
                      width: 150,
                      height: 150,
                    )
                  ]
              )
          )
      )
    ];
    return scrollContents;
  }

  Widget _buildRows(List<Widget> contents, BuildContext context,int pos)
  {
    screenSize = MediaQuery
        .of(context)
        .size;
    return  contents[pos];

  }
}*/
