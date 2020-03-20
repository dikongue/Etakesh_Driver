import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etakesh_driver/model/prestataires.dart';
import 'package:etakesh_driver/model/users_logged.dart';
import 'package:etakesh_driver/roli/my_colors.dart';
import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../model/vehicules.dart';
import '../../remote/api.dart';

class MonProfil extends StatefulWidget {
  @override
  _MonProfilState createState() => _MonProfilState();
}

class _MonProfilState extends State<MonProfil> {
  String TAG = "_CompteState";
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  final dbHelper = DatabaseHelper.instance;
  bool _is_signout = false;
  VehiculesModel _vehiculesModel;
  UsersLoggedModel _usersLoggedModel;
  PrestatairesModel _prestatairesModel;
  String _profile_img,_vehicule_img;
  File _imageProfile;

//  modification de la photo prestataire
  void _update_presta_image(PrestatairesModel prestaMod) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_PRESTA_ID: prestaMod.prestataireid,
      DatabaseHelper.COLUMN_PRESTA_IMAGE: prestaMod.image,
    };
    final id = await dbHelper.update_presta(row);
//    print('${TAG}:_update_presta_image updated row id: $id');
  }

//  Future getImageFromLocal() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      _imageProfile = image;
//      print(
//          "${TAG}:getImageFromLocal length=${_imageProfile.length()} | path=${_imageProfile.path}");
//
//      uploadImgToServer(_imageProfile);
//    });
//  }

//  void uploadImgToServer(File imgProfile) {
//    String imgName =
//        'PRO_${DateFormat("yMMdd_hhmmss").format(DateTime.now())}.png';
//
//    API
//        .executeSaveContainers(_prestatairesModel.code, _usersLoggedModel.id)
//        .then((responseContainer) {
//      print(
//          "${TAG}:uploadImgToServer:executeSaveContainers statusCode=${responseContainer.statusCode}");
//      if (responseContainer.statusCode == 200 ||
//          json.decode(responseContainer.body)['error']['code'] == "EEXIST") {
//        final String responseContString = responseContainer.body;
////        print("${TAG}:uploadImgToServer:executeSaveContainers responseContStringCode=${json.decode(responseContainer.body)['error']['code']} responseContString=${responseContString}");
//
//        API
//            .uploadPrestaImg(_prestatairesModel.code, imgProfile, imgName,
//                _usersLoggedModel.id)
//            .then((responseUpload) {
//          print(
//              "${TAG}:uploadImgToServer:executeSaveContainers:uploadPrestaImg ${responseUpload.statusCode}");
//          final String responseUplString = responseUpload.statusMessage;
//          print(
//              "${TAG}:uploadImgToServer:executeSaveContainers:uploadPrestaImg imgName=${imgName} prestataireid=${_prestatairesModel.prestataireid} responseUplString=${responseUplString}");
//          if (responseUpload.statusCode == 200) {
//            PrestatairesModel presta = new PrestatairesModel(
//              prestataireid: _prestatairesModel.prestataireid,
//              cni: '${_prestatairesModel.cni}',
//              date_creation: '${_prestatairesModel.date_creation}',
//              date_naissance: '${_prestatairesModel.date_naissance}',
//              email: '${_prestatairesModel.email}',
//              nom: '${_prestatairesModel.nom}',
//              pays: '${_prestatairesModel.pays}',
//              prenom: '${_prestatairesModel.prenom}',
//              status: '${_prestatairesModel.status}',
//              telephone: '${_prestatairesModel.telephone}',
//              ville: '${_prestatairesModel.ville}',
//              code: '${_prestatairesModel.code}',
//              image: '${imgName}',
//              positionId: _prestatairesModel.positionId,
//              UserId: _prestatairesModel.UserId,
//            );
//
//            API
//                .executeSetPrestaInfos(presta, _usersLoggedModel.id)
//                .then((responseInfos) {
//              final String responseInfosBody = responseInfos.body;
//              print(
//                  "${TAG}:API.executeSetPrestaLogged ${responseInfos.statusCode} | ${responseInfosBody}");
//
//              if (responseInfos.statusCode == 200) {
//                setState(() {
//                  _prestatairesModel = null;
//                  _prestatairesModel = new PrestatairesModel.fromJson(
//                      json.decode(responseInfosBody));
//                  _profile_img = API.getProfileImgURL(_prestatairesModel.code,
//                      _prestatairesModel.image, _usersLoggedModel.id);
//
//                  _update_presta_image(_prestatairesModel);
//                  print(
//                      "${TAG}:API.executeSetPrestaInfos newImgProf ${_prestatairesModel.prestataireid} | ${_prestatairesModel.image} | ${_profile_img}");
//                  initPrestaInfoTok();
//                });
//              } else {
//                Fluttertoast.showToast(
//                    msg: 'Vos informations n\'ont pas été mise a jour, veuillez reouvrir E-Takesh.',
//                    backgroundColor: MyColors.colorRouge,
//                    textColor: Colors.white,
//                    timeInSecForIos: 3);
//
//              }
//            });
//          } else {
//            Fluttertoast.showToast(
//                msg: 'Photo invalide, veuillez choisir une autre photo.',
//                backgroundColor: MyColors.colorRouge,
//                textColor: Colors.white,
//                timeInSecForIos: 3);
//
//          }
//        });
//      } else {
//        Fluttertoast.showToast(
//            msg: 'Erreur serveur, veuillez réessayer plus tard.',
//            backgroundColor: MyColors.colorRouge,
//            textColor: Colors.white,
//            timeInSecForIos: 3);
//
//      }
//    });
//  }

//  initialisation du token pour les requetes http
  void initPrestaInfoTok() async {
    final prestaRows = await dbHelper.queryAll_presta();

//    print("${TAG}:initPrestaInfoTok ${vehiRows.length}");
    if (prestaRows.length > 0) {
      setState(() {
        _usersLoggedModel = new UsersLoggedModel(
          id: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TOKEN],
        );

        _prestatairesModel = new PrestatairesModel(
          prestataireid: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_ID],
          cni: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CNI],
          email: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_EMAIL],
          nom: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_NOM],
          prenom: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PRENOM],
          date_creation: prestaRows[0]
              [DatabaseHelper.COLUMN_PRESTA_DATE_CREATION],
          date_naissance: prestaRows[0]
              [DatabaseHelper.COLUMN_PRESTA_DATE_NAISSANCE],
          pays: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_PAYS],
          telephone: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TELEPHONE],
          ville: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_VILLE],
          code: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_CODE],
          status: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_STATUS],
          image: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_IMAGE],
          positionId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_POSITION_ID],
          UserId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_USER_ID],
        );

        _profile_img = API.getProfileImgURL(_prestatairesModel.image, _usersLoggedModel.id);
      });
    }
  }

  void initVehiInfo() async {
    final vehiRows = await dbHelper.queryAll_vehicule();
    final prestaRows = await dbHelper.queryAll_presta();

//    print("${TAG}:initVehiInfo ${vehiRows.length}");
    _usersLoggedModel = new UsersLoggedModel(
      id: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_TOKEN],
    );
    if (vehiRows.length > 0) {

        _vehiculesModel = new VehiculesModel(
            vehiculeid: vehiRows[0][DatabaseHelper.COLUMN_VEHI_ID],
            couleur: vehiRows[0][DatabaseHelper.COLUMN_VEHI_COULEUR],
            status: vehiRows[0][DatabaseHelper.COLUMN_VEHI_STATUS],
            immatriculation: vehiRows[0]
                [DatabaseHelper.COLUMN_VEHI_IMMATRICULATION],
            marque: vehiRows[0][DatabaseHelper.COLUMN_VEHI_MARQUE],
            nombre_places: vehiRows[0][DatabaseHelper.COLUMN_VEHI_NOMBREPLACES],
            date: vehiRows[0][DatabaseHelper.COLUMN_VEHI_DATE],
            image: vehiRows[0][DatabaseHelper.COLUMN_VEHI_IMAGE],
            code: vehiRows[0][DatabaseHelper.COLUMN_VEHI_CODE],
            categorievehiculeId: vehiRows[0]
                [DatabaseHelper.COLUMN_VEHI_CATEGORIEVEHICILEID],
            prestataireId: vehiRows[0]
                [DatabaseHelper.COLUMN_VEHI_PRESTATAIREID]);
        print("Image :");
        print(" Url :"+_vehiculesModel.image);
        setState(() {
        _vehicule_img = _vehiculesModel.image+"?access_token="+ _usersLoggedModel.id;
        print("test test :");
        });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVehiInfo();
    initPrestaInfoTok();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double backHeight = screenHeight * (2 / 5);

    return new Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: MyColors.colorBlue,
        ),
        body: new SingleChildScrollView(
          child: new Stack(
            children: <Widget>[
              new Container(
                height: backHeight,
                width: screenWidth,
                color: MyColors.colorBlue,
                padding: EdgeInsets.only(bottom: 2.0),
                child: _vehiculesModel != null
                    ? new CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: _vehicule_img,
                        placeholder: (context, url)=> new CircularProgressIndicator(),
                        errorWidget:(context, url, error) =>
                        new Icon(Icons.error)
                      )
                    : new Image.asset(
                        'images/et_no_image.png',
                        fit: BoxFit.cover,
                      ),
              ),
              new Container(
                margin: EdgeInsets.only(top: backHeight - 70),
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    new Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: new Center(
                        child: Container(
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    child: ClipOval(
                                      child: _prestatairesModel != null
                                          ? new CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: _profile_img,
                                              placeholder:(context, url) =>
                                              new CircularProgressIndicator(
                                              ),
                                              errorWidget:(context, url, error)=>
                                              new Icon(Icons.error)
                                            )
                                          : new Image.asset(
                                              'images/et_no_profile.png',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                          color: MyColors.colorBlue,
                                          width: 2.0),
                                    )),
                              ],
                            ),
//                            Container(
//                              margin: EdgeInsets.only(top: 100.0, right: 100.0),
//                              child: new Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Container(
//                                    decoration: new BoxDecoration(
//                                      color: MyColors.colorBlue,
//                                      shape: BoxShape.circle,
//                                    ),
//                                    child: IconButton(
//                                        icon: new Icon(
//                                          Icons.camera_alt,
//                                          color: Colors.white,
//                                        ),
//                                        onPressed: () {
//                                          getImageFromLocal();
//                                        }),
//                                  ),
//                                ],
//                              ),
//                            ),
                          ]),
                        ),
                      ),
                    ),
                    _vehiculesModel != null
                        ? new Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 25.0,
                                        bottom: 12.0),
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'INFORMATIONS VÉHICULE',
                                          style: TextStyle(
                                              color: MyColors.colorBlue,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Marque',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text('${_vehiculesModel.marque}',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Code',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text('${_vehiculesModel.code}',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Immatriculation',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  '${_vehiculesModel.immatriculation}',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Couleur',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text('${_vehiculesModel.couleur}',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child:
                                    Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Places',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  '${_vehiculesModel.nombre_places}',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    _prestatairesModel != null
                        ? Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 25.0,
                                        bottom: 12.0),
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'INFORMATIONS PERSONNELLES',
                                          style: TextStyle(
                                              color: MyColors.colorBlue,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Code',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  _prestatairesModel.code !=
                                                          null
                                                      ? _prestatairesModel.code
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Prénom',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  _prestatairesModel.prenom !=
                                                          null
                                                      ? _prestatairesModel
                                                          .prenom
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Nom',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  _prestatairesModel.nom != null
                                                      ? _prestatairesModel.nom
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'CNI',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  _prestatairesModel.cni != null
                                                      ? _prestatairesModel.cni
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Email',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  _prestatairesModel.email !=
                                                          null
                                                      ? _prestatairesModel.email
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Téléphone',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  _prestatairesModel
                                                              .telephone !=
                                                          null
                                                      ? _prestatairesModel
                                                          .telephone
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Localisation',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  '${_prestatairesModel.ville != null ? _prestatairesModel.ville : ''}, ${_prestatairesModel.pays != null ? _prestatairesModel.pays : ''}',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: Divider(
                                      height: 6.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ));
    /*
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: MyColors.colorBlue,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(_vehiculesModel.image),
                          backgroundColor: Colors.grey,
                        )
                      ]),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: _vehiculesModel != null ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${_vehiculesModel.marque}',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 21.0)),
                        Text('${_vehiculesModel.immatriculation}',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 13.0)),
                      ],
                    ) : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );*/
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
