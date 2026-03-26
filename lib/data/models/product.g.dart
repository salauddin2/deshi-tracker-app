// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductOptionImpl _$$ProductOptionImplFromJson(Map<String, dynamic> json) =>
    _$ProductOptionImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      choices:
          (json['choices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProductOptionImplToJson(_$ProductOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'choices': instance.choices,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'GBP',
      thumbnail: json['thumbnail'] as String? ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
      discountStart: json['discountStart'] == null
          ? null
          : DateTime.parse(json['discountStart'] as String),
      discountEnd: json['discountEnd'] == null
          ? null
          : DateTime.parse(json['discountEnd'] as String),
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      businessId: json['businessId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      options: json['options'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'thumbnail': instance.thumbnail,
      'images': instance.images,
      'discountPercent': instance.discountPercent,
      'discountStart': instance.discountStart?.toIso8601String(),
      'discountEnd': instance.discountEnd?.toIso8601String(),
      'finalPrice': instance.finalPrice,
      'businessId': instance.businessId,
      'categoryId': instance.categoryId,
      'options': instance.options,
    };
