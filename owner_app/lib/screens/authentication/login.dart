import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owner_app/screens/authentication/register.dart';
import 'package:owner_app/screens/screen1.dart';
import 'package:owner_app/themes/colors.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    // Get user input
    String phoneNumber = phoneController.text.trim();
    String pin = pinController.text.trim();

    // Send POST request to login API
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': '+251$phoneNumber',
        'PIN': pin,
      }),
    );

    // Log response
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Handle response
    if (response.statusCode == 200) {
      // If login is successful, save token to flutter_secure_storage
      final storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: jsonDecode(response.body)['token']);

      // Redirect user to home screen
      Navigator.pushNamed(context, '/home');
    } else {
      // If login fails, show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid phone number or PIN. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Text(
                "Login to your account",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold font weight
                  color: AppConstants.primaryColor, // Primary color
                ),
              ),
            ),
            SizedBox(height: 20),
            // Phone Number Field
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: AppConstants.primaryColor.withOpacity(0.3), // 30% opacity
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixText: '+251', // Country code
                prefixStyle: TextStyle(color: Colors.black),
                suffixIcon: Container(
                  height: 55,
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
              controller: pinController,
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
                  height: 55,
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
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => loginUser(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  AppConstants.primaryColor,
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  height: 3.5,
                  fontWeight: FontWeight.bold, // Bold font weight
                  color: Colors.white, // Primary color
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    color: AppConstants.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.primaryColor), // Primary color border
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: AppConstants.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
