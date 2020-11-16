import 'package:anad_magicar/utils/dart_helper.dart';

class ApiCarModelDetail {

  int carModelDetailId;
  String carModelDetailTitle;
  String imageUrl;
  int carModelId;
  String description;
  bool isActive;
  int businessUnitId;
  int owner;

  ApiCarModelDetail({
     this.carModelDetailId,
     this.carModelDetailTitle,
     this.imageUrl,
     this.carModelId,
     this.description,
     this.isActive,
     this.businessUnitId,
     this.owner,
  });

  Map<String, dynamic> toMap() {
    return {
      'CarModelDetailId': this.carModelDetailId,
      'CarModelDetailTitle': this.carModelDetailTitle,
      'ImageUrl': this.imageUrl,
      'CarModelId': this.carModelId,
      'Description': this.description,
      'IsActive': this.isActive,
      'BusinessUnitId': this.businessUnitId,
      'Owner': this.owner,
    };
  }


  Map<String, dynamic> toMapForResultGetAll() {
    return {
      'CarModelDetailId': this.carModelDetailId,
      'CarModelDetailTitle': this.carModelDetailTitle,
      'Description': this.description,
    };
  }
  Map<String, dynamic> toMapForGetById() {
    return {
      'CarModelDetailId': this.carModelDetailId,
      //'CarModelDetailTitle': this.carModelDetailTitle,
      //'Description': this.description,
    };
  }

  Map<String, dynamic> toMapForGetByCarModelId() {
    return {
      'CarModelId': this.carModelId,
      //'CarModelDetailTitle': this.carModelDetailTitle,
      //'Description': this.description,
    };
  }

  Map<String, dynamic> toMapForResultGetById() {
    return {
      'CarModelDetailId': this.carModelDetailId,
      'CarModelDetailTitle': this.carModelDetailTitle,
      'Description': this.description,
    };
  }
  Map<String, dynamic> toMapForResultGetByCarModelId() {
    return {
      'CarModelDetailId': this.carModelDetailId,
      'CarModelDetailTitle': this.carModelDetailTitle,
      'Description': this.description,
    };
  }

  factory ApiCarModelDetail.fromMap(Map<String, dynamic> map) {
    return new ApiCarModelDetail(
      carModelDetailId: map['CarModelDetailId'],
      carModelDetailTitle: map['CarModelDetailTitle'] ,
      imageUrl: map['ImageUrl'],
      carModelId: map['CarModelId'] ,
      description: map['Description'] ,
      isActive: map['IsActive'] ,
      businessUnitId: map['BusinessUnitId'] ,
      owner: map['Owner'] ,
    );
  }

  factory ApiCarModelDetail.fromJson(Map<String, dynamic> json) {
    return ApiCarModelDetail(
      carModelDetailId: json["CarModelDetailId"],
      carModelDetailTitle: json["CarModelDetailTitle"],
      imageUrl: json["ImageUrl"],
      carModelId:json["CarModelId"],
      description: DartHelper.isNullOrEmptyString(json["Description"]),
      isActive: json["IsActive"],
      businessUnitId: json["BusinessUnitId"],
      owner: json["Owner"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "CarModelDetailId": this.carModelDetailId,
      "CarModelDetailTitle": this.carModelDetailTitle,
      "ImageUrl": this.imageUrl,
      "CarModelId": this.carModelId,
      "Description": this.description,
      "IsActive": this.isActive,
      "BusinessUnitId": this.businessUnitId,
      "Owner": this.owner,
    };
  }

  Map<String, dynamic> toJsonForResultGetAll() {
    return {
      "CarModelDetailId": this.carModelDetailId,
      "CarModelDetailTitle": this.carModelDetailTitle,
      "Description": this.description,
    };
  }

  Map<String, dynamic> toJsonForResultGetById() {
    return {
      "CarModelDetailId": this.carModelDetailId,
      "CarModelDetailTitle": this.carModelDetailTitle,
      "Description": this.description,
    };
  }
  Map<String, dynamic> toJsonForResultGetByCarModelId() {
    return {
      "CarModelDetailId": this.carModelDetailId,
      "CarModelDetailTitle": this.carModelDetailTitle,
      "Description": this.description,
    };
  }
  Map<String, dynamic> toJsonForGetById() {
    return {
      "carModelDetailId": this.carModelDetailId,
    };
  }
  Map<String, dynamic> toJsonForGetBycarModelId() {
    return {
      "carModelId": this.carModelId,
    };
  }
}
