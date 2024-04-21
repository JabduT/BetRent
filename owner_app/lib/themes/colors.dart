import 'package:flutter/material.dart';

class AppConstants {
  static final Color primaryColor = Color.fromRGBO(0, 39, 56, 1.0);

  // static final Color backgroundColor = Color(0xFFC7B4FF);
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppConstants.primaryColor,
    // Other light mode theme properties
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppConstants.primaryColor,
    brightness: Brightness.dark,
    // Other dark mode theme properties
  );
}
