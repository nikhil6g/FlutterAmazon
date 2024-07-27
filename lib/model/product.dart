import 'dart:convert';

import 'package:amazon_clone/model/rating.dart';

class Product {
  final String name;
  final String description;
  final double quantity;
  final double price;
  final List<String> imageUrls;
  final String category;
  final String? id;
  //rating
  final List<Rating>? ratings;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.imageUrls,
    required this.category,
    this.id,
    this.ratings
  });
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "quantity": quantity,
      "imageUrls": imageUrls,
      "category": category,
      "price": price,
      "id": id,
      "ratings": ratings
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        quantity: map['quantity']?.toDouble() ?? 0.0,
        imageUrls: List<String>.from(map['imageUrls']),
        category: map['category'] ?? '',
        price: map['price']?.toDouble() ?? 0.0,
        id: map['_id'],
        ratings: map['ratings'] != null
            ? List<Rating>.from(
                map['ratings']?.map(
                  (x) => Rating.fromMap(x),
                ),
              )
            : 
            null
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
