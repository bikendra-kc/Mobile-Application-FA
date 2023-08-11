import 'dart:io';
import 'dart:convert';

class AddProduct {
  String name;
  double price;
  double offerPrice;
  String description;
  String category;
  int stock;
  File? image; // Nullable File property for the image

  AddProduct({
    required this.name,
    required this.price,
    required this.offerPrice,
    required this.description,
    required this.category,
    required this.stock,
    this.image,
  });

  // Convert class properties to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'offerPrice': offerPrice,
      'description': description,
      'category': category,
      'stock': stock,
      // Convert image to base64 or send it as a file path if required by your API
      'images': image != null ? base64Encode(image!.readAsBytesSync()) : null,
    };
  }
}
