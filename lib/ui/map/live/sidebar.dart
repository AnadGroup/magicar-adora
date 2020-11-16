import 'package:anad_magicar/ui/map/live/custom_cached_network_tile_ptovider.dart';
import 'package:anad_magicar/widgets/rounded_floating_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';
import 'package:geopoint/geopoint.dart';
import 'package:geopoint_location/geopoint_location.dart';

class _SideBarPageState extends State<SideBarPage> {

  String layer='anadbase';

  final List<String> carImgList = [
    "assets/images/car_red.png",
    "assets/images/car_blue.png",
    "assets/images/car_black.png",
    "assets/images/car_white.png",
    "assets/images/car_black.png",
    "assets/images/car_white.png",
  ];

  _SideBarPageState() {
    mapController = MapController();

    liveMapController = LiveMapController(
        autoCenter: true, mapController: mapController, verbose: true,autoRotate: true,positionStreamEnabled: true,
    updateTimeInterval: 1,
    updateDistanceFilter: 1,);
  }

  MapController mapController;
  LiveMapController liveMapController;

  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      /*NestedScrollView(
        headerSliverBuilder: (context, isInnerBoxScroll) {
          return [
            RoundedFloatingAppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.video_call),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: CircleAvatar(
                    child: FlutterLogo(
                      size: 18,
                    ),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {},
                ),
              ],
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              textTheme: TextTheme(
                title: TextStyle(
                  color: Colors.black,
                ),
              ),
              floating: true,
              snap: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Youtube",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
            ),
          ];
        },*/
         Stack(
          children: <Widget>[
            LiveMap(
              controller: liveMapController,
              center: LatLng(51.0, 0.0),
              zoom: 17.0,
            ),
         LiveMapSideBar(
           liveMapController: liveMapController,
         ),
         /*new FlutterMap(
           mapController: mapController,
         options: new MapOptions(
           minZoom: 0,
             maxZoom: 22,
             center: new LatLng(51.5, -0.09),
      zoom: 13.0,
    ),
    layers: [
    new TileLayerOptions(
      maxZoom: 22,
    tileSize: 256,
    tms: false,
    tileProvider: CachedNetworkTileProvider(),
    urlTemplate: "http://130.185.72.186:9090/geoserver/gwc/service/tms/1.0.0/anad:"+layer+"@EPSG:900913@png/{z}/{x}/{y}.png",

    ),
   *//* new MarkerLayerOptions(
    markers: [
    new Marker(
    width: 80.0,
    height: 80.0,
    point: new LatLng(51.5, -0.09),
    builder: (ctx) =>
    new Container(
    child: new FlutterLogo(),
    ),
    ),
    ],
    ),*//*
    ],
    ),*/

        /* FlutterMap(
         options: new MapOptions(
             center: new LatLng(51.506292, -0.114374),
      zoom: 13.0,
    ),
    layers: [
    new TileLayerOptions(
      urlTemplate: "https://api.tiles.mapbox.com/v4/"
          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoicmV6YW5kIiwiYSI6ImNrNWNkdnB2dDAwdGwzZnMwc2lhcTlxd3QifQ.61hONdUooWn7aBJs-Km8OA',
        'id': 'mapbox.streets',
      },
    ),
      new MarkerLayerOptions(
        markers: [
          new Marker(
            width: 80.0,
            height: 80.0,
            point: new LatLng(51.5, -0.09),
            builder: (ctx) =>
            new Container(
              child: new FlutterLogo(),
            ),
          ),
        ],
      ),
    ],
    ),*/
            Positioned(
              top: MediaQuery.of(context).size.height-100.0,
              right: 15,
              left: 15,
              child: Container(
                height: 80.0,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20.0,
                backgroundColor: Colors.blueAccent,
                child:
                    IconButton(
                      color: Colors.pinkAccent,
                      iconSize: 20.0,
                      icon: Icon(Icons.add),
                      onPressed: () => addGeoMarkerFromCurrentPosition(),
                    ),
                    ),
                    IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    Text('خودروی شماره: '+(widget.carNo+1).toString()),
                    /*Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 15),
                            hintText: "جستجو..."),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.transparent,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child:
                        Image.asset(carImgList[widget.carNo],width: 100.0,height: 98.0,),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),



      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addGeoMarkerFromCurrentPosition(),
      ),*/);
  }


  void addGeoMarkerFromCurrentPosition() async {
    GeoPoint gp = await geoPointFromLocation(name: "Current position");
    Marker m = Marker(
        width: 180.0,
        height: 250.0,
        point: gp.point,
        builder: (BuildContext context) {
          return Icon(Icons.location_on);
        });
    await liveMapController.addMarker(marker: m, name: "Current position");
    await liveMapController.fitMarker("Current position");
  }
}

class SideBarPage extends StatefulWidget {
  int carNo;


  @override
  _SideBarPageState createState() => _SideBarPageState();

  SideBarPage({
    @required this.carNo,
  });
}
