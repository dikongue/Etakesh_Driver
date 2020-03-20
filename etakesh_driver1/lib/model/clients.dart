
class ClientsModel {
  int clientid;
  String adresse;
  String date_creation;
  String date_naissance;
  String email;
  String image;
  String code;
  String nom;
  String password;
  String pays;
  String prenom;
  String status;
  String telephone;
  String ville;
  String positionId;
  int UserId;

  ClientsModel({this.clientid, this.adresse, this.date_creation,
      this.date_naissance, this.email, this.image, this.code, this.nom,
      this.password, this.pays, this.prenom, this.status, this.telephone,
      this.ville, this.positionId, this.UserId});

  factory ClientsModel.fromJson(Map<String, dynamic> json) {
    return ClientsModel(
        clientid: json["clientid"],
        adresse: json["adresse"],
        date_creation: json["date_creation"],
        date_naissance: json["date_naissance"],
        email: json["email"],
        image: json["image"],
        code: json["code"],
        nom: json["nom"],
        password: json["password"],
        pays: json["pays"],
        prenom: json["prenom"],
        status: json["status"],
        telephone: json["telephone"],
        ville: json["ville"],
        positionId: json["positionId"],
        UserId: int.parse('${json["UserId"]}'));
  }
}
