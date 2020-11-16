import 'package:anad_magicar/ui/screen/setting/security_settings_form.dart';
import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatefulWidget {

  bool fromMain=true;
  GlobalKey<ScaffoldState> scaffoldKey;
  SecuritySettingsScreen({
    @required this.fromMain,
    @required this.scaffoldKey
  });
  @override
  _SecuritySettingsScreenState createState() {
    return _SecuritySettingsScreenState();
  }


}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SecuritySettingsForm(fromMain: widget.fromMain,scaffoldKey: widget.scaffoldKey,);
  }
}
