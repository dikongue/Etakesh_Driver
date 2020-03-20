import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../database/database_helper.dart';
import '../../model/commandes.dart';
import '../../model/prestataires.dart';
import '../../model/users_logged.dart';
import '../../remote/api.dart';
import '../../roli/my_colors.dart';
import '../../roli/my_const.dart';

class HistoriqueCmde extends StatefulWidget {
  @override
  _HistoriqueCmdeState createState() => _HistoriqueCmdeState();
}

class _HistoriqueCmdeState extends State<HistoriqueCmde> {
  static final String TAG = 'HistoriqueCmdeState';
  final dbHelper = DatabaseHelper.instance;

  UsersLoggedModel _usersLoggedModel;
  PrestatairesModel _prestatairesModel;

  List<dynamic> _commandesModel;
  bool _is_finding = false;
  String _token;
  int _idpresta;
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

    /*  dbHelper.queryAll_presta().then((prest) {
      print("${TAG}:_createForm:queryAll_presta presta=${prest.length}");
      if (prest.length > 0) {
        print(
            "${TAG}:_createForm:_findAllOwnPresta success listCmdes=${prest[0]}");
       /*  _name = prest[0]['nom'].toString();
        _prenom = prest[0]['prenom'].toString();
        print("le nom est : " + _name.toString()); */
        _token = prest[0]['token'].toString();
        _idpresta = prest[0]['prestataireid'];

         print("le token est : " + _token.toString());

Fluttertoast.showToast(
              msg: 'votre token3 est ${_token} et id3 est ${_idpresta.toString()}.',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIos: 8);

      }
   

      }); */

//    print('${TAG}:_findHistoryCmde token = ${_usersLoggedModel.id} | prestionIds = ${_prestatairesModel.prestataireid}');
    API
        .findHistCmdeTer(_usersLoggedModel.id, _prestatairesModel.prestataireid)
        .then((responseCmdes) {
//      print("${TAG}:_findAllOwnCmde:API.findCmdeCreated findAllServices statusCode = ${responseCmdes.statusCode}");
      if (responseCmdes.statusCode == 200) {
        final String responseCmdesString = responseCmdes.body;
        print(
            "${TAG}:_findHistoryCmde:API.findCmdeCreated responseCmdesString = ${responseCmdesString}");

        List<dynamic> listCmdes = new List();

        listCmdes = json
            .decode(responseCmdesString)
            .map((chatCardJson) => CommandesModel.fromJson(chatCardJson))
            .toList();
        print("${TAG}:_findHistoryCmde success listCmdes=${listCmdes.length}");

        setState(() {
          _is_finding = false;
        });
        if (listCmdes.length > 0) {
          setState(() {
            _commandesModel = listCmdes;
            print("commande2 est : " +
                listCmdes.toString() +
                "la taille2 est : " +
                listCmdes.length.toString());
            print("commande est : " +
                _commandesModel.toString() +
                "la taille est : " +
                _commandesModel.length.toString());
          });

          /*  Fluttertoast.showToast(
              msg: 'votre commande est ${_commandesModel.toString()}.',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIos: 8);

               */
          print("commande1 est : " +
              _commandesModel.toString() +
              "la taille1 est : " +
              _commandesModel.length.toString());
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
                                    fontSize: 16.0,
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
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              child: Text(
                                '${cmdeItem.client.prenom} ${cmdeItem.client.nom}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
//                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '${MyConst.amountFormat(double.parse(cmdeItem.prestation.montant.toString()))} XAF',
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  '${cmdeItem.position_destination}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
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
                              )
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
  void initState() {
    // TODO: implement initState
    super.initState();

    initPrestaInfoTok();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenus'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: MyColors.colorBlue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 6.0,
            ),
            Text(
              'Mon Revenu total',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 17.0),
            ),

            /*  Text('montant est : '
                    '${getRevenuTotal(_commandesModel)} XAF',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 28.0),
                  ), */

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
            )
          ],
        ),
      ),
    );
  }
}
