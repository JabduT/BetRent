import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:owner_app/screens/chatting_screen.dart';
import 'package:owner_app/screens/common/profile.dart';
import 'package:owner_app/screens/renter/favorite_list.dart';
import 'package:owner_app/screens/renter/property_list_screen.dart';
import 'package:owner_app/screens/owner/homeScreen.dart';
import 'package:owner_app/screens/common/notification.dart';
import 'package:owner_app/screens/owner/addHouse.dart';
import 'package:owner_app/screens/common/messaging.dart';
import 'package:owner_app/themes/colors.dart';

class RenterBottomNavigationBar extends StatefulWidget {
  @override
  _RenterBottomNavigationBarState createState() =>
      _RenterBottomNavigationBarState();
}

class _RenterBottomNavigationBarState extends State<RenterBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PropertyListScreen(),
    FavoriteListScreen(),
    // ChattingScreen(),
    HomeScreen(),
    // Screen2(),
    // Screen2(),
    ProfileScreen(),
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
          Icon(Icons.favorite,
              color:
                  _selectedIndex == 1 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.message,
              color:
                  _selectedIndex == 2 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.person,
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
