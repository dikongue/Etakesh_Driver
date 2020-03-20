import 'google_places_item.dart';

class GooglePlacesModel {
  String status;
  List<GooglePlacesItemModel> predictions;

  GooglePlacesModel({this.status, this.predictions});

  factory GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    return GooglePlacesModel(
      status: json["status"],
      predictions: (json['predictions'] as List)
          ?.map((e) => e == null
          ? null
          : GooglePlacesItemModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}