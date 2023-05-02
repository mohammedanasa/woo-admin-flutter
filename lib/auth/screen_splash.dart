import 'package:flutter/material.dart';
import 'package:foodflow/auth/screen_login.dart';
import 'package:foodflow/screens/screen-main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Hello')),
    );
  }

  Future<void> getLogin() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return LoginPage();
    }));
  }

  Future<void> checkUserLoggedin() async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    final _userLoggedin = _sharedPrefs.getBool(SAVE_KEY_NAME);

    if (_userLoggedin == null || _userLoggedin == false) {
      getLogin();
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx1) => ScreenMain()));
    }
  }
}
