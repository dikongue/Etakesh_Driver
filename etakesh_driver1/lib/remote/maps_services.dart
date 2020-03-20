
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../roli/my_const.dart';
import '../model/eposition.dart';

class MapsServices {
  static String TAG = "GoogleMapsServices";

  static Future getRouteCoordinates(EPositionModel from, EPositionModel to) {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&key=${MyConst.MAPS_API_KEY}";
//    http.Response response = await http.get(url);
//    Map values = jsonDecode(response.body);
//    return values["routes"][0]["overview_polyline"]["points"];
    print("${TAG}:getRouteCoordinates url=${url}");
    return http.get(url);
  }
}