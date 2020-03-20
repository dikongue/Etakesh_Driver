//import 'dart:async';
//
//import 'package:etakesh_client/DAO/google_maps_requests.dart';
//import 'package:etakesh_client/Database/DatabaseHelper.dart';
//import 'package:etakesh_client/Models/clients.dart';
//import 'package:etakesh_client/Models/commande.dart';
//import 'package:etakesh_client/Models/google_place_item.dart';
//import 'package:etakesh_client/Models/google_place_item_term.dart';
//import 'package:etakesh_client/Models/prestataires.dart';
//import 'package:etakesh_client/Models/services.dart';
//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//class CommandePage extends StatefulWidget {
//
//  @override
//  State createState() => CommandePageState();
//}
//
//class CommandePageState extends State<CommandePage> {
//  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
//  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
//
//
//  Set<Marker> markers = Set();
//  Set<Polyline> _polyLines = Set();
//  GoogleMapController mapController;
//
//  GooglePlacesItem destinationModel = new GooglePlacesItem();
//  GooglePlacesItem positiontionModel = new GooglePlacesItem();
//  LatLng _mypositio = new LatLng(4.0922421, 9.748265);
//  LocationModel position, destination;
//
//
//  @override
//  void initState() {
//
//    _addMarkerPosition(widget.position.place_id);
//
//    _addMarkerDestination(widget.destination.place_id);
//
//    _sendRequest();
//    super.initState();
//  }
//
//  /*
//* [12.12, 312.2, 321.3, 231.4, 234.5, 2342.6, 2341.7, 1321.4]
//* (0-------1-------2------3------4------5-------6-------7)
//* */
//
////  this method will convert list of doubles into latlng
//  List<LatLng> convertToLatLng(List points) {
//    List<LatLng> result = <LatLng>[];
//    for (int i = 0; i < points.length; i++) {
//      if (i % 2 != 0) {
//        result.add(LatLng(points[i - 1], points[i]));
//      }
//    }
//    return result;
//  }
//
//  List decodePoly(String poly) {
//    var list = poly.codeUnits;
//    var lList = new List();
//    int index = 0;
//    int len = poly.length;
//    int c = 0;
//// repeating until all attributes are decoded
//    do {
//      var shift = 0;
//      int result = 0;
//
//      // for decoding value of one attribute
//      do {
//        c = list[index] - 63;
//        result |= (c & 0x1F) << (shift * 5);
//        index++;
//        shift++;
//      } while (c >= 32);
//      /* if value is negetive then bitwise not the value */
//      if (result & 1 == 1) {
//        result = ~result;
//      }
//      var result1 = (result >> 1) * 0.00001;
//      lList.add(result1);
//    } while (index < len);
//
///*adding to previous value as done in encoding */
//    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
//
//    print(lList.toString());
//
//    return lList;
//  }
//
//  void createRoute(String encondedPoly) {
//    setState(() {
//      _polyLines.add(Polyline(
//          polylineId: PolylineId(_mypositio.toString()),
//          width: 10,
//          points: convertToLatLng(decodePoly(encondedPoly)),
//          color: Colors.black));
//    });
//  }
//
//  void _sendRequest() async {
//    String route = await _googleMapsServices.getRouteCoordinates(
//        widget.locposition, widget.locdestination);
//    createRoute(route);
//  }
//
//  void _addMarkerDestination(String paceId) async {
//    LocationModel dest = await _googleMapsServices.getRoutePlaceById(paceId);
//    setState(() {
//      destination = dest;
//      markers.add(Marker(
//          markerId: MarkerId(paceId),
//          position: LatLng(destination.lat, destination.lng),
//          infoWindow: InfoWindow(
//              title: widget.destination.description, snippet: "Destination"),
//          icon: BitmapDescriptor.defaultMarkerWithHue(
//              BitmapDescriptor.hueGreen)));
//    });
//  }
//
//  void _addMarkerPosition(String paceId) async {
//    LocationModel post = await _googleMapsServices.getRoutePlaceById(paceId);
//    setState(() {
//      position = post;
//      markers.add(Marker(
//          markerId: MarkerId(paceId),
//          position: LatLng(position.lat, position.lng),
//          infoWindow: InfoWindow(
//              title: widget.position.description, snippet: "Position"),
//          icon:
//          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
//    });
//  }
//
//  Completer<GoogleMapController> _controller = Completer();
//
//  @override
//  Widget build(BuildContext context) {
//
//    return new Scaffold(
//        key: _scaffoldKey,
//        body: Stack(children: <Widget>[
//          Container(
//              height: MediaQuery.of(context).size.height,
//              width: MediaQuery.of(context).size.width,
//              child: GoogleMap(
//                onMapCreated: (GoogleMapController controller) {
//                  _controller.complete(controller);
//                },
//                compassEnabled: true,
//                initialCameraPosition: CameraPosition(
//                    target: LatLng(
//                        widget.locposition.lat, widget.locposition.lng),
//                    zoom: 9.0),
//                markers: markers,
//                polylines: _polyLines,
//              )),
//          Positioned(
//            height: 50.0,
//            left: 5.0,
//            top: 15.0,
//            child: IconButton(
//              onPressed: () {},
//              icon: Icon(
//                Icons.arrow_back,
//                color: Colors.black,
//              ),
//            ),
//          ),
//        ]));
//
//  }
//
//}