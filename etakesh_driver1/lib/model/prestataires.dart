import 'eposition.dart';
import 'prestations.dart';

class PrestatairesModel {
  int prestataireid;
  String cni;
  String date_creation;
  String date_naissance;
  String email;
  String nom;
  String pays;
  String prenom;
  String status;
  String telephone;
  String ville;
  String code;
  String image;
  int positionId;
  int UserId;
  bool etat;
  EPositionModel position;
  List<PrestationsModel> prestation;

  PrestatairesModel({this.prestataireid, this.cni, this.date_creation,
      this.date_naissance, this.email, this.nom, this.pays, this.prenom,
      this.status, this.telephone, this.ville, this.positionId, this.UserId,
      this.position, this.prestation, this.code, this.image, this.etat});

  factory PrestatairesModel.fromJson(Map<String, dynamic> json) {
    return PrestatairesModel(
      prestataireid: json["prestataireid"],
      cni: json["cni"],
      date_creation: json["date_creation"],
      date_naissance: json["date_naissance"],
      email: json["email"],
      nom: json["nom"],
      pays: json["pays"],
      prenom: json["prenom"],
      status: json["status"],
      telephone: json["telephone"],
      ville: json["ville"],
      code: json["code"],
      image: json["image"],
      positionId: json["positionId"],
      UserId: json["UserId"],
      prestation: (json['prestation'] as List)
          ?.map((e) => e == null
          ? null
          : PrestationsModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    position: json["position"] != null ? EPositionModel.fromJson(json["position"]) : null,
     etat: json["etat"], );
  }
}