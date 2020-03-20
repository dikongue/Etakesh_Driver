import 'vehicules.dart';
import 'services.dart';

class PrestationsModel {
  int prestationid;
  String date;
  String status;
  int montant;
  String vehiculeId;
  String prestataireId;
  String serviceId;
  VehiculesModel vehicule;
  ServicesModel service;

  PrestationsModel({this.prestationid, this.date, this.status, this.montant,
      this.vehiculeId, this.prestataireId, this.serviceId, this.vehicule,
      this.service});

  factory PrestationsModel.fromJson(Map<String, dynamic> json) {
    return PrestationsModel(
      prestationid: json["prestationid"],
      date: json["date"],
      status: json["status"],
      montant: json["montant"],
      vehiculeId: json["vehiculeId"],
      prestataireId: json["prestataireId"],
      serviceId: json["serviceId"],
      vehicule: json["vehicule"] != null ? VehiculesModel.fromJson(json["vehicule"]) : null,
      service: json["service"] != null ? ServicesModel.fromJson(json["service"]) : null);
  }
}
