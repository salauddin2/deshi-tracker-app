import 'package:freezed_annotation/freezed_annotation.dart';


part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class ProductOption with _$ProductOption {
  const factory ProductOption({
    required String id,
    @Default('') String name,
    @Default([]) List<String> choices,
  }) = _ProductOption;

  factory ProductOption.fromJson(Map<String, dynamic> json) => _$ProductOptionFromJson(json);
}


@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: '_id', fromJson: _idFromObject) required String id,
    @Default('') String name,
    @Default('') String description,
    @JsonKey(fromJson: _toDouble) @Default(0.0) double price,
    @Default('GBP') String currency,
    @Default('') String thumbnail,
    @Default([]) List<String> images,
    @JsonKey(fromJson: _toDouble) @Default(0.0) double discountPercent,
    DateTime? discountStart,
    DateTime? discountEnd,
    @JsonKey(fromJson: _toDouble) @Default(0.0) double finalPrice,
    @JsonKey(name: 'business_id', fromJson: _idFromObject) @Default('') String businessId,
    @JsonKey(name: 'product_category_id', fromJson: _idFromObject) @Default('') String categoryId,
    @JsonKey(fromJson: _idsFromList) @Default([]) List<String> options,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

double _toDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

String _idFromObject(dynamic val) {
  if (val is Map) return val['_id']?.toString() ?? val['id']?.toString() ?? '';
  return val?.toString() ?? '';
}

List<String> _idsFromList(dynamic val) {
  if (val is List) {
    return val.map<String>((e) {
      if (e is Map) return e['_id']?.toString() ?? e['id']?.toString() ?? '';
      return e.toString();
    }).toList();
  }
  return [];
}
