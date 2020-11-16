import 'package:flutter/foundation.dart';

class CarData {
  int brandId;
  int modelId;
  int tip;
  String pelak;
  int colorId;
  int distance;
  bool cancel;
  CarData({
    @required this.brandId,
    @required this.modelId,
    @required this.tip,
    @required this.pelak,
    @required this.colorId,
    @required this.distance,
  @required this.cancel
  });

  @override
  String toString() {
    return '$runtimeType($pelak, $tip)';
  }
}
