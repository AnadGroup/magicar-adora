import 'package:anad_magicar/model/apis/accessable_actions.dart';
import 'package:flutter/material.dart';

class CurrentUserAccessableActionModel {

  int UserId ;
  int RoleId;
  int CarId;
  String Description;
  String RoleTitle;
  List<AccessableActions> accessableActions;

  CurrentUserAccessableActionModel({
    @required this.UserId,
    @required this.RoleId,
    @required this.CarId,
    @required this.RoleTitle,
    @required this.Description,
    @required this.accessableActions,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': this.UserId,
      'RoleId': this.RoleId,
      'RoleTitle': this.RoleTitle,
      'CarId': this.CarId,
      'Description': this.Description,
      'AccessableActions': this.accessableActions,
    };
  }

  factory CurrentUserAccessableActionModel.fromMap(Map<String, dynamic> map) {
    var accActions= map["AccessableActions"];
    List<AccessableActions> accessActionsList=new List();
    if(accActions!=null)
    {
      accessActionsList=accActions.map<AccessableActions>((ac)=>AccessableActions.fromMap(ac) ).toList();
    }
    return new CurrentUserAccessableActionModel(
      UserId: map['UserId'] ,
      RoleId: map['RoleId'] ,
      CarId: map['CarId'],
      Description: map['Description'] ,
      accessableActions: accessActionsList ,
    );
  }

  factory CurrentUserAccessableActionModel.fromJson(Map<String, dynamic> json) {
    var accActions= json["AccessableActions"];
    List<AccessableActions> accessActionsList=new List();
    if(accActions!=null)
      {
        accessActionsList=accActions.map<AccessableActions>((ac)=>AccessableActions.fromJson(ac) ).toList();
      }

    return CurrentUserAccessableActionModel(UserId:json["UserId"],
      RoleId: json["RoleId"],
      CarId: json["CarId"],
      RoleTitle: json["RoleTitle"],
      Description: json["Description"],
      accessableActions: accessActionsList,);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserId": this.UserId,
      "RoleId": this.RoleId,
      "CarId": this.CarId,
      "RoleTitle": this.RoleTitle,
     "Description": this.Description,
      //"AccessableActions": this.accessableActions.,
    };
  }


}
