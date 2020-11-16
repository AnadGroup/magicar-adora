import 'package:anad_magicar/components/GridView.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {

  void onItemTap(){}
  List<Map<String,dynamic>> setItems=new List();

  _buildSettings(List<Map> items) {
    return Container(
        color: Color(0xff424242),
      height: 500.0,
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: new GridViewLayout(items: null,type: '', cats: items, onItemTapFunc: onItemTap)
      ,
    );
  }

  @override
  void initState() {
    super.initState();
    setItems=centerRepository.getSettingItems();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSettings(setItems);
  }
}
