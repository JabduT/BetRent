import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:owner_app/constants/url.dart';
import 'package:flutter/material.dart';
import 'package:owner_app/themes/colors.dart';
import 'package:owner_app/widgets/bottom_bar_owner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' show MediaType;

class AddHouseRentScreen extends StatefulWidget {
  @override
  _AddHouseRentScreenState createState() => _AddHouseRentScreenState();
}

class _AddHouseRentScreenState extends State<AddHouseRentScreen> {
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
  List<File> _imageFiles = []; // List to hold selected image files
  late String _selectedType; // Declare _selectedType
  late PageController _pageController;
  late TextEditingController _propertySizeController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _roomController;
  late TextEditingController _exactLocationController;
  String _price = '';
  String _selectedPriceType = 'Per Day'; // Default selection
  String _propertySize = ''; // Variable to hold property size
  int _currentPage = 0;
  String userId = '';
  // Method to pick an image using image_picker
// Method to pick an image using image_picker
Future<void> _pickImage() async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    setState(() {
      _imageFiles.add(File(pickedImage.path)); // Create a File object from the picked image path
    });
  }
}

// Method to submit the form data including image file
Future<void> _submitHouse() async {
  // Validate input data
  if (_titleController.text.isEmpty ||
      _descriptionController.text.isEmpty ||
      _roomController.text.isEmpty ||
      _exactLocationController.text.isEmpty ||
      _price.isEmpty ||
      _propertySize.isEmpty ||
      _imageFiles.isEmpty) {
    print('Please fill in all required fields');
    return;
  }

  // Create a multipart request to send form data and image file
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${AppConstants.APIURL}/houses'),
  );

  // Add form fields to the request
  request.fields['title'] = _titleController.text;
  request.fields['userId'] = userId;
  request.fields['type'] = _selectedType;
  request.fields['description'] = _descriptionController.text;
  request.fields['price'] = _price;
  request.fields['priceType'] = _selectedPriceType;
  request.fields['numOfRooms'] = _roomController.text;
  request.fields['exactLocation'] = _exactLocationController.text;
  request.fields['propertySize'] = _propertySize;

  // Add image file(s) to the request
  // Add image file(s) to the request
  for (int i = 0; i < _imageFiles.length; i++) {
    var file = _imageFiles[i];
    request.files.add(
      http.MultipartFile.fromBytes(
        'image$i', // Form field name expected by the server
        await file.readAsBytes(),
        filename: 'image$i.jpg',
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      ),
    );
  }

  // Send the multipart request and handle the response
  var response = await request.send();
  if (response.statusCode == 200) {
    // Handle successful submission
    print('House submitted successfully');
  } else {
    // Handle error
    print('Error submitting house: ${response.reasonPhrase}');
  }
}


  @override
  void initState() {
    super.initState();
    getUserId();
    _pageController = PageController(initialPage: _currentPage);
    _selectedType = propertyTypes[0]; // Initialize _selectedType here
    _propertySizeController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _roomController = TextEditingController();
    _exactLocationController = TextEditingController();
  }

  Future<void> getUserId() async {
    final storage = FlutterSecureStorage();
    final String? userData = await storage.read(key: 'user');

    if (userData != null) {
      final user = jsonDecode(userData);
      userId = user['_id'];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _propertySizeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _roomController.dispose();

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
          padding:
              const EdgeInsets.only(top: 90.0), // Adjust top padding as needed
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
            controller: _titleController, // Add the controller here
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
            controller: _descriptionController,
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
                  backgroundColor:
                      AppColors.primaryColor, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Add border radius
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                ),
                child: Text(
                  'Next',
                  style:
                      TextStyle(color: Colors.white), // Set text color to white
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
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price(birr)',
                    filled: true,
                    fillColor: AppColors.primaryColor.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _price = value;
                  },
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPriceType,
                  onChanged: (value) {
                    setState(() {
                      _selectedPriceType = value!;
                    });
                  },
                  items: ['Per Day', 'Per Month', 'Per Year'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryColor.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _roomController,
            decoration: InputDecoration(
              labelText: 'Number of rooms',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
            // Implement validation and save logic here
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _exactLocationController,
            decoration: InputDecoration(
              labelText: 'Exact Location',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: 4,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
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
              labelText: 'house Size (sqft)',
              filled: true,
              fillColor: AppColors.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none, // Remove border color
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _propertySize =
                    value; // Update property size when the user types
              });
            },
            // Implement validation and save logic here
          ),
          SizedBox(height: 40.0),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Change button color if needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0), // Add border radius
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 40.0, horizontal: 90.0), // Adjust padding as needed
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload_outlined), // Add upload icon
                SizedBox(width: 15.0), // Add spacing between icon and text
                Text(
                  'Upload Image',
                  style:
                      TextStyle(fontSize: 16.0), // Adjust font size as needed
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0), // Add vertical spacing
          _imageFiles.isEmpty
              ? Container()
              : SizedBox(
                  height: 150.0, // Increase height for larger image preview
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageFiles.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Image.file(
                          _imageFiles[index],
                          width:
                              150.0, // Increase width for larger image preview
                          height:
                              150.0, // Increase height for larger image preview
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed:
                    _submitHouse, // Call _submitHouse method when the button is pressed
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
