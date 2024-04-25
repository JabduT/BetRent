import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owner_app/screens/authentication/register.dart';
import 'package:owner_app/screens/chatting_screen.dart';
import 'package:owner_app/screens/renter/property_list_screen.dart';
import 'package:owner_app/widgets/bottom_bar_owner.dart';
import 'package:owner_app/screens/owner/homeScreen.dart';
import 'package:owner_app/screens/common/notification.dart';
import 'package:owner_app/screens/owner/addHouse.dart';
import 'package:owner_app/screens/common/messaging.dart';
import 'package:owner_app/screens/authentication/login.dart';
import 'package:owner_app/widgets/bottom_bar_renter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Fetch user data asynchronously
      future: getUserData(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String? role = snapshot.data;
            // Role-based navigation
            if (role == 'renter') {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.red,
                ),
                initialRoute: '/renter_home',
                routes: {
                  '/login': (context) => LoginScreen(),
                  '/register': (context) => SignUpScreen(),
                  '/renter_home': (context) => RenterBottomNavigationBar(),
                  '/screen1': (context) => PropertyListScreen(),
                  // '/chat': (context) => ChattingScreen(),
                  '/screen4': (context) => Screen4(), //add it here
                },
              );
            } else {
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
                  '/screen1': (context) => PropertyListScreen(),
                  // '/chat': (context) => ChattingScreen(),
                  '/screen4': (context) => Screen4(), //and here
                },
              );
            }
          }
        }
      },
    );
  }

  // Function to get user data asynchronously
  Future<String?> getUserData() async {
    final storage = FlutterSecureStorage();
    final String? userData = await storage.read(key: 'user');

    if (userData != null) {
      final user = jsonDecode(userData);
      return user['role'];
    } else {
      return null;
    }
  }
}
