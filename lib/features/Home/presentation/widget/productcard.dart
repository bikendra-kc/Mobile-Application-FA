import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String productImagePath;
  final String productName;
  final String productPrice;
  final Function() onPressed;

  const ProductCard({
    required this.productImagePath,
    required this.productName,
    required this.onPressed,
    required this.productPrice,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          widget.onPressed();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  isTapped ? Colors.transparent : Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: isTapped
              ? Border.all(
                  color: Colors.red, // Change border color to red when tapped
                  width: 2,
                )
              : null,
          color: isTapped
              ? Colors.red.withOpacity(0.2)
              : Colors.white, // Red background when tapped
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.productImagePath,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.productName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              "NPR ${widget.productPrice}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Change text color to red
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Change button color to red
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(
                  color: Colors.white, // Change button text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
