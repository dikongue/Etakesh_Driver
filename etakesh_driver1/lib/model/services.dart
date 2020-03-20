import '../database/database_helper.dart';

class ServicesModel {
  int serviceid;
  String code;
  int duree;
  String intitule;
  double prix;
  double prix_douala;
  double prix_yaounde;
  String status;
  String date_creation;

  ServicesModel({this.serviceid, this.code, this.duree, this.intitule, this.prix,
      this.prix_douala, this.prix_yaounde, this.status, this.date_creation});

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      serviceid: json["serviceid"],
      code: json["code"],
      duree: json["duree"],
      intitule: json["intitule"],
      prix: double.parse('${json["prix"]}'),
      prix_douala: double.parse('${json["prix_douala"]}'),
      prix_yaounde: double.parse('${json["prix_yaounde"]}'),
      status: json["status"],
      date_creation: json["date_creation"],);
  }

  ServicesModel.fromMap(Map<String, dynamic> map) {
    serviceid = map[DatabaseHelper.COLUMN_SERV_ID];
    code = map[DatabaseHelper.COLUMN_SERV_CODE];
    duree = map[DatabaseHelper.COLUMN_SERV_DUREE];
    intitule = map[DatabaseHelper.COLUMN_SERV_INTITULE];
    prix = double.parse('${map[DatabaseHelper.COLUMN_SERV_PRIX]}');
    prix_douala = double.parse('${map[DatabaseHelper.COLUMN_SERV_PRIXDLA]}');
    prix_yaounde = double.parse('${map[DatabaseHelper.COLUMN_SERV_PRIXYDE]}');
    status = map[DatabaseHelper.COLUMN_SERV_STATUS];
    date_creation = map[DatabaseHelper.COLUMN_SERV_DATECREATION];
  }
}
