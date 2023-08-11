import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_managent/core/failure/failure.dart';
import 'package:flutter_library_managent/features/Home/data/model/products.dart';
import 'package:flutter_library_managent/features/Home/data/repository/productRepository.dart';
import 'package:flutter_library_managent/features/Home/data/response/productResponse.dart';
import 'package:flutter_library_managent/features/Home/presentation/widget/productcard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'productdetails.dart';

class HomeScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 14, 11, 11),
        centerTitle: true,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 190,
            width: double.infinity,
            child: Image.asset(
              'assets/images/guitar.jpg', // Replace with your guitar banner image path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                filled: true,
              ),
              onChanged: (value) {
                ref.refresh(productRemoteRepositoryProvider);
              },
            ),
          ),
          Expanded(
            child: _buildBookList(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(BuildContext context, WidgetRef ref) {
    final String searchValue = _searchController.text.trim();
    final Future<Either<AppException, ProductResponse>> books =
        searchValue.isNotEmpty
            ? ref.watch(productRemoteRepositoryProvider).getBooks(searchValue)
            : ref.watch(productRemoteRepositoryProvider).getBooks('');

    return FutureBuilder<Either<AppException, ProductResponse>>(
      future: books,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CupertinoActivityIndicator(
            color: Colors.red,
            radius: 20,
          ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<Product> categoryBooks = snapshot.data!.fold(
            (l) => [],
            (r) => r.products ?? [],
          );

          return GridView.builder(
            shrinkWrap: true,
            primary: true,
            itemCount: categoryBooks.length,
            padding: const EdgeInsets.all(8), // Add padding around the grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing:
                  12, // Add spacing between the cards horizontally
              mainAxisSpacing: 12, // Add spacing between the cards vertically
              childAspectRatio: 0.590,
            ),
            itemBuilder: (context, index) {
              final product = categoryBooks[index];
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: ProductCard(
                  productName: product.name ?? '',
                  productPrice: product.price?.toString() ?? '',
                  productImagePath: product.images?.isNotEmpty == true
                      ? product.images![0].url ?? ''
                      : '',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          imageUrl: product.images?.isNotEmpty == true
                              ? product.images![0].url ?? ''
                              : '',
                          name: product.name ?? '',
                          price: product.price?.toDouble() ?? 0.0,
                          comments: product.reviews ?? [],
                          description: product.description ?? '',
                          productId: product.id ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else {
          return const Text('No Guitar  found.');
        }
      },
    );
  }
}
