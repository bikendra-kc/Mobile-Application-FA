import 'dart:convert';

class CommentModel {
  final int rating;
  final String comment;
  final String productId;

  CommentModel({
    required this.rating,
    required this.comment,
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'productId': productId,
    };
  }

  String toEncodedJson() => json.encode(toJson());
}
