import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_library_managent/core/failure/failure.dart';
import 'package:flutter_library_managent/core/shared_prefs/user_shared_prefs.dart';
import 'package:flutter_library_managent/features/Home/data/model/cart.dart';
import 'package:flutter_library_managent/features/Home/data/model/commnet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_library_managent/features/Home/data/repository/productRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/review_model.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  final String description;
  final String productId;

  final List<ReviewModel>? comments;

  const ProductDetailsScreen({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.productId,
    required this.price,
    required this.description,
    this.comments,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  UserSharedPrefs? userSharedPrefs;
  double rating = 0.0; // Rating value
  late List<ReviewModel> comment; // List of comments

  @override
  void initState() {
    super.initState();
    comment = widget.comments!;
  }

  // add to cart
  void _addToCart() async {
    ref
        .read(productRemoteRepositoryProvider)
        .addToCart(
          Cart(
              productPrice: widget.price.toInt(),
              productName: widget.name,
              producQuantity: 1),
        )
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Flowers added to cart'),
                  duration: Duration(seconds: 1),
                ),
              )
            });

    // bookRepository.onError((error, stackTrace) => print(error);
    // Perform the necessary logic to add the product to the cart using bookRepository
  }

  // Function to handle submitting comments and ratings
  void _submitCommentAndRating(String comment, double rating) {
    final commnetprovider = ref.read(productRemoteRepositoryProvider);
    final newComment = CommentModel(
      comment: comment.toString(),
      productId: widget.productId,
      rating: rating.toInt(),
    );

    final result = commnetprovider.creatComment(newComment);
  }

  Future<Either<AppException, bool>> createComment(CommentModel comment) {
    var comm = ref.read(productRemoteRepositoryProvider).creatComment(comment);

    return comm;
  }

  // Function to show the comment and rating dialog
  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String comment = '';
        return AlertDialog(
          title: Text('Add Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  comment = value;
                },
              ),
              SizedBox(height: 16),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  widget.comments!.add(
                    ReviewModel(
                      comment: comment,
                      rating: rating.toInt(),
                    ),
                  );
                });
                final result = await createComment(
                  CommentModel(
                    comment: comment,
                    productId: widget.productId,
                    rating: rating.toInt(),
                  ),
                );

                result.fold(
                  (exception) {
                    // Handle comment failure
                    print('Comment failed: ${exception.error}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(exception.error),
                      ),
                    );
                  },
                  (isCommentAdded) {
                    // Handle comment success
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Comment added"),
                      ),
                    );
                  },
                );

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guitar Details'),
        backgroundColor: Color.fromARGB(255, 118, 17, 7),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(
                    10.0), // Apply border radius to the image
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: \$${widget.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 220, 117, 7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _addToCart();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  primary: Color.fromRGBO(88, 7, 2, 1),
                ),
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showCommentDialog,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 50, 1, 174),
                    ),
                    icon: Icon(Icons.edit),
                    label: Text('Add Comment'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'User Comments:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      final comment = widget.comments![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              // Add your user icon/image here
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.comment.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  RatingBar.builder(
                                    initialRating:
                                        double.parse(comment.rating.toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (value) {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
