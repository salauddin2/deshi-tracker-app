
class ProductOption {
  final String? id;
  final String name;
  final String businessId;
  final List<OptionValue> values;
  final bool isRequired;
  final bool isMultiSelect;

  ProductOption({
    this.id,
    required this.name,
    required this.businessId,
    required this.values,
    this.isRequired = false,
    this.isMultiSelect = false,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['_id'],
      name: json['name'] ?? '',
      businessId: json['businessId'] ?? '',
      values: (json['values'] as List?)
              ?.map((v) => OptionValue.fromJson(v))
              .toList() ??
          [],
      isRequired: json['isRequired'] ?? false,
      isMultiSelect: json['isMultiSelect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'businessId': businessId,
      'values': values.map((e) => e.toJson()).toList(),
      'isRequired': isRequired,
      'isMultiSelect': isMultiSelect,
    };
  }
}

class OptionValue {
  final String name;
  final double priceModifier;

  OptionValue({
    required this.name,
    required this.priceModifier,
  });

  factory OptionValue.fromJson(Map<String, dynamic> json) {
    return OptionValue(
      name: json['name'] ?? '',
      priceModifier: (json['priceModifier'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'priceModifier': priceModifier,
    };
  }
}
