import 'package:etakesh_driver/Utils/AppSharePreferences.dart';
import 'package:etakesh_driver/pages/home/home.dart';
import 'package:etakesh_driver/pages/login/login.dart';
import 'package:flutter/material.dart';

import 'pages/presentation/presentation.dart';
import 'roli/my_colors.dart';

void main() => runApp(
      MaterialApp(
          title: 'E-Takesh Driver',
          theme: ThemeData(
              primaryColor: MyColors.colorBlue,
              accentColor: MyColors.colorRouge),
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          home: MainPage()),
    );

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    AppSharedPreferences().isAppFirstLaunch().then((bool1) {
      if (bool1 == true) {
        // on presente l'appli
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return Presentation();
        }));
      } else {
        AppSharedPreferences().isAppLoggedIn().then((bool2) {
          if (bool2 == false) {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return Login();
            }));
          } else {

                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return Home();
                }));
          }
        }, onError: (e) {});
      }
    }, onError: (e) {
      AppSharedPreferences().setAppFirstLaunch(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    return new AnimatedBuilder(builder: (context, _) {
    return Material(
      color: Colors.white,
    );
//    });
  }
}


/*
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class CallPhone extends StatelessWidget {
  final String phone = 'tel:+2347012345678';

  _callPhone() async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Call Phone from App Example')),
      body: Center(
          child: RaisedButton(
        onPressed: _callPhone,
        child: Text('Call Phone'),
        color: Colors.red,
      )),
    );
  }
}
*/
