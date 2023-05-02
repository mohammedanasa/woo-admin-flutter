import 'package:flutter/material.dart';
import 'package:foodflow/auth/screen_splash.dart';
import 'package:foodflow/screens/screen-main.dart';
import 'package:foodflow/screens/screen-products.dart';

const SAVE_KEY_NAME = 'UserLoggedIn';

main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: ScreenSplash(),
        routes: {
          '/main-screen': (BuildContext context) => ScreenMain(),
          //'/product-list': (BuildContext context) => ProductListPage(),
          //'/order-list': (BuildContext context) => OrderListPage(),
          //'/product-list1': (BuildContext context) => ProductListPage1(),
        });
  }
}
