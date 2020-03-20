
class ECompteModel {
  int compteid;
  String date_creation;
  String numero_compte;
  double solde;
  String prestataireId;

  ECompteModel({this.compteid, this.date_creation, this.numero_compte, this.solde, this.prestataireId});

  factory ECompteModel.fromJson(Map<String, dynamic> json) {
    return ECompteModel(
        compteid: int.parse('${json["compteid"].toString()}'),
        solde: double.parse('${json["solde"].toString()}'),
        date_creation: json["date_creation"].toString(),
        numero_compte: json["numero_compte"],
        prestataireId: json["prestataireId"].toString()
    );
  }
}
