import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
import 'package:owner_app/constants/url.dart';
import 'package:owner_app/themes/colors.dart';

class ContactDetail extends StatefulWidget {
  final String? userId;

  const ContactDetail({Key? key, this.userId}) : super(key: key);

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfile();
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final String userId = widget.userId ?? '';

      final response = await http.get(
        Uri.parse('${AppConstants.APIURL}/users/$userId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      return jsonDecode(response.body)['user'];
    } catch (error) {
      throw Exception('Failed to load contact detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profileData = snapshot.data!;
            final String? fullName = profileData['name'] as String?;
            final String? userEmail = profileData['email'] as String?;
            final String? userName = profileData['username'] as String?;
            final String? userPhone = profileData['phoneNumber'] as String?;
            final String? userImageURL =
                profileData['profile_image'] as String?;
            final bool isVerified = profileData['verified'] as bool? ?? false;

            return _buildContactDetailContent(
              fullName,
              userEmail,
              userName,
              userPhone,
              userImageURL,
              isVerified,
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildContactDetailContent(
    String? fullName,
    String? userEmail,
    String? userName,
    String? userPhone,
    String? userImageURL,
    bool isVerified,
  ) {
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
          if (fullName != null) _buildContactDetailItem('Name', fullName),
          if (userEmail != null) _buildContactDetailItem('Email', userEmail),
          if (userName != null) _buildContactDetailItem('Username', userName),
          if (userPhone != null)
            _buildContactDetailItem('Phone', userPhone, icon: Icons.phone),
          _buildContactDetailItem(
            'Verified',
            isVerified ? 'Verified' : 'Not Verified',
            icon: isVerified ? Icons.verified : Icons.warning,
            iconColor: isVerified ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailItem(String title, String value,
      {IconData? icon, Color? iconColor}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: icon != null
          ? IconButton(
              icon: Icon(icon, color: iconColor),
              onPressed: () {
                _makePhoneCall(value);
              },
            )
          : null,
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    if (await Permission.phone.request().isGranted) {
      if (await canLaunch('tel:$phoneNumber')) {
        await launch('tel:$phoneNumber');
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } else {
      throw 'Permission denied for making phone calls';
    }
  }
}
