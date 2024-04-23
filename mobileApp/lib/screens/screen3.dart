import 'package:flutter/material.dart';
import 'package:owner_app/widgets/bottom_bar_owner.dart';
class AddHouseRentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add House Rent'),
        // No back icon in the app bar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Post Title'),
              // Implement validation and save logic here
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'House Type'),
              // Implement validation and save logic here
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'House Description'),
              // Implement validation and save logic here
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen to continue filling the form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextScreen()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
        // No back icon in the app bar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Total Number of Rooms'),
              keyboardType: TextInputType.number,
              // Implement validation and save logic here
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Total Number of Bathrooms'),
              keyboardType: TextInputType.number,
              // Implement validation and save logic here
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Exact Location'),
              // Implement validation and save logic here
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen to continue filling the form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FinalScreen()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: OwnerBottomNavigationBar(), // Reusing the bottom nav bar
    );
  }
}

class FinalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Screen'),
        // No back icon in the app bar
      ),
      body: Center(
        child: Text('This is the final screen or add more fields here.'),
      ),
      bottomNavigationBar: OwnerBottomNavigationBar(), // Reusing the bottom nav bar
    );
  }
}