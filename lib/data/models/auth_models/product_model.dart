class ProductModel {
  final double price;
  final String unit;
  final Translations translations;
  final List<TechnicalData> technicalData;
  final String productCategoryId;

  ProductModel({
    required this.price,
    required this.unit,
    required this.translations,
    required this.technicalData,
    required this.productCategoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      price: json['price'],
      unit: json['unit'],
      translations: Translations.fromJson(json['translations']),
      technicalData: (json['technicalData'] as List)
          .map((e) => TechnicalData.fromJson(e))
          .toList(),
      productCategoryId: json['productCategoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'unit': unit,
      'translations': translations.toJson(),
      'technicalData': technicalData.map((e) => e.toJson()).toList(),
      'productCategoryId': productCategoryId,
    };
  }
}

class Translations {
  final Map<String, String> name;
  final Map<String, String> description;
  final Map<String, String> imageUrl;

  Translations({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Translations.fromJson(Map<String, dynamic> json) {
    return Translations(
      name: Map<String, String>.from(json['name']),
      description: Map<String, String>.from(json['description']),
      imageUrl: Map<String, String>.from(json['imageUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}

class TechnicalData {
  final Map<String, String> key;
  final Map<String, String> value;

  TechnicalData({
    required this.key,
    required this.value,
  });

  factory TechnicalData.fromJson(Map<String, dynamic> json) {
    return TechnicalData(
      key: Map<String, String>.from(json['key']),
      value: Map<String, String>.from(json['value']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}
