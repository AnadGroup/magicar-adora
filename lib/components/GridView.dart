import 'dart:core' as prefix0;
import 'dart:core';

import 'package:anad_magicar/components/animstepper/stepper.dart';
import 'package:anad_magicar/components/switch_button.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:anad_magicar/components/CircleImage.dart';


class GridViewLayout extends StatefulWidget {
  static List<dynamic> items;
  List<Map> cats;
  static int count_of_grid=items.length;
  String type='';
  Function onItemTapFunc;

  @override
  GridViewLayoutState createState() {
    // TODO: implement createState
    return new GridViewLayoutState();
  }

  GridViewLayout({
    items,
    @required this.cats,
    @required this.type,
    @required this.onItemTapFunc,
  });

}

class GridViewLayoutState extends State<GridViewLayout> {

  //GridViewLayoutState(items,this.type,this.cats,this.onItemTapFunc);

  bool enableCoolStuff=true;

  Widget _gridView(List<dynamic> itemList) {
    return  GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(4.0),
      childAspectRatio: 8.0 / 9.0,
      children: itemList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return gridView(widget.cats);
  }


  void _toggle() {
    setState(() {
      enableCoolStuff = !enableCoolStuff;
    });
  }

  gridView(List<Map> cats) {

    return new GridView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: cats.length,
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 0.8),
        itemBuilder: (BuildContext context, int index) {
          return
            GridTile(
              child: new GestureDetector(
                child:
                Card(
                  color: Color(0xff616161),
                  child: Column(

                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                          width: MediaQuery.of(context).size.width/3.0,
                          height: 450.0,
                          decoration: myBoxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              //  Expanded(

                              //      child: ClipRRect(
                              //         borderRadius: BorderRadius.circular(2.0),

                              //         child:  CachedNetworkImage(
                              //                        placeholder: (context, url) => CircularProgressIndicator(),
                              //                         imageUrl:cats[index]['image'],
                              //                         fit: BoxFit.cover,
                              //                         errorWidget: (context,url,error) => Image.asset('assets/images/no_image.png'),
                              //                       )),//Image.asset(collections[index]['image'], fit: BoxFit.cover))
                              // ),
                              //             new Hero(

                              // tag: cats[index],
                              // child:
                              new Container(

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(new Radius.circular(1.0)),
                                  color: Color(0xff616161),
                                ),
                                height: 30.0,

                                child:
                                new Container(
                                  width: MediaQuery.of(context).size.width/4.0,
                                  height: 28.0,
                                  child: SwitchlikeCheckbox(checked: enableCoolStuff),
                                  /*StepperTouch(
                                    initialValue: 0,
                                    direction: Axis.horizontal,
                                    withSpring: false,
                                    baseColor: Colors.black26,
                                    leftImage: 'assets/images/disable.png',
                                    rightImage: 'assets/images/enable.png',
                                    leftTitle: Translations.current.disable(),
                                    rightTitle:  Translations.current.enable(),
                                    showIcon: true,
                                    onChanged: (int value) => print('new value $value'),
                                  )*/
                                ),
                               /* new Container(
                                    height: 100.0,
                                    margin: EdgeInsets.all(2.0),
                                    padding: EdgeInsets.all(1.0),
                                    child: new CircleImage(height: 80.0,width: 80.0,radius: 50.0, imageUrl: cats[index]['image'],)
                                ),*/
                              ),
                              // ),


                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.0,),
                      Text( cats[index]['title'],
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.subhead.merge(TextStyle(color: Colors.grey.shade600,fontSize: 13.0))),
                      SizedBox(height: 1.0,),
                    ],
                  ),
                ),

                onTap: () {
                    _toggle();
                    widget.onItemTapFunc();
                },
              ),

            );
        });
  }


  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 0.5,
        color: Colors.pinkAccent,
      ),

      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //         <--- border radius here
      ),
    );
  }
}
//         CustomScrollView(
//   slivers: List.generate(
//       10,
//       (item) => SliverGrid(
//             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 150.0,
//               mainAxisSpacing: 10.0,
//               crossAxisSpacing: 10.0,
//               childAspectRatio: 4.0,
//             ),
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 return Container(
//                   alignment: Alignment.center,
//                   color: Colors.amber[100 * (index % 9)],
//                   child: Text('grid item $index'),
//                 );
//               },
//               childCount: 6,
//             ),
//           )),
// )
// }


// class ItemCard extends StatelessWidget {
//   const ItemCard({Key key, this.item}) : super(key: key);
//   final ProductCategoryModel item;

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle textStyle = Theme.of(context).textTheme.display1;
//         return Card(
//           color: Colors.white,
//           child: Center(child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Icon(choice.icon, size:80.0, color: textStyle.color),
//                 Text(choice.title, style: textStyle),
//           ]
//         ),
//       )
//     );
//   }
// }
