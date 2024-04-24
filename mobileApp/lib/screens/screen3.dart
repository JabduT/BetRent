import 'package:flutter/material.dart';
import 'package:owner_app/themes/colors.dart';
import 'package:owner_app/widgets/bottom_bar_owner.dart';
class AddHouseRentScreen extends StatefulWidget {
  @override
  _AddHouseRentScreenState createState() => _AddHouseRentScreenState();
}

class _AddHouseRentScreenState extends State<AddHouseRentScreen> {
  // Define a list of property types
List<String> propertyTypes = [
  "Apartment",
  "Condo",
  "House",
  "Studio Apartment",
  "Villa",
  "Bedsitter",
  "Block of Flats",
  "Chalet",
  "Duplex",
  "Farm House",
  "Mansion",
  "Penthouse",
  "Room & Parlour",
  "Shared Apartment",
  "Townhouse / Terrace",
];
  late String _selectedType; // Declare _selectedType
  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _selectedType = propertyTypes[0]; // Initialize _selectedType here

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
            fontSize: 26.0,
            color: AppColors.primaryColor,
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

          DropdownButtonFormField<String>(
            value: _selectedType,
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
            items: propertyTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Type',
              filled: true,
              fillColor: Colors.blue.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
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
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Total Number of Rooms',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none, // Remove border color
              ),
            ),
            keyboardType: TextInputType.number,
            // Implement validation and save logic here
          ),
          SizedBox(height: 10.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Price',
            filled: true,
            fillColor: AppColors.primaryColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove border color
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
            ElevatedButton(
                onPressed: _previousPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),

              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
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
  return SingleChildScrollView(
    padding: EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Property Size (sqft)',
            filled: true,
            fillColor: AppColors.primaryColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove border color
            ),
          ),
          keyboardType: TextInputType.number,
          // Implement validation and save logic here
        ),
        SizedBox(height: 20.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Price',
            filled: true,
            fillColor: AppColors.primaryColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // Remove border color
            ),
          ),
          keyboardType: TextInputType.number,
          // Implement validation and save logic here
        ),
       
       
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _previousPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
              ),
              child: Text(
                'Back',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


}
