
class VehiculesModel {
  int vehiculeid;
  String couleur;
  String status;
  String immatriculation;
  String marque;
  int nombre_places;
  String date;
  String code;
  String image;
  String categorievehiculeId;
  String prestataireId;

  VehiculesModel({this.vehiculeid, this.couleur, this.status,
      this.immatriculation, this.marque, this.nombre_places, this.date, this.image, this.code,
      this.categorievehiculeId, this.prestataireId});

  factory VehiculesModel.fromJson(Map<String, dynamic> json) {
    return VehiculesModel(
      vehiculeid: json["vehiculeid"],
      couleur: json["couleur"],
      status: json["status"],
      immatriculation: json["immatriculation"],
      marque: json["marque"],
      nombre_places: json["nombre_places"],
      date: json["date"],
      image: json["image"],
      code: json["code"],
      categorievehiculeId: json["categorievehiculeId"],
      prestataireId: json["prestataireId"],);
  }
}
