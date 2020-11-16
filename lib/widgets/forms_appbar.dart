import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/magicar_appbar.dart';
import 'package:anad_magicar/widgets/magicar_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FormsAppBar extends StatefulWidget {

  Icon actionIcon;
  NotyBloc<NotyLoadingVM> loadingNoty;
  Function onBackPress;
  Function onIconFunc;
  FormsAppBar({Key key,
    this.onIconFunc,
    this.onBackPress,
    this.loadingNoty,
  this.actionIcon}) : super(key: key);

  @override
  _FormsAppBarState createState() {
    return _FormsAppBarState();
  }
}

class _FormsAppBarState extends State<FormsAppBar> {


  NotyLoadingVM notyLoadingVM;
  @override
  void initState() {
    super.initState();
    //loadingNoty=new NotyBloc<NotyLoadingVM>();
    notyLoadingVM=new NotyLoadingVM(
        isLoading: false,
        hasLoaded: false,
        haseError: false,
    hasInternet: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<NotyLoadingVM>(
      stream: widget.loadingNoty.noty,
      initialData: null,
      builder: (BuildContext c, AsyncSnapshot<NotyLoadingVM> data) {
        if (data != null && data.hasData) {
          notyLoadingVM=data.data;
        }
        return
          Positioned(
            child:
            new MagicarAppbar(
              backgroundColorAppBar: Colors.transparent,
              title: new MagicarAppbarTitle(
                currentColor: Colors.indigoAccent,
                actionIcon: widget.actionIcon,
                actionFunc: (){ widget.onIconFunc();},
              ),
              actionsAppBar: [
              notyLoadingVM.isLoading ?
              new Row(
              children: <Widget>[
              new Column(
            children: <Widget>[
            new SpinKitDualRing(
              color: Colors.blueAccent, size: 25.0,),
            ],
          ),
        ],
        ) :
                  notyLoadingVM.haseError ?
                  new Row(
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new SpinKitDualRing(
                            color: Colors.redAccent, size: 25.0,),
                        ],
                      ),
                    ],
                  )  :
                  new Container(width: 0.0,height: 0.0,)  ,
         notyLoadingVM.hasInternet ?
         new Container(width: 0.0,height: 0.0,) :
         new Row(
           children: <Widget>[
             new Container(width: 48.0,height: 48.0,
             child:
             Image.asset('assets/images/no_internet.png'),),
            ],
        ),
        ],
        elevationAppBar: 0.0,
        iconMenuAppBar: Icon(Icons.arrow_back,color: Colors.indigoAccent,),
        toggle: () { widget.onBackPress();} ,
        )
        ,
        );
      },
    );
  }
}
