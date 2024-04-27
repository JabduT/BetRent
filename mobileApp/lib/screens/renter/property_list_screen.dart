import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owner_app/constants/url.dart';
import 'package:owner_app/models/property.dart';
import 'package:owner_app/screens/common/property_detail.dart';
import 'package:owner_app/themes/colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _PropertyListScreenState extends State<PropertyListScreen> {
  late List<Property> properties = [];
  late TextEditingController _searchController;
  String selectedType = '';
  bool isLoading = false;
  String errorMessage = '';
  String userId = '';
  bool isSearching = false;

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
    getUserId();
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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse(
          '${AppConstants.APIURL}/properties${_buildQueryParams()}',
        ),
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Include token in the header
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          properties = responseData
              .map((data) => Property(
                  id: data['_id'],
                  owner_Id: data['userId'],
                  description: data['description'],
                  title: data['title'],
                  type: data['type'],
                  roomNumber: data['roomNumber'],
                  bedRoomNum: data['bedRoomNum'],
                  propertySize: data['propertySize'],
                  address: data['address'],
                  files: List<String>.from(data['files']),
                  price: data['price'],
                  favorite: data['favorite']))
              .toList();
          errorMessage =
              ''; // Clear error message if data is loaded successfully
        });
      } else {
        throw Exception('Failed to load properties: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        properties = [];
        errorMessage =
            'Failed to load properties. Please check your internet connection and try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addFavorite(String propertyId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.APIURL}/favorites'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'propertyId': propertyId,
        }),
      );
      if (response.statusCode == 201) {
        // Favorite added successfully
        print('Favorite added for property: $propertyId');
      } else {
        throw Exception('Failed to add favorite: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding favorite: $e');
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
      queryParams = '?q=${_searchController.text}';
    }
    if (selectedType.isNotEmpty) {
      queryParams +=
          '${_searchController.text.isEmpty ? '?' : '&'}type=$selectedType';
    }
    return queryParams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 26, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Add the app logo
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/logo.png",
                            height: isSearching ? 24 : 56,
                          ),
                          if (!isSearching)
                            Text(
                              "Hello, Welcome!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/profile.jpg"),
                          radius: isSearching ? 20 : 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pinned: true,
            floating: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          fillColor: AppColors.primaryColor.withOpacity(0.2),
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            isSearching = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: search,
                    ),
                  ],
                ),
              ),
            ),
            title: null,
            actions: [
              if (isSearching)
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      isSearching = false;
                    });
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
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
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PropertyListItem(
                  property: properties[index],
                  onFavoriteTap: () {
                    addFavorite(properties[index].id);
                  },
                );
              },
              childCount: properties.length,
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyListItem extends StatefulWidget {
  final Property property;
  final VoidCallback? onFavoriteTap;

  const PropertyListItem({Key? key, required this.property, this.onFavoriteTap})
      : super(key: key);

  @override
  _PropertyListItemState createState() => _PropertyListItemState();
}

class _PropertyListItemState extends State<PropertyListItem> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.property.favorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PropertyDetailScreen(property: widget.property),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.5),
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
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.property.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('${widget.property.address}'),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.apartment),
                        Text('${widget.property.roomNumber}'),
                        SizedBox(width: 6),
                        Icon(Icons.king_bed),
                        Text('${widget.property.bedRoomNum}'),
                      ],
                    ),
                    SizedBox(width: 4),
                    Row(
                      children: [
                        Icon(Icons.fullscreen),
                        Text('${widget.property.propertySize}'),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: AppColors.primaryColor),
                              ),
                            ),
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.2)),
                            elevation: MaterialStateProperty.all<double>(3.0),
                          ),
                          child: Text('${widget.property.price} BIRR'),
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                            if (widget.onFavoriteTap != null) {
                              widget.onFavoriteTap!();
                            }
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Image.network(
                '${AppConstants.BASEURL}/${widget.property.files[0]}',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyListScreen extends StatefulWidget {
  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}
