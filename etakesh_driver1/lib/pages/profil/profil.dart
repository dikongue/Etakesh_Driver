import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etakesh_driver/database/database_helper.dart';
import 'package:etakesh_driver/model/commandes.dart';
import 'package:etakesh_driver/model/prestataires.dart';
import 'package:etakesh_driver/model/users_logged.dart';
import 'package:etakesh_driver/remote/api.dart';
import 'package:etakesh_driver/roli/my_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../roli/my_colors.dart';
import '../compte/compte.dart';
import '../historique_cmde/historique_cmde.dart';
import '../mon_profil/mon_profil.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrestaInfoTok();
  }

  static final String TAG = 'HistoriqueCmdeState';
  final dbHelper = DatabaseHelper.instance;

  UsersLoggedModel _usersLoggedModel;
  PrestatairesModel _prestatairesModel;

  List<dynamic> _commandesModel;
  bool _is_finding = false;

//  initialisation du token pour les requetes http
  void initPrestaInfoTok() async {
    final prestaRows = await dbHelper.queryAll_presta();

    if (prestaRows.length > 0) {
      _usersLoggedModel = new UsersLoggedModel(
        id: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TOKEN],
      );
      _prestatairesModel = new PrestatairesModel(
        prestataireid: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ID],
        cni: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CNI],
        email: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_EMAIL],
        nom: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_NOM],
        prenom: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PRENOM],
        positionId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_POSITION_ID],
      );

      _findHistoryCmde();
    }
  }

//  recuperation de la liste des commandes de l'API
  void _findHistoryCmde() {
    setState(() {
      _is_finding = true;
    });

//    print('${TAG}:_findHistoryCmde token = ${_usersLoggedModel.id} | prestionIds = ${_prestatairesModel.prestataireid}');
    API
        .findHistCmde(_usersLoggedModel.id, _prestatairesModel.prestataireid)
        .then((responseCmdes) {
//      print("${TAG}:_findAllOwnCmde:API.findCmdeCreated findAllServices statusCode = ${responseCmdes.statusCode}");
    print("requette reponce:0........................................." +responseCmdes.statusCode.toString());
      if (responseCmdes.statusCode == 200) {
        final String responseCmdesString = responseCmdes.body;
        print(
            "${TAG}:_findHistoryCmde:API.findCmdeCreated responseCmdesString = ${responseCmdesString}");

        List<dynamic> listCmdes = new List();
  
  print(" la reponse de.............................................. l'historique"+ responseCmdes.body.toString());

        listCmdes = json
            .decode(responseCmdesString)
            .map((chatCardJson) => CommandesModel.fromJson(chatCardJson))
            .toList();
        print("${TAG}:_findHistoryCmde success listCmdes=${listCmdes.length}");
  print(" fabiol cmd raiboul ....................");

        setState(() {
          _is_finding = false;
        });
        if (listCmdes.length > 0) {
          setState(() {
            _commandesModel = listCmdes;
          });
        } else {
          setState(() {
            _is_finding = false;
          });

          Fluttertoast.showToast(
              msg: 'Vous n\'avez pas de commandes.',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              timeInSecForIos: 3);
        }
      } else {
        setState(() {
          _is_finding = false;
        });

        Fluttertoast.showToast(
            msg: 'Impossible de recupérer l\'historique de vos commandes.',
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

  Widget getItemNew(CommandesModel cmdeItem) {
    DateTime dateCmde =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(cmdeItem.date);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          padding:
              EdgeInsets.only(left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
          color: Color(0x88F9FAFC),
          child: Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: 66.0,
                    height: 66.0,
                    child: ClipOval(
                      child: new CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: cmdeItem.client.image +
                              "?access_token=" +
                              _usersLoggedModel.id,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
//                          direction: Axis.vertical,

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                '${cmdeItem.prestation.service.intitule}',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: MyColors.colorJaune,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Text(
                                '${cmdeItem.position_prise_en_charge}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              child: Text(
                                '${cmdeItem.client.prenom} ${cmdeItem.client.nom}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Column(
//                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '${MyConst.amountFormat(double.parse(cmdeItem.prestation.montant.toString()))} XAF',
                                  style: new TextStyle(
                                      fontSize: 17.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  '${cmdeItem.position_destination}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                child: new Text(
                                  DateFormat("dd MMM y hh:mm:ss")
                                      .format(dateCmde),
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: MyColors.colorBlue),
                                ),
                              ),
                            ],
                          ),
                        ),

//                        SizedBox(
//                          height: 6.0,
//                        ),
//
//                        Divider(height: 2.0,),
//                        new Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//
//                          ],
//                        ),
                      ],
                    ),
                  ),
                ],
              ),
//              Positioned(
//                right: 0.0,
//                child: new Column(
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  children: <Widget>[
//                    cmdeItem.is_created == true &&
//                            cmdeItem.is_accepted == true &&
//                            cmdeItem.is_terminated == false
//                        ? Icon(
//                            Icons.brightness_1,
//                            color: MyColors.colorVert,
//                            size: 13.0,
//                          )
//                        : Container(),
//                  ],
//                ),
//              ),
            ],
          ),
        ));
  }

  String getRevenuTotal(List<dynamic> listCmdes) {
    double total = 0;

    for (int i = 0; i < listCmdes.length; i++) {
      total += listCmdes[i].prestation.montant;
    }

    return MyConst.amountFormat(total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: MyColors.colorBlue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: MyColors.colorBlue,
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 24.0, top: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          _goToHistoriqueCmdePage();
                        },
                        child: new Icon(
                          Icons.equalizer,
                          color: MyColors.colorJaune,
                          size: 48.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 4.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: Text('Revenus',
                            style:
                                TextStyle(color: Colors.white, fontSize: 19.0)),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          _goToMonProfilPage();
                        },
                        child: new Icon(
                          Icons.person_outline,
                          color: MyColors.colorJaune,
                          size: 48.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 4.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Text('Profil',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 19.0))),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          _goToComptePage();
                        },
                        child: new Icon(
                          Icons.monetization_on,
                          color: MyColors.colorJaune,
                          size: 48.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 4.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Text('Compte',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 19.0))),
                    ],
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 16.0, bottom: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  /*  Text('Votre profile a ETakesh',
                      style: TextStyle(color: Colors.black87, fontSize: 24.0)),
                       */
                  Text("HISTORIQUE DE VOS TRANSACTIONS",
                      style: TextStyle(
                          color: MyColors.colorJaune, fontSize: 17.0)),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),

            /*  Text(
                    'Mon Revenu total',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 17.0),
                  ), 
                  _commandesModel != null
                      ? Text(
                          '${getRevenuTotal(_commandesModel)} XAF',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 28.0),
                        )
                      : Container(),

                      */

            _commandesModel != null
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.vertical,
                        itemCount: _commandesModel.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          CommandesModel cmde = _commandesModel[index];
                          return InkWell(
                              child: Container(child: getItemNew(cmde)),
                              onTap: () {
                                print("travail sur les dates");
                              });
                        }))
                : Container(),
            _is_finding
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 16.0, bottom: 10.0),
                    height: 36.0,
                    width: 36.0,
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Divider(
              height: 6.0,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: _commandesModel != null
                  ? Text(
                      '${_commandesModel.length} commande(s)',
                      style: TextStyle(color: Colors.black54),
                    )
                  : Container(),
            ),
            Divider(
              height: 6.0,
            ),
          ],
        ),
      ),
    );
  }

  void _goToComptePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new Compte()));
  }

  void _goToHistoriqueCmdePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new HistoriqueCmde()));
  }

  void _goToMonProfilPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new MonProfil()));
  }
}
