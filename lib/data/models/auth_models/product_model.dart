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
    try {
      return ProductModel(
        price: _parseDouble(json['price']),
        unit: _parseString(json['unit']),
        translations: json['translations'] != null 
            ? Translations.fromJson(json['translations']) 
            : Translations.empty(),
        technicalData: json['technicalData'] != null
            ? (json['technicalData'] as List)
                .where((e) => e != null)
                .map((e) => TechnicalData.fromJson(e))
                .toList()
            : [],
        productCategoryId: _parseString(json['productCategoryId']),
      );
    } catch (e) {
      print('Error parsing ProductModel: $e, JSON: $json');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
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
    try {
      return Translations(
        name: _parseStringMap(json['name']),
        description: _parseStringMap(json['description']),
        imageUrl: _parseStringMap(json['imageUrl']),
      );
    } catch (e) {
      print('Error parsing Translations: $e, JSON: $json');
      return Translations.empty();
    }
  }

  factory Translations.empty() {
    return Translations(
      name: {'uz': 'Gazobeton bloklari'},
      description: {'uz': 'Yuqori sifatli qurilish materiali'},
      imageUrl: {},
    );
  }

  static Map<String, String> _parseStringMap(dynamic value) {
    if (value == null) return <String, String>{};
    if (value is Map) {
      Map<String, String> result = {};
      value.forEach((key, val) {
        if (key != null && val != null) {
          result[key.toString()] = val.toString();
        }
      });
      return result;
    }
    return <String, String>{};
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
    try {
      return TechnicalData(
        key: Translations._parseStringMap(json['key']),
        value: Translations._parseStringMap(json['value']),
      );
    } catch (e) {
      print('Error parsing TechnicalData: $e, JSON: $json');
      return TechnicalData(
        key: {'uz': 'Xususiyat'},
        value: {'uz': 'Ma\'lumot yo\'q'},
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}