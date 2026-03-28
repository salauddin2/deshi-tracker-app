// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: _idFromObject(json['_id']),
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      details: json['details'] as String? ?? '',
      subCategories: json['subCategories'] == null
          ? const []
          : _idsFromList(json['subCategories']),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'slug': instance.slug,
      'details': instance.details,
      'subCategories': instance.subCategories,
    };
