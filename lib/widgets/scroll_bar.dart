import 'package:flutter/material.dart';
Widget build(BuildContext context) {
  //get the screen width

}

class ScrollStatusBar extends StatefulWidget {
  @override
  _ScrollBar createState() {
    // TODO: implement createState
    return _ScrollBar();
  }
}

class _ScrollBar extends State<ScrollStatusBar> {
  double cWidth = 0.0;
  double itemHeight = 28.0;
  double itemsCount = 20;
  double screenWidth;

  final controller = ScrollController();
  //final primaryController=PrimaryScrollController.of(context);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 24,//status bar height
          width: cWidth,
          color: Colors.green,
        ),
        Flexible(
          child: ListView(
            controller: PrimaryScrollController.of(context),
            children: List.generate(
                20,
                    (index) => ListTile(
                  title: Text(index.toString()),
                )),
          ),
        ),
      ],
    );
  }
  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  onScroll() {
    setState(() {
      cWidth = controller.offset * screenWidth / (itemHeight * itemsCount);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onScroll);
  }
}