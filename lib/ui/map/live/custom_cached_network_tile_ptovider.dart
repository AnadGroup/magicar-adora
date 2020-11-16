import 'package:flutter_map/flutter_map.dart';

class CustomCachedNetworkTileProvider extends CachedNetworkTileProvider {

 static String layer='anadbase';
  String baseURL="http://130.185.72.186:9090/geoserver/gwc/service/tms/1.0.0/anad:"+layer+"@EPSG:900913@png/";
  @override
  String getTileUrl(Coords coords, TileLayerOptions options) {
    var data = <String, String>{
      'x': coords.x.round().toString(),
      'y': coords.y.round().toString(),
      'z': coords.z.round().toString(),
      's': getSubdomain(coords, options)
    };
    if (options.tms) {
      data['y'] = invertY(coords.y.round(), coords.z.round()).toString();
    }
    var allOpts = Map<String, String>.from(data)
      ..addAll(options.additionalOptions);
    return baseURL+data['z']+'/'+data['x']+'/'+data['y']+'.png'; //util.template(options.urlTemplate, allOpts);

  }
}
