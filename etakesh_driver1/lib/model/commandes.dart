import 'eposition.dart';
import 'clients.dart';
import 'prestations.dart';

class CommandesModel {
  int commandeid;
  String code;
  String date;
  String date_debut;
  String date_fin;
  double montant;
  String status;
  String distance_client_prestataire;
  String duree_client_prestataire;
  String date_acceptation;
  String date_prise_en_charge;
  String position_prise_en_charge;
  String position_destination;
  String rate_comment;
  String rate_date;
  double rate_value;
  bool is_created;
  bool is_accepted;
  bool is_refused;
  bool is_terminated;
  bool is_started;
  int clientId;
  int prestationId;
  int prestataireId;
  int position_priseId;
  int position_destId;
  ClientsModel client;
  EPositionModel position_prise;
  EPositionModel position_dest;
  PrestationsModel prestation;

  CommandesModel(
      {this.commandeid,
      this.code,
      this.date,
      this.date_debut,
      this.date_fin,
      this.montant,
      this.status,
      this.distance_client_prestataire,
      this.duree_client_prestataire,
      this.date_acceptation,
      this.date_prise_en_charge,
      this.position_prise_en_charge,
      this.position_destination,
      this.rate_comment,
      this.rate_date,
      this.rate_value,
      this.is_created,
      this.is_accepted,
      this.is_refused,
      this.is_terminated,
      this.is_started,
      this.clientId,
      this.prestationId,
      this.position_priseId,
      this.position_destId,
      this.prestataireId,
      this.client,
      this.position_prise,
      this.position_dest,
      this.prestation});

  factory CommandesModel.fromJson(Map<String, dynamic> json) {
    return CommandesModel(
        commandeid: json["commandeid"],
        code: json["code"],
        date: json["date"],
        date_debut: json["date_debut"],
        date_fin: json["date_fin"],
        montant: double.parse('${json["montant"]}'),
        status: json["status"],
        distance_client_prestataire: json["distance_client_prestataire"],
        duree_client_prestataire: json["duree_client_prestataire"],
        date_acceptation: json["date_acceptation"],
        date_prise_en_charge: json["date_prise_en_charge"],
        position_prise_en_charge: json["position_prise_en_charge"],
        position_destination: json["position_destination"],
        rate_comment: json["rate_comment"],
        rate_date: json["rate_date"],
        rate_value: double.parse('${json["rate_value"]}'),
        is_created: json["is_created"],
        is_accepted: json["is_accepted"],
        is_refused: json["is_refused"],
        is_terminated: json["is_terminated"],
        is_started: json["is_started"],
        clientId: int.parse('${json["clientId"]}'),
        prestationId: int.parse('${json["prestationId"]}'),
        prestataireId: int.parse('${json["prestataireId"]}'),
        position_destId: int.parse('${json["position_destId"]}'),
        position_priseId: int.parse('${json["position_priseId"]}'),
        client: ClientsModel.fromJson(json["client"]),
        position_prise: json["position_prise"] != null
            ? EPositionModel.fromJson(json["position_prise"])
            : null,
        position_dest: json["position_dest"] != null
            ? EPositionModel.fromJson(json["position_dest"])
            : null,
        prestation: json["prestation"] != null
            ? PrestationsModel.fromJson(json["prestation"])
            : null);
  }
}

class CommandesModel1 {
  int commandeid;
  String code;
  String date;
  String date_debut;
  String date_fin;
  double montant;
  String status;
  String distance_client_prestataire;
  String duree_client_prestataire;
  String date_acceptation;
  String date_prise_en_charge;
  String position_prise_en_charge;
  String position_destination;
  String rate_comment;
  String rate_date;
  double rate_value;
  bool is_created;
  bool is_accepted;
  bool is_refused;
  bool is_terminated;
  bool is_started;
  int clientId;
  int prestationId;
  int prestataireId;
  int position_priseId;
  int position_destId;
  
  CommandesModel1(
      {this.commandeid,
      this.code,
      this.date,
      this.date_debut,
      this.date_fin,
      this.montant,
      this.status,
      this.distance_client_prestataire,
      this.duree_client_prestataire,
      this.date_acceptation,
      this.date_prise_en_charge,
      this.position_prise_en_charge,
      this.position_destination,
      this.rate_comment,
      this.rate_date,
      this.rate_value,
      this.is_created,
      this.is_accepted,
      this.is_refused,
      this.is_terminated,
      this.is_started,
      this.clientId,
      this.prestationId,
      this.position_priseId,
      this.position_destId,
      this.prestataireId,
     });

  factory CommandesModel1.fromJson(Map<String, dynamic> json) {
    return CommandesModel1(
        commandeid: json["commandeid"],
        code: json["code"],
        date: json["date"],
        date_debut: json["date_debut"],
        date_fin: json["date_fin"],
        montant: double.parse('${json["montant"]}'),
        status: json["status"],
        distance_client_prestataire: json["distance_client_prestataire"],
        duree_client_prestataire: json["duree_client_prestataire"],
        date_acceptation: json["date_acceptation"],
        date_prise_en_charge: json["date_prise_en_charge"],
        position_prise_en_charge: json["position_prise_en_charge"],
        position_destination: json["position_destination"],
        rate_comment: json["rate_comment"],
        rate_date: json["rate_date"],
        rate_value: double.parse('${json["rate_value"]}'),
        is_created: json["is_created"],
        is_accepted: json["is_accepted"],
        is_refused: json["is_refused"],
        is_terminated: json["is_terminated"],
        is_started: json["is_started"],
        clientId: int.parse('${json["clientId"]}'),
        prestationId: int.parse('${json["prestationId"]}'),
        prestataireId: int.parse('${json["prestataireId"]}'),
        position_destId: int.parse('${json["position_destId"]}'),
        position_priseId: int.parse('${json["position_priseId"]}'),
    );
  }
}

class CommandesModel2 {
  int commandeid;
  String code;
  String date;
  String date_debut;
  String date_fin;
  double montant;
  String status;
  String distance_client_prestataire;
  String duree_client_prestataire;
  String date_acceptation;
  String date_prise_en_charge;
  String position_prise_en_charge;
  String position_destination;
  String rate_comment;
  String rate_date;
  double rate_value;
  bool is_created;
  bool is_accepted;
  bool is_refused;
  bool is_terminated;
  bool is_started;
  int clientId;
  int prestationId;
  int prestataireId;
  int position_priseId;
  int position_destId;
  //ClientsModel client;
  PrestationsModel prestation;

  CommandesModel2(
      {this.commandeid,
      this.code,
      this.date,
      this.date_debut,
      this.date_fin,
      this.montant,
      this.status,
      this.distance_client_prestataire,
      this.duree_client_prestataire,
      this.date_acceptation,
      this.date_prise_en_charge,
      this.position_prise_en_charge,
      this.position_destination,
      this.rate_comment,
      this.rate_date,
      this.rate_value,
      this.is_created,
      this.is_accepted,
      this.is_refused,
      this.is_terminated,
      this.is_started,
      this.clientId,
      this.prestationId,
      this.position_priseId,
      this.position_destId,
      this.prestataireId,
     // this.client,
      this.prestation});

  factory CommandesModel2.fromJson(Map<String, dynamic> json) {
    return CommandesModel2(
        commandeid: json["commandeid"],
        code: json["code"],
        date: json["date"],
        date_debut: json["date_debut"],
        date_fin: json["date_fin"],
        montant: double.parse('${json["montant"]}'),
        status: json["status"],
        distance_client_prestataire: json["distance_client_prestataire"],
        duree_client_prestataire: json["duree_client_prestataire"],
        date_acceptation: json["date_acceptation"],
        date_prise_en_charge: json["date_prise_en_charge"],
        position_prise_en_charge: json["position_prise_en_charge"],
        position_destination: json["position_destination"],
        rate_comment: json["rate_comment"],
        rate_date: json["rate_date"],
        rate_value: double.parse('${json["rate_value"]}'),
        is_created: json["is_created"],
        is_accepted: json["is_accepted"],
        is_refused: json["is_refused"],
        is_terminated: json["is_terminated"],
        is_started: json["is_started"],
        clientId: int.parse('${json["clientId"]}'),
        prestationId: int.parse('${json["prestationId"]}'),
        prestataireId: int.parse('${json["prestataireId"]}'),
        position_destId: int.parse('${json["position_destId"]}'),
        position_priseId: int.parse('${json["position_priseId"]}'),
       // client: ClientsModel.fromJson(json["client"]),
        prestation: json["prestation"] != null
            ? PrestationsModel.fromJson(json["prestation"])
            : null);
  }
}
