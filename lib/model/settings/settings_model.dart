import 'package:flutter/material.dart';

class SettingsModel {
  String title;
  String image;
  int id;

  SettingsModel({
    @required this.title,
    @required this.image,
    @required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'image': this.image,
      'id': this.id,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return new SettingsModel(
      title: map['title'] as String,
      image: map['image'] as String,
      id: map['id'] as int,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      title: json["title"], image: json["image"], id: int.parse(json["id"]),);
  }

  Map<String, dynamic> toJson() {
    return {"title": this.title, "image": this.image, "id": this.id,};
  }


}