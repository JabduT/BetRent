import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owner_app/screens/common/profile.dart';
import 'package:owner_app/screens/owner/addHouse.dart';
import 'package:owner_app/themes/colors.dart';
import 'package:owner_app/widgets/bottom_bar_owner.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token;
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
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while retrieving token
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          // Token is available, show home screen content
          return _buildHomePageContent(context);
        } else {
          // No token found, redirect to login screen
          Navigator.pushReplacementNamed(context, '/login');
          return Container(); // Placeholder widget, not rendered
        }
      },
    );
  }



  Widget _buildHomePageContent(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: SizedBox.shrink(),
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.primaryColor),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0,),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 80.0,
                    width: 80.0,
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Text(
                      'Place where you can get renter for your house',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Image.asset(
              'assets/home_image.png',
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20.0),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureTile(context, Icons.add, 'Post your house'),
                _buildFeatureTile(context, Icons.message, 'Messaging'),
                _buildFeatureTile(context, Icons.house, 'My houses'),
                _buildFeatureTile(context, Icons.person, 'My profile'),
              ],
            ),
          ],
        ),
      ),
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

  Widget _buildFeatureTile(BuildContext context, IconData iconData, String label) {
    return Card(
      elevation: 2.0,
      child: InkWell(
      onTap: () {
        if (iconData == Icons.add) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHouseRentScreen()),
          );
        } else if (iconData == Icons.message) {
          // Handle Messaging feature
        } else if (iconData == Icons.house) {
          // Handle My houses feature
        }  
        else if(iconData==Icons.person){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfileScreen ()),
  );

        }
            },
    
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 36.0, color: AppColors.primaryColor),
              SizedBox(height: 8.0),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
