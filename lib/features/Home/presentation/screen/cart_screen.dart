import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_managent/features/Home/presentation/screen/paymet.dart';
import 'package:flutter_library_managent/features/profile/presentation/order_details_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../../../../core/failure/failure.dart';
import '../../../profile/presentation/my_orders_screen.dart';
import '../../data/model/cart_response.dart';
import '../../data/model/orderModel.dart';
import '../../data/repository/productRepository.dart';

class CartScreen extends ConsumerWidget {
  OrderOptionsDialog? orderOptionsDialog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProvider = ref.watch(productRemoteRepositoryProvider);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double totalAmount = 0.0;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Your Guitar cart'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 36, 2, 2),
      ),
      body: FutureBuilder<Either<AppException, CartResponse>>(
        future: cartProvider.getUserCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CupertinoActivityIndicator(
              animating: true,
              color: Colors.red,
              radius: 20,
            ));
          } else if (snapshot.hasError) {
            final appException = snapshot.error as AppException?;
            final errorMessage = appException?.error ?? 'Unknown error';
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 100,
                    color: Colors.grey,
                  ),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final cartItems = snapshot.data!;
            if (cartItems.isLeft()) {
              // Error response
              final appException = cartItems.fold(
                (failure) => failure,
                (_) => null,
              );

              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'No Cart item found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
              ;
            } else {
              // Successful response
              final response = cartItems.fold(
                (_) => null,
                (success) => success as CartResponse?,
              );
              if (response == null || response.cartItems!.isEmpty) {
                return const ListTile(
                  title: Text('No cart items found'),
                );
              } else {
                // Calculate total amount
                response.cartItems!.forEach((item) {
                  totalAmount += item.productPrice! * item.producQuantity!;
                });

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: response.cartItems!.length,
                        itemBuilder: (context, index) {
                          final item = response.cartItems![index];
                          return CartItem(
                            name: item.productName.toString(),
                            price: int.parse(item.productPrice.toString()),
                            quantity: int.parse(item.producQuantity.toString()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => OrderOptionsDialog(
                                  onOptionSelected: (paymentType) async {
                                    if (paymentType == "Khalti") {
                                      KhaltiScope.of(context).pay(
                                        config: PaymentConfig(
                                          amount: totalAmount.toInt() *
                                              10, //in paisa
                                          productIdentity: 'Product Id',
                                          productName: 'Product Name',
                                          mobileReadOnly: false,
                                        ),
                                        preferences: [
                                          PaymentPreference.khalti,
                                        ],
                                        onSuccess: (PaymentSuccessModel
                                            success) async {
                                          final orderCreated = await ref
                                              .read(
                                                  productRemoteRepositoryProvider)
                                              .createOrder(
                                                OrderModel(
                                                  totalAmount: totalAmount,
                                                  cartItems: response.cartItems,
                                                  paymentType: paymentType,
                                                ),
                                              );
                                          orderCreated.fold(
                                            (left) {
                                              // Order creation failed
                                              final appException =
                                                  left as AppException?;
                                              final errorMessage =
                                                  appException?.error ??
                                                      'Failed to create order';
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content:
                                                        Text(errorMessage)),
                                              );
                                            },
                                            (right) {
                                              // Order creation successful
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Order placed successfully')),
                                              );
                                              return Navigator.pushNamed(
                                                  context, "/orderScreen");
                                              // Navigate to the order details screen or perform any other action
                                            },
                                          );
                                        },
                                        onFailure:
                                            (PaymentFailureModel failure) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text(failure.toString())),
                                          );
                                        },
                                      );
                                    } else if (paymentType ==
                                        "cash_on_delivery") {
                                      final orderCreated = await ref
                                          .read(productRemoteRepositoryProvider)
                                          .createOrder(
                                            OrderModel(
                                              totalAmount: totalAmount,
                                              cartItems: response.cartItems!,
                                              paymentType: paymentType,
                                            ),
                                          );
                                      orderCreated.fold((left) {
                                        // Order creation failed
                                        final appException =
                                            left as AppException?;
                                        final errorMessage =
                                            appException?.error ??
                                                'Failed to create order';
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(errorMessage)),
                                        );
                                      }, (right) {
                                        // Order creation successful

                                        return Navigator.pushNamed(
                                            context, "/orderScreen");

                                        // Navigate to the order details screen or perform any other action
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                            child: Text('Place Order'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;
  final int price;
  final int quantity;

  const CartItem({
    Key? key,
    required this.name,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Price: \$${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Quantity: $quantity',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      // Add your logic here for decreasing the quantity
                    },
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      // Add your logic here for increasing the quantity
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Add your logic here for deleting the cart item
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderOptionsDialog extends StatelessWidget {
  final Function(String) onOptionSelected;

  const OrderOptionsDialog({Key? key, required this.onOptionSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Cash on Delivery'),
            onTap: () => onOptionSelected('cash_on_delivery'),
          ),
          ListTile(
            title: Text('Online Payment'),
            onTap: () => onOptionSelected('Khalti'),
          ),
        ],
      ),
    );
  }
}
