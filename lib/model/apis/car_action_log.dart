import 'package:flutter/material.dart';

class CarActionLog {
  int CarActionLogId;
  int CarId;
  String ActionDate;
  String Latitude;
  String Logitude;
  String CostAmount;
  int PlanId;
  String PlanTitle;
  String ActionTitle;
  String UserName;
  int ActionId;
  CarActionLog({
    @required this.CarActionLogId,
    @required this.CarId,
    @required this.ActionDate,
    @required this.Latitude,
    @required this.Logitude,
    @required this.CostAmount,
    @required this.PlanId,
    @required this.PlanTitle,
    @required this.ActionTitle,
    @required this.UserName,
    @required this.ActionId
  });

  Map<String, dynamic> toMap() {
    return {
      'CarActionLogId': this.CarActionLogId,
      'CarId': this.CarId,
      'ActionDate': this.ActionDate,
      'Latitude': this.Latitude,
      'Logitude': this.Logitude,
      'CostAmount': this.CostAmount,
      'PlanId': this.PlanId,
      'PlanTitle': this.PlanTitle,
      'ActionTitle': this.ActionTitle,
      'UserName': this.UserName
    };
  }

  factory CarActionLog.fromMap(Map<String, dynamic> map) {
    return new CarActionLog(
      CarActionLogId: map['CarActionLogId'] ,
      CarId: map['CarId'] ,
      ActionDate: map['ActionDate'] ,
      Latitude: map['Latitude'] ,
      Logitude: map['Logitude'] ,
      CostAmount: map['CostAmount'] ,
      PlanId: map['PlanId'] ,
      PlanTitle: map['PlanTitle'] ,
      ActionTitle: map['ActionTitle'] ,
      UserName: map['UserName'],
    );
  }

  factory CarActionLog.fromJson(Map<String, dynamic> json) {
    String costAmnt='';
     double ca=json["CostAmount"];
     if(ca!=null){
       costAmnt=ca.toString();
     }
    return CarActionLog(CarActionLogId: json["CarActionLogId"],
      CarId: json["CarId"],
      ActionDate: json["ActionDate"],
      Latitude: json["Latitude"],
      Logitude: json["Logitude"],
      CostAmount: costAmnt,
      PlanId: json["PlanId"],
      PlanTitle: json["PlanTitle"],
      ActionTitle: json["ActionTitle"],
    ActionId: json["ActionId"],
    UserName: json["UserName"]);
  }

  Map<String, dynamic> toJson() {

    return {
      "CarActionLogId": this.CarActionLogId,
      "CarId": this.CarId,
      "ActionDate": this.ActionDate,
      "Latitude": this.Latitude,
      "Logitude": this.Logitude,
      "CostAmount": this.CostAmount.toString(),
      "PlanId": this.PlanId,
      "PlanTitle": this.PlanTitle,
      "ActionTitle": this.ActionTitle,
      "UserName":this.UserName,
      "ActionId":this.ActionId
    };
  }


}
