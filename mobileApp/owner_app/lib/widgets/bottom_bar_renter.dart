import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:owner_app/screens/property_list_screen.dart';
import 'package:owner_app/screens/screen1.dart';
import 'package:owner_app/screens/screen2.dart';
import 'package:owner_app/screens/screen3.dart';
import 'package:owner_app/screens/screen4.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    PropertyListScreen(),
    Screen2(),
    AddHouseRentScreen(),
    Screen4(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // Change as needed
        items: const <Widget>[
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.history, color: Colors.white, size: 30),
          Icon(Icons.add, color: Colors.white, size: 30),
          Icon(Icons.message, color: Colors.white, size: 30),
          Icon(Icons.notifications,
              color: Colors.white, size: 30), // Use notifications icon
        ],

        index: _selectedIndex,
        onTap: _onItemTapped,
        height: 60.0,
        color: Color.fromRGBO(0, 39, 56, 1.0),
        buttonBackgroundColor: Color.fromRGBO(0, 39, 56, 1.0),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
      ),
    );
  }
}
