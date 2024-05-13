import 'package:flutter/cupertino.dart';

class Shoes extends ChangeNotifier{
  final String id;
  final String name;
  final String brand;
  final String description;
  final String imageUrl;
  final bool isFavorite;
  final int price;
  final int quantity;
  final List<String> sizes;
  final List<String> thumbNails;

  Shoes({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.imageUrl,
    required this.isFavorite,
    required this.price,
    required this.quantity,
    required this.sizes,
    required this.thumbNails
});
}