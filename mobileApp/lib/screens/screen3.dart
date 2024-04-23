import 'package:flutter/material.dart';
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
        title: Text('Add House Rent'),
        // No back icon in the app bar
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
            onPressed: _nextPage,
            child: Text('Next'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _previousPage,
                child: Text('Back'),
              ),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This is the final screen or add more fields here.'),
          ElevatedButton(
            onPressed: _previousPage,
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}
