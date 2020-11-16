import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/ui/screen/login/reset/fancy_login/src/models/login_data.dart';
import 'package:anad_magicar/ui/screen/login/reset/reset_form.dart';
import 'package:anad_magicar/widgets/flutter_offline/flutter_offline.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  ResetScreen({Key key}) : super(key: key);

  @override
  _ResetScreenState createState() {
    return _ResetScreenState();
  }
}

class _ResetScreenState extends State<ResetScreen> {
  NotyBloc<NotyLoadingVM> loadingNoty;
  bool hasInternet = true;

  Future<String> _onSignUp(LoginData data) {
    return Future.delayed(new Duration(microseconds: 100)).then((_) {
      if (data.password != null &&
          data.currentPassword != null &&
          data.confrimPassword != null &&
          data.password.isNotEmpty &&
          data.currentPassword.isNotEmpty &&
          data.confrimPassword.isNotEmpty) {
        return '';
      }
      return 'NOTOK';
    });
  }

  Future<String> _onReset(LoginData data) {
    return Future.delayed(new Duration(microseconds: 100)).then((_) {
      if (data.password != null &&
          data.currentPassword != null &&
          data.confrimPassword != null &&
          data.password.isNotEmpty &&
          data.currentPassword.isNotEmpty &&
          data.confrimPassword.isNotEmpty) {
        // widget.resetFunc(data);
        return '';
      }
      return 'NoOK';
    });
  }

  _toggle() {
    Navigator.of(context).pop(false);
  }

  @override
  void initState() {
    super.initState();
    loadingNoty = new NotyBloc<NotyLoadingVM>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            hasInternet = connectivity != ConnectivityResult.none;
            if (connectivity == ConnectivityResult.none) {
              loadingNoty.updateValue(NotyLoadingVM(
                  isLoading: false,
                  hasLoaded: false,
                  haseError: false,
                  hasInternet: hasInternet));
            }
            return child;
          },
          child:
              //BaseFormWidget<LoginData>(
              Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: ResetForm(),
          ),
          /*leftFunc: null,
      leftIcon: Icon(Icons.done_outline,color: Colors.redAccent,size: 20.0,),
      rightFunc: _toggle(),
        rightIcon: Icon(Icons.keyboard_backspace,color: Colors.redAccent,size: 20.0,),*/
          //),
        ),
        FormsAppBar(
          onBackPress: () {
            Navigator.of(context).pop();
          },
          actionIcon: null,
          loadingNoty: loadingNoty,
        )
      ],
    );
  }
}
