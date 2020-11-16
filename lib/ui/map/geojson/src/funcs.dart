import 'dart:async';
import 'dart:io';
import 'models.dart';
import 'geojson.dart' as geo;
import 'package:anad_magicar/ui/map/geojson/geojson.dart';
//import 'package:geojson/geojson.dart';
/// Get a feature collection from a geojson string
Future<GeoJsonFeatureCollection> featuresFromGeoJson(String data,
    {String nameProperty, bool verbose = false}) async {
  final featureCollection = GeoJsonFeatureCollection();
  final geojson = GeoJson();
  try {
    await geojson.parse(data, nameProperty: nameProperty, verbose: verbose);
  } catch (e) {
    rethrow;
  }
  geojson.features.forEach((f) => featureCollection.collection.add(f));
  geojson.dispose();
  return featureCollection;
}

/// Get a feature collection from a geojson file
Future<GeoJsonFeatureCollection> featuresFromGeoJsonFile(File file,
    {String nameProperty, bool verbose = false}) async {
  final featureCollection = GeoJsonFeatureCollection();
  final geojson = GeoJson();
  try {
    await geojson.parseFile(file.path,
        nameProperty: nameProperty, verbose: verbose);
  } catch (e) {
    rethrow;
  }
  geojson.features.forEach((f) => featureCollection.collection.add(f));
  geojson.dispose();
  return featureCollection;
}
