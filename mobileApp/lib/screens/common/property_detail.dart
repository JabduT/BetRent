import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:owner_app/constants/url.dart';
import 'package:owner_app/models/property.dart';
import 'package:owner_app/screens/common/ContactDetail.dart';
import 'package:owner_app/themes/colors.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({Key? key, required this.property})
      : super(key: key);

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.2;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                height: containerHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.primaryColor.withOpacity(0.3)),
                child: CarouselSlider(
                  items: widget.property.files.map((image) {
                    return Image.network(
                      '${AppConstants.BASEURL}/${image}',
                   
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${_currentPage + 1} of ${widget.property.files.length}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.property.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(widget.property.description),
              Text('Total Number of Rooms: ${widget.property.roomNumber}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Number of Bedrooms: ${widget.property.roomNumber}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Total Area: ${widget.property.propertySize} meter square',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Address: ${widget.property.address}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Type: ${widget.property.type}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Price:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Type: ${widget.property.price} ETB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.symmetric(vertical: 16),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContactDetail(userId: widget.property.owner_Id),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.primaryColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'Contact Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
