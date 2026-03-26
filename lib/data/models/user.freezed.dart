// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserContact _$UserContactFromJson(Map<String, dynamic> json) {
  return _UserContact.fromJson(json);
}

/// @nodoc
mixin _$UserContact {
  String get address => throw _privateConstructorUsedError;
  String get subArea => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;

  /// Serializes this UserContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserContactCopyWith<UserContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserContactCopyWith<$Res> {
  factory $UserContactCopyWith(
    UserContact value,
    $Res Function(UserContact) then,
  ) = _$UserContactCopyWithImpl<$Res, UserContact>;
  @useResult
  $Res call({
    String address,
    String subArea,
    String district,
    String state,
    String country,
  });
}

/// @nodoc
class _$UserContactCopyWithImpl<$Res, $Val extends UserContact>
    implements $UserContactCopyWith<$Res> {
  _$UserContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? subArea = null,
    Object? district = null,
    Object? state = null,
    Object? country = null,
  }) {
    return _then(
      _value.copyWith(
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            subArea: null == subArea
                ? _value.subArea
                : subArea // ignore: cast_nullable_to_non_nullable
                      as String,
            district: null == district
                ? _value.district
                : district // ignore: cast_nullable_to_non_nullable
                      as String,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            country: null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserContactImplCopyWith<$Res>
    implements $UserContactCopyWith<$Res> {
  factory _$$UserContactImplCopyWith(
    _$UserContactImpl value,
    $Res Function(_$UserContactImpl) then,
  ) = __$$UserContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String address,
    String subArea,
    String district,
    String state,
    String country,
  });
}

/// @nodoc
class __$$UserContactImplCopyWithImpl<$Res>
    extends _$UserContactCopyWithImpl<$Res, _$UserContactImpl>
    implements _$$UserContactImplCopyWith<$Res> {
  __$$UserContactImplCopyWithImpl(
    _$UserContactImpl _value,
    $Res Function(_$UserContactImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? subArea = null,
    Object? district = null,
    Object? state = null,
    Object? country = null,
  }) {
    return _then(
      _$UserContactImpl(
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        subArea: null == subArea
            ? _value.subArea
            : subArea // ignore: cast_nullable_to_non_nullable
                  as String,
        district: null == district
            ? _value.district
            : district // ignore: cast_nullable_to_non_nullable
                  as String,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        country: null == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserContactImpl implements _UserContact {
  const _$UserContactImpl({
    this.address = '',
    this.subArea = '',
    this.district = '',
    this.state = '',
    this.country = '',
  });

  factory _$UserContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserContactImplFromJson(json);

  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String subArea;
  @override
  @JsonKey()
  final String district;
  @override
  @JsonKey()
  final String state;
  @override
  @JsonKey()
  final String country;

  @override
  String toString() {
    return 'UserContact(address: $address, subArea: $subArea, district: $district, state: $state, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserContactImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.subArea, subArea) || other.subArea == subArea) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, address, subArea, district, state, country);

  /// Create a copy of UserContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserContactImplCopyWith<_$UserContactImpl> get copyWith =>
      __$$UserContactImplCopyWithImpl<_$UserContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserContactImplToJson(this);
  }
}

abstract class _UserContact implements UserContact {
  const factory _UserContact({
    final String address,
    final String subArea,
    final String district,
    final String state,
    final String country,
  }) = _$UserContactImpl;

  factory _UserContact.fromJson(Map<String, dynamic> json) =
      _$UserContactImpl.fromJson;

  @override
  String get address;
  @override
  String get subArea;
  @override
  String get district;
  @override
  String get state;
  @override
  String get country;

  /// Create a copy of UserContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserContactImplCopyWith<_$UserContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get userStatus => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get fbProfile => throw _privateConstructorUsedError;
  String? get profilePic => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  UserContact get contact => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String? get profilePicUrl => throw _privateConstructorUsedError;
  String? get serialNumber => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String userStatus,
    String email,
    String phone,
    String? fbProfile,
    String? profilePic,
    String role,
    UserContact contact,
    bool isBlocked,
    bool isDeleted,
    String? profilePicUrl,
    String? serialNumber,
  });

  $UserContactCopyWith<$Res> get contact;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userStatus = null,
    Object? email = null,
    Object? phone = null,
    Object? fbProfile = freezed,
    Object? profilePic = freezed,
    Object? role = null,
    Object? contact = null,
    Object? isBlocked = null,
    Object? isDeleted = null,
    Object? profilePicUrl = freezed,
    Object? serialNumber = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            userStatus: null == userStatus
                ? _value.userStatus
                : userStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            fbProfile: freezed == fbProfile
                ? _value.fbProfile
                : fbProfile // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePic: freezed == profilePic
                ? _value.profilePic
                : profilePic // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            contact: null == contact
                ? _value.contact
                : contact // ignore: cast_nullable_to_non_nullable
                      as UserContact,
            isBlocked: null == isBlocked
                ? _value.isBlocked
                : isBlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            profilePicUrl: freezed == profilePicUrl
                ? _value.profilePicUrl
                : profilePicUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            serialNumber: freezed == serialNumber
                ? _value.serialNumber
                : serialNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserContactCopyWith<$Res> get contact {
    return $UserContactCopyWith<$Res>(_value.contact, (value) {
      return _then(_value.copyWith(contact: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String userStatus,
    String email,
    String phone,
    String? fbProfile,
    String? profilePic,
    String role,
    UserContact contact,
    bool isBlocked,
    bool isDeleted,
    String? profilePicUrl,
    String? serialNumber,
  });

  @override
  $UserContactCopyWith<$Res> get contact;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userStatus = null,
    Object? email = null,
    Object? phone = null,
    Object? fbProfile = freezed,
    Object? profilePic = freezed,
    Object? role = null,
    Object? contact = null,
    Object? isBlocked = null,
    Object? isDeleted = null,
    Object? profilePicUrl = freezed,
    Object? serialNumber = freezed,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        userStatus: null == userStatus
            ? _value.userStatus
            : userStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        fbProfile: freezed == fbProfile
            ? _value.fbProfile
            : fbProfile // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePic: freezed == profilePic
            ? _value.profilePic
            : profilePic // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        contact: null == contact
            ? _value.contact
            : contact // ignore: cast_nullable_to_non_nullable
                  as UserContact,
        isBlocked: null == isBlocked
            ? _value.isBlocked
            : isBlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        profilePicUrl: freezed == profilePicUrl
            ? _value.profilePicUrl
            : profilePicUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        serialNumber: freezed == serialNumber
            ? _value.serialNumber
            : serialNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    this.userStatus = 'new',
    required this.email,
    required this.phone,
    this.fbProfile,
    this.profilePic,
    this.role = 'user',
    this.contact = const UserContact(),
    this.isBlocked = false,
    this.isDeleted = false,
    this.profilePicUrl,
    this.serialNumber,
  });

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String userStatus;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String? fbProfile;
  @override
  final String? profilePic;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey()
  final UserContact contact;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final String? profilePicUrl;
  @override
  final String? serialNumber;

  @override
  String toString() {
    return 'User(id: $id, name: $name, userStatus: $userStatus, email: $email, phone: $phone, fbProfile: $fbProfile, profilePic: $profilePic, role: $role, contact: $contact, isBlocked: $isBlocked, isDeleted: $isDeleted, profilePicUrl: $profilePicUrl, serialNumber: $serialNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userStatus, userStatus) ||
                other.userStatus == userStatus) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fbProfile, fbProfile) ||
                other.fbProfile == fbProfile) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.profilePicUrl, profilePicUrl) ||
                other.profilePicUrl == profilePicUrl) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    userStatus,
    email,
    phone,
    fbProfile,
    profilePic,
    role,
    contact,
    isBlocked,
    isDeleted,
    profilePicUrl,
    serialNumber,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    final String userStatus,
    required final String email,
    required final String phone,
    final String? fbProfile,
    final String? profilePic,
    final String role,
    final UserContact contact,
    final bool isBlocked,
    final bool isDeleted,
    final String? profilePicUrl,
    final String? serialNumber,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String get userStatus;
  @override
  String get email;
  @override
  String get phone;
  @override
  String? get fbProfile;
  @override
  String? get profilePic;
  @override
  String get role;
  @override
  UserContact get contact;
  @override
  bool get isBlocked;
  @override
  bool get isDeleted;
  @override
  String? get profilePicUrl;
  @override
  String? get serialNumber;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
