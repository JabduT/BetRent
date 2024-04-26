import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owner_app/constants/url.dart';
import 'package:owner_app/screens/authentication/register.dart';
import 'package:owner_app/screens/owner/homeScreen.dart';
import 'package:owner_app/themes/colors.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    // Get user input
    print('pressed');
    String phoneNumber = phoneController.text.trim();
    String pin = pinController.text.trim();

    final response = await http.post(
      Uri.parse('${AppConstants.APIURL}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': '+251$phoneNumber',
        'PIN': pin,
      }),
    );

    if (response.statusCode == 200) {
      final storage = FlutterSecureStorage();
      await storage.write(
          key: 'token', value: jsonDecode(response.body)['token']);
      final userJson = jsonEncode(jsonDecode(response.body)['user']);
      await storage.write(key: 'user', value: userJson);
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String role = responseBody['user']['role'];
      print(role);

      if (role == 'renter') {
        Navigator.pushReplacementNamed(context, '/renter_home');
      } else {
        Navigator.pushReplacementNamed(context, '/owner_home');
      }
    }
     else {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100),
              Image.asset(
                'assets/images/logo.png',
                height: 120,
                width: 50,
              ),
              Center(
                child: Text(
                  "Login to your account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  filled: true,
                  fillColor: AppColors.primaryColor.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixText: '+251',
                  prefixStyle: TextStyle(color: Colors.black),
                  suffixIcon: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  filled: true,
                  fillColor: AppColors.primaryColor.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => loginUser(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.primaryColor,
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    height: 3.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                      thickness: 1,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 20,
                      thickness: 1,
                      color: AppColors.primaryColor,
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
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40), // Additional space for bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
