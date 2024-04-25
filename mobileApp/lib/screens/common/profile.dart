import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:owner_app/constants/url.dart';
import 'package:owner_app/themes/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId;
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    final storage = FlutterSecureStorage();
    final String? userData = await storage.read(key: 'user');

    if (userData != null) {
      final user = jsonDecode(userData);
      userId = user['_id'];
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      final response = await http.get(
        Uri.parse('${AppConstants.APIURL}/users/profile'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      setState(() {
        profileData = jsonDecode(response.body)['user'];
      });
    } catch (error) {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    if (profileData == null) {
      return Center(child: CircularProgressIndicator());
    }

    final fullName = profileData!['name'] as String?;
    final userEmail = profileData!['email'] as String?;
    final userPhone = profileData!['phoneNumber'] as String;
    final userImageURL = profileData!['profile_image'] as String?;
    final joined = profileData!['createdAt'] as String?;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: userImageURL != null
                  ? NetworkImage(userImageURL)
                  : AssetImage('assets/images/user_icon.png') as ImageProvider,
            ),
          ),
          SizedBox(height: 20.0),
          if (fullName != null) _buildProfileItem('Name', fullName),
          if (userEmail != null) _buildProfileItem('Email', userEmail),
          _buildProfileItem('Phone', userPhone),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          // Handle edit action for the profile item
          // For example, navigate to EditProfileScreen with the specific item to edit
        },
      ),
    );
  }
}
