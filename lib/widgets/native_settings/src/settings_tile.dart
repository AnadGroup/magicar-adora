import 'package:anad_magicar/widgets/native_settings/src/cupertino_settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum _SettingsTileType { simple, switchTile }

class SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final VoidCallback onTap;
  //final ValueChanged onChange;
  final Function(bool value) onToggle;
  final bool switchValue;
  final _SettingsTileType _tileType;
  final double leftPadding;
  final double rightPadding;

  const SettingsTile({
    Key key,
    @required this.title,
    this.subtitle,
    this.leading,
    this.leftPadding,
    this.rightPadding,
    this.onTap,
  })  : _tileType = _SettingsTileType.simple,
        onToggle = null,
        switchValue = null,
        super(key: key);

  const SettingsTile.switchTile({
    Key key,
    this.leftPadding,
    this.rightPadding,
    @required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    @required this.onToggle,
    @required this.switchValue,
  })  : _tileType = _SettingsTileType.switchTile,
        // onTap = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return iosTile();
    } else {
      return androidTile();
    }
  }

  Widget iosTile() {
    if (_tileType == _SettingsTileType.switchTile) {
      return CupertinoSettingsItem(
        type: SettingsItemType.toggle,
        label: title,
        leading: leading,
        switchValue: switchValue,
        onToggle: onToggle,
      );
    } else {
      return CupertinoSettingsItem(
        type: SettingsItemType.modal,
        label: title,
        value: subtitle,
        hasDetails: true,
        leading: leading,
        onPress: onTap,
      );
    }
  }

  Widget androidTile() {
    if (_tileType == _SettingsTileType.switchTile) {
      return
          /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            Padding(
            padding: EdgeInsets.only(left: 20.0,right: 10.0),
        child:
                leading,
            ),
            Padding(
            padding: EdgeInsets.only(left: 20.0,right: 1.0),
         child:
         Text(title,textAlign: TextAlign.justify,textDirection: TextDirection.rtl,),),

        Padding(
        padding: EdgeInsets.only(left: leftPadding,right: rightPadding),
        child:GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {onTap();},
    child:
        SwitchlikeCheckbox(checked:  switchValue,),),),
              ],
            );*/
          SwitchListTile(
        // activeThumbImage: AssetImage('assets/images/on.png'),
        //inactiveThumbImage: AssetImage('assets/images/off.png'),
        //activeTrackColor: Colors.deepOrangeAccent,
        dense: true,
        // inactiveTrackColor: Colors.black54,
        secondary: leading,
        value: switchValue,
        onChanged: onToggle,
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
      );
    } else {
      return ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        leading: leading,
        onTap: onTap,
      );
    }
  }
}
