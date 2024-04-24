import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 import 'package:owner_app/constants/url.dart';
class Profile extends StatelessWidget {
  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await http.get(Uri.parse('${AppConstants.APIURL}/users/profile'));
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final profileData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Owner Home'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Profile:',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text('Name: ${profileData['name']}'),
                  Text('Email: ${profileData['email']}'),
                  Text('Phone: ${profileData['phone']}'),
                  // Add more profile details as needed
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}
