import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owner_app/constants/url.dart';
import 'package:owner_app/themes/colors.dart';

class Property {
  final String title;
  final String type;
  final int roomNumber;
  final int bedRoomNum;
  final String address;
  final List<String> files;
  final int price;

  Property({
    required this.title,
    required this.type,
    required this.roomNumber,
    required this.bedRoomNum,
    required this.address,
    required this.files,
    required this.price,
  });
}

class PropertyListScreen extends StatefulWidget {
  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  late List<Property> properties = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConstants.APIURL}/properties'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          properties = responseData
              .map((data) => Property(
                    title: data['title'],
                    type: data['type'],
                    roomNumber: data['roomNumber'],
                    bedRoomNum: data['bedRoomNum'],
                    address: data['address'],
                    files: List<String>.from(data['files']),
                    price: data['price'],
                  ))
              .toList();
        });
      } else {
        throw Exception('Failed to load properties: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error gracefully, e.g., show a snackbar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to load properties. Please check your internet connection and try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Listing'),
      ),
      body: properties.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return PropertyListItem(property: properties[index]);
              },
            ),
    );
  }
}
class PropertyListItem extends StatelessWidget {
  final Property property;

  const PropertyListItem({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Row(
                    children: [
                      Icon(Icons.apartment),
                      SizedBox(width: 4),
                      Text('${property.roomNumber}'),
                      Icon(Icons.king_bed),
                      SizedBox(width: 4),
                      Text('${property.bedRoomNum}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('${property.address}'),
                      SizedBox(width: 4),
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
