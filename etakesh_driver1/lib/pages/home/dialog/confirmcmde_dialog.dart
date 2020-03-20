import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:etakesh_driver/Utils/AppSharePreferences.dart';
import 'package:etakesh_driver/model/prestataires.dart';
import 'package:etakesh_driver/roli/etakesh_tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../remote/api.dart';
import '../../../database/database_helper.dart';
import '../../../model/commandes.dart';
import '../../../roli/my_colors.dart';

class ConfirmCommandesDialog extends StatelessWidget {
  final String TAG = 'ConfirmCommandesDialog';
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();
  String localFilePath;
  MediaQueryData mediaQueryData;

  Timer timer;
  Timer timer1;

  dynamic commande;
  String token;
  final dbHelper = DatabaseHelper.instance;
  ProgressDialog _progressDialog;

  bool _isButtonDisabled;
  bool _isvalider = false;
  String _code;

  ConfirmCommandesDialog({@required this.commande, @required this.token});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    _progressDialog = new ProgressDialog(context);
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

//    audioCache.play('new_cmde_dialog.mp3');

    ///  Service de notif des cmds validees et des cmds en cour de livraison
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      print("${TAG}:Timer.periodic tick=${t.tick}");
      checkCmdeServer(context);
    });

    //
    /* AppSharedPreferences().isTime().then((bool1){
      _isButtonDisabled = true;
    });
 */
    return dialogContent(context, commande);
  }

  void checkCmdeServer(BuildContext context) {
    print("${TAG}:checkCmdeServer ");
    API.findCmdeCreatedById(token, commande.commandeid).then((responseCmde) {
      print("${TAG}:checkCmdeServer statusCode=${responseCmde.statusCode}");
      if (responseCmde.statusCode == 200) {
        final String responseCmdeString = responseCmde.body;
        print(
            "${TAG}:checkCmdeServer responseCmdeString=${responseCmdeString}");

        CommandesModel cmde =
            new CommandesModel.fromJson(json.decode(responseCmdeString));

        if (cmde.is_terminated == true &&
            cmde.is_refused == false &&
            cmde.is_accepted == true &&
            cmde.is_created == true &&
            cmde.status == "TERMINATED") {
          timer.cancel();
          Navigator.of(context).pop(cmde);
        }
      }
    });
  }

  String TAG1 = "LoginState";

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
          "${TAG1}:API.executeSetPrestaLogged ${responseStatus.statusCode} | ${responseStatusBody}");
      if (responseStatus.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Connection reussie.',
            backgroundColor: MyColors.colorBlue,
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
    print(
        '${TAG}:dialogContent cmdeItem=${cmdeModal} | ${cmdeModal.code} | ${cmdeModal.prestation.service}');

    return Stack(
      children: <Widget>[
        Material(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:
                EdgeInsets.only(top: 30, left: 16.0, right: 16.0, bottom: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.topRight,
                  child: IconButton(
                    onPressed: () {
                      timer.cancel();
                      Navigator.of(context).pop(null);
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 26.0,
                      color: Colors.black,
                    ),
                  ),
                ),

                /*  Align(
                  alignment: FractionalOffset.topLeft,
                  child: FlatButton.icon(
                    color: MyColors.colorRouge,
                    textColor: Colors.white,
                    label: Text(
                      "ANNULEE",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w900),
                    ),
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () {

                     
                      // modification du status des commandes
                      _progressDialog.show();

                      cmdeModal.status = "ANNULER";
                      cmdeModal.is_terminated = true;

                      API
                          .executeSetCmde(commande, token)
                          .then((responseSetCmde) {
                        final String responsesetCmdeBody = responseSetCmde.body;

                        _progressDialog.hide();
                        print(
                            "${TAG}:dialogContent:API.executeSetCmde ANNULEE findAllServices statusCode = ${responseSetCmde.statusCode} | ${responsesetCmdeBody}");
                        if (responseSetCmde.statusCode == 200) {
                          // passer le prestataire en ONLINE
                          reconnexion();
                          Fluttertoast.showToast(
                              msg: 'COMMANDE ANNULEE.',
                              backgroundColor: MyColors.colorBlue,
                              textColor: Colors.white,
                              timeInSecForIos: 3);
                          Navigator.of(context).pop(cmdeModal);
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'Impossible d annuler la commande. veuillez réessayer.',
                              backgroundColor: MyColors.colorRouge,
                              textColor: Colors.white,
                              timeInSecForIos: 3);
                        }
                      });
                   

                    },
                  ),
                ),
 */
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                  backgroundColor: Colors.grey,
                  radius: Consts.avatarRadius,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0, top: 5.0),
                    child: Text(
                      'En attente du scan du QR Code par le client ${cmdeModal.client.prenom} ${cmdeModal.client.nom}',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                    child: Text(
                      '${cmdeModal.prestation.service.intitule} (${cmdeModal.prestation.montant} FR CFA)',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.w700,
                        color: MyColors.colorBlue,
                      ),
                    ),
                  ),
                ),
                QrImage(
                  padding: EdgeInsets.only(top: 5.0),
                  data: "${cmdeModal.code}",
                  size: mediaQueryData.size.height * 0.3,
                ),
                SizedBox(
                  height: 15,
                ),
                
                
                     SizedBox(
                        width: double.infinity,
                        child: FlatButton.icon(
                          color: MyColors.colorRouge,
                          textColor: Colors.white,
                          label: Text(
                            "ANNULEE",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w900),
                          ),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // modification du status des commandes
                            _progressDialog.show();

                            cmdeModal.status = "ANNULER";
                            cmdeModal.is_terminated = false;

                            API
                                .executeSetCmde(commande, token)
                                .then((responseSetCmde) {
                              final String responsesetCmdeBody =
                                  responseSetCmde.body;

                              _progressDialog.hide();
                              print(
                                  "${TAG}:dialogContent:API.executeSetCmde ANNULEE findAllServices statusCode = ${responseSetCmde.statusCode} | ${responsesetCmdeBody}");
                              if (responseSetCmde.statusCode == 200) {
                                // passer le prestataire en ONLINE
                                reconnexion();
                                Fluttertoast.showToast(
                                    msg: 'COMMANDE ANNULEE.',
                                    backgroundColor: MyColors.colorBlue,
                                    textColor: Colors.white,
                                    timeInSecForIos: 3);
                                Navigator.of(context).pop(cmdeModal);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Impossible d annuler la commande. veuillez réessayer.',
                                    backgroundColor: MyColors.colorRouge,
                                    textColor: Colors.white,
                                    timeInSecForIos: 3);
                              }
                            });
                          },
                        ),
                      ),
                      
                    /* : SizedBox(
                        width: double.infinity,
                        child: FlatButton.icon(
                          color: MyColors.colorRouge,
                          textColor: Colors.white,
                          label: Text(
                            "APPUYER ICI POUR RECEVOIR VOTRE CODE",
                            style: TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.w900),
                          overflow: TextOverflow.ellipsis,),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // recuperation du code de validation

                            API.findCmdeById(token, commande).then((response) {
                              if (response.statusCode == 200) {
                                print(
                                    "${TAG}: getClientById statusCode=${response.statusCode}");

                                final String responseString = response.body;
                                print(
                                    "${TAG}: getClientById responseCmdeString=${responseString}");

                                CommandesModel cmde =
                                    new CommandesModel.fromJson(
                                        json.decode(responseString));

                                _code = cmde.rate_comment.toString();

                              }else{

                                ////
                                ///
                              }

                            });

                            Alert(
                                context: context,
                                title: "VOTRE CODE DE VALIDATION",
                                content: Column(
                                  children: <Widget>[
                                    Text("{$_code}"),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _isvalider = true;
                                    },
                                    child: Text(
                                      "VALIDER",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ]).show();
                          },
                        ),
                      ) */
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
