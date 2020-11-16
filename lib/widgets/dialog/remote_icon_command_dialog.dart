import 'package:flutter/material.dart';
import 'package:sy_flutter_widgets/sy_flutter_widgets.dart';

class RemoteIconCommandDialog extends StatefulWidget {
  final String title;
  final int itemClickedId;
  final Function callback;

  const RemoteIconCommandDialog(this.title, this.itemClickedId, this.callback);

  @override
  State<StatefulWidget> createState() => RemoteIconCommandDialogState();
}

class RemoteIconCommandDialogState extends State<RemoteIconCommandDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  List<String> _allIconsCommand = [];
  List<String> _allIconsCommand0 = [
    "assets/images/adora/r5_off.png",
    "assets/images/adora/r1_off.png",
    "assets/images/adora/aux_one.png",
    "assets/images/adora/r2_off.png",
    "assets/images/adora/aux_two.png",
    "assets/images/adora/r6_off.png",
    "assets/images/adora/adora_eo1_off.png",
    "assets/images/adora/r4_off.png",
  ];
  List<String> _allIconsCommand1 = [
    "assets/images/adora/r5_off.png",
    "assets/images/adora/r1_off.png",
    "assets/images/adora/aux_one.png",
    "assets/images/adora/r2_off.png",
    "assets/images/adora/aux_two.png",
    "assets/images/adora/r6_off.png",
    "assets/images/adora/adora_eo2_off.png",
    "assets/images/adora/r4_off.png",
  ];
  List<String> _allIconsCommand2 = [
    "assets/images/adora/r5_off.png",
    "assets/images/adora/r1_off.png",
    "assets/images/adora/aux_one.png",
    "assets/images/adora/r2_off.png",
    "assets/images/adora/aux_two.png",
    "assets/images/adora/r6_off.png",
    "assets/images/adora/adora_do2_off.png",
    "assets/images/adora/r4_off.png",
  ];
  List<String> _allIconsCommand3 = [
    "assets/images/adora/r5_off.png",
    "assets/images/adora/r1_off.png",
    "assets/images/adora/aux_one.png",
    "assets/images/adora/r2_off.png",
    "assets/images/adora/aux_two.png",
    "assets/images/adora/r6_off.png",
    "assets/images/adora/adora_do1_off.png",
    "assets/images/adora/r4_off.png",
  ];

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.forward();
    _allIconsCommand = getDefaultImageList(widget.itemClickedId);
  }

  /// return list of icons related by [RemoteSetting] button icon
  List<String> getDefaultImageList(int index) {
    switch (widget.itemClickedId) {
      case 0:
        return _allIconsCommand0;
      case 1:
        return _allIconsCommand1;
      case 2:
        return _allIconsCommand2;
      case 3:
        return _allIconsCommand3;
      default:
        return _allIconsCommand0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              width: 250,
              height: 300,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                // image: DecorationImage(
                //     image: AssetImage("assets/images/car.png"),
                //     fit: BoxFit.cover,
                //     alignment: Alignment.topCenter),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 30.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 8.0, right: 8.0),
                    child: Text(widget.title,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
                      child: Center(
                        child: GridView.builder(
                            itemCount: _allIconsCommand0.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 50,
                              mainAxisSpacing: 0.1,
                            ),
                            itemBuilder: (ctx, index) => Container(
                                  width: 60,
                                  height: 60,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context, true);
                                      widget.callback(_allIconsCommand[index]);
                                    },
                                    child: Image.asset(
                                      _allIconsCommand[index],
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                )),
                      ),
                    ),
                  ),
                  // Container(
                  //   alignment: Alignment.bottomRight,
                  //   padding: EdgeInsets.only(right: 5.0),
                  //   child: FlatButton(
                  //       onPressed: () {
                  //         Navigator.pop(context, true);
                  //       },
                  //       child: Text(
                  //         widget.buttonTitle,
                  //         style: TextStyle(color: Colors.red, fontSize: 15.0),
                  //       )),
                  // )
                ],
              )),
        ),
      ),
    );
  }
}
