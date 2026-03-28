// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberImpl _$$MemberImplFromJson(Map<String, dynamic> json) => _$MemberImpl(
  id: json['_id'] as String?,
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String?,
  serial: json['serialNumber'] as String?,
  slug: json['qrSlug'] as String?,
  isActive: json['active'] as bool? ?? false,
  profileImageUrl: json['profileImageUrl'] as String?,
);

Map<String, dynamic> _$$MemberImplToJson(_$MemberImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'serialNumber': instance.serial,
      'qrSlug': instance.slug,
      'active': instance.isActive,
      'profileImageUrl': instance.profileImageUrl,
    };
