import 'dart:convert';

import 'package:etakesh_driver/model/depot.dart';
import 'package:etakesh_driver/model/ecompte.dart';
import 'package:etakesh_driver/roli/my_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../database/database_helper.dart';
import '../../model/users_logged.dart';
import '../../remote/api.dart';
import '../../roli/my_colors.dart';

class MesDepots extends StatefulWidget {
  @override
  _MesDepotsState createState() => _MesDepotsState();
}

class _MesDepotsState extends State<MesDepots> {
  String TAG = "_MesDepotsState";

  List<dynamic> _depotsModel;
  final dbHelper = DatabaseHelper.instance;
  UsersLoggedModel _usersLoggedModel;
  ECompteModel _eCompteModel;
  bool _is_signout = false;
  bool _is_finding = false;

//  initialisation du token pour les requetes http
  void initPrestaInfoTok() async {
    final prestaRows = await dbHelper.queryAll_presta();

    if (prestaRows.length > 0) {
      _usersLoggedModel = new UsersLoggedModel(
        id: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TOKEN],
      );

      final cpteRows = await dbHelper.queryAll_compte();

      if (cpteRows.length > 0) {
        setState(() {
          _eCompteModel = new ECompteModel(
            compteid: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_ID],
            solde: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_SOLDE],
            prestataireId: cpteRows[0]
                [DatabaseHelper.COLUMN_COMPTE_PRESTATAIREID],
            numero_compte: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_NUMCOMPTE],
            date_creation: cpteRows[0]
                [DatabaseHelper.COLUMN_COMPTE_DATECREATION],
          );
        });

        _findHistoryDepot();
      }
    }
  }

//  recuperation de la liste des commandes de l'API
  void _findHistoryDepot() {
    setState(() {
      _is_finding = true;
    });

//    print('${TAG}:_findHistoryCmde token = ${_usersLoggedModel.id} | prestionIds = ${_prestatairesModel.prestataireid}');
    API
        .findHistDepots(_usersLoggedModel.id, _eCompteModel.compteid)
        .then((responseDpts) {
//      print("${TAG}:_findAllOwnCmde:API.findCmdeCreated findAllServices statusCode = ${responseCmdes.statusCode}");
      if (responseDpts.statusCode == 200) {
        final String responsedptsString = responseDpts.body;
        print(
            "${TAG}:_findHistoryDepot:API.findHistDepots responseCmdesString = ${responsedptsString}");

        List<dynamic> listDepts = new List();

        listDepts = json
            .decode(responsedptsString)
            .map((itemDpt) => DepotModel.fromJson(itemDpt))
            .toList();
        print("${TAG}:findHistDepots success listCmdes=${listDepts.length}");

        setState(() {
          _is_finding = false;
        });
        if (listDepts.length > 0) {
          setState(() {
            _depotsModel = listDepts;
          });
        } else {
          setState(() {
            _is_finding = false;
          });

          Fluttertoast.showToast(
              msg: 'Vous n\'avez pas de dépôts.',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              timeInSecForIos: 3);
        }
      } else {
        setState(() {
          _is_finding = false;
        });

        Fluttertoast.showToast(
            msg: 'Impossible de recupérer l\'historique de vos dépôts.',
            backgroundColor: Colors.black,
            textColor: Colors.white,
            timeInSecForIos: 3);
      }
    }).catchError((error) {
      setState(() {
        _is_finding = false;
      });

      Fluttertoast.showToast(
          msg: 'Erreur réseau. Veuillez réessayer plus tard',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          timeInSecForIos: 3);
    });
  }

  String getRevenuTotal(List<dynamic> listDpts) {
    double total = 0;

    for(int i = 0; i < listDpts.length; i++) {
      total += listDpts[i].montant;
    }

    return MyConst.amountFormat(total);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initPrestaInfoTok();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes dépôts'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: MyColors.colorBlue,
      ),
      body: Container(
        color: Colors.white,
        padding:
            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0, top: 10.0),
        child: _is_finding
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Montant total dépôts',
                      style: TextStyle(fontSize: 17.0),),
                    trailing: Text(
                      '${_depotsModel != null ? getRevenuTotal(_depotsModel) : '0.00'} XAF',
                      style: TextStyle(fontSize: 23.0, color: MyColors.colorBlue, fontWeight: FontWeight.w500),
                    ),
                  ),
                  _depotsModel != null
                      ? Expanded(child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(4.0),
                      scrollDirection: Axis.vertical,
                      itemCount: _depotsModel.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        DepotModel itemDpt = _depotsModel[index];
                        DateTime dateDpt =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                            .parse(itemDpt.date);

                        return new Stack(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: new Card(
                                margin: new EdgeInsets.all(5.0),
                                child: new Container(
                                  width: double.infinity,
                                  height: 70.0,
                                  child: Center(
                                    child: ListTile(
                                      title: Text(
                                        '${DateFormat("dd MMM, yyyy à hh:mm:ss").format(dateDpt)}',
                                        style: TextStyle(fontSize: 17.0),),
                                      trailing: Text(
                                        '${MyConst.amountFormat(itemDpt.montant)} XAF',
                                        style: TextStyle(fontSize: 21.0, color: MyColors.colorRouge, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            new Positioned(
                              top: 0.0,
                              bottom: 0.0,
                              left: 25.0,
                              child: new Container(
                                height: double.infinity,
                                width: 1.0,
                                color: Colors.blue,
                              ),
                            ),
                            new Positioned(
                              top: 20.0,
                              left: 5.0,
                              child: new Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: new Container(
                                  child: new Center(
                                    child: Text('${index+1}',
                                    style: TextStyle(color: Colors.white, fontSize: 12.0),),
                                  ),
                                  margin: new EdgeInsets.all(5.0),
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: MyColors.colorJaune),
                                ),
                              ),
                            )
                          ],
                        );
                        /*return InkWell(
                            child: Card(
                              child: Container(
                                  padding: EdgeInsets.only(left: 4.0, right: 4.0,top: 6.0, bottom: 6.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${DateFormat("dd MMMM, yyyy à hh:mm:ss").format(dateDpt)}',
                                        style: TextStyle(fontSize: 19.0),),
                                      Text(
                                        '${MyConst.amountFormat(itemDpt.montant)} XAF',
                                        style: TextStyle(fontSize: 21.0, color: MyColors.colorRouge, fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )),
                            ),
                            onTap: () {
                              print("travail sur les dates");
                            });*/
                      }))
                      : Container(),
                  Divider(
                    height: 6.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: _depotsModel != null
                        ? Text(
                            '${_depotsModel.length} depot(s)',
                            style: TextStyle(color: Colors.black54),
                          )
                        : Container(),
                  )
                ],
              ),
      ),
    );
  }
}
