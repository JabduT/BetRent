import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:owner_app/constants/url.dart';

class Profile extends StatelessWidget {
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final response = await http.get(
          Uri.parse('${AppConstants.APIURL}/user/profile'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          });
      print(response.body);
      return jsonDecode(response.body);
    } catch (error) {
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
          final fullName = profileData['name'] as String;
          final userEmail = profileData['email'] as String;
          final userPhone = profileData['phone'] as String;
          // Assuming 'userImageURL' is the URL of the user's profile image
          final userImageURL = profileData['profile_image'] as String;

          return Scaffold(
            appBar: AppBar(
              title: Text('My Profile'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userImageURL),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  _buildProfileItem('Name', fullName, Icons.edit),
                  _buildProfileItem('Email', userEmail, Icons.edit),
                  _buildProfileItem('Phone', userPhone, Icons.edit),
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

  Widget _buildProfileItem(String title, String value, IconData iconData) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: IconButton(
        icon: Icon(iconData),
        onPressed: () {
          // Handle edit action for the profile item
          // For example, navigate to EditProfileScreen with the specific item to edit
        },
      ),
    );
  }
}
