// @dart=2.9
import 'dart:async';

import 'package:aqua/Navbar/navbar.dart';
import 'package:aqua/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_selection.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => BottomNavBar(),
        ),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => LanguageSelecttion()));
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
    //  PushNotificationsManager().init();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // body: new Center(
        //   child: Center(
        //     child: SpinKitCubeGrid(
        //       color: Colors.black87,
        //       size: 30,
        //     ),
        //   ),
        // ),
        );
  }
}
