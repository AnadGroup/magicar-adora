import 'package:anad_magicar/model/apis/api_carmodel_model.dart';
import 'package:anad_magicar/model/apis/slave_paired_car.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:flutter/material.dart';

class ApiPairedCar {

  int PairedCarId;
  
  int MasterCarId;
  int SecondCarId;
  String FromDate;
  String ToDate;
  String FromTime;
  String ToTime;
  String Description;
  bool IsActive;
  int RowStateType;
  Car MasterCar;
  Car SecondCar;

  int master;
  List<SlavedCar> slaves;
  List<int> CarIds=new List();
  
  ApiPairedCar({
    @required this.PairedCarId,
    @required this.MasterCarId,
    @required this.SecondCarId,
    @required this.FromDate,
    @required this.ToDate,
    @required this.FromTime,
    @required this.ToTime,
    @required this.Description,
    @required this.IsActive,
    @required this.RowStateType,
    @required this.CarIds,
    @required this.master,
    @required this.slaves,
    @required this.MasterCar,
    @required this.SecondCar
  });
  
  

  


  Map<String, dynamic> toJsonForDeletePairedCars() {
    return {"MasterCarId": this.MasterCarId, "CarIds": this.CarIds.map<int>((i)=>i).toList(),};
  }

  Map<String, dynamic> toMap() {
    return {
      'PairedCarId': this.PairedCarId,
      'MasterCarId': this.MasterCarId,
      'SecondCarId': this.SecondCarId,
      'FromDate': this.FromDate,
      'ToDate': this.ToDate,
      'FromTime': this.FromTime,
      'ToTime': this.ToTime,
      'Description': this.Description,
      'IsActive': this.IsActive,
      'RowStateType': this.RowStateType,
      'CarIds': this.CarIds,
    };
  }

  factory ApiPairedCar.fromMap(Map<String, dynamic> map) {
    return new ApiPairedCar(
      PairedCarId: map['PairedCarId'] ,
      MasterCarId: map['MasterCarId'] ,
      SecondCarId: map['SecondCarId'] ,
      FromDate: map['FromDate'] ,
      ToDate: map['ToDate'] ,
      FromTime: map['FromTime'] ,
      ToTime: map['ToTime'] ,
      Description: map['Description'] ,
      IsActive: map['IsActive'] ,
      RowStateType: map['RowStateType'] ,
      CarIds: map['CarIds'] ,
    );
  }

  factory ApiPairedCar.fromJson(Map<String, dynamic> json) {
    return ApiPairedCar(PairedCarId: json["PairedCarId"],
      MasterCarId: json["MasterCarId"],
      SecondCarId: json["SecondCarId"],
      FromDate: json["FromDate"],
      ToDate: json["ToDate"],
      FromTime: json["FromTime"],
      ToTime: json["ToTime"],
      Description: json["Description"],
      IsActive: json["IsActive"],
      RowStateType: json["RowStateType"],
      CarIds:json["CarIds"]);
  }

  factory ApiPairedCar.fromJsonForPairedCars(Map<String, dynamic> json) {
    return ApiPairedCar(PairedCarId: json["PairedCarId"],
        MasterCar: Car.fromJsonForPairedCars( json["MasterCar"]),
        SecondCar: Car.fromJsonForPairedCars(json["SecondCar"]),
        IsActive: json["IsActive"]);
  }

  factory ApiPairedCar.fromJsonForGetAllPaired(Map<String, dynamic> json) {
    List<dynamic> slvs=json["slave"];
    List<SlavedCar> tslvs=new List();
    if(slvs!=null && slvs.length>0){
        tslvs=slvs.map<SlavedCar>((s)=>SlavedCar.fromJson(s)).toList();
    }
    return ApiPairedCar(master: json["master"],
    slaves: tslvs);
  }

  Map<String, dynamic> toJson() {
    return {
      "PairedCarId": this.PairedCarId,
      "MasterCarId": this.MasterCarId,
      "SecondCarId": this.SecondCarId,
      "FromDate": this.FromDate,
      "ToDate": this.ToDate,
      "FromTime": this.FromTime,
      "ToTime": this.ToTime,
      "Description": this.Description,
      "IsActive": this.IsActive,
      "RowStateType": this.RowStateType,
     // "CarIds": this.CarIds,
    };
  }


}
