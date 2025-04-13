import 'dart:convert';

import 'package:amazon_clone/model/rating.dart';

class Product {
  final String name;
  final String description;
  final String brand;
  final double quantity;
  final double price;
  final List<String> imageUrls;
  final String category;
  final String? id;
  final String tags;
  final double? soldCount;
  //rating
  final double? avgRating;
  final List<Rating>? ratings;
  Product({
    required this.name,
    required this.description,
    required this.brand,
    required this.quantity,
    required this.price,
    required this.imageUrls,
    required this.category,
    this.id,
    required this.tags,
    this.soldCount,
    this.avgRating,
    this.ratings,
  });
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "brand": brand,
      "quantity": quantity,
      "imageUrls": imageUrls,
      "category": category,
      "price": price,
      "id": id,
      "tags": tags,
      "avgRating": avgRating,
      "ratings": ratings
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      brand: map['brand'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(map['imageUrls']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      id: map['_id'],
      tags: map['tags'] ?? '',
      soldCount: map['soldCount']?.toDouble() ?? 0.0,
      avgRating: map['avgRating']?.toDouble() ?? 0.0,
      ratings: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
