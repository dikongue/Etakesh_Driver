import 'package:etakesh_driver/Utils/AppSharePreferences.dart';
import 'package:etakesh_driver/model/ecompte.dart';
import 'package:etakesh_driver/pages/a_propos/a_propos.dart';
import 'package:etakesh_driver/pages/login/login.dart';
import 'package:etakesh_driver/pages/mes_depots/mes_depots.dart';
import 'package:etakesh_driver/roli/my_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../database/database_helper.dart';
import '../../model/prestataires.dart';
import '../../model/users_logged.dart';
import '../../remote/api.dart';
import '../../roli/my_colors.dart';

class Compte extends StatefulWidget {
  @override
  _CompteState createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  String TAG = "_CompteState";
  final dbHelper = DatabaseHelper.instance;
  bool _is_signout = false;
  ECompteModel _eCompteModel;

  void _delete_database() async {
    setState(() {
      _is_signout = true;
    });

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
        .executeSetPrestaLogged(presta, "OFFLINE", false, prestaRows[0]["token"])
        .then((responseStatus) {
      final String responsePrestaStatus = responseStatus.body;
      print(
          "${TAG}:API.executeSetPrestaLogged ${responseStatus.statusCode} | ${responsePrestaStatus}");
      if (responseStatus.statusCode == 200) {
//    print('${TAG}:_delete_database row ${prestaRows[0]["prestataireid"]} | ${prestaRows[0]["token"]} ${prestaRows[0]}');
        UsersLoggedModel usersLoggedModel = new UsersLoggedModel();
        usersLoggedModel.id = '${prestaRows[0]["token"]}';
//    print('${TAG}:row token ${usersLoggedModel.id}');

        API.executeUsersLogout(usersLoggedModel.id).then((responseSignOut) {
          final String responseLoginString = responseSignOut.body;
          print(
              "${TAG}:API.executeUsersLogout response = ${prestaRows[0]["token"]} | ${responseLoginString}");

              

          if (responseSignOut.statusCode == 204) {
            setState(() {
              _is_signout = false;
            });
            dbHelper.delete_all_presta();
            dbHelper.delete_all_eposition();
            dbHelper.delete_all_prestation();
            dbHelper.delete_all_service();
            dbHelper.delete_all_vehicule();
            dbHelper.delete_all_cmde();
            dbHelper.delete_all_compte();

            AppSharedPreferences().setAppLoggedIn(false);
            AppSharedPreferences().setAllowsNotifications(true);
//        Navigator.popUntil(context, ModalRoute.withName('/login'));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator
                .of(context)
                .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => Login()));
//            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Fluttertoast.showToast(
                msg: 'Déconnexion échouée, veuillez réessayer.',
                backgroundColor: MyColors.colorBlue,
                textColor: Colors.white,
                timeInSecForIos: 3);

            setState(() {
              _is_signout = false;
            });
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Erreur serveur, veuillez réessayer plus tard.',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 3);

        setState(() {
          _is_signout = false;
        });
      }
    });
  }
  void initCompte() async {
    final cpteRows = await dbHelper.queryAll_compte();

    if (cpteRows.length > 0) {
      setState(() {
        _eCompteModel = new ECompteModel(
          compteid: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_ID],
          solde: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_SOLDE],
          prestataireId: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_PRESTATAIREID],
          numero_compte: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_NUMCOMPTE],
          date_creation: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_DATECREATION],
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCompte();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compte'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: MyColors.colorBlue,
      ),
      body: Container(
        color: Colors.white,
        padding:
            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0, top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: EdgeInsets.only(
                  left: 6.0, right: 6.0, top: 14.0, bottom: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 4.0),
                    child: Text('Mon Solde'),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "${_eCompteModel != null ? MyConst.amountFormat(_eCompteModel.solde) : '0.00'} XAF",
                      style: TextStyle(
                          fontSize: 26.0,
                          color: MyColors.colorBlue,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: FlatButton.icon(
                color: Colors.white,
                icon: Icon(
                  Icons.credit_card,
                  size: 32.0,
                  color: Colors.black87,
                ), //`Icon` to display
                label: Text(
                  'Mes Dépôts',
                  style: TextStyle(color: Colors.black87, fontSize: 19.0),
                ), //`Text` to display
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => MesDepots()));
                },
              ),
            ),
            /*Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: FlatButton.icon(
                color: Colors.white,
                icon: Icon(
                  Icons.settings,
                  size: 32.0,
                  color: Colors.black87,
                ), //`Icon` to display
                label: Text(
                  'Paramètre de l\'application',
                  style: TextStyle(color: Colors.black87, fontSize: 19.0),
                ), //`Text` to display
                onPressed: () {},
              ),
            ),*/
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: FlatButton.icon(
                color: Colors.white,
                icon: Icon(
                  Icons.info,
                  size: 32.0,
                  color: Colors.black87,
                ), //`Icon` to display
                label: Text(
                  'A Propos',
                  style: TextStyle(color: Colors.black87, fontSize: 19.0),
                ), //`Text` to display
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => APropos()));
                  },
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 4.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    padding: EdgeInsets.all(4.0),
                    child: Text('Déconnexion',
                        style: TextStyle(
                            color: MyColors.colorJaune, fontSize: 19.0)),
                    onPressed: () {
                      _delete_database();
                    },
                  ),
                  _is_signout
                      ? Container(
                          height: 24.0,
                          width: 24.0,
                          child: CircularProgressIndicator(),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
