
class DepotModel {
  int depotid;
  double montant;
  String date;
  String compteId;


  DepotModel({this.depotid, this.montant, this.date, this.compteId});

  factory DepotModel.fromJson(Map<String, dynamic> json) {
    return DepotModel(
        depotid: int.parse('${json["depotid"].toString()}'),
        montant: double.parse('${json["montant"].toString()}'),
        date: json["date"].toString(),
        compteId: json["compteId"].toString());
  }
}
