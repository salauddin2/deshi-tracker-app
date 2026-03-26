class ProductOption {
  final String id;
  final String name;
  final List<String> choices;

  ProductOption({
    required this.id,
    required this.name,
    required this.choices,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      choices: List<String>.from(json['choices'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'choices': choices,
  };
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String thumbnail;
  final List<String> images;
  final double discountPercent;
  final double finalPrice;
  final String businessId;
  final String categoryId;
  final List<dynamic> options; // raw option groups from backend

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.thumbnail,
    required this.images,
    required this.discountPercent,
    required this.finalPrice,
    required this.businessId,
    this.categoryId = '',
    this.options = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'GBP',
      thumbnail: json['thumbnail'] ?? '',
      images: (json['images'] as List? ?? [])
          .map((e) => (e is Map ? e['url'] as String? : e as String?) ?? '')
          .toList(),
      discountPercent: (json['discount_percent'] ?? 0).toDouble(),
      finalPrice: (json['final_price'] ?? 0).toDouble(),
      businessId: json['business_id'] ?? '',
      categoryId: json['product_category_id']?.toString() ?? json['category_id']?.toString() ?? '',
      options: json['options'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'price': price,
        'currency': currency,
        'thumbnail': thumbnail,
        'images': images,
        'discount_percent': discountPercent,
        'final_price': finalPrice,
        'business_id': businessId,
        'product_category_id': categoryId,
        'options': options,
      };
}

