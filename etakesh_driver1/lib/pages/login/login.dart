import 'dart:convert';

import 'package:etakesh_driver/Utils/AppSharePreferences.dart';
import 'package:etakesh_driver/roli/etakesh_tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../database/database_helper.dart';
import '../../model/eposition.dart';
import '../../model/prestataires.dart';
import '../../model/users_logged.dart';
import '../../model/services.dart';
import '../../model/vehicules.dart';
import '../../model/prestations.dart';
import '../../model/ecompte.dart';

import '../../remote/api.dart';
import '../../roli/my_colors.dart';
import '../home/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String TAG = "LoginState";
  Widget _page;

  final GlobalKey<FormState> _key_formlogin = GlobalKey<FormState>();
  bool _autovalidate_formlogin = false;
  var _password_controller = TextEditingController();
  var _email_controller = TextEditingController();
  FocusNode email_node;
  FocusNode password_node;
  ProgressDialog _progressDialog;

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

//  insertion du prestataire dans la BD
  void _insert_presta(
      PrestatairesModel prestaMod, UsersLoggedModel userLogged) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_PRESTA_ID: prestaMod.prestataireid,
      DatabaseHelper.COLUMN_PRESTA_NOM: prestaMod.nom,
      DatabaseHelper.COLUMN_PRESTA_PRENOM: prestaMod.prenom,
      DatabaseHelper.COLUMN_PRESTA_CNI: prestaMod.cni,
      DatabaseHelper.COLUMN_PRESTA_DATE_CREATION: prestaMod.date_creation,
      DatabaseHelper.COLUMN_PRESTA_DATE_NAISSANCE: prestaMod.date_naissance,
      DatabaseHelper.COLUMN_PRESTA_EMAIL: prestaMod.email,
      DatabaseHelper.COLUMN_PRESTA_PAYS: prestaMod.pays,
      DatabaseHelper.COLUMN_PRESTA_STATUS: prestaMod.status,
      DatabaseHelper.COLUMN_PRESTA_TELEPHONE: prestaMod.telephone,
      DatabaseHelper.COLUMN_PRESTA_VILLE: prestaMod.ville,
      DatabaseHelper.COLUMN_PRESTA_CODE: prestaMod.code,
      DatabaseHelper.COLUMN_PRESTA_IMAGE: prestaMod.image,
      DatabaseHelper.COLUMN_PRESTA_TOKEN: userLogged.id,
      DatabaseHelper.COLUMN_PRESTA_TTL: userLogged.ttl,
      DatabaseHelper.COLUMN_PRESTA_POSITION_ID: prestaMod.positionId,
      DatabaseHelper.COLUMN_PRESTA_USER_ID: userLogged.userId
      /* DatabaseHelper.COLUMN_PRESTA_ETAT: prestaMod.etat */
    };
    final id = await dbHelper.insert_presta(row);
    print('${TAG}:_insert_presta inserted row id: $id');
  }

  void _insert_eposition(EPositionModel epos) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_POSITION_ID:
          epos.positionid != null ? epos.positionid : 0,
      DatabaseHelper.COLUMN_POSITION_LIBELLE: epos.libelle,
      DatabaseHelper.COLUMN_POSITION_LNG: epos.longitude,
      DatabaseHelper.COLUMN_POSITION_LAT: epos.latitude,
    };
    final id = await dbHelper.insert_eposition(row);
//    print('${TAG}:_insert_eposition inserted row id: $id');
  }

  void _insert_ecompte(ECompteModel ecpte) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_COMPTE_ID:
          ecpte.compteid != null ? ecpte.compteid : 0,
      DatabaseHelper.COLUMN_COMPTE_SOLDE: ecpte.solde,
      DatabaseHelper.COLUMN_COMPTE_PRESTATAIREID: ecpte.prestataireId,
      DatabaseHelper.COLUMN_COMPTE_NUMCOMPTE: ecpte.numero_compte,
      DatabaseHelper.COLUMN_COMPTE_DATECREATION: ecpte.date_creation,
    };
    final id = await dbHelper.insert_compte(row);
    print('${TAG}:_insert_ecompte inserted row id: $id');
  }

  void _insert_service(ServicesModel serv) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_SERV_ID: serv.serviceid,
      DatabaseHelper.COLUMN_SERV_DATECREATION: serv.date_creation,
      DatabaseHelper.COLUMN_SERV_STATUS: serv.status,
      DatabaseHelper.COLUMN_SERV_PRIX: serv.prix,
      DatabaseHelper.COLUMN_SERV_INTITULE: serv.intitule,
      DatabaseHelper.COLUMN_SERV_PRIXYDE: serv.prix_yaounde,
      DatabaseHelper.COLUMN_SERV_PRIXDLA: serv.prix_douala,
      DatabaseHelper.COLUMN_SERV_DUREE: serv.duree,
      DatabaseHelper.COLUMN_SERV_CODE: serv.code,
    };
    final id = await dbHelper.insert_service(row);
    print('${TAG}:_insert_service inserted row id: $id');
  }

  void _insert_vehicule(VehiculesModel vehi) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_VEHI_ID: vehi.vehiculeid,
      DatabaseHelper.COLUMN_VEHI_PRESTATAIREID: vehi.prestataireId,
      DatabaseHelper.COLUMN_VEHI_CATEGORIEVEHICILEID: vehi.categorievehiculeId,
      DatabaseHelper.COLUMN_VEHI_DATE: vehi.date,
      DatabaseHelper.COLUMN_VEHI_NOMBREPLACES: vehi.nombre_places,
      DatabaseHelper.COLUMN_VEHI_MARQUE: vehi.marque,
      DatabaseHelper.COLUMN_VEHI_IMMATRICULATION: vehi.immatriculation,
      DatabaseHelper.COLUMN_VEHI_STATUS: vehi.status,
      DatabaseHelper.COLUMN_VEHI_COULEUR: vehi.couleur,
      DatabaseHelper.COLUMN_VEHI_IMAGE: vehi.image,
      DatabaseHelper.COLUMN_VEHI_CODE: vehi.code,
    };
    final id = await dbHelper.insert_vehicule(row);
    print('${TAG}:_insert_vehicule inserted row id: $id');
  }

  void _insert_prestation(PrestationsModel prestion) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_PRESTION_ID: prestion.prestationid,
      DatabaseHelper.COLUMN_PRESTION_SERVICEID: prestion.serviceId,
      DatabaseHelper.COLUMN_PRESTION_PRESTATAIREID: prestion.prestataireId,
      DatabaseHelper.COLUMN_PRESTION_VEHICULEID: prestion.vehiculeId,
      DatabaseHelper.COLUMN_PRESTION_MONTANT: prestion.montant,
      DatabaseHelper.COLUMN_PRESTION_STATUS: prestion.status,
      DatabaseHelper.COLUMN_PRESTION_DATE: prestion.date,
    };
    final id = await dbHelper.insert_prestation(row);
    print('${TAG}:_insert_prestation inserted row id: $id');
  }

  void _query_presta() async {
    final prestaRows = await dbHelper.queryAll_presta();
    print(
        '${TAG}:_query_presta query all rows:${prestaRows.length} | ${prestaRows.toString()}');
    if (prestaRows.length > 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home()));
      return;
    }
  }

  void executeFindCompte() async {}

  void attempSignIn(BuildContext context) {
    if (_key_formlogin.currentState.validate()) {
      ETakeshTools.showSimpleLoadingDialog(context, 'Connexion en cours...');

      print(
          "${TAG} email=${_email_controller.text} | password=${_password_controller.text}");

// on effectue une requete de post de login pour le prestataire
      API
          .executeUsersLogin(_email_controller.text, _password_controller.text)
          .then((responseLogin) {
        final String responseLoginString = responseLogin.body;
//        print("${TAG}:API.executeUsersLogin ${responseLogin.statusCode} | ${responseLoginString}");
        if (responseLogin.statusCode == 200) {
          UsersLoggedModel userslogged =
              new UsersLoggedModel.fromJson(json.decode(responseLoginString));
//                                          print("${TAG}:userslogged id = ${userslogged.id} ttl = ${userslogged.ttl} userId = ${userslogged.userId}");

//                                          Recuperation des informations du prestataire
          API
              .findOnePresta(userslogged.userId, userslogged.id)
              .then((responsePresta) {
            final String responsePrestaString = responsePresta.body;
            print(
                "${TAG}:API.findOnePresta ${responsePresta.statusCode} | ${responsePrestaString}");

            if (responsePresta.statusCode == 200) {
              PrestatairesModel presta = new PrestatairesModel.fromJson(
                  json.decode(responsePrestaString));
              print(
                  "${TAG}:findOnePresta prestataireid = ${presta.prestataireid} nom = ${presta.nom} ${presta.prenom} UserId = ${presta.nom} ${presta.UserId}");

              // verifier qu'un prestataire ne se connecte avec le compte d'un autre prestataire en ONLINE
              print("status user : " + presta.status);

            //    if(presta.status.toString() != "ONLINE"){

//              Modification du status de connexion du prestataire
              API
                  .executeSetPrestaLogged(
                      presta, "ONLINE", false, userslogged.id)
                  .then((responseStatus) {
                final String responseStatusBody = responseStatus.body;

                print(
                    "${TAG}:API.executeSetPrestaLogged ${responseStatus.statusCode} | ${responseStatusBody}");
                //  print("l'etat actuel est : " + presta.etat.toString());
                if (responseStatus.statusCode == 200) {
                  //  print("l'etat actuel est : " + presta.etat.toString());
                  API
                      .findCompte(presta.prestataireid, userslogged.id)
                      .then((responseCpte) {
                    final String responseCpteBody = responseCpte.body;

                    print(
                        "${TAG}:API.findCompte ${responseCpte.statusCode} | ${responseCpteBody}");
                    if (responseStatus.statusCode == 200) {
                      //   print("l'etat actuel est : " + presta.etat.toString());
                      ECompteModel ecpte = new ECompteModel.fromJson(
                          json.decode(responseCpteBody));
//                      showLoadingDialog(false, null);
//                      suppression des elements dans la BD
                      dbHelper.delete_all_presta();
                      dbHelper.delete_all_eposition();
                      dbHelper.delete_all_prestation();
                      dbHelper.delete_all_service();
                      dbHelper.delete_all_vehicule();
                      dbHelper.delete_all_compte();

//                                                Insertion du prestataire dans la BD
                      _insert_presta(presta, userslogged);
                      _insert_ecompte(ecpte);
//              print("${TAG}:attempLogin ${presta.position}");
                      if (presta.position != null) {
                        _insert_eposition(presta.position);
                      }

                      // var _vehi = null;
                      VehiculesModel _vehicules;

                      debugPrint("Presta : " + presta.toString());
                      for (int i = 0; i < presta.prestation.length; i++) {
                        PrestationsModel prestionItem = presta.prestation[i];

                        debugPrint(
                            "taille " + presta.prestation.length.toString());
                        debugPrint("data : " + prestionItem.toString());

                        _insert_prestation(prestionItem);
                        _insert_service(prestionItem.service);

                        debugPrint(
                            "service : " + prestionItem.service.toString());

                        _vehicules = prestionItem.vehicule;

                        debugPrint("vehicule1 avant : " +
                            _vehicules.immatriculation.toString());
                        debugPrint(
                            "vehicule1 avant : " + _vehicules.toString());

                        // _insert_vehicule(prestionItem.vehicule);
                      }
                      debugPrint(
                          "vehicule2 apres : " + _vehicules.code.toString());
                      debugPrint("vehicule2 apres : " + _vehicules.toString());
                      _insert_vehicule(_vehicules);

                      print("${TAG}:Login SUCCESS ");

                      ETakeshTools.dismissAlertDialog(context);
                      AppSharedPreferences().setAppLoggedIn(true);
                      // AppSharedPreferences().setAllowsNotifications(true);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Home()));
                    } else {
                      ETakeshTools.dismissAlertDialog(context);

                      Fluttertoast.showToast(
                          msg: 'Erreur serveur, veuillez réessayer plus tard.',
                          backgroundColor: MyColors.colorRouge,
                          textColor: Colors.white,
                          timeInSecForIos: 3);

                      setState(() {
                        _autovalidate_formlogin = true;
                      });
                    }
                  }).catchError((error) {
                    ETakeshTools.dismissAlertDialog(context);

                    Fluttertoast.showToast(
                        msg: 'Erreur réseau. Veuillez réessayer plus tard',
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        timeInSecForIos: 3);
                  });
                } else {
                  ETakeshTools.dismissAlertDialog(context);

                  Fluttertoast.showToast(
                      msg: 'Erreur serveur, veuillez réessayer plus tard.',
                      backgroundColor: MyColors.colorRouge,
                      textColor: Colors.white,
                      timeInSecForIos: 3);

                  setState(() {
                    _autovalidate_formlogin = true;
                  });
                }
              }).catchError((error) {
                ETakeshTools.dismissAlertDialog(context);

                Fluttertoast.showToast(
                    msg: 'Erreur réseau. Veuillez réessayer plus tard',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    timeInSecForIos: 3);
              });

              /*   }else{
              ETakeshTools.dismissAlertDialog(context);

              showDialog(
                  context: context,
              builder: (BuildContext context){
                    return AlertDialog(
                      title: Text("Compte Driver invalide"),
                      content: Text("Compte Driver déjà ouvert, veuillez contacter le service client."),
                      actions: <Widget>[
                        FlatButton(onPressed: () {Navigator.of(context).pop();}, child: Text("OK"))
                      ],
                    );
              });
            }  */

            } else if (responsePresta.statusCode == 404) {
              ETakeshTools.dismissAlertDialog(context);

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Compte Driver invalide"),
                      content: Text(
                          "Compte Driver invalide, veuillez contacter le service client."),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"))
                      ],
                    );
                  });
              /*Fluttertoast.showToast(
                  msg:
                      'Compte Driver invalide, veuillez contacter le service client.',
                  backgroundColor: MyColors.colorBlue,
                  textColor: Colors.white,
                  timeInSecForIos: 3); */

              setState(() {
                _autovalidate_formlogin = true;
              });
            } else {
              ETakeshTools.dismissAlertDialog(context);

              Fluttertoast.showToast(
                  msg: 'Erreur serveur, veuillez réessayer plus tard.',
                  backgroundColor: MyColors.colorRouge,
                  textColor: Colors.white,
                  timeInSecForIos: 3);

              setState(() {
                _autovalidate_formlogin = true;
              });
            }
          }).catchError((error) {
            ETakeshTools.dismissAlertDialog(context);

            Fluttertoast.showToast(
                msg: 'Erreur réseau. Veuillez réessayer plus tard',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                timeInSecForIos: 3);
          });
        } else {
          ETakeshTools.dismissAlertDialog(context);

          Fluttertoast.showToast(
              msg: 'Paramètres de connexion incorrect.',
              backgroundColor: MyColors.colorRouge,
              textColor: Colors.white,
              timeInSecForIos: 3);

          setState(() {
            _autovalidate_formlogin = true;
          });
        }
      }).catchError((error) {
        ETakeshTools.dismissAlertDialog(context);

        Fluttertoast.showToast(
            msg: 'Erreur réseau. Veuillez réessayer plus tard',
            backgroundColor: Colors.black,
            textColor: Colors.white,
            timeInSecForIos: 3);
      });
    } else {
      setState(() {
        _autovalidate_formlogin = true;
      });
    }
  }

// emettre une appel vers le service E-TAKESH

  final String phone = 'tel:+237677144446';

  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone $phone';
    }
  }

  Widget _createForm(BuildContext context) {
    _query_presta();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.5),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0),
          child: Form(
            key: _key_formlogin,
            autovalidate: _autovalidate_formlogin,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Connectez-vous',
                          style: new TextStyle(fontSize: 31.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          controller: _email_controller,
                          focusNode: email_node,
                          enabled: true,
                          enableInteractiveSelection: true,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                          ),
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 0.0, top: 0.0, bottom: 2.0),
                            labelText: "Adresse e-mail",
                            labelStyle: TextStyle(color: MyColors.colorBlack),
                            border: null,
                          ),
                          onFieldSubmitted: (term) {
                            email_node.unfocus();
                            FocusScope.of(context).requestFocus(password_node);
                          },
                          validator: (value) {
                            if (value.length == 0) {
                              return "Veuillez remplir l'adresse e-mail.";
                            } else if (!new RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(value)) {
                              return "Adresse e-mail invalide.";
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          controller: _password_controller,
                          focusNode: password_node,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                          ),
                          obscureText: true,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 0.0, top: 0.0, bottom: 2.0),
                            labelText: "Mot de Passe",
                            counterStyle: TextStyle(color: MyColors.colorBlack),
                            labelStyle: TextStyle(color: MyColors.colorBlack),
                            border: null,
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Veuillez remplir le mot de passe";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 12.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                        minWidth: 0.0,
                        child: Text('Mot de Passe oublié ?',
                            style: new TextStyle(
                                fontSize: 17.0, color: MyColors.colorBlue)),
                        onPressed: () {
                          _callPhone();
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        child: FloatingActionButton(
                            elevation: 12.0,
                            backgroundColor: MyColors.colorBlue,
                            child: Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              attempSignIn(context);
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    password_node = FocusNode();
    email_node = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      // Create the form if it does not exist
      _page = _createForm(context); // Build the form
    }
    _progressDialog = new ProgressDialog(context);
    return _page;
  }
}
