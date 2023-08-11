import 'package:dartz/dartz.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/failure/failure.dart';

import '../datasource/remote_data_source.dart';
import '../model/cart.dart';
import '../model/cart_response.dart';
import '../model/commnet_model.dart';
import '../model/orderModel.dart';
import '../response/productResponse.dart';

final productRemoteRepositoryProvider = Provider<BookRemoteRepository>((ref) {
  return BookRemoteRepository(
    ref.read(productRemoteDataSourceProvider),
  );
});

class BookRemoteRepository {
  final HomeRemoteDataSource _bookRemoteDataSource;

  BookRemoteRepository(this._bookRemoteDataSource);

  Future<Either<AppException, ProductResponse>> getBooks(String searchQuery) {
    return _bookRemoteDataSource.getBooks(searchQuery);
  }

  Future<Either<AppException, CartResponse>> getUserCart() {
    return _bookRemoteDataSource.getCartForUser();
  }

  Future<Either<AppException, bool>> addToCart(Cart cart) {
    return _bookRemoteDataSource.addToCart(cart);
  }

  Future<Either<AppException, bool>> createOrder(OrderModel order) {
    return _bookRemoteDataSource.createOrder(order);
  }

   Future<Either<AppException, bool>> creatComment(CommentModel comment) {
    return _bookRemoteDataSource.addComment(comment);
  }
}
