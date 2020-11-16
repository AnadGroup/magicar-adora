library hidden_drawer_menu;

export 'package:anad_magicar/ui/hiddendrawer/hidden_drawer/screen_hidden_drawer.dart';
export 'package:anad_magicar/ui/hiddendrawer/menu/hidden_menu.dart';
export 'package:anad_magicar/ui/hiddendrawer/menu/item_hidden_menu.dart';
export 'package:anad_magicar/ui/hiddendrawer/controllers/hidden_drawer_controller.dart';
export 'package:anad_magicar/ui/hiddendrawer/simple_hidden_drawer/bloc/simple_hidden_drawer_bloc.dart';
export 'package:anad_magicar/ui/hiddendrawer/simple_hidden_drawer/animated_drawer_content.dart';
export 'package:anad_magicar/ui/hiddendrawer/simple_hidden_drawer/simple_hidden_drawer.dart';



import 'package:flutter/material.dart';
import 'package:anad_magicar/ui/hiddendrawer/hidden_drawer/screen_hidden_drawer.dart';
import 'package:anad_magicar/ui/hiddendrawer/menu/hidden_menu.dart';
import 'package:anad_magicar/ui/hiddendrawer/menu/item_hidden_menu.dart';
import 'package:anad_magicar/ui/hiddendrawer/simple_hidden_drawer/simple_hidden_drawer.dart';

class HiddenDrawerMenu extends StatelessWidget {

  /// List item menu and respective screens
  final List<ScreenHiddenDrawer> screens;

  /// position initial item selected in menu( sart in 0)
  final int initPositionSelected;

  /// Decocator that allows us to add backgroud in the content(color)
  final Color backgroundColorContent;

  //AppBar
  /// enable auto title in appbar with menu item name
  final bool whithAutoTittleName;

  /// Style of the title in appbar
  final TextStyle styleAutoTittleName;

  /// change backgroundColor of the AppBar
  final Color backgroundColorAppBar;

  ///Change elevation of the AppBar
  final double elevationAppBar;

  ///Change iconmenu of the AppBar
  final Widget iconMenuAppBar;

  /// Add actions in the AppBar
  final List<Widget> actionsAppBar;

  /// Set custom widget in tittleAppBar
  final Widget tittleAppBar;

  //Menu
  /// Decocator that allows us to add backgroud in the menu(img)
  final DecorationImage backgroundMenu;

  /// that allows us to add backgroud in the menu(color)
  final Color backgroundColorMenu;

  /// that allows us to add shadow above menu items
  final bool enableShadowItensMenu;

  /// enable and disable open and close with gesture
  final bool isDraggable;

  final Curve curveAnimation;

  final double slidePercent;

  /// percent the content should scale vertically
  final double verticalScalePercent;

  /// radius applied to the content when active
  final double contentCornerRadius;

  /// anable animation Scale
  final bool enableScaleAnimin;

  /// anable animation borderRadius
  final bool enableCornerAnimin;

  final Widget bottomNavigationBar;

  final Widget solidBottomSheet;
  HiddenDrawerMenu({
    this.screens,
    this.initPositionSelected = 0,
    this.backgroundColorAppBar,
    this.elevationAppBar = 4.0,
    this.iconMenuAppBar = const Icon(Icons.menu,color: Colors.redAccent,),
    this.backgroundMenu,
    this.backgroundColorMenu,
    this.backgroundColorContent = Colors.white,
    this.whithAutoTittleName = true,
    this.styleAutoTittleName,
    this.actionsAppBar,
    this.tittleAppBar,
    this.enableShadowItensMenu = false,
    this.curveAnimation = Curves.decelerate,
    this.isDraggable = true,
    this.slidePercent = 80.0,
    this.verticalScalePercent = 80.0,
    this.contentCornerRadius = 10.0,
    this.enableScaleAnimin = true,
    this.enableCornerAnimin = true,
    this.bottomNavigationBar,
    this.solidBottomSheet
  });

  @override
  Widget build(BuildContext context) {

    return SimpleHiddenDrawer(
      isDraggable: isDraggable,
      curveAnimation: curveAnimation,
      slidePercent: slidePercent,
      verticalScalePercent: verticalScalePercent,
      contentCornerRadius: contentCornerRadius,
      enableCornerAnimin: enableCornerAnimin,
      enableScaleAnimin: enableScaleAnimin,
      menu: buildMenu(),
      screenSelectedBuilder: (position,bloc){
        return Scaffold(
          backgroundColor: backgroundColorContent,
          /*appBar: AppBar(
            backgroundColor: backgroundColorAppBar,
            elevation: elevationAppBar,
            title: getTittleAppBar(position),
            leading: new IconButton(
                icon: iconMenuAppBar,
                onPressed: () {
                  bloc.toggle();
                }),
            actions: actionsAppBar,
          ),*/
          body: Stack(
            overflow: Overflow.visible,
            children: <Widget> [
              screens[position].screen,
              Positioned(
                child: Container(
                  color: Colors.blueAccent.withOpacity(0.0),
                  height: 88.0,
                  child:
                  AppBar(
                    flexibleSpace: Container(
                      height: 2.0,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.0),
                      ),
                    ),
                    brightness: Brightness.light,
                    backgroundColor: backgroundColorAppBar,
                    elevation: elevationAppBar,
                    title: getTittleAppBar(position),
                    titleSpacing: 0.0,
                    actions: actionsAppBar,
                    leading: new IconButton(
                        icon: iconMenuAppBar,
                        onPressed: () {
                          bloc.toggle();
                        }),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: bottomNavigationBar ,
          bottomSheet: solidBottomSheet,
        );
      },
    );

  }

  getTittleAppBar(int position) {
    if (tittleAppBar == null) {
      return whithAutoTittleName
          ? Text(screens[position].itemMenu.name,
          style: styleAutoTittleName,
      )
          : Container();
    } else {
      return tittleAppBar;
    }
  }

  buildMenu() {

    List<ItemHiddenMenu> _itensMenu = new List();

    screens.forEach((item) {
      _itensMenu.add(item.itemMenu);
    });

    return HiddenMenu(
      itens: _itensMenu,
      background: backgroundMenu,
      backgroundColorMenu: backgroundColorMenu,
      initPositionSelected: initPositionSelected,
      enableShadowItensMenu: enableShadowItensMenu,
    );
  }

}