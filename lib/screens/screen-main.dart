import 'package:flutter/material.dart';
import 'package:foodflow/auth/screen_login.dart';
import 'package:foodflow/screens/screen-orders.dart';
import 'package:foodflow/screens/screen-products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({Key? key}) : super(key: key);

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  int _currentSelectedIndex = 0;
  final _pages = [
    //ScreenHome(),
    CategoryProductsPage(),
    OrderListPage(),
    //ScreenProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
        onTap: (newIndex) {
          setState(() {
            _currentSelectedIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Orders'),
          //BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

signOut(BuildContext ctx) async {
  final _sharedPrefs = await SharedPreferences.getInstance();
  _sharedPrefs.clear();
  Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx1) => LoginPage(),
      ),
      (route) => false);
}
