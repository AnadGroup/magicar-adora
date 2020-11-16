import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:flutter/material.dart';

class RegServiceTypeVM {
   int carId;
   String route;
    bool editMode =false;
    ServiceType serviceType;
   RegServiceTypeVM({
     @required this.carId,
     @required this.route,
     @required this.editMode,
     @required this.serviceType
   });

}
