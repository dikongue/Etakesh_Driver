import 'google_places_item_term.dart';

class GooglePlacesItemModel {
  String description;
  String id;
  String place_id;
  String reference;
  List<GooglePlacesItemTermModel> terms;

  GooglePlacesItemModel(
      {this.description, this.id, this.place_id, this.reference, this.terms});

  factory GooglePlacesItemModel.fromJson(Map<String, dynamic> json) {
    return GooglePlacesItemModel(
      description: json["description"],
      id: json["id"],
      place_id: json["place_id"],
      reference: json["reference"],
      terms: (json['terms'] as List)
          ?.map((e) => e == null
              ? null
              : GooglePlacesItemTermModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}
