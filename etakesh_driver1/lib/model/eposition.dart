
class EPositionModel {
  int positionid;
  double latitude;
  double longitude;
  String libelle;

  EPositionModel({this.positionid, this.latitude, this.longitude, this.libelle});

  factory EPositionModel.fromJson(Map<String, dynamic> json) {
    return EPositionModel(
      positionid: json["positionid"],
      latitude: double.parse('${json["latitude"]}'),
      longitude: double.parse('${json["longitude"]}'),
      libelle: json["libelle"]);
  }
}
