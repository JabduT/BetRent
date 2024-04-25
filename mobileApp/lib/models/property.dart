
import 'package:flutter/material.dart';

class Property {
  final String id;
  final String title;
  final String type;
  final int roomNumber;
  final int bedRoomNum;
  final int propertySize;
  final String address;
  final List<String> files;
  final int price;
  final bool favorite;
  final String description;

  Property(
      {required this.id,
      required this.title,
      required this.type,
      required this.roomNumber,
      required this.description,
      required this.bedRoomNum,
      required this.propertySize,
      required this.address,
      required this.files,
      required this.price,
      required this.favorite});
}
