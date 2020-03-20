import 'dart:async';
import 'dart:convert';

import 'package:etakesh_driver/Utils/AppSharePreferences.dart';
import 'package:etakesh_driver/Utils/Navigation.dart';
import 'package:etakesh_driver/model/clients.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../database/database_helper.dart';
import '../../model/commandes.dart';
import '../../model/ecompte.dart';
import '../../model/eposition.dart';

import '../../model/google_places_item.dart';
import '../../model/prestataires.dart';
import '../../model/services.dart';
import '../../model/users_logged.dart';
import '../../remote/api.dart';
import '../../remote/maps_services.dart';
import '../../roli/my_colors.dart';
import '../../roli/my_const.dart';
import '../findlocation/findlocation.dart';
import '../profil/profil.dart';
import 'dialog/confirmcmde_dialog.dart';
import 'dialog/newcmdes_dialog.dart';
import 'package:unicorndial/unicorndial.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final String TAG = 'HomeState';
  double _statusbarHeight;
  MediaQueryData mediaQueryData;
  Widget _page;

  String error;

  StreamSubscription<Map<String, double>> streamSubscription;
  Location location = Location();
  final dbHelper = DatabaseHelper.instance;

  UsersLoggedModel _usersLoggedModel;
  PrestatairesModel _prestatairesModel;
  PrestatairesModel _prestatairesModel1;
  ECompteModel _eCompteModel;
  bool _is_show_cmde_dialog = false, montant = false;
  bool _is_find_solde = false;
  CommandesModel _cmde_selected = null;
  CommandesModel1 _cmde_selected1 = null;
  bool _load() => true;
  String TAG1 = "LoginState";

  Timer timer, timer2;
  String _name;
  String _prenom;
  String _token;
  ClientsModel _client = null;
  String _telClient;
  bool _etat1 = false;
  int _idCmde;
  double _montant;
  String _code = '';

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  GooglePlacesItemModel _findLocationModel = new GooglePlacesItemModel();
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocationData _currentLocation;
//  4.0833446, 9.515695
  Set<Polyline> _poly_lines = Set();
  final Set<Marker> _markers = Set();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.0833446, 9.515695),
    zoom: 11,
  );

  // BuildContext context;

  init() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  /// Active la notification avec sound customiser cmd valide
  Future _showNotificationCmdVal() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: '@mipmap/ic_launcher',
        /* sound: 'iphone_notification', */
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Takesh',
      'Commande reçue',
      platformChannelSpecifics,
      payload: 'Datas',
    );
  }

  Future _showNotificationCmdAN() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: '@mipmap/ic_launcher',
        /* sound: 'iphone_notification', */
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Takesh',
      'Commande annulée',
      platformChannelSpecifics,
      payload: 'Datas',
    );
  }

  void _insert_commande(CommandesModel commande) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_CMD_ID: commande.commandeid,
      DatabaseHelper.COLUMN_CMD_CODE: commande.code,
      DatabaseHelper.COLUMN_CMD_DATEDEBUT: commande.date_debut,
      DatabaseHelper.COLUMN_CMD_DATEFIN: commande.date_fin,
      DatabaseHelper.COLUMN_CMD_MONTANT: commande.montant,
      DatabaseHelper.COLUMN_CMD_STATUS: commande.status,
      DatabaseHelper.COLUMN_CMD_DISTANCE: commande.distance_client_prestataire,
      DatabaseHelper.COLUMN_CMD_DUREE: commande.duree_client_prestataire,
      DatabaseHelper.COLUMN_CMD_DATEACCEPTATION: commande.date_acceptation,
      DatabaseHelper.COLUMN_CMD_DATEPRISE: commande.date_prise_en_charge,
      DatabaseHelper.COLUMN_CMD_POSITIONPRISE:
          commande.position_prise_en_charge,
      DatabaseHelper.COLUMN_CMD_POSITIONDEST: commande.position_destination,
      DatabaseHelper.COLUMN_CMD_RATECOMMENT: commande.rate_comment,
      DatabaseHelper.COLUMN_CMD_RATEDATE: commande.rate_date,
      DatabaseHelper.COLUMN_CMD_RATEVALUE: commande.rate_value,
      DatabaseHelper.COLUMN_CMD_ISCREATED: commande.is_created,
      DatabaseHelper.COLUMN_CMD_ISACCEPTED: commande.is_accepted,
      DatabaseHelper.COLUMN_CMD_ISREFUSED: commande.is_refused,
      DatabaseHelper.COLUMN_CMD_ISTERMINATED: commande.is_terminated,
      DatabaseHelper.COLUMN_CMD_ISSTARTED: commande.is_started,
      DatabaseHelper.COLUMN_CMD_CLIENTID: commande.clientId,
      DatabaseHelper.COLUMN_CMD_PRESTATIONID: commande.prestationId,
    };
    final idCmde = await dbHelper.insert_cmde(row);
    print('${TAG}:_insert_commande inserted row id: ${idCmde}');
  }

  void showFindLocationDialog() async {
    _findLocationModel = await Navigator.of(context)
        .push(new MaterialPageRoute<GooglePlacesItemModel>(
            builder: (BuildContext context) {
              return new FindLocation();
            },
            fullscreenDialog: true));

    print('${TAG}:showFindLocationDialog ${_findLocationModel}');

    if (_findLocationModel != null) {
      /* StartNavigation.startNavigate(
                _currentLocation.latitude,
                _currentLocation.longitude,
                _cmde_selected.position_dest.latitude,
                _cmde_selected.position_dest.longitude,
                "Depart",
                _findLocationModel.description); */

      /*  Fluttertoast.showToast(
          msg: 'Destination pour: ${_findLocationModel.description}',
          backgroundColor: MyColors.colorBlue,
          textColor: Colors.white,
          timeInSecForIos: 3); */

      Alert(
          context: context,
          type: AlertType.info,
          title: "Démarrer la navigation",
          desc:
              "Démarrer la navigation  Destination pour: ${_findLocationModel.description}",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                /*

                @override
                Widget build(BuildContext context) {
                  final double statusbarHeight =
                      MediaQuery.of(context).padding.top;
                  var location = new Location();
                  var childButtons = List<UnicornButton>();

                  childButtons.add(UnicornButton(
                      hasLabel: true,
                      labelText: "Destination",
                      currentButton: FloatingActionButton(
                        heroTag: "Destination",
                        backgroundColor: Colors.green,
                        mini: true,
                        child: Icon(Icons.send),
                        onPressed: () {
                          StartNavigation.startNavigate(
                              _currentLocation.latitude,
                              _currentLocation.longitude,
                              _cmde_selected.position_dest.latitude,
                              _cmde_selected.position_dest.longitude,
                              "Depart",
                              _cmde_selected.position_destination);
                        },
                      )));

                  childButtons.add(UnicornButton(
                      hasLabel: true,
                      labelText: "Aller vers le client",
                      currentButton: FloatingActionButton(
                        heroTag: "client",
                        backgroundColor: Colors.blue,
                        mini: true,
                        child: Icon(Icons.person),
                        onPressed: () {
                          StartNavigation.startNavigate(
                              _currentLocation.latitude,
                              _currentLocation.longitude,
                              _cmde_selected.position_prise.latitude,
                              _cmde_selected.position_prise.longitude,
                              "Depart",
                              _cmde_selected.position_prise_en_charge);
                        },
                      )));
                  location
                      .onLocationChanged()
                      .listen((LocationData currentLocation) {
                    if (_currentLocation.longitude !=
                            currentLocation.longitude &&
                        _currentLocation.latitude != currentLocation.latitude) {
                      print("Test lat:" + currentLocation.latitude.toString());
                      print("Test lng:" + currentLocation.longitude.toString());
                      setState(() {
                        _currentLocation = currentLocation;
                      });
                    }
                  });

                  return 
                     Scaffold(
                      floatingActionButton: UnicornDialer(
                          backgroundColor: Colors.transparent,
                          parentButtonBackground: MyColors.colorBlue,
                          orientation: UnicornOrientation.VERTICAL,
                          parentButton: Icon(Icons.navigation),
                          childButtons: childButtons),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      body: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 0.0,
                            right: 0.0,
                            top: statusbarHeight,
                            bottom: -25.0,
                            child: new GoogleMap(
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              initialCameraPosition: _kGooglePlex,
                              markers: _markers,
                              polylines: _poly_lines,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                mapController = controller;
                              },
                            ),
                          ),
                        ],
                      ),
                    
                  );
                }
                */
              },
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0),
              ]),
            ),
          ]).show();
    }
  }

  void _showNewCmde(dynamic cmdenew) async {
    AppSharedPreferences().setAllowsNotifications(false);
    _is_show_cmde_dialog = true;
    /*showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _createNewCmdeWidget(context));*/
//    print("_showNewCmde itemCmde ${cmdenew.prestationId}");
    final servItem =
        await dbHelper.queryServ_byid(int.parse(cmdenew.prestation.serviceId));
//    print('_showNewCmde itemCmdeServ ${servItem.intitule}');
    cmdenew.prestation.service = new ServicesModel();
    cmdenew.prestation.service =
        servItem != null ? servItem : new ServicesModel();

    _cmde_selected = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NewCommandesDialog(
        commande: cmdenew,
        token: _usersLoggedModel.id,
      ),
    );

    if (_cmde_selected.is_created == true &&
        _cmde_selected.is_accepted == true) {
      _insert_commande(_cmde_selected);

      _is_show_cmde_dialog = false;
//getCode();
      setState(() {
        _etat1 = true;
      });

      AppSharedPreferences().setTime(true);

      displayRoutePriseEnCharge();
      _displayRouteDestination();

      /*  if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER"){
        _showNotificationCmdAN();
        reinitialiseMap();
      }
 */

      /*  }else if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER"){
      _showNotificationCmdAN();
        reinitialiseMap();
         */

    } else {
      // cas des commandes refusées on reinitialise la map
      reinitialiseMap();
      _is_show_cmde_dialog = false;
      // reconnexion
    }

    /*  timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
       AppSharedPreferences().setTime(true);
     }); */
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

  void reconnexion2() async {
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
        /* Fluttertoast.showToast(
            msg: 'Connection reussie.',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 3);
 */
      } else {
        Fluttertoast.showToast(
            msg: 'Erreur serveur, veuillez réessayer plus tard.',
            backgroundColor: MyColors.colorRouge,
            textColor: Colors.white,
            timeInSecForIos: 3);
      }
    });
  }

  void _showConfirmCmde(CommandesModel cmde) async {
    // AppSharedPreferences().setAllowsNotifications(false);
    final servItem =
        await dbHelper.queryServ_byid(int.parse(cmde.prestation.serviceId));
    cmde.prestation.service = new ServicesModel();
    cmde.prestation.service = servItem != null ? servItem : new ServicesModel();

    CommandesModel model = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmCommandesDialog(
        commande: cmde,
        token: _usersLoggedModel.id,
      ),
    );
    if (model != null) {
      _cmde_selected = model;
      print(
          "${TAG}:_showNewCmde _cmde_selected = ${_cmde_selected != null ? _cmde_selected.code : 'code null'}");
//getCode();
      if (_cmde_selected.is_terminated == true &&
          _cmde_selected.is_refused == false &&
          _cmde_selected.is_accepted == true &&
          _cmde_selected.is_created == true &&
          _cmde_selected.status == "TERMINATED") {
        reinitialiseMap();
        Fluttertoast.showToast(
            msg: 'COMMANDE TERMINÉE AVEC SUCCÈS.',
            backgroundColor: MyColors.colorVert,
            textColor: Colors.white,
            timeInSecForIos: 3);

        // reconnection du prestataire
        reconnexion();
      } else if (_cmde_selected.status == "ANNULER") {
        reinitialiseMap();
        Fluttertoast.showToast(
            msg: 'COMMANDE ANNULÉE AVEC SUCCÈS.',
            backgroundColor: MyColors.colorVert,
            textColor: Colors.white,
            timeInSecForIos: 3);

        // envoie service de notifications des cmdes annulées
        _showNotificationCmdAN();
        // reconnection du prestataire
        reconnexion();
      }
    }
  }

  Future onSelectNotification(String payload) async {
    if (payload != '') {
      debugPrint("hell notification");
    }

    Alert(
        context: context,
        type: AlertType.info,
        title: "Commande annulée",
        desc: "Commande annulée",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0),
            ]),
          ),
        ]).show();
  }

  void reinitialiseMap() {
    dbHelper.delete_all_cmde();
    _markers.removeWhere(
        (marker) => marker.markerId == MarkerId(MyConst.MAKERS_ID_POST_PRISE));
    _markers.removeWhere(
        (marker) => marker.markerId == MarkerId(MyConst.MAKERS_ID_POST_DEST));
    _poly_lines.clear();
    setState(() {
      _cmde_selected = null;
    });
  }

  void displayRoutePriseEnCharge() {
    print(
        "${TAG}:_showNewCmde _cmde_selected = ${_cmde_selected != null ? _cmde_selected.code : 'code null'}");
    if (_cmde_selected.is_accepted) {
      MapsServices.getRouteCoordinates(
              new EPositionModel(
                  latitude: _currentLocation.latitude,
                  longitude: _currentLocation.longitude),
              new EPositionModel(
                  latitude: _cmde_selected.position_prise.latitude,
                  longitude: _cmde_selected.position_prise.longitude))
          .then((responseRoute) {
        print(
            "${TAG}:getRouteCoordinates responseRoute status=${responseRoute.statusCode} body=${responseRoute.body}");
        if (responseRoute.statusCode == 200) {
          Map routesValues = jsonDecode(responseRoute.body);
          print(
              "${TAG}:getRouteCoordinates SUCCESS points=${routesValues["routes"][0]["overview_polyline"]["points"]}");

          setState(() {
            _markers.add(
              new Marker(
                markerId: MarkerId(MyConst.MAKERS_ID_POST_PRISE),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                position: LatLng(_cmde_selected.position_prise.latitude,
                    _cmde_selected.position_prise.longitude),
                infoWindow: InfoWindow(
                  title:
                      '${_cmde_selected.client.nom} ${_cmde_selected.client.prenom}',
                  snippet:
                      'Position de prise en charge du client (${_cmde_selected.position_prise_en_charge})',
                ),
              ),
            );
          });

          _goToTheLake(_cmde_selected.position_prise.latitude,
              _cmde_selected.position_prise.longitude, 14.0);
          createRoutePoly(
              routesValues["routes"][0]["overview_polyline"]["points"]);
        }
      });

      /*  } else if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER") {
      // affichage notification des commandes annulées par le client
      _showNotificationCmdAN();
      reinitialiseMap();
 */
    } else {
      print("${TAG}:_showNewCmde cmde not accepted");
    }

    /*  if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER") {
      // affichage notification des commandes annulées par le client
      _showNotificationCmdAN();
      reinitialiseMap();
    } */
  }

  void _displayRouteDestination() {
    print(
        "${TAG}:_showNewCmde _cmde_selected = ${_cmde_selected != null ? _cmde_selected.code : 'code null'}");
    if (_cmde_selected.is_accepted) {
      MapsServices.getRouteCoordinates(
              new EPositionModel(
                  latitude: _currentLocation.latitude,
                  longitude: _currentLocation.longitude),
              new EPositionModel(
                  latitude: _cmde_selected.position_dest.latitude,
                  longitude: _cmde_selected.position_dest.longitude))
          .then((responseRoute) {
        print(
            "${TAG}:displayRouteDestination:getRouteCoordinates responseRoute status=${responseRoute.statusCode} body=${responseRoute.body}");
        if (responseRoute.statusCode == 200) {
          Map routesValues = jsonDecode(responseRoute.body);
          print(
              "${TAG}:displayRouteDestination:getRouteCoordinates SUCCESS points=${routesValues["routes"][0]["overview_polyline"]["points"]}");

          setState(() {
            _markers.add(
              new Marker(
                markerId: MarkerId(MyConst.MAKERS_ID_POST_DEST),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueYellow),
                position: LatLng(_cmde_selected.position_dest.latitude,
                    _cmde_selected.position_dest.longitude),
                infoWindow: InfoWindow(
                  title: '${_cmde_selected.position_destination}',
                  snippet: 'Position de destination',
                ),
              ),
            );
          });
//
//          _goToTheLake(_cmde_selected.position_dest.latitude,
//              _cmde_selected.position_dest.longitude, 14.0);
////          _insert_commande(_cmde_selected);
          createRouteDestPoly(
              routesValues["routes"][0]["overview_polyline"]["points"]);
        }
      });
      /* } else if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER") {

      _showNotificationCmdAN();
      reinitialiseMap();
 */
    } else {
      Fluttertoast.showToast(
          msg:
              "Vous ne pouvez démarrer la navigation : car vous n'avez acceptez aucune commande ",
          backgroundColor: MyColors.colorBlack,
          textColor: Colors.white,
          timeInSecForIos: 3);
    }

    /*  if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER") {
      // affichage notification des commandes annulées par le client
      _showNotificationCmdAN();
      reinitialiseMap();
    } */
  }

  void createRoutePoly(String encondedPoly) {
    setState(() {
      _poly_lines.add(Polyline(
          polylineId: PolylineId("routes_prise"),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: MyColors.colorBlue));
    });
  }

  void createRouteDestPoly(String encondedPoly) {
    setState(() {
      _poly_lines.add(Polyline(
          polylineId: PolylineId("routes_destination"),
          width: 7,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: MyColors.colorVert));
    });
  }

//  this method will convert list of doubles into latlng
  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

// recuperation de la liste des commandes de l"API
//  Action a effectuer lorsqu'on clique sur la notification

  Future onSelectNotification1(String payload) async {
    if (payload != '') {
      debugPrint("hello notification");
    }
//    print('${TAG}:_findAllOwnCmde token = ${_usersLoggedModel.id} | prestionIds = ${_prestatairesModel.prestataireid}');
    API
        .findCmdeCreated(_usersLoggedModel.id, _prestatairesModel.prestataireid)
        .then((responseCmdes) {
//      print("${TAG}:_findAllOwnCmde:API.findCmdeCreated findAllServices statusCode = ${responseCmdes.statusCode}");
      if (responseCmdes.statusCode == 200) {
        final String responseCmdesString = responseCmdes.body;
        print(
            "${TAG}:_findAllOwnCmde:API.findCmdeCreated responseCmdesString = ${responseCmdesString}");

        List<dynamic> listCmdes = new List();
//          listCmdes = (json.decode(responseCmdesString) as List)
//              ?.map((e) => e == null
//              ? null
//              : CommandesModel.fromJson(e as Map<String, dynamic>))
//              ?.toList();

        listCmdes = json
            .decode(responseCmdesString)
            .map((chatCardJson) => CommandesModel.fromJson(chatCardJson))
            .toList();
        print("${TAG}:_findAllOwnCmde success listCmdes=${listCmdes.length}");
        if (!_is_show_cmde_dialog && listCmdes.length > 0) {
          dbHelper.queryAll_cmde().then((cmdeRows) async {
            print("taille des nouvelles commandes...........................");
            print("${TAG}:queryAll_cmde cmdeRows=${cmdeRows.length}");

            if (cmdeRows.length == 0) {
//          print("${TAG}:_findAllOwnCmde success listCmdes=${listCmdes[0]}");
              _showNewCmde(listCmdes[0]);
            }
          });
        }
      }
    });
  }

  void _getCmde() async {
    /*  final cmde = await dbHelper.queryAll_cmde();
    CommandesModel cmds =
        new CommandesModel(commandeid: cmde[0][DatabaseHelper.COLUMN_CMD_ID]);

    Fluttertoast.showToast(
        msg: 'numero commande 1 = ${cmds.commandeid.toString()}',
        backgroundColor: MyColors.colorVert,
        textColor: Colors.white,
        timeInSecForIos: 5); */

    dbHelper.queryAll_presta().then((prest) {
      print("${TAG}:_createForm:queryAll_presta presta=${prest.length}");
      if (prest.length > 0) {
        print(
            "${TAG}:_createForm:_findAllOwnPresta success listCmdes=${prest[0]}");
        _name = prest[0]['nom'].toString();
        _prenom = prest[0]['prenom'].toString();
        print("le nom est : " + _name.toString());
        _token = prest[0]['token'].toString();
      }
    });

    AppSharedPreferences().isTime().then((bool1) {
      if (bool1) {
        dbHelper.queryAll_cmde().then((cmdeRows) {
          print("taille des nouvelles commandes...........................");
          print("${TAG}:queryAll_cmde cmdeRows=${cmdeRows.length}");
          if (cmdeRows.length > 0) {
            print("cmde anuller..........................");

            _idCmde = cmdeRows[0]['commandeid'];
            print(_idCmde.toString());
            /* Fluttertoast.showToast(
                msg: 'numero commande = ${_idCmde.toString()}',
                backgroundColor: MyColors.colorVert,
                textColor: Colors.white,
                timeInSecForIos: 5); */

            API
                .findCmdeById(_token, cmdeRows[0]['commandeid'])
                .then((responseCmde) {
              print(
                  "${TAG}:findCmdeCreatedById statusCode=${responseCmde.statusCode}");
              if (responseCmde.statusCode == 200) {
                print("tout /////////////////////////");
                final String responseCmdeString = responseCmde.body;

                print(
                    "${TAG}:findCmdeCreatedById responseCmdeString=${responseCmdeString}");
                print("*************");

                print(responseCmdeString);
                /* _cmde_selected =
                new CommandesModel.fromJson(json.decode(responseCmdeString));*/
                _cmde_selected1 = new CommandesModel1.fromJson(
                    json.decode(responseCmdeString));

                print("###################");
                print(_cmde_selected1.toString());
                print("1212121212");

                /* Fluttertoast.showToast(
                    msg: 'COMMANDE accepte 3.',
                    backgroundColor: MyColors.colorVert,
                    textColor: Colors.white,
                    timeInSecForIos: 3);
 */
                setState(() {
                  //_cmde_selected =  _cmde_selected1;
                });
                if (_cmde_selected1.is_accepted == true &&
                    _cmde_selected1.status == "ANNULER" &&
                    _cmde_selected1.is_terminated == true) {
                  _showNotificationCmdAN();
                  reinitialiseMap();
                  reconnexion();

                  setState(() {
                    AppSharedPreferences().setTime(false);
                    _etat1 = false;
                  });
                }
              }
            });
          }
        });
      } else {
        setState(() {
          // AppSharedPreferences().setTime(false);
          _etat1 = false;
        });
        // _showNotificationCmdAN();
      }
    });

    setState(() {
      // AppSharedPreferences().setTime(false);
      _etat1 = false;
    });
  }

//  recuperation de la liste des commandes de l'API
  void _findAllOwnCmde() async {
//    print('${TAG}:_findAllOwnCmde token = ${_usersLoggedModel.id} | prestionIds = ${_prestatairesModel.prestataireid}');

    API
        .findCmdeCreated(_usersLoggedModel.id, _prestatairesModel.prestataireid)
        .then((responseCmdes) {
//      print("${TAG}:_findAllOwnCmde:API.findCmdeCreated findAllServices statusCode = ${responseCmdes.statusCode}");
      if (responseCmdes.statusCode == 200) {
        final String responseCmdesString = responseCmdes.body;
        print("fabiol une cmd ........");
        print(responseCmdesString);
        print(
            "${TAG}:_findAllOwnCmde:API.findCmdeCreated responseCmdesString = ${responseCmdesString}");

        List<dynamic> listCmdes = new List();
//          listCmdes = (json.decode(responseCmdesString) as List)
//              ?.map((e) => e == null
//              ? null
//              : CommandesModel.fromJson(e as Map<String, dynamic>))
//              ?.toList();

        listCmdes = json
            .decode(responseCmdesString)
            .map((chatCardJson) => CommandesModel.fromJson(chatCardJson))
            .toList();
        // _showNewCmde(listCmdes[0]);
        print("${TAG}:_findAllOwnCmde success listCmdes=${listCmdes.length}");

        if (!_is_show_cmde_dialog && listCmdes.length > 0) {
          dbHelper.queryAll_cmde().then((cmdeRows) async {
            print("taille des nouvelles commandes...........................");
            print("${TAG}:queryAll_cmde cmdeRows=${cmdeRows.length}");

            if (cmdeRows.length == 0) {
//          print("${TAG}:_findAllOwnCmde success listCmdes=${listCmdes[0]}");
              _showNewCmde(listCmdes[0]);
            }
          });
        }
      }
    });
  }

  void _update_ecompte(ECompteModel ecpte) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.COLUMN_COMPTE_ID:
          ecpte.compteid != null ? ecpte.compteid : 0,
      DatabaseHelper.COLUMN_COMPTE_SOLDE: ecpte.solde,
      DatabaseHelper.COLUMN_COMPTE_PRESTATAIREID: ecpte.prestataireId,
      DatabaseHelper.COLUMN_COMPTE_NUMCOMPTE: ecpte.numero_compte,
      DatabaseHelper.COLUMN_COMPTE_DATECREATION: ecpte.date_creation,
    };
    final id = await dbHelper.update_compte(row);
    print('${TAG}:_update_ecompte updated row id: $id');
  }

  Future<String> _initCurrentMarker() async {
//    Map<String, double> myCurrentLocation;
    LocationData currentLocation;
    Location location = new Location();

    // AppSharedPreferences().setAllowsNotifications(false);

    try {
      currentLocation = await location.getLocation();
      print("lat :" + currentLocation.latitude.toString());
      print("lng :" + currentLocation.longitude.toString());
      setState(() {
        print('${TAG}:initPlatform _currentLocation ${_currentLocation}');
        _currentLocation = currentLocation;
        _markers.add(
          new Marker(
              markerId: MarkerId(MyConst.MAKERS_ID_POST_CURR),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position:
                  LatLng(_currentLocation.latitude, _currentLocation.longitude),
              infoWindow: InfoWindow(
                title: 'Ma position courante',
                snippet: 'Vous vous trouvez ici en ce moment',
              ),
              onTap: () {
//                Fluttertoast.showToast(msg: "Position Courant click listener");
              }),
        );

//        print("${TAG} _markers size = ${_markers.length} | ${_markers}");
      });

      _goToTheLake(_currentLocation.latitude, _currentLocation.longitude, 14.0);

      return null;
//      as Map<String, double>;
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        error = "PERMISSION_DENIED";
        return null;
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "Never Ask";
      }
      currentLocation = null;
      return null;
    }
  }

  void executeFindCompte() async {
    setState(() {
      _is_find_solde = true;
    });

    API
        .findCompte(_prestatairesModel.prestataireid, _usersLoggedModel.id)
        .then((responseCpte) {
      final String responseCpteBody = responseCpte.body;

      print(
          "${TAG}:API.findCompte ${responseCpte.statusCode} | ${responseCpteBody}");
      if (responseCpte.statusCode == 200) {
        setState(() {
          _is_find_solde = false;
        });

        ECompteModel ecpte =
            new ECompteModel.fromJson(json.decode(responseCpteBody));
        _update_ecompte(ecpte);
        initCompte();
      } else {
        setState(() {
          _is_find_solde = false;
        });

        Fluttertoast.showToast(
            msg: 'Solde indisponible, veuillez réessayer plus tard.',
            backgroundColor: MyColors.colorRouge,
            textColor: Colors.white,
            timeInSecForIos: 3);
      }
    }).catchError((error) {
      setState(() {
        _is_find_solde = false;
      });

      Fluttertoast.showToast(
          msg: 'Erreur réseau. Veuillez réessayer plus tard',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          timeInSecForIos: 3);
    });
  }

//  mise a jour de la position du prestataire dans l'api
  void _executeSetEpostion(double lat, double long) {
//    print('${TAG}:_findAllOwnCmde token = ${_usersLoggedModel.id} | prestionIds = ${_prestatairesModel.prestataireid}');
    EPositionModel ePositionModel = new EPositionModel(
        positionid: _prestatairesModel.positionId != null
            ? _prestatairesModel.positionId
            : 0,
        latitude: lat,
        longitude: long,
        libelle: "Current Position");
    API
        .executeSetEPosition(ePositionModel, _usersLoggedModel.id)
        .then((responseEPos) {
//      print("${TAG}:_executeSetEpostion:API.executeSetEPosition statusCode = ${responseEPos.statusCode} | body= ${responseEPos.body}");
    });
  }

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
    }
    print("hey nom : " + _prestatairesModel.nom.toString());
  }

  Future<PrestatairesModel> initPrest() async {
    final prestaRows = await dbHelper.queryAll_presta();

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
          positionId: prestaRows[0][DatabaseHelper.COLUMN_PRESTA_POSITION_ID],
        );
      });
    }
    print("hey nom : " + _prestatairesModel.nom.toString());
    return _prestatairesModel;
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
            msg:
                'Votre compte est insuffisant. Vous ne pouvez recevoir une commande.',
            backgroundColor: MyColors.colorRouge,
            textColor: Colors.white,
            timeInSecForIos: 8);
      } else {
        Fluttertoast.showToast(
            msg: 'Erreur serveur, veuillez réessayer plus tard.',
            backgroundColor: MyColors.colorBlue,
            textColor: Colors.white,
            timeInSecForIos: 3);
      }
    });
  }

  void deconnexion2() async {
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
            msg: 'Vous ne pouvez qu\' accepter une commande de 3000 ou 3500.',
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

  void initCompte() async {
    final cpteRows = await dbHelper.queryAll_compte();

    if (cpteRows.length > 0) {
      setState(() {
        _eCompteModel = new ECompteModel(
          compteid: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_ID],
          solde: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_SOLDE],
          prestataireId: cpteRows[0]
              [DatabaseHelper.COLUMN_COMPTE_PRESTATAIREID],
          numero_compte: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_NUMCOMPTE],
          date_creation: cpteRows[0][DatabaseHelper.COLUMN_COMPTE_DATECREATION],
        );
        _montant = _eCompteModel.solde;

        montant
            ? Fluttertoast.showToast(
                msg:
                    'Votre solde est : ${_montant.toString()} \n vous serez mise hors circulation \n après la prochaîne course',
                backgroundColor: MyColors.colorRouge,
                textColor: Colors.white,
                timeInSecForIos: 3)
            : Fluttertoast.showToast(
                msg: 'Votre solde est : ${_montant.toString()}',
                backgroundColor: MyColors.colorBlue,
                textColor: Colors.white,
                timeInSecForIos: 3);

        if (_montant < 3000.0) {
          // deconnexion du prestataire sur la map
          deconnexion();
        } else if (_montant < 5000.0 && _montant >= 3000.0) {
          setState(() {
            montant = true;
          });
          reconnexion();
          Fluttertoast.showToast(
              msg: 'Vous ne pouvez qu\' accepter une commande de 3000 ou 3500.',
              backgroundColor: MyColors.colorBlueT66,
              textColor: Colors.white,
              timeInSecForIos: 3);
        } else {
          reconnexion();
          setState(() {
            montant = false;
          });
          Fluttertoast.showToast(
              msg: 'Vous pouvez accepter une commande.',
              backgroundColor: MyColors.colorVert,
              textColor: Colors.white,
              timeInSecForIos: 3);
        }
      });
    }
  }

  Widget _createForm(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    var location = new Location();
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Destination",
        currentButton: FloatingActionButton(
          heroTag: "Destination",
          backgroundColor: Colors.green,
          mini: true,
          child: Icon(Icons.send),
          onPressed: () {
            StartNavigation.startNavigate(
                _currentLocation.latitude,
                _currentLocation.longitude,
                _cmde_selected.position_dest.latitude,
                _cmde_selected.position_dest.longitude,
                "Depart",
                _cmde_selected.position_destination);
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Aller vers le client",
        currentButton: FloatingActionButton(
          heroTag: "client",
          backgroundColor: Colors.blue,
          mini: true,
          child: Icon(Icons.person),
          onPressed: () {
            StartNavigation.startNavigate(
                _currentLocation.latitude,
                _currentLocation.longitude,
                _cmde_selected.position_prise.latitude,
                _cmde_selected.position_prise.longitude,
                "Depart",
                _cmde_selected.position_prise_en_charge);
          },
        )));
    location.onLocationChanged().listen((LocationData currentLocation) {
      if (_currentLocation.longitude != currentLocation.longitude &&
          _currentLocation.latitude != currentLocation.latitude) {
        print("Test lat:" + currentLocation.latitude.toString());
        print("Test lng:" + currentLocation.longitude.toString());
        setState(() {
          _currentLocation = currentLocation;
        });
      }
    });

    return WillPopScope(
        child: Scaffold(
          floatingActionButton: _cmde_selected != null
              ? UnicornDialer(
                  backgroundColor: Colors.transparent,
                  parentButtonBackground: MyColors.colorBlue,
                  orientation: UnicornOrientation.VERTICAL,
                  parentButton: Icon(Icons.navigation),
                  childButtons: childButtons)
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Stack(
            children: <Widget>[
              Positioned(
                left: 0.0,
                right: 0.0,
                top: statusbarHeight,
                bottom: -25.0,
                child: new GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  markers: _markers,
                  polylines: _poly_lines,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;
                  },
                ),
              ),
              Positioned(
                left: 4.0,
                right: 4.0,
                top: _statusbarHeight + 8,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
//                            _goToFindLocation();
                          showFindLocationDialog();
                        },
                        child: new Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(13.0),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "${_eCompteModel != null ? MyConst.amountFormat(_eCompteModel.solde) : '0.00'}",
                                    style: TextStyle(
                                        color: Colors.grey[200],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    " XAF",
                                    style: TextStyle(
                                        color: MyColors.colorJaune,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      new Radius.circular(26.0)),
                                  color: montant
                                      ? MyColors.colorRouge
                                      : MyColors.colorBlue),
                              padding: new EdgeInsets.fromLTRB(
                                  13.0, 13.0, 13.0, 13.0),
                            ),
                            _is_find_solde
                                ? Container(
                                    margin: EdgeInsets.all(12),
                                    width: 24.0,
                                    height: 24.0,
                                    child: CircularProgressIndicator(),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.refresh,
                                      color: MyColors.colorBlue,
                                      size: 28.0,
                                    ),
                                    onPressed: () {
//                                    print("updateCompte info");
                                      executeFindCompte();
                                    })
                          ],
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _goToProfilPage();
                        },
                        child: new Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: new EdgeInsets.all(13.0),
                      ),

                      /*  _cmde_selected != null
                          ? RawMaterialButton(
                              onPressed: () {
                                getClient();
                              },
                              child: new Icon(
                                Icons.call,
                                color: Colors.black,
                                size: 30.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: new EdgeInsets.all(13.0),
                            )
                          : Container(),
 */
/* 
                     ListTile(leading:  IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        title: Text("hello"),
        ),
         Divider(
              height: 6.0,
            ), */
                    ],
                  ),
                ),
              ),
              /*   SizedBox(
                height: 15,
              ), */
              // message de bienvenue

              Positioned(
                  left: 4.0,
                  right: 4.0,
                  bottom: _statusbarHeight + 8,
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RawMaterialButton(
                              child: Icon(
                                Icons.zoom_in,
                                color: MyColors.colorBlue,
                                size: 25.0,
                              ),
                              onPressed: () {
                                mapController.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              },
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                            ),
                            RawMaterialButton(
                              child: Icon(
                                Icons.zoom_out,
                                color: MyColors.colorBlue,
                                size: 25.0,
                              ),
                              onPressed: () {
                                mapController.animateCamera(
                                  CameraUpdate.zoomOut(),
                                );
                              },
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                            ),
                          ],
                        ),
//                        RawMaterialButton(
//                          onPressed: () {
//                            displayRouteDestination();
//                          },
//                          child: Text(
//                            "GO",
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontWeight: FontWeight.w600,
//                                fontSize: 25.0),
//                          ),
//                          shape: new CircleBorder(),
//                          elevation: 2.0,
//                          fillColor: MyColors.colorBlue,
//                          padding: const EdgeInsets.all(17.0),
//                        ),
                        Column(
                          children: <Widget>[
                            _cmde_selected != null
                                ? RawMaterialButton(
                                    onPressed: () {
                                      _showConfirmCmde(_cmde_selected);
                                    },
                                    child: new Icon(
                                      Icons.done_outline,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                    shape: new CircleBorder(),
                                    elevation: 2.0,
                                    fillColor: MyColors.colorRouge,
                                    padding: const EdgeInsets.all(10.0),
                                  )
                                : Container(),
                            _cmde_selected != null
                                ? RawMaterialButton(
                                    onPressed: () {
                                      getClient();
                                    },
                                    child: new Icon(
                                      Icons.call,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                                    shape: new CircleBorder(),
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    padding: new EdgeInsets.all(10.0),
                                  )
                                : Container(),
                            _cmde_selected != null
                                ? (_code != ''
                                    ? RawMaterialButton(
                                        onPressed: () {
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
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                )
                                              ]).show();
                                        },
                                        child: new Icon(
                                          Icons.code,
                                         color: Colors.black,
                                          size: 30.0,
                                        ),
                                        shape: new CircleBorder(),
                                        elevation: 2.0,
                                        fillColor: Colors.white,
                                        padding: new EdgeInsets.all(10.0),
                                      )
                                    : Container()
                                    )
                                : Container(),
                            RawMaterialButton(
                              onPressed: () {
                                if (_currentLocation != null) {
                                  _goToTheLake(_currentLocation.latitude,
                                      _currentLocation.longitude, 17.0);
                                }
                              },
                              child: new Icon(
                                Icons.my_location,
                                color: MyColors.colorBlue,
                                size: 25.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(10.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              /* ===============================================================
              Positioned(
                      left: 4.0,
                      right: 4.0,
                      top: _statusbarHeight + 10,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () {
                                _showConfirmCmde(_cmde_selected);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.done_outline,
                                    color: MyColors.colorVert,
                                    size: 24.0,
                                  ),
                                  Text(
                                    "Confirmer la Prise en Charge",
                                    style: TextStyle(
                                        color: MyColors.colorVert,
                                        fontSize: 17.0),
                                  ),
                                ],
                              ),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(9.0),
                            ),
                          ]))*/
            ],
          ),
        ),
        onWillPop: () {
          return new Future(() => false);
        });
  }

  _callPhone(String telClient) async {
    final String phone = 'tel:$telClient';
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone $phone';
    }
  }

  void getClient() {
    if (_cmde_selected != null &&
        _cmde_selected.is_accepted == true &&
        _cmde_selected.status != "ANNULER" &&
        _cmde_selected.is_terminated == false) {
      // envoie notification
      /*    _cmde_selected.rate_comment = "true";
           API
                                .executeSetCmde(_cmde_selected, _token)
                                .then((responseSetCmde) {
                              final String responsesetCmdeBody =
                                  responseSetCmde.body;

                             // _progressDialog.hide();
                              print(
                                  "${TAG}:dialogContent:API.executeSetCmde ACCEPTED findAllServices statusCode = ${responseSetCmde.statusCode} | ${responsesetCmdeBody}");
                              if (responseSetCmde.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: 'Commande update success.',
                                    backgroundColor: MyColors.colorVert,
                                    textColor: Colors.white,
                                    timeInSecForIos: 3);
                              
                              } 
                                }); */

      // emmettre un appel vers le client ayant passé la commande

      API.getClientById(_cmde_selected.clientId, _token).then((response) {
        if (response.statusCode == 200) {
          print("${TAG}: getClientById statusCode=${response.statusCode}");

          final String responseString = response.body;
          print("${TAG}: getClientById responseCmdeString=${responseString}");

          _client = new ClientsModel.fromJson(json.decode(responseString));

          _telClient = _client.telephone.toString();

          print(
              "numero de téléphone du client ${_client.nom} est de : ${_telClient}");

          _callPhone(_telClient);
        }
      });

      /*  } else  if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER") {

      _showNotificationCmdAN();
      reinitialiseMap(); */

    } else {
      Fluttertoast.showToast(
          msg:
              "Vous ne pouvez appeler : car vous n'avez acceptez aucune commande ",
          backgroundColor: MyColors.colorRouge,
          textColor: Colors.white,
          timeInSecForIos: 4);
    }
  }

  void getCode() async{
    print('pas de cmde ds selected_cmd1111111111111111111');
    if(_cmde_selected!=null)
    API.findCmdeById(_token, _cmde_selected.commandeid).then((response) {
      print('fababy le king..................');
      print('pas de cmde ds selected_cmd1111111111111111111');
      if (response.statusCode == 200) {
        print("${TAG}: getClientById statusCode=${response.statusCode}");

        final String responseString = response.body;
        print("${TAG}: getClientById responseCmdeString=${responseString}");

        CommandesModel1 cmde =
            new CommandesModel1.fromJson(json.decode(responseString));
         
            print("le grand code :"+cmde.rate_comment.toString());
            if(cmde.rate_comment.toString()!=false.toString())
        setState(() {
          _code = cmde.rate_comment.toString();
        });
      } else {
        ////
        ///
      }
    });
    else{
    //  print('pas de cmde ds selected_cmd1111111111111111111');
    }
  }

  Future<Null> refreshList() async {
    // refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      //  _findAllOwnCmde();
      _getCmde();
      getCode();
    });
  }

  @override
  void initState() {
    super.initState();
    _initCurrentMarker();
    initPrestaInfoTok();
    initCompte();
    init();
    refreshList();
   // _code="fegefd";
   // getCode();
   /* AppSharedPreferences().isTime().then((etat) {
      print(
          "hgdhgfvjhdjhfvjhvjhdfvh..............................................................................");
      print(etat);

      if (etat) {
        /* displayRoutePriseEnCharge();
      _displayRouteDestination(); */
        timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
          getCode();
        });
      } else {
        //
        print("l'etat n'a pas changer");
        Fluttertoast.showToast(
            msg: 'l a na pas changer',
            backgroundColor: MyColors.colorRouge,
            textColor: Colors.white,
            timeInSecForIos: 5);
      }
    });*/

    //reconnexion();
    ///  Service de notif des cmds validees et des cmds en cour de livraison
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      print("${TAG}:Timer.periodic tick=${t.tick}");
      if (_montant <= 5000.0) {
        setState(() {
          montant = true;
        });
        Fluttertoast.showToast(
            msg:
                'Votre solde est : ${_montant.toString()}  vous serez mise hors circulation après la prochaîne course...',
            backgroundColor: MyColors.colorRouge,
            textColor: Colors.white,
            timeInSecForIos: 5);
      }
      if (_usersLoggedModel == null) {
        initPrestaInfoTok();
      } else {
        _findAllOwnCmde();
        _getCmde();
        //onSelectNotification1("f");
        //  _showNotificationCmdAN();
      }
    });

    // _getCmde();

    // API.findCmde(token)
    dbHelper.queryAll_cmde().then((cmdeRows) {
      print(
          "/////////////////////////////////////////////////////````````````````````````");
      print(cmdeRows.length);
      print('status commande' +
          cmdeRows[0]['status'].toString() +
          "et " +
          cmdeRows[0]['is_terminated'].toString());
      print("${TAG}:_createForm:queryAll_cmde cmdeRows=${cmdeRows.length}");
      if (cmdeRows.length > 0) {
        print(
            "${TAG}:_createForm:_findAllOwnCmde success listCmdes=${cmdeRows[0]}");

        print('status commande' +
            cmdeRows[0]['status'].toString() +
            "et " +
            cmdeRows[0]['is_terminated'].toString());
        print('status commande' +
            cmdeRows[0]['status'].toString() +
            "et " +
            cmdeRows[0]['is_terminated'].toString());

        API
            .findCmdeCreatedById(
                _usersLoggedModel.id, cmdeRows[0]['commandeid'])
            .then((responseCmde) {
          print(
              "${TAG}:findCmdeCreatedById statusCode=${responseCmde.statusCode}");
          if (responseCmde.statusCode == 200) {
            final String responseCmdeString = responseCmde.body;
            print(
                "${TAG}:findCmdeCreatedById responseCmdeString=${responseCmdeString}");

            _cmde_selected =
                new CommandesModel.fromJson(json.decode(responseCmdeString));
//getCode();
//            recupération du service de la commande
            dbHelper
                .queryServ_byid(int.parse(_cmde_selected.prestation.serviceId))
                .then((servItem) {
//    print('_showNewCmde itemCmdeServ ${servItem.intitule}');
              _cmde_selected.prestation.service = new ServicesModel();
              _cmde_selected.prestation.service =
                  servItem != null ? servItem : new ServicesModel();

              displayRoutePriseEnCharge();

              _displayRouteDestination();

              /*  if(_cmde_selected.is_terminated == true && _cmde_selected.status == "ANNULER"){
                _showNotificationCmdAN();
                reinitialiseMap(); 
              }   */
            });
          }
        });
      }
    });

    dbHelper.queryAll_presta().then((prest) {
      print("${TAG}:_createForm:queryAll_presta presta=${prest.length}");
      if (prest.length > 0) {
        print(
            "${TAG}:_createForm:_findAllOwnPresta success listCmdes=${prest[0]}");
        _name = prest[0]['nom'].toString();
        _prenom = prest[0]['prenom'].toString();
        print("le nom est : " + _name.toString());
        _token = prest[0]['token'].toString();

        print("le token est : " + _token.toString());

        AppSharedPreferences().getAllowsNotifications().then((bool1) {
          if (bool1 == true) {
            Future.delayed(Duration.zero, () {
              showDialog(
                  context: context,
                  builder: (context) {
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).pop(true);
                    });
                    return AlertDialog(
                      title: Text("BIENVENU SUR TAKESH"),
                      content: Text(
                        _name.toString() + " " + _prenom.toString(),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w700),
                      ),
                    );
                  });

              /*
              var alertStyle = AlertStyle(
                animationType: AnimationType.fromTop,
                isCloseButton: false,
                isOverlayTapDismiss: false,
                descStyle: TextStyle(fontWeight: FontWeight.bold),
                animationDuration: Duration(milliseconds: 400),
                alertBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                titleStyle: TextStyle(
                  color: Colors.red,
                ),
              );
              Alert(
                context: context,
                style: alertStyle,
                type: AlertType.info,
                title: "Bienvenu",
                desc: _name.toString() + " " + _prenom.toString(),
              ).show();

              */
            });
          } else {}
        });
      } else {
        print("Erreur........... ");
      }
    });

    /*  AppSharedPreferences().isOrderCreated().then((bool2){
     if(bool2 == true){
       print("affichage notification commande annulée par le client !!!");

     }else{

        var alertStyle = AlertStyle(
                animationType: AnimationType.fromTop,
                isCloseButton: false,
                isOverlayTapDismiss: false,
                descStyle: TextStyle(fontWeight: FontWeight.bold),
                animationDuration: Duration(milliseconds: 400),
                alertBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                titleStyle: TextStyle(
                  color: Colors.red,
                ),
              );
              Alert(
                context: context,
                style: alertStyle,
                type: AlertType.info,
                title: "Bienvenu",
                desc: "Pas de commandes"
              ).show();

     }

   }); */

    ///  Service to update the position of prestataire in server each 10
    timer2 = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _executeSetEpostion(
          _currentLocation.latitude, _currentLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
//    if (_page == null) {
//      // Create the form if it does not exist
//      _page = _createForm(context); // Build the form
//    }
    mediaQueryData = MediaQuery.of(context);
    _statusbarHeight = MediaQuery.of(context).padding.top;

    return _createForm(context);
  }

  Future<void> _goToTheLake(double lat, double lng, double zm) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: zm,
    )));
  }

  Future<void> _goToFindLocation() {
//    Navigator.of(context).pushNamed('/findlocation');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FindLocation()));
  }

  void _goToProfilPage() {
//    Navigator.of(context).pushNamed('/profil');
    AppSharedPreferences().setAllowsNotifications(false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
  }
}
