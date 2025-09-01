class HomeCategoryModel {
  final String productCategoryId;
  final String? parentProductCategoryId;
  final HomeCategoryTranslations translations;

  HomeCategoryModel({
    required this.productCategoryId,
    required this.parentProductCategoryId,
    required this.translations,
  });

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      productCategoryId: json['productcategoryid'] ?? '',
      parentProductCategoryId: json['parentproductcategoryid'],
      translations: HomeCategoryTranslations.fromJson(json['translations'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'productcategoryid': productCategoryId,
    'parentproductcategoryid': parentProductCategoryId,
    'translations': translations.toJson(),
  };
}

class HomeCategoryTranslations {
  final LocalizedField name;
  final LocalizedField description;
  final LocalizedField imageUrl;

  HomeCategoryTranslations({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory HomeCategoryTranslations.fromJson(Map<String, dynamic> json) {
    return HomeCategoryTranslations(
      name: LocalizedField.fromJson(json['name'] ?? {}),
      description: LocalizedField.fromJson(json['description'] ?? {}),
      imageUrl: LocalizedField.fromJson(json['imageurl'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name.toJson(),
    'description': description.toJson(),
    'imageurl': imageUrl.toJson(),
  };
}

class LocalizedField {
  final String uz_UZ;
  final String ru_RU;
  final String en_US;

  LocalizedField({
    required this.uz_UZ,
    required this.ru_RU,
    required this.en_US,
  });

  factory LocalizedField.fromJson(Map<String, dynamic> json) {
    return LocalizedField(
      uz_UZ: json['uz_uz'] ?? '',
      ru_RU: json['ru_ru'] ?? '',
      en_US: json['en_us'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'uz_uz': uz_UZ,
    'ru_ru': ru_RU,
    'en_us': en_US,
  };
}

class Pagination {
  final int skip;
  final int take;
  final int count;

  Pagination({
    required this.skip,
    required this.take,
    required this.count,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      skip: json['skip'] ?? 0,
      take: json['take'] ?? 0,
      count: json['count'] ?? 0,
    );
  }
}

class HomeResponse {
  final List<HomeCategoryModel> list;
  final Pagination pagination;

  HomeResponse({
    required this.list,
    required this.pagination,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      list: (json['list'] as List<dynamic>? ?? [])
          .map((e) => HomeCategoryModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
