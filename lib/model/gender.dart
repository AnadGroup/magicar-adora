import 'package:flutter/material.dart';

class Genders {
  String title;
  String type;
  bool value;
  Genders({
    @required this.title,
    @required this.type,
    @required this.value
  });

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'type': this.type,
      'value': this.value,
    };
  }

  factory Genders.fromMap(Map<String, dynamic> map) {
    return new Genders(
      title: map['title'] ,
      type: map['type'] ,
      value: map['value']
    );
  }

  factory Genders.fromJson(Map<String, dynamic> json) {
    return Genders(title: json["title"], type: json["type"],value: json["value"]);
  }

  Map<String, dynamic> toJson() {
    return {"title": this.title, "type": this.type,"value": this.value};
  }



}