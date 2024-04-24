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
        icon: Icon(Icons.menu, color: AppColors.primaryColor), // Use primary color from AppColors
        onPressed: () {
          // Open the drawer using the ScaffoldState
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    ),
    body: 
    
    SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combined widget for logo and text
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0,),
            child: Row(
              children: [
                // Logo image
                Image.asset(
                  'assets/logo.png',
                  height: 80.0,
                  width: 80.0,
                  // Adjust the path and size as needed for your logo
                ),
                SizedBox(width: 20.0), // Add spacing between logo and text
                // Text widget for "Place where you can get renter for your house"
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
          // Image between the statement and features
          Image.asset(
            'assets/home_image.png',
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
            // Adjust the path and size as needed for your image
          ),

          SizedBox(height: 20.0),

          // Grid of features
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildFeatureTile(context,Icons.add, 'Post your house'),
              _buildFeatureTile(context,Icons.message, 'Messaging'),
              _buildFeatureTile(context,Icons.house, 'My houses'),
              _buildFeatureTile(context,Icons.person, 'My profile'),
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
              color: AppColors.primaryColor, // Set background color to primary color
            ),
            child: Row(
              children: [
                // Your logo image widget
                Image.asset(
                  'assets/logo.png',
                  height: 40.0,
                  width: 40.0,
                  // Adjust size and path as needed
                ),
                SizedBox(width: 10.0), // Add spacing between logo and text
                // Text widget for "Find Renter"
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
            leading: Icon(Icons.pin), // Icon for Change PIN
            title: Text('Change PIN'),
            onTap: () {
              // Handle change PIN action
            },
          ),
          ListTile(
            leading: Icon(Icons.logout), // Icon for Logout
            title: Text('Logout'),
            onTap: () {
              // Handle logout action
            },
          ),
          ListTile(
            leading: Icon(Icons.info), // Icon for About
            title: Text('About'),
            onTap: () {
              // Handle about action
            },
          ),
          ListTile(
            leading: Icon(Icons.star), // Icon for Rate the App
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



    Widget _buildFeatureTile(BuildContext context,IconData iconData, String label) {
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
    MaterialPageRoute(builder: (context) => Profile ()),
  );

        }
            },
    
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 36.0,color: AppColors.primaryColor,),
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
