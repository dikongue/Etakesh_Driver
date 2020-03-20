import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:etakesh_driver/Utils/AppSharePreferences.dart';
import 'package:etakesh_driver/model/prestataires.dart';
import 'package:etakesh_driver/model/users_logged.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../database/database_helper.dart';
import '../../../model/commandes.dart';
import '../../../remote/api.dart';
import '../../../roli/my_colors.dart';

class NewCommandesDialog extends StatelessWidget {
  final String TAG = 'NewCommandesDialog';
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();
  String localFilePath;

  dynamic commande;
  String token;
  final dbHelper = DatabaseHelper.instance;
  ProgressDialog _progressDialog;

  NewCommandesDialog({@required this.commande, @required this.token});

  bool _is_signout = false;

  @override
  Widget build(BuildContext context) {
    _progressDialog = new ProgressDialog(context);
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    audioCache.play('new_cmde_dialog.mp3');
    return dialogContent(context, commande);
    /*return CarouselSlider(
      height: (MediaQuery.of(context).size.height * 2) / 3,
      items: list_commandes.map((cmdeItem) {
        return Builder(
          builder: (BuildContext context) {
            return dialogContent(context, cmdeItem);
          },
        );
      }).toList(),
    );*/
//    dialogContent(context);
  }


   void deconnexion1() async {
    final prestaRows = await dbHelper.queryAll_presta();

    print("${TAG}:API.executeUsersLogout SUCCESS ${prestaRows}");
    PrestatairesModel presta = new PrestatairesModel(
      prestataireid: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ID],
      cni: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CNI]}',
      date_creation:
          '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_DATE_CREATION]}',
      date_naissance:
          '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_DATE_NAISSANCE]}',
      email: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_EMAIL]}',
      nom: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_NOM]}',
      pays: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PAYS]}',
      prenom: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PRENOM]}',
      status: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_STATUS]}',
      telephone: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TELEPHONE]}',
      ville: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_VILLE]}',
      code: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CODE]}',
      image: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_IMAGE]}',
      positionId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_POSITION_ID],
      UserId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_USER_ID],
      etat: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ETAT],
    );

    API
        .executeSetPrestaLogged(presta, "ONLINE", true, prestaRows[0]["token"])
        .then((responseStatus) {
      final String responsePrestaStatus = responseStatus.body;
      print(
          "${TAG}:API.executeSetPrestaLogged ${responseStatus.statusCode} | ${responsePrestaStatus}");
      if (responseStatus.statusCode == 200) {
        UsersLoggedModel usersLoggedModel = new UsersLoggedModel();
        usersLoggedModel.id = '${prestaRows[0]["token"]}';

        Fluttertoast.showToast(
            msg: 'Commande refusée.',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 3);
      } else {
        Fluttertoast.showToast(
            msg: 'Erreur serveur, veuillez réessayer plus tard.',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 3);
      }
    });
  }

  void deconnexion() async {
    final prestaRows = await dbHelper.queryAll_presta();

    print("${TAG}:API.executeUsersLogout SUCCESS ${prestaRows}");
    PrestatairesModel presta = new PrestatairesModel(
      prestataireid: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ID],
      cni: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CNI]}',
      date_creation:
          '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_DATE_CREATION]}',
      date_naissance:
          '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_DATE_NAISSANCE]}',
      email: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_EMAIL]}',
      nom: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_NOM]}',
      pays: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PAYS]}',
      prenom: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PRENOM]}',
      status: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_STATUS]}',
      telephone: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TELEPHONE]}',
      ville: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_VILLE]}',
      code: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CODE]}',
      image: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_IMAGE]}',
      positionId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_POSITION_ID],
      UserId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_USER_ID],
      etat: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ETAT],
    );

    API
        .executeSetPrestaLogged(presta, "ONLINE", true, prestaRows[0]["token"])
        .then((responseStatus) {
      final String responsePrestaStatus = responseStatus.body;
      print(
          "${TAG}:API.executeSetPrestaLogged ${responseStatus.statusCode} | ${responsePrestaStatus}");
      if (responseStatus.statusCode == 200) {
        UsersLoggedModel usersLoggedModel = new UsersLoggedModel();
        usersLoggedModel.id = '${prestaRows[0]["token"]}';

        Fluttertoast.showToast(
            msg: 'Déconnexion reussie.',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 3);
      } else {
        Fluttertoast.showToast(
            msg: 'Erreur serveur, veuillez réessayer plus tard.',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 3);
      }
    });
  }


  void reconnexion() async {
    final prestaRows = await dbHelper.queryAll_presta();

    print("${TAG}:API.executeUsersLogout SUCCESS ${prestaRows}");
    PrestatairesModel presta = new PrestatairesModel(
      prestataireid: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ID],
      cni: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CNI]}',
      date_creation:
          '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_DATE_CREATION]}',
      date_naissance:
          '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_DATE_NAISSANCE]}',
      email: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_EMAIL]}',
      nom: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_NOM]}',
      pays: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PAYS]}',
      prenom: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PRENOM]}',
      status: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_STATUS]}',
      telephone: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TELEPHONE]}',
      ville: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_VILLE]}',
      code: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CODE]}',
      image: '${prestaRows[0][DatabaseHelper.COLUMN_PRESTA_IMAGE]}',
      positionId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_POSITION_ID],
      UserId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_USER_ID],
      etat: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ETAT],
    );

    API
        .executeSetPrestaLogged(presta, "ONLINE", false, prestaRows[0]['token'])
        .then((responseStatus) {
      final String responseStatusBody = responseStatus.body;

      print(
          "${TAG}:API.executeSetPrestaLogged ${responseStatus.statusCode} | ${responseStatusBody}");
      if (responseStatus.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Commande refusée2.',
            backgroundColor: MyColors.colorVert,
            textColor: Colors.white,
            timeInSecForIos: 3);
      } else {
        Fluttertoast.showToast(
            msg: 'Erreur serveur, veuillez réessayer plus tard.',
            backgroundColor: MyColors.colorRouge,
            textColor: Colors.white,
            timeInSecForIos: 3);
      }
    });
  }


  Widget dialogContent(BuildContext context, CommandesModel cmdeModal) {
    DateTime dateTime =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(cmdeModal.date);

    print(
        '${TAG}:CarouselSlider cmdeItem=${cmdeModal} | ${cmdeModal.code} | ${cmdeModal.prestation.service} ');

    return Stack(
      children: <Widget>[
        Material(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:
                EdgeInsets.only(top: 32, left: 16.0, right: 16.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      cmdeModal.client.image + "?access_token=" + token),
                  backgroundColor: Colors.grey,
                  radius: Consts.avatarRadius,
                ),
                Center(
                  child: Text(
                    '${cmdeModal.client.prenom} ${cmdeModal.client.nom} ${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 7.0, top: 15.0),
                    child: Text(
                      '${cmdeModal.prestation.service.intitule} (${cmdeModal.prestation.montant} FR CFA)',
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.w700,
                        color: MyColors.colorBlue,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.brightness_1,
                          color: MyColors.colorBlue,
                          size: 13.0,
                        ),
                        Expanded(
                            child: Text(
                          '   ${cmdeModal.position_prise_en_charge}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.w400,
                            color: MyColors.colorBlue,
                          ),
                        )),
                      ],
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.panorama_fish_eye,
                      color: MyColors.colorBlue,
                      size: 13.0,
                    ),
                    Expanded(
                      child: Text(
                        '   ${cmdeModal.position_destination}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.w400,
                          color: MyColors.colorBlue,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: FlatButton.icon(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 14.0, right: 14.0),
                          color: MyColors.colorRouge,
                          textColor: Colors.white,
                          onPressed: () {
                            //_progressDialog.setMessage('Veuillez patienter...');
                            _progressDialog.show();

                            cmdeModal.is_created = true;
                            cmdeModal.is_refused = true;
                            cmdeModal.is_accepted = false;

                            //cmdeModal.status = "ANNULER";
                             cmdeModal.is_terminated = false;
                            print(cmdeModal);
                            
                           // cmdeModal.is_terminated = true;

                               print("cmd refuser...............");
                            API
                                .executeSetCmde(commande, token)
                                .then((responseSetCmde) {
                              final String responsesetCmdeBody =
                                  responseSetCmde.body;
                                print("on retire le msg....");
                              _progressDialog.hide();
                              print(
                                  "${TAG}:dialogContent:API.executeSetCmde REFUSED findAllServices statusCode = ${responseSetCmde.statusCode} | ${responsesetCmdeBody}");
                              if (responseSetCmde.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: 'Commande REFUSÉE.',
                                    backgroundColor: MyColors.colorBlue,
                                    textColor: Colors.white,
                                    timeInSecForIos: 3);
                                Navigator.of(context).pop(cmdeModal);
                                //deconnexion1();
                               // reconnexion();


                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Impossible de refuser la commande. veuillez réessayer.',
                                    backgroundColor: MyColors.colorRouge,
                                    textColor: Colors.white,
                                    timeInSecForIos: 3);
                              }
                            });
                          },

                          label: Text(
                            "REFUSER",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w900),
                          ),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: FlatButton.icon(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 14.0, right: 14.0),
                          color: MyColors.colorVert,
                          textColor: Colors.white,
                          onPressed: () {
                            // _progressDialog.setMessage('Veuillez patienter...');
                            _progressDialog.show();

                            cmdeModal.is_created = true;
                            cmdeModal.is_accepted = true;
                            cmdeModal.is_refused = false;
                            cmdeModal.is_terminated = false;

                            API
                                .executeSetCmde(commande, token)
                                .then((responseSetCmde) {
                              final String responsesetCmdeBody =
                                  responseSetCmde.body;

                              _progressDialog.hide();
                              print(
                                  "${TAG}:dialogContent:API.executeSetCmde ACCEPTED findAllServices statusCode = ${responseSetCmde.statusCode} | ${responsesetCmdeBody}");
                              if (responseSetCmde.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: 'Commande ACCEPTÉE.',
                                    backgroundColor: MyColors.colorVert,
                                    textColor: Colors.white,
                                    timeInSecForIos: 3);
                                //  deconnexion();
                                Navigator.of(context).pop(cmdeModal);
                                // AppSharedPreferences().setOrderCreate(true);
                                deconnexion();
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Impossible d\'accepter la commande. veuillez réessayer.',
                                    backgroundColor: MyColors.colorRouge,
                                    textColor: Colors.white,
                                    timeInSecForIos: 3);
                              }
                            });
                          },
                          label: Text(
                            "ACCEPTER",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w900),
                          ),
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 14.0;
  static const double avatarRadius = 50.0;
}
