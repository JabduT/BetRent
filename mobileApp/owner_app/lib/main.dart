import 'package:flutter/material.dart';
import 'package:owner_app/screens/authentication/register.dart';
import 'package:owner_app/widgets/my_bottom_navigation_bar.dart';
import 'package:owner_app/screens/screen1.dart';
import 'package:owner_app/screens/screen2.dart';
import 'package:owner_app/screens/screen3.dart';
import 'package:owner_app/screens/screen4.dart';
import 'package:owner_app/screens/authentication/login.dart'; // Import the login screen

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        "/register": (context) => SignUpScreen(),
        '/home': (context) => MyBottomNavigationBar(),
        '/screen1': (context) => HomeScreen(),
        '/screen2': (context) => Screen2(),
        '/screen3': (context) => Screen3(),
        '/screen4': (context) => Screen4(),
      },
    );
  }
}
