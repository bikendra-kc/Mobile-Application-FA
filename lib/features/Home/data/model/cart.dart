class Cart {
  String? productName;
  int? productPrice;
  int? producQuantity;

  Cart({
    this.productName,
    this.productPrice,
    this.producQuantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productName: json['productName'],
      productPrice: json['productPrice'],
      producQuantity: json['producQuantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'producQuantity': producQuantity,
    };
  }
}
