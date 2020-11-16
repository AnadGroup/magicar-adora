import 'package:anad_magicar/ui/map/openmapstreet/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
class RoutingApiMapPage extends StatefulWidget {
  RoutingApiMapPage({Key key}) : super(key: key);

  @override
  _RoutingApiMapPageState createState() {
    return _RoutingApiMapPageState();
  }
}

class _RoutingApiMapPageState extends State<RoutingApiMapPage> {
  static const String route = '/';


  String routeSJON='{"coordinates":[[8.681495,49.41461],[8.686507,49.41943],[8.687872,49.420318]]}';
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
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: buildDrawer(context, route),
      body:
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng( 35.770555,51.419504,),
                  zoom: 15.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                    'https://api.openrouteservice.org/v2/directions/driving-car/gpx',
                   //subdomains: ['a', 'b', 'c'],
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                    tileProvider: NetworkTileProvider(),
                    additionalOptions: {
                      "Authorization": "5b3ce3597851110001cf62480efcf9a66bbf4819825a3f50e2bfa0ea"
                    },
                  ),
                //  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );;
  }
}
