// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberImpl _$$MemberImplFromJson(Map<String, dynamic> json) => _$MemberImpl(
  id: json['id'] as String?,
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String?,
  serial: json['serial'] as String?,
  businessId: json['businessId'] as String? ?? '',
  slug: json['slug'] as String?,
  isVerified: json['isVerified'] as bool? ?? false,
);

Map<String, dynamic> _$$MemberImplToJson(_$MemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'serial': instance.serial,
      'businessId': instance.businessId,
      'slug': instance.slug,
      'isVerified': instance.isVerified,
    };
