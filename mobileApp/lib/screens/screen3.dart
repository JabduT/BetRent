import 'package:flutter/material.dart';
import 'package:owner_app/themes/colors.dart';
import 'package:owner_app/widgets/bottom_bar_owner.dart';
class AddHouseRentScreen extends StatefulWidget {
  @override
  _AddHouseRentScreenState createState() => _AddHouseRentScreenState();
}

class _AddHouseRentScreenState extends State<AddHouseRentScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 90.0), // Adjust top padding as needed
        child: Text(
          'Add House Rent',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          ),
        ),
      ),
      centerTitle: true, // Center the title horizontally
      toolbarHeight: 120.0, 
    ),
    body: PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(), // Disable swipe navigation
      children: [
        _buildFirstScreen(),
        _buildSecondScreen(),
        _buildFinalScreen(),
      ],
    ),
  );
}
  Widget _buildFirstScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Post Title',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
                border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0), // Add border radius
      borderSide: BorderSide.none, // Remove border color
    ),
            ),
            // Implement validation and save logic here
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'House Type',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none, // Remove border color
              ),
            ),
            // Implement validation and save logic here
          ),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'House Description',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // Remove border color
              ),
            ),
            maxLines: 4, // Increase height
            // Implement validation and save logic here
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0) // Show back button if not on the first screen
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _previousPage,
                  color: Colors.white, // Set text color to white
                ),
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0), // Add padding
                ),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.0), // Move title down
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Total Number of Rooms',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            // Implement validation and save logic here
          ),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Total Number of Bathrooms',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            // Implement validation and save logic here
          ),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Exact Location',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            // Implement validation and save logic here
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousPage,
                color: Colors.white, // Set text color to white
              ),
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalScreen() {
    return Center(
      child: Text('This is the final screen or add more fields here.'),
    );
  }
}
