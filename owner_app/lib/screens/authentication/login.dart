import 'package:flutter/material.dart';
import 'package:owner_app/screens/authentication/register.dart';
import 'package:owner_app/screens/screen1.dart';
import 'package:owner_app/themes/colors.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo Image
            SizedBox(height: 20),
            Image.asset(
              'assets/images/logo.png',
              height: 120,
              width: 50,
            ),
            Center(
              child: Text("Login to your account"),
            ),
            SizedBox(height: 20),
            // Phone Number Field
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: AppConstants.primaryColor.withOpacity(0.2), // 30% opacity
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixText: '+251', // Country code
                prefixStyle: TextStyle(color: Colors.black),
                suffixIcon: Container(
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppConstants.primaryColor, // Background color for icon
                  ),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white, // Icon color
                  ), // Phone Icon
                ),
              ),
            ),
            SizedBox(height: 20),
            // PIN Field
            TextFormField(
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PIN',
                filled: true,
                fillColor: AppConstants.primaryColor.withOpacity(0.3), // 30% opacity
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Container(
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppConstants.primaryColor, // Background color for icon
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Colors.white, // Icon color
                  ), // Lock Icon
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Don\'t have an account? create account',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
