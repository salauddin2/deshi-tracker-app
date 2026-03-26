class Category {
  final String id;
  final String name;
  final String icon;
  final String slug;
  final String details;
  final List<String> subCategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.slug,
    required this.details,
    required this.subCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var subCatsJson = json['subCategories'] ?? [];
    List<String> subCats = [];
    if (subCatsJson is List) {
      for (var item in subCatsJson) {
        if (item is String) {
          subCats.add(item);
        } else if (item is Map && item.containsKey('name')) {
          subCats.add(item['name']);
        }
      }
    }

    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      slug: json['slug'] ?? '',
      details: json['details'] ?? '',
      subCategories: subCats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icon': icon,
      'slug': slug,
      'details': details,
      'subCategories': subCategories,
    };
  }
}
