// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserContactImpl _$$UserContactImplFromJson(Map<String, dynamic> json) =>
    _$UserContactImpl(
      address: json['address'] as String? ?? '',
      subArea: json['subArea'] as String? ?? '',
      district: json['district'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$$UserContactImplToJson(_$UserContactImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'subArea': instance.subArea,
      'district': instance.district,
      'state': instance.state,
      'country': instance.country,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['_id'] as String,
  name: json['name'] as String,
  userStatus: json['userStatus'] as String? ?? 'new',
  email: json['email'] as String,
  phone: json['phone'] as String,
  fbProfile: json['fbProfile'] as String?,
  profilePic: json['profilePic'] as String?,
  role: json['role'] as String? ?? 'user',
  contact: json['contact'] == null
      ? const UserContact()
      : UserContact.fromJson(json['contact'] as Map<String, dynamic>),
  isBlocked: json['isBlocked'] as bool? ?? false,
  isDeleted: json['isDeleted'] as bool? ?? false,
  profilePicUrl: json['profilePicUrl'] as String?,
  serialNumber: json['serialNumber'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'userStatus': instance.userStatus,
      'email': instance.email,
      'phone': instance.phone,
      'fbProfile': instance.fbProfile,
      'profilePic': instance.profilePic,
      'role': instance.role,
      'contact': instance.contact,
      'isBlocked': instance.isBlocked,
      'isDeleted': instance.isDeleted,
      'profilePicUrl': instance.profilePicUrl,
      'serialNumber': instance.serialNumber,
    };
