// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DayOfferImpl _$$DayOfferImplFromJson(Map<String, dynamic> json) =>
    _$DayOfferImpl(
      id: json['id'] as String,
      day: json['day'] as String? ?? '',
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      businessId: json['businessId'] as String? ?? '',
      productCategoryId: json['productCategoryId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$DayOfferImplToJson(_$DayOfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'discountPercent': instance.discountPercent,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'businessId': instance.businessId,
      'productCategoryId': instance.productCategoryId,
      'isActive': instance.isActive,
    };
