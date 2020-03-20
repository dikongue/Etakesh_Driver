import 'package:etakesh_driver/Utils/AppSharePreferences.dart';
import 'package:etakesh_driver/database/database_helper.dart';
import 'package:etakesh_driver/pages/home/home.dart';
import 'package:etakesh_driver/pages/login/login.dart';
import 'package:flutter/material.dart';

import '../../roli/my_colors.dart';

class Presentation extends StatefulWidget {
  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  String TAG = "LoginState";
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  void _query_presta() async {
//    final prestaRows = await dbHelper.queryAll_presta();
//    print(
//        '${TAG}:_query_presta query all rows:${prestaRows.length} | ${prestaRows.toString()}');
//    if (prestaRows.length > 0) {
//      Navigator.of(context)
//          .push(MaterialPageRoute(builder: (context) => Home()));
//    } else {
    AppSharedPreferences().setAppFirstLaunch(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
//    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              height: (statusbarHeight * 2) / 3,
              left: 0.0,
              right: 0.0,
              top: 0.0,
              child: Image.asset(
                'images/presentation_1.gif',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                left: 4.0,
                right: 4.0,
                bottom: 8.0,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Bienvenue Dans la nouvelle application destinée aux partenaires',
                        style: new TextStyle(fontSize: 21.0),
                        textAlign: TextAlign.center,
                      ),
                      Divider(),
                      RaisedButton(
                          child: Text('CONNECTEZ-VOUS',
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.white)),
                          colorBrightness: Brightness.dark,
                          color: MyColors.colorBlue,
                          onPressed: () {
                            _query_presta();
                          }),
                      /*Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('CONNECTEZ-VOUS',
                                style: new TextStyle(fontSize: 20.0)),
                            onPressed: () {},
                          ),
                          /*RaisedButton(
                            child: Text('Inscription',
                                style: new TextStyle(fontSize: 20.0)),
                            onPressed: () {},
                          ),*/
                        ],
                      ),*/
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
