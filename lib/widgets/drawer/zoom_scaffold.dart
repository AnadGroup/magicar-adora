import 'package:flutter/material.dart';
import 'package:anad_magicar/data/fake_helper.dart';
import 'package:anad_magicar/widgets/curved_navigation_bar.dart';

class ZoomScaffold extends StatefulWidget {

  final Widget menuScreen;
  final Layout contentScreen;

  ZoomScaffold({
    this.menuScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}
ScrollController _controller;
class _ZoomScaffoldState extends State<ZoomScaffold> with TickerProviderStateMixin {

  MenuController menuController;



  Curve scaleDownCurve = new Interval(0.0, 0.83, curve: Curves.bounceOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.bounceOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.bounceIn);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.bounceIn);

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )
      ..addListener(() => setState(() {}));
  }

  Color clr = Colors.lightGreen;
  _scrollListener() {

    if (_controller.offset > _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        clr = Colors.red;
      });
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        clr = Colors.lightGreen;
      });
    }

  }
  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  createContentDisplay() {
    return zoomAndSlideContent(
      new Container(
          child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              backgroundColor: Colors.blueAccent,
              elevation: 0.0,
              leading: new IconButton(
                  icon: new Icon(Icons.menu, color: Colors.white,),
                  onPressed: () {
                    menuController.toggle();
                  }
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/request');
                  },
                  icon: Icon(Icons.add_circle, color: Colors.white,),
                )
              ],
            ),
            body: widget.contentScreen.contentBuilder(context),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.blueAccent[400],
              items: <Widget>[
                Icon(Icons.accessibility, size: 30),
                Icon(Icons.sync_problem, size: 30),
                Icon(Icons.view_list, size: 30),
                Icon(Icons.shopping_cart, size: 30),
                Icon(Icons.account_circle, size: 30),
              ],
              onTap: (index) {
                //Handle button tap
                onNavButtonTap(index);
              },

            ),
          )
      ),
    );
  }

  void onNavButtonTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/coachs');
    }
    else if(index==4)
      {
        Navigator.pushReplacementNamed(context, '/myprofile',arguments: null);
      }
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    final slideAmount = -205.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 16.0 * menuController.percentOpen;

    return new Transform(
      transform: new Matrix4
          .translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
     //origin: Offset(slideAmount /2,slideAmount/2),
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*return new Directionality (
        textDirection: TextDirection.ltr,
        child: new Builder(builder: (BuildContext context) {*/
          return Stack(
            children: [
              Container(child: Scaffold(body: widget.menuScreen,),),
              createContentDisplay()
            ],
          );
        //});
   // );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {

  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState extends State<ZoomScaffoldMenuController> {

  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  getMenuController(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(
        new TypeMatcher<_ZoomScaffoldState>()
    ) as _ZoomScaffoldState;
    return scaffoldState.menuController;
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }

}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context,
    MenuController menuController
    );

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 500)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}