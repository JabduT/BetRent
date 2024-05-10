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
      setState(() {
        profileData = jsonDecode(response.body)['user'];
      });
    } catch (error) {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> _logout(BuildContext context) async {
    final bool logoutConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled logout
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed logout
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );

    if (logoutConfirmed != null && logoutConfirmed) {
      // Perform logout action here, for example, delete stored token
      final storage = FlutterSecureStorage();
      await storage.delete(key: 'token');

      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: _buildProfileContent(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 40.0,
                    width: 40.0,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Find Renter',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.pin),
              title: Text('Change PIN'),
              onTap: () {
                // Handle change PIN action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout(context); // Call logout function
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // Handle about action
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate the App'),
              onTap: () {
                // Handle rate the app action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
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
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              _logout(context); // Call logout function
            },
          ),
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
