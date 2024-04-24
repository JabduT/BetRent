import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:owner_app/screens/owner/my_property_list.dart';
import 'package:owner_app/screens/screen1.dart';
import 'package:owner_app/screens/screen2.dart';
import 'package:owner_app/screens/screen3.dart';
import 'package:owner_app/screens/screen4.dart';
import 'package:owner_app/themes/colors.dart';

class OwnerBottomNavigationBar extends StatefulWidget {
  @override
  _OwnerBottomNavigationBarState createState() =>
      _OwnerBottomNavigationBarState();
}

class _OwnerBottomNavigationBarState extends State<OwnerBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    OwnerPropertyListScreen(),
    AddHouseRentScreen(),
    Screen2(),
    // Screen3(),
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
        items: <Widget>[
          Icon(Icons.home,
              color:
                  _selectedIndex == 0 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.history,
              color:
                  _selectedIndex == 1 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.history,
              color:
                  _selectedIndex == 1 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.add,
              color:
                  _selectedIndex == 1 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.message,
              color:
                  _selectedIndex == 2 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.notifications,
              color:
                  _selectedIndex == 3 ? AppColors.secondaryColor : Colors.white,
              size: 30),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
        height: 60.0,
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.primaryColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
      ),
    );
  }
}