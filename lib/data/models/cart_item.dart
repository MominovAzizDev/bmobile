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
      productId: json['productId']?.toString() ?? json['id']?.toString() ?? '',
      productName: json['productName']?.toString() ?? json['name']?.toString() ?? '',
      productDetail: json['productDetail']?.toString() ?? json['detail']?.toString() ?? json['description']?.toString() ?? '',
      kvPrice: json['kvPrice']?.toString() ?? json['unitPrice']?.toString() ?? '',
      price: _parsePrice(json['price'] ?? json['totalPrice'] ?? 0),
      quantity: _parseInt(json['quantity'] ?? 1),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 1;
    }
    return 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDetail': productDetail,
      'kvPrice': kvPrice,
      'price': price,
      'quantity': quantity,
    };
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}