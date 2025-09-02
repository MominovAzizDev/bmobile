class CartItem {
  final String productId;
  final String productName;
  final String productDetail;
  final String kvPrice;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productDetail,
    required this.kvPrice,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      productDetail: json['productDetail']?.toString() ?? '',
      kvPrice: json['kvPrice']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productDetail,
    String? kvPrice,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDetail: productDetail ?? this.productDetail,
      kvPrice: kvPrice ?? this.kvPrice,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}