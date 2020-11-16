
import 'package:anad_magicar/components/CircleImage.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/login/logout_dialog.dart';
import 'package:anad_magicar/ui/screen/profile/profile2.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/ui/screen/setting/security_settings_form.dart';
import 'package:anad_magicar/ui/screen/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/utils/dart_helper.dart';

//final String imageUrl = 'assets/images/user_profile.png';


Drawer buildDrawer(BuildContext context,
    String currentRoute,
    String userName,
    String imageUrl,
    Function onTap,
    String type) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.indigoAccent.withOpacity(0.8),
            backgroundBlendMode: BlendMode.darken,
            /*image: DecorationImage(
              image: AssetImage('assets/images/i26.png')
            )*/
          ),
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 38.0,
              child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/i26.png'),
              ],
            ),
            ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16,left: 5.0),
                child:new CircleImage(imageUrl: imageUrl,isLocal: true,width: 48.0,height: 48.0,)/*CircleAvatar(
                backgroundImage: new Image(image: imageUrl)
                 radius: 50.0,
                child : Image.asset(imageUrl),)*/,
              ),
              Text(DartHelper.isNullOrEmptyString( centerRepository.getUserInfo()!=null ?
              centerRepository.getUserInfo().UserName : userName),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
    ],
              ),
        ),
        ListTile(
          title:  Text(Translations.current.users()),
          subtitle: Divider(height: 1.0,color: Colors.grey,),
          leading: Icon(Icons.person_add, color: Theme.of(context).iconTheme.color, size: 20,),
          selected: currentRoute == UserPageState.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, UserPageState.route);
          },
        ),
        ListTile(
          title:  Text(Translations.current.car()),
          subtitle: Divider(height: 1.0,color: Colors.grey,),

          leading: Icon(Icons.directions_car, color: Theme.of(context).iconTheme.color, size: 20,),
          selected: currentRoute == CarPageState.route,
          onTap: () {
            //Navigator.pushReplacementNamed(context, CarPageState.route);
            onTap();
          },
        ),
        ListTile(
          title:  Text(Translations.current.security()),
          subtitle: Divider(height: 1.0,color: Colors.grey,),

          leading: Icon(Icons.security, color: Theme.of(context).iconTheme.color, size: 20,),
          selected: currentRoute == SecuritySettingsFormState.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, SecuritySettingsFormState.route,arguments: true);
          },
        ),
         ListTile(
          title:  Text(Translations.current.settings()),
           subtitle: Divider(height: 1.0,color: Colors.grey,),

           leading: Icon(Icons.settings, color: Theme.of(context).iconTheme.color, size: 20,),
          selected: currentRoute == SettingsScreenState.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, SettingsScreenState.route);
          },
        ),
        ListTile(
          title:  Text(Translations.current.profile()),
          subtitle: Divider(height: 1.0,color: Colors.grey,),

          leading: Icon(Icons.person_pin, color: Theme.of(context).iconTheme.color, size: 20,),
          selected: currentRoute == ProfileTwoPageState.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, ProfileTwoPageState.route,arguments: centerRepository.getUserInfo());
          },
        ),
        ListTile(
          title:  Text(Translations.current.exit()),
          leading: Icon(Icons.exit_to_app, color: Colors.black, size: 20,),
          selected: currentRoute == LogoutDialogState.route,
          onTap: () {
            Navigator.pushReplacementNamed(
                context, LogoutDialogState.route);
          },
        ),
        /*ListTile(
          title: const Text('Marker Anchors'),
          selected: currentRoute == MarkerAnchorPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MarkerAnchorPage.route);
          },
        ),
        ListTile(
          title: const Text('Plugins'),
          selected: currentRoute == PluginPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, PluginPage.route);
          },
        ),
        ListTile(
          title: const Text('ScaleBar Plugins'),
          selected: currentRoute == PluginScaleBar.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, PluginScaleBar.route);
          },
        ),
        ListTile(
          title: const Text('Offline Map'),
          selected: currentRoute == OfflineMapPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, OfflineMapPage.route);
          },
        ),
        ListTile(
          title: const Text('Offline Map (using MBTiles)'),
          selected: currentRoute == OfflineMBTilesMapPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(
                context, OfflineMBTilesMapPage.route);
          },
        ),
        ListTile(
          title: const Text('OnTap'),
          selected: currentRoute == OnTapPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, OnTapPage.route);
          },
        ),
        ListTile(
          title: const Text('Moving Markers'),
          selected: currentRoute == MovingMarkersPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MovingMarkersPage.route);
          },
        ),
        ListTile(
          title: const Text('Circle'),
          selected: currentRoute == CirclePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, CirclePage.route);
          },
        ),
        ListTile(
          title: const Text('Overlay Image'),
          selected: currentRoute == OverlayImagePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, OverlayImagePage.route);
          },
        ),*/
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.indigoAccent.withOpacity(0.8),
            backgroundBlendMode: BlendMode.darken,
            /*image: DecorationImage(
              image: AssetImage('assets/images/i26.png')
            )*/
          ),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 38.0,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Image.asset('assets/images/i26.png'),
                    Container(),
                  ],
                ),
              ),

            ],
          ),
        ),
      ],
    ),
  );
}
