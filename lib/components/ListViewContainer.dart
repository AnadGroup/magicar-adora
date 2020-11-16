import 'package:flutter/material.dart';
import 'List.dart';
import 'Calender.dart';
//import '../Screens/Home/styles.dart';

class ListViewContent extends StatelessWidget {
  final Animation<double> listTileWidth;
  final Animation<Alignment> listSlideAnimation;
  final Animation<EdgeInsets> listSlidePosition;
  ListViewContent({
    this.listSlideAnimation,
    this.listSlidePosition,
    this.listTileWidth,
  });
  @override
  Widget build(BuildContext context) {
    return (new Stack(
      alignment: listSlideAnimation.value,
      children: <Widget>[
        new Calender(margin: listSlidePosition.value * 6.5),
        new ListData(
            margin: listSlidePosition.value * 5.5,
            width: listTileWidth.value,
            title: "Yoga classes with Emily",
            subtitle: "7 - 8am Workout",
            ),
        new ListData(
            margin: listSlidePosition.value * 4.5,
            width: listTileWidth.value,
            title: "Breakfast with Harry",
            subtitle: "9 - 10am ",
            ),
        new ListData(
            margin: listSlidePosition.value * 3.5,
            width: listTileWidth.value,
            title: "Meet Pheobe ",
            subtitle: "12 - 1pm  Meeting",
            ),
        new ListData(
            margin: listSlidePosition.value * 2.5,
            width: listTileWidth.value,
            title: "Lunch with Janet and friends",
            subtitle: "2 - 3pm ",
            ),
        new ListData(
            margin: listSlidePosition.value * 1.5,
            width: listTileWidth.value,
            title: "Catch up with Tom",
            subtitle: "5 - 6pm  Hangouts",
            ),
        new ListData(
            margin: listSlidePosition.value * 0.5,
            width: listTileWidth.value,
            title: "Party at Hard Rock",
            subtitle: "8 - 12 Pub and Restaurant",
            ),
      ],
    ));
  }
}

//For large set of data

//import '../Screens/Home/data.dart';
// DataListBuilder dataListBuilder = new DataListBuilder();
// var i = dataListBuilder.rowItemList.length + 0.5;
// children: dataListBuilder.rowItemList.map((RowBoxData rowBoxData) {
//   return new ListData(
//     title: rowBoxData.title,
//     subtitle: rowBoxData.subtitle,
//     image: rowBoxData.image,
//     width: listTileWidth.value,
//     margin: listSlidePosition.value * (--i).toDouble(),
//   );
// }).toList(),
