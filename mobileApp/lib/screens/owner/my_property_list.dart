import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:owner_app/constants/url.dart';
import 'package:owner_app/themes/colors.dart';

class Property {
  final String title;
  final String type;
  final int roomNumber;
  final int bedRoomNum;
  final int propertySize;
  final String address;
  final List<String> files;
  final int price;

  Property({
    required this.title,
    required this.type,
    required this.roomNumber,
    required this.bedRoomNum,
    required this.propertySize,
    required this.address,
    required this.files,
    required this.price,
  });
}

class _OwnerPropertyListScreenState extends State<OwnerPropertyListScreen> {
  late List<Property> properties = [];
  late TextEditingController _searchController;
  String selectedType = '';
  bool isLoading = false;
  String errorMessage = '';

  // Define the list of filter options
  final List<String> filterOptions = [
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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final storage = FlutterSecureStorage();
      final String? userData = await storage.read(key: 'user');
      if (userData != null) {
        final user = jsonDecode(userData);
        final response = await http.get(Uri.parse(
            '${AppConstants.APIURL}/properties?userId=${user['_id']}${_buildQueryParams()}'));

        if (response.statusCode == 200) {
          final List<dynamic> responseData = jsonDecode(response.body);
          setState(() {
            properties = responseData
                .map((data) => Property(
                      title: data['title'],
                      type: data['type'],
                      roomNumber: data['roomNumber'],
                      bedRoomNum: data['bedRoomNum'],
                      propertySize: data['propertySize'],
                      address: data['address'],
                      files: List<String>.from(data['files']),
                      price: data['price'],
                    ))
                .toList();
            errorMessage = '';
          });
        } else {
          throw Exception('Failed to load properties: ${response.statusCode}');
        }
      } else {
        throw Exception('User data not found.');
      }
    } catch (e) {
      setState(() {
        properties = [];
        errorMessage = 'no data found';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void search() {
    setState(() {
      fetchData();
    });
  }

  String _buildQueryParams() {
    String queryParams = '';
    if (_searchController.text.isNotEmpty) {
      queryParams = '&q=${_searchController.text}';
    }
    if (selectedType.isNotEmpty) {
      queryParams += '&type=$selectedType';
    }
    return queryParams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => search(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: search,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filterOptions
                        .map((filter) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                label: Text(filter),
                                selected: selectedType == filter,
                                onSelected: (isSelected) {
                                  setState(() {
                                    selectedType = isSelected ? filter : '';
                                  });
                                  fetchData();
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage),
                )
              : properties.isEmpty
                  ? Center(
                      child: Text('No data found.'),
                    )
                  : ListView.builder(
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        return PropertyListItem(property: properties[index]);
                      },
                    ),
    );
  }
}

class OwnerPropertyListScreen extends StatefulWidget {
  @override
  _OwnerPropertyListScreenState createState() =>
      _OwnerPropertyListScreenState();
}

class PropertyListItem extends StatelessWidget {
  final Property property;

  const PropertyListItem({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white, // Set the background color to white
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text('${property.address}'),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.apartment),
                      Text('${property.roomNumber}'),
                      SizedBox(width: 6),
                      Icon(Icons.king_bed),
                      Text('${property.bedRoomNum}'),
                    ],
                  ),
                  SizedBox(width: 4),
                  Row(
                    children: [
                      Icon(Icons.fullscreen),
                      Text('${property.propertySize}'),
                      SizedBox(width: 4),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {}, // Add your action here
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: AppColors.primaryColor),
                            ),
                          ),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.black.withOpacity(0.2)),
                          elevation: MaterialStateProperty.all<double>(3.0),
                        ),
                        child: Text('${property.price} BIRR'),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.favorite_outline),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Image.network(
              'http://localhost/api/${property.files.first}', // Assuming the API serves images from the same base URL
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
