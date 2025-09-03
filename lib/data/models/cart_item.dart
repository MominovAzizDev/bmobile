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
      productName: json['productName']?.toString() ?? 'Noma\'lum mahsulot',
      productDetail: json['productDetail']?.toString() ?? '',
      kvPrice: json['kvPrice']?.toString() ?? '0',
      price: _parsePrice(json['price']),
      quantity: _parseQuantity(json['quantity']),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseQuantity(dynamic quantity) {
    if (quantity == null) return 1;
    if (quantity is int) {
      return quantity > 0 ? quantity : 1;
    }
    if (quantity is String) {
      final parsed = int.tryParse(quantity);
      return (parsed != null && parsed > 0) ? parsed : 1;
    }
    if (quantity is double) {
      final parsed = quantity.toInt();
      return (parsed > 0) ? parsed : 1;
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
    return other is CartItem &&
        other.productId == productId &&
        other.productName == productName &&
        other.productDetail == productDetail &&
        other.kvPrice == kvPrice &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return productId.hashCode ^ productName.hashCode ^ productDetail.hashCode ^ kvPrice.hashCode ^ price.hashCode ^ quantity.hashCode;
  }
}
