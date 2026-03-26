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
    required String id,
    @Default('') String name,
    @Default('') String description,
    @Default(0.0) double price,
    @Default('GBP') String currency,
    @Default('') String thumbnail,
    @Default([]) List<String> images,
    @Default(0.0) double discountPercent,
    DateTime? discountStart,
    DateTime? discountEnd,
    @Default(0.0) double finalPrice,
    @Default('') String businessId,
    @Default('') String categoryId,
    @Default([]) List<dynamic> options,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
