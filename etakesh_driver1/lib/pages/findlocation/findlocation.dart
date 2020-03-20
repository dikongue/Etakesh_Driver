import 'dart:convert';

import 'package:flutter/material.dart';

import '../../model/google_places_item.dart';
import '../../model/google_places.dart';
import '../../remote/api.dart';

class FindLocation extends StatefulWidget {
  /* final double latitude;
  final double longitude;
  FindLocation({Key key, this.latitude, this.longitude}) : super(key: key); */
  @override
  _FindLocationState createState() => _FindLocationState();
}

class _FindLocationState extends State<FindLocation> {
  String TAG = "FindLocationState";
  double _statusbarHeight;
  var _locations = new List<GooglePlacesItemModel>();
  TextEditingController _searchLocation;

    _findLocation(String input) {
    API.findLocation(input, "fr").then((response) {
      final String responseString = response.body;
//      print("${TAG}:findLocation ${responseString}");
      setState(() {
        GooglePlacesModel placesModel =
            new GooglePlacesModel.fromJson(json.decode(responseString));
        _locations = placesModel.predictions;
//        print("${TAG}:placesModel length = ${placesModel.predictions.length}");
      });
    });
  }  

   /* _findLocation(String input) {
   API
        .findLocation1(input, "fr", widget.latitude, widget.longitude)
        .then((response) {
      final String responseString = response.body;
      setState(() {
        GooglePlacesModel placesModel =
            new GooglePlacesModel.fromJson(json.decode(responseString));
        _locations = placesModel.predictions;
      });
    });
  }  */


  initState() {
    super.initState();
    _searchLocation = new TextEditingController();
 //   _findLocation();
  }

  @override
  Widget build(BuildContext context) {
    _statusbarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: _statusbarHeight + 14),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
              ),
              child: Container(
                margin: EdgeInsets.only(
                    top: 2.0, bottom: 2.0, left: 4.0, right: 4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
//                            Navigator.pop(context);
                            Navigator.of(context).pop(null);
                          }
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.black,),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _searchLocation,
                        enabled: true,
                        enableInteractiveSelection: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                        ),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          hintText: "Définissez une destination",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        onChanged: (text) {
                          print("${TAG}:onChanged test=${text}");
                          if(text.isNotEmpty) {
                            _findLocation(text);
                            return;
                          } else {
                            setState(() {
                              _searchLocation.text = "";
                            });
                          }
                        },
                      ),
                    ),
                    _searchLocation.text.isNotEmpty ? Expanded(
                      flex: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _searchLocation.text = "";
                          });
                        },
                        icon: Icon(Icons.clear, color: Colors.black),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(8.0),
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  String title = _locations[index].terms[0].value;
                  String subtitle = "";

                  for (int i = 1; i < _locations[index].terms.length; i++) {
                    subtitle = _locations[index].terms[i].value + ", ";
                  }
                  return ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(title, style: TextStyle(color: Colors.black),),
                    subtitle: Text(subtitle),
                    onTap: () {
                      print("${TAG}:onTap Location item index=${index}");
                      Navigator.of(context).pop(_locations[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
