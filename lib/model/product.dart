import 'dart:convert';

class Product{
  final String name;
  final String description;
  final double quantity;
  final double price;
  final List<String> imageUrls;
  final String category;
  final String? id;
  //rating

  Product({
    required this.name, 
    required this.description, 
    required this.quantity, 
    required this.price, 
    required this.imageUrls, 
    required this.category, 
    this.id,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
  
}