// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Member _$MemberFromJson(Map<String, dynamic> json) {
  return _Member.fromJson(json);
}

/// @nodoc
mixin _$Member {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'serialNumber')
  String? get serial => throw _privateConstructorUsedError;
  @JsonKey(name: 'qrSlug')
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'active')
  bool get isActive => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberCopyWith<Member> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberCopyWith<$Res> {
  factory $MemberCopyWith(Member value, $Res Function(Member) then) =
      _$MemberCopyWithImpl<$Res, Member>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String name,
    String email,
    String? phone,
    @JsonKey(name: 'serialNumber') String? serial,
    @JsonKey(name: 'qrSlug') String? slug,
    @JsonKey(name: 'active') bool isActive,
    String? profileImageUrl,
  });
}

/// @nodoc
class _$MemberCopyWithImpl<$Res, $Val extends Member>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? serial = freezed,
    Object? slug = freezed,
    Object? isActive = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            serial: freezed == serial
                ? _value.serial
                : serial // ignore: cast_nullable_to_non_nullable
                      as String?,
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberImplCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$$MemberImplCopyWith(
    _$MemberImpl value,
    $Res Function(_$MemberImpl) then,
  ) = __$$MemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String name,
    String email,
    String? phone,
    @JsonKey(name: 'serialNumber') String? serial,
    @JsonKey(name: 'qrSlug') String? slug,
    @JsonKey(name: 'active') bool isActive,
    String? profileImageUrl,
  });
}

/// @nodoc
class __$$MemberImplCopyWithImpl<$Res>
    extends _$MemberCopyWithImpl<$Res, _$MemberImpl>
    implements _$$MemberImplCopyWith<$Res> {
  __$$MemberImplCopyWithImpl(
    _$MemberImpl _value,
    $Res Function(_$MemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
    Object? serial = freezed,
    Object? slug = freezed,
    Object? isActive = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(
      _$MemberImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        serial: freezed == serial
            ? _value.serial
            : serial // ignore: cast_nullable_to_non_nullable
                  as String?,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberImpl implements _Member {
  const _$MemberImpl({
    @JsonKey(name: '_id') this.id,
    this.name = '',
    this.email = '',
    this.phone,
    @JsonKey(name: 'serialNumber') this.serial,
    @JsonKey(name: 'qrSlug') this.slug,
    @JsonKey(name: 'active') this.isActive = false,
    this.profileImageUrl,
  });

  factory _$MemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String email;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'serialNumber')
  final String? serial;
  @override
  @JsonKey(name: 'qrSlug')
  final String? slug;
  @override
  @JsonKey(name: 'active')
  final bool isActive;
  @override
  final String? profileImageUrl;

  @override
  String toString() {
    return 'Member(id: $id, name: $name, email: $email, phone: $phone, serial: $serial, slug: $slug, isActive: $isActive, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.serial, serial) || other.serial == serial) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    phone,
    serial,
    slug,
    isActive,
    profileImageUrl,
  );

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      __$$MemberImplCopyWithImpl<_$MemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberImplToJson(this);
  }
}

abstract class _Member implements Member {
  const factory _Member({
    @JsonKey(name: '_id') final String? id,
    final String name,
    final String email,
    final String? phone,
    @JsonKey(name: 'serialNumber') final String? serial,
    @JsonKey(name: 'qrSlug') final String? slug,
    @JsonKey(name: 'active') final bool isActive,
    final String? profileImageUrl,
  }) = _$MemberImpl;

  factory _Member.fromJson(Map<String, dynamic> json) = _$MemberImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'serialNumber')
  String? get serial;
  @override
  @JsonKey(name: 'qrSlug')
  String? get slug;
  @override
  @JsonKey(name: 'active')
  bool get isActive;
  @override
  String? get profileImageUrl;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
