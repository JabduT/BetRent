import 'package:flutter/material.dart';
import 'package:owner_app/screens/authentication/register.dart';
import 'package:owner_app/screens/renter/property_list_screen.dart';
import 'package:owner_app/widgets/bottom_bar_owner.dart';
import 'package:owner_app/screens/owner/homeScreen.dart';
import 'package:owner_app/screens/screen2.dart';
import 'package:owner_app/screens/owner/addHouse.dart';
import 'package:owner_app/screens/screen4.dart';
import 'package:owner_app/screens/authentication/login.dart';
import 'package:owner_app/widgets/bottom_bar_renter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/owner_home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => SignUpScreen(),
        '/owner_home': (context) => OwnerBottomNavigationBar(),
        '/renter_home': (context) => RenterBottomNavigationBar(),
        '/screen1': (context) => PropertyListScreen(),
        '/screen4': (context) => Screen4(),
      },
    );
  }
}
