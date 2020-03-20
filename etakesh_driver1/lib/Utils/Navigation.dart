import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

class StartNavigation {
 static Future startNavigate(double latOrig,double lngOrig,double latDest,double lngDest,String labelOrig, String labelDest) async {
    var origin = Location(
        name: labelOrig, latitude: latOrig, longitude: lngOrig);
    var destination = Location(
        name: labelDest , latitude: latDest, longitude: lngDest);

    await FlutterMapboxNavigation.startNavigation(origin, destination);
  }
}
