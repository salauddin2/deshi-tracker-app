// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MediaUnit _$MediaUnitFromJson(Map<String, dynamic> json) {
  return _MediaUnit.fromJson(json);
}

/// @nodoc
mixin _$MediaUnit {
  String get url => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this MediaUnit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaUnitCopyWith<MediaUnit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaUnitCopyWith<$Res> {
  factory $MediaUnitCopyWith(MediaUnit value, $Res Function(MediaUnit) then) =
      _$MediaUnitCopyWithImpl<$Res, MediaUnit>;
  @useResult
  $Res call({String url, String description});
}

/// @nodoc
class _$MediaUnitCopyWithImpl<$Res, $Val extends MediaUnit>
    implements $MediaUnitCopyWith<$Res> {
  _$MediaUnitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? description = null}) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MediaUnitImplCopyWith<$Res>
    implements $MediaUnitCopyWith<$Res> {
  factory _$$MediaUnitImplCopyWith(
    _$MediaUnitImpl value,
    $Res Function(_$MediaUnitImpl) then,
  ) = __$$MediaUnitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String description});
}

/// @nodoc
class __$$MediaUnitImplCopyWithImpl<$Res>
    extends _$MediaUnitCopyWithImpl<$Res, _$MediaUnitImpl>
    implements _$$MediaUnitImplCopyWith<$Res> {
  __$$MediaUnitImplCopyWithImpl(
    _$MediaUnitImpl _value,
    $Res Function(_$MediaUnitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaUnit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? description = null}) {
    return _then(
      _$MediaUnitImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaUnitImpl implements _MediaUnit {
  const _$MediaUnitImpl({this.url = '', this.description = ''});

  factory _$MediaUnitImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaUnitImplFromJson(json);

  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'MediaUnit(url: $url, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaUnitImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, description);

  /// Create a copy of MediaUnit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaUnitImplCopyWith<_$MediaUnitImpl> get copyWith =>
      __$$MediaUnitImplCopyWithImpl<_$MediaUnitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaUnitImplToJson(this);
  }
}

abstract class _MediaUnit implements MediaUnit {
  const factory _MediaUnit({final String url, final String description}) =
      _$MediaUnitImpl;

  factory _MediaUnit.fromJson(Map<String, dynamic> json) =
      _$MediaUnitImpl.fromJson;

  @override
  String get url;
  @override
  String get description;

  /// Create a copy of MediaUnit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaUnitImplCopyWith<_$MediaUnitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Media _$MediaFromJson(Map<String, dynamic> json) {
  return _Media.fromJson(json);
}

/// @nodoc
mixin _$Media {
  List<MediaUnit> get thumbnail => throw _privateConstructorUsedError;
  List<MediaUnit> get images => throw _privateConstructorUsedError;
  List<MediaUnit> get videos => throw _privateConstructorUsedError;

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaCopyWith<Media> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaCopyWith<$Res> {
  factory $MediaCopyWith(Media value, $Res Function(Media) then) =
      _$MediaCopyWithImpl<$Res, Media>;
  @useResult
  $Res call({
    List<MediaUnit> thumbnail,
    List<MediaUnit> images,
    List<MediaUnit> videos,
  });
}

/// @nodoc
class _$MediaCopyWithImpl<$Res, $Val extends Media>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = null,
    Object? images = null,
    Object? videos = null,
  }) {
    return _then(
      _value.copyWith(
            thumbnail: null == thumbnail
                ? _value.thumbnail
                : thumbnail // ignore: cast_nullable_to_non_nullable
                      as List<MediaUnit>,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<MediaUnit>,
            videos: null == videos
                ? _value.videos
                : videos // ignore: cast_nullable_to_non_nullable
                      as List<MediaUnit>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MediaImplCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$$MediaImplCopyWith(
    _$MediaImpl value,
    $Res Function(_$MediaImpl) then,
  ) = __$$MediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<MediaUnit> thumbnail,
    List<MediaUnit> images,
    List<MediaUnit> videos,
  });
}

/// @nodoc
class __$$MediaImplCopyWithImpl<$Res>
    extends _$MediaCopyWithImpl<$Res, _$MediaImpl>
    implements _$$MediaImplCopyWith<$Res> {
  __$$MediaImplCopyWithImpl(
    _$MediaImpl _value,
    $Res Function(_$MediaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = null,
    Object? images = null,
    Object? videos = null,
  }) {
    return _then(
      _$MediaImpl(
        thumbnail: null == thumbnail
            ? _value._thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as List<MediaUnit>,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<MediaUnit>,
        videos: null == videos
            ? _value._videos
            : videos // ignore: cast_nullable_to_non_nullable
                  as List<MediaUnit>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaImpl implements _Media {
  const _$MediaImpl({
    final List<MediaUnit> thumbnail = const [],
    final List<MediaUnit> images = const [],
    final List<MediaUnit> videos = const [],
  }) : _thumbnail = thumbnail,
       _images = images,
       _videos = videos;

  factory _$MediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaImplFromJson(json);

  final List<MediaUnit> _thumbnail;
  @override
  @JsonKey()
  List<MediaUnit> get thumbnail {
    if (_thumbnail is EqualUnmodifiableListView) return _thumbnail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thumbnail);
  }

  final List<MediaUnit> _images;
  @override
  @JsonKey()
  List<MediaUnit> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<MediaUnit> _videos;
  @override
  @JsonKey()
  List<MediaUnit> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  @override
  String toString() {
    return 'Media(thumbnail: $thumbnail, images: $images, videos: $videos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaImpl &&
            const DeepCollectionEquality().equals(
              other._thumbnail,
              _thumbnail,
            ) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._videos, _videos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_thumbnail),
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_videos),
  );

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaImplCopyWith<_$MediaImpl> get copyWith =>
      __$$MediaImplCopyWithImpl<_$MediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaImplToJson(this);
  }
}

abstract class _Media implements Media {
  const factory _Media({
    final List<MediaUnit> thumbnail,
    final List<MediaUnit> images,
    final List<MediaUnit> videos,
  }) = _$MediaImpl;

  factory _Media.fromJson(Map<String, dynamic> json) = _$MediaImpl.fromJson;

  @override
  List<MediaUnit> get thumbnail;
  @override
  List<MediaUnit> get images;
  @override
  List<MediaUnit> get videos;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaImplCopyWith<_$MediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactDetails _$ContactDetailsFromJson(Map<String, dynamic> json) {
  return _ContactDetails.fromJson(json);
}

/// @nodoc
mixin _$ContactDetails {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get websiteUrl => throw _privateConstructorUsedError;
  String get facebook => throw _privateConstructorUsedError;
  String get instagram => throw _privateConstructorUsedError;
  String get linkedin => throw _privateConstructorUsedError;
  String get twitter => throw _privateConstructorUsedError;

  /// Serializes this ContactDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactDetailsCopyWith<ContactDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactDetailsCopyWith<$Res> {
  factory $ContactDetailsCopyWith(
    ContactDetails value,
    $Res Function(ContactDetails) then,
  ) = _$ContactDetailsCopyWithImpl<$Res, ContactDetails>;
  @useResult
  $Res call({
    String phoneNumber,
    String email,
    String websiteUrl,
    String facebook,
    String instagram,
    String linkedin,
    String twitter,
  });
}

/// @nodoc
class _$ContactDetailsCopyWithImpl<$Res, $Val extends ContactDetails>
    implements $ContactDetailsCopyWith<$Res> {
  _$ContactDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? email = null,
    Object? websiteUrl = null,
    Object? facebook = null,
    Object? instagram = null,
    Object? linkedin = null,
    Object? twitter = null,
  }) {
    return _then(
      _value.copyWith(
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            websiteUrl: null == websiteUrl
                ? _value.websiteUrl
                : websiteUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            facebook: null == facebook
                ? _value.facebook
                : facebook // ignore: cast_nullable_to_non_nullable
                      as String,
            instagram: null == instagram
                ? _value.instagram
                : instagram // ignore: cast_nullable_to_non_nullable
                      as String,
            linkedin: null == linkedin
                ? _value.linkedin
                : linkedin // ignore: cast_nullable_to_non_nullable
                      as String,
            twitter: null == twitter
                ? _value.twitter
                : twitter // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContactDetailsImplCopyWith<$Res>
    implements $ContactDetailsCopyWith<$Res> {
  factory _$$ContactDetailsImplCopyWith(
    _$ContactDetailsImpl value,
    $Res Function(_$ContactDetailsImpl) then,
  ) = __$$ContactDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String phoneNumber,
    String email,
    String websiteUrl,
    String facebook,
    String instagram,
    String linkedin,
    String twitter,
  });
}

/// @nodoc
class __$$ContactDetailsImplCopyWithImpl<$Res>
    extends _$ContactDetailsCopyWithImpl<$Res, _$ContactDetailsImpl>
    implements _$$ContactDetailsImplCopyWith<$Res> {
  __$$ContactDetailsImplCopyWithImpl(
    _$ContactDetailsImpl _value,
    $Res Function(_$ContactDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? email = null,
    Object? websiteUrl = null,
    Object? facebook = null,
    Object? instagram = null,
    Object? linkedin = null,
    Object? twitter = null,
  }) {
    return _then(
      _$ContactDetailsImpl(
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        websiteUrl: null == websiteUrl
            ? _value.websiteUrl
            : websiteUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        facebook: null == facebook
            ? _value.facebook
            : facebook // ignore: cast_nullable_to_non_nullable
                  as String,
        instagram: null == instagram
            ? _value.instagram
            : instagram // ignore: cast_nullable_to_non_nullable
                  as String,
        linkedin: null == linkedin
            ? _value.linkedin
            : linkedin // ignore: cast_nullable_to_non_nullable
                  as String,
        twitter: null == twitter
            ? _value.twitter
            : twitter // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactDetailsImpl implements _ContactDetails {
  const _$ContactDetailsImpl({
    this.phoneNumber = '',
    this.email = '',
    this.websiteUrl = '',
    this.facebook = '',
    this.instagram = '',
    this.linkedin = '',
    this.twitter = '',
  });

  factory _$ContactDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactDetailsImplFromJson(json);

  @override
  @JsonKey()
  final String phoneNumber;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String websiteUrl;
  @override
  @JsonKey()
  final String facebook;
  @override
  @JsonKey()
  final String instagram;
  @override
  @JsonKey()
  final String linkedin;
  @override
  @JsonKey()
  final String twitter;

  @override
  String toString() {
    return 'ContactDetails(phoneNumber: $phoneNumber, email: $email, websiteUrl: $websiteUrl, facebook: $facebook, instagram: $instagram, linkedin: $linkedin, twitter: $twitter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactDetailsImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.facebook, facebook) ||
                other.facebook == facebook) &&
            (identical(other.instagram, instagram) ||
                other.instagram == instagram) &&
            (identical(other.linkedin, linkedin) ||
                other.linkedin == linkedin) &&
            (identical(other.twitter, twitter) || other.twitter == twitter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    phoneNumber,
    email,
    websiteUrl,
    facebook,
    instagram,
    linkedin,
    twitter,
  );

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactDetailsImplCopyWith<_$ContactDetailsImpl> get copyWith =>
      __$$ContactDetailsImplCopyWithImpl<_$ContactDetailsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactDetailsImplToJson(this);
  }
}

abstract class _ContactDetails implements ContactDetails {
  const factory _ContactDetails({
    final String phoneNumber,
    final String email,
    final String websiteUrl,
    final String facebook,
    final String instagram,
    final String linkedin,
    final String twitter,
  }) = _$ContactDetailsImpl;

  factory _ContactDetails.fromJson(Map<String, dynamic> json) =
      _$ContactDetailsImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String get email;
  @override
  String get websiteUrl;
  @override
  String get facebook;
  @override
  String get instagram;
  @override
  String get linkedin;
  @override
  String get twitter;

  /// Create a copy of ContactDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactDetailsImplCopyWith<_$ContactDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return _Branch.fromJson(json);
}

/// @nodoc
mixin _$Branch {
  String? get branchName => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get postCode => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchCopyWith<Branch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchCopyWith<$Res> {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) then) =
      _$BranchCopyWithImpl<$Res, Branch>;
  @useResult
  $Res call({
    String? branchName,
    String address,
    String postCode,
    String city,
    String state,
    String country,
  });
}

/// @nodoc
class _$BranchCopyWithImpl<$Res, $Val extends Branch>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchName = freezed,
    Object? address = null,
    Object? postCode = null,
    Object? city = null,
    Object? state = null,
    Object? country = null,
  }) {
    return _then(
      _value.copyWith(
            branchName: freezed == branchName
                ? _value.branchName
                : branchName // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            postCode: null == postCode
                ? _value.postCode
                : postCode // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BranchImplCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$$BranchImplCopyWith(
    _$BranchImpl value,
    $Res Function(_$BranchImpl) then,
  ) = __$$BranchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? branchName,
    String address,
    String postCode,
    String city,
    String state,
    String country,
  });
}

/// @nodoc
class __$$BranchImplCopyWithImpl<$Res>
    extends _$BranchCopyWithImpl<$Res, _$BranchImpl>
    implements _$$BranchImplCopyWith<$Res> {
  __$$BranchImplCopyWithImpl(
    _$BranchImpl _value,
    $Res Function(_$BranchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchName = freezed,
    Object? address = null,
    Object? postCode = null,
    Object? city = null,
    Object? state = null,
    Object? country = null,
  }) {
    return _then(
      _$BranchImpl(
        branchName: freezed == branchName
            ? _value.branchName
            : branchName // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        postCode: null == postCode
            ? _value.postCode
            : postCode // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
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
class _$BranchImpl implements _Branch {
  const _$BranchImpl({
    this.branchName,
    this.address = '',
    this.postCode = '',
    this.city = '',
    this.state = '',
    this.country = '',
  });

  factory _$BranchImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchImplFromJson(json);

  @override
  final String? branchName;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String postCode;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String state;
  @override
  @JsonKey()
  final String country;

  @override
  String toString() {
    return 'Branch(branchName: $branchName, address: $address, postCode: $postCode, city: $city, state: $state, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchImpl &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.postCode, postCode) ||
                other.postCode == postCode) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    branchName,
    address,
    postCode,
    city,
    state,
    country,
  );

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      __$$BranchImplCopyWithImpl<_$BranchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchImplToJson(this);
  }
}

abstract class _Branch implements Branch {
  const factory _Branch({
    final String? branchName,
    final String address,
    final String postCode,
    final String city,
    final String state,
    final String country,
  }) = _$BranchImpl;

  factory _Branch.fromJson(Map<String, dynamic> json) = _$BranchImpl.fromJson;

  @override
  String? get branchName;
  @override
  String get address;
  @override
  String get postCode;
  @override
  String get city;
  @override
  String get state;
  @override
  String get country;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationDetails _$LocationDetailsFromJson(Map<String, dynamic> json) {
  return _LocationDetails.fromJson(json);
}

/// @nodoc
mixin _$LocationDetails {
  String get address => throw _privateConstructorUsedError;
  String get exactBusinessLocation => throw _privateConstructorUsedError;
  String? get division => throw _privateConstructorUsedError;
  String? get district => throw _privateConstructorUsedError;
  String? get homeTown => throw _privateConstructorUsedError;
  String? get thana => throw _privateConstructorUsedError;
  String? get postCode => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  bool get isMultipleLocation => throw _privateConstructorUsedError;
  List<Branch> get branches => throw _privateConstructorUsedError;
  String? get lat => throw _privateConstructorUsedError;
  String? get long => throw _privateConstructorUsedError;

  /// Serializes this LocationDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationDetailsCopyWith<LocationDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationDetailsCopyWith<$Res> {
  factory $LocationDetailsCopyWith(
    LocationDetails value,
    $Res Function(LocationDetails) then,
  ) = _$LocationDetailsCopyWithImpl<$Res, LocationDetails>;
  @useResult
  $Res call({
    String address,
    String exactBusinessLocation,
    String? division,
    String? district,
    String? homeTown,
    String? thana,
    String? postCode,
    String? city,
    String state,
    String country,
    bool isMultipleLocation,
    List<Branch> branches,
    String? lat,
    String? long,
  });
}

/// @nodoc
class _$LocationDetailsCopyWithImpl<$Res, $Val extends LocationDetails>
    implements $LocationDetailsCopyWith<$Res> {
  _$LocationDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? exactBusinessLocation = null,
    Object? division = freezed,
    Object? district = freezed,
    Object? homeTown = freezed,
    Object? thana = freezed,
    Object? postCode = freezed,
    Object? city = freezed,
    Object? state = null,
    Object? country = null,
    Object? isMultipleLocation = null,
    Object? branches = null,
    Object? lat = freezed,
    Object? long = freezed,
  }) {
    return _then(
      _value.copyWith(
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            exactBusinessLocation: null == exactBusinessLocation
                ? _value.exactBusinessLocation
                : exactBusinessLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            division: freezed == division
                ? _value.division
                : division // ignore: cast_nullable_to_non_nullable
                      as String?,
            district: freezed == district
                ? _value.district
                : district // ignore: cast_nullable_to_non_nullable
                      as String?,
            homeTown: freezed == homeTown
                ? _value.homeTown
                : homeTown // ignore: cast_nullable_to_non_nullable
                      as String?,
            thana: freezed == thana
                ? _value.thana
                : thana // ignore: cast_nullable_to_non_nullable
                      as String?,
            postCode: freezed == postCode
                ? _value.postCode
                : postCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            country: null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String,
            isMultipleLocation: null == isMultipleLocation
                ? _value.isMultipleLocation
                : isMultipleLocation // ignore: cast_nullable_to_non_nullable
                      as bool,
            branches: null == branches
                ? _value.branches
                : branches // ignore: cast_nullable_to_non_nullable
                      as List<Branch>,
            lat: freezed == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as String?,
            long: freezed == long
                ? _value.long
                : long // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationDetailsImplCopyWith<$Res>
    implements $LocationDetailsCopyWith<$Res> {
  factory _$$LocationDetailsImplCopyWith(
    _$LocationDetailsImpl value,
    $Res Function(_$LocationDetailsImpl) then,
  ) = __$$LocationDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String address,
    String exactBusinessLocation,
    String? division,
    String? district,
    String? homeTown,
    String? thana,
    String? postCode,
    String? city,
    String state,
    String country,
    bool isMultipleLocation,
    List<Branch> branches,
    String? lat,
    String? long,
  });
}

/// @nodoc
class __$$LocationDetailsImplCopyWithImpl<$Res>
    extends _$LocationDetailsCopyWithImpl<$Res, _$LocationDetailsImpl>
    implements _$$LocationDetailsImplCopyWith<$Res> {
  __$$LocationDetailsImplCopyWithImpl(
    _$LocationDetailsImpl _value,
    $Res Function(_$LocationDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? exactBusinessLocation = null,
    Object? division = freezed,
    Object? district = freezed,
    Object? homeTown = freezed,
    Object? thana = freezed,
    Object? postCode = freezed,
    Object? city = freezed,
    Object? state = null,
    Object? country = null,
    Object? isMultipleLocation = null,
    Object? branches = null,
    Object? lat = freezed,
    Object? long = freezed,
  }) {
    return _then(
      _$LocationDetailsImpl(
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        exactBusinessLocation: null == exactBusinessLocation
            ? _value.exactBusinessLocation
            : exactBusinessLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        division: freezed == division
            ? _value.division
            : division // ignore: cast_nullable_to_non_nullable
                  as String?,
        district: freezed == district
            ? _value.district
            : district // ignore: cast_nullable_to_non_nullable
                  as String?,
        homeTown: freezed == homeTown
            ? _value.homeTown
            : homeTown // ignore: cast_nullable_to_non_nullable
                  as String?,
        thana: freezed == thana
            ? _value.thana
            : thana // ignore: cast_nullable_to_non_nullable
                  as String?,
        postCode: freezed == postCode
            ? _value.postCode
            : postCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        country: null == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String,
        isMultipleLocation: null == isMultipleLocation
            ? _value.isMultipleLocation
            : isMultipleLocation // ignore: cast_nullable_to_non_nullable
                  as bool,
        branches: null == branches
            ? _value._branches
            : branches // ignore: cast_nullable_to_non_nullable
                  as List<Branch>,
        lat: freezed == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as String?,
        long: freezed == long
            ? _value.long
            : long // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationDetailsImpl implements _LocationDetails {
  const _$LocationDetailsImpl({
    this.address = '',
    this.exactBusinessLocation = '',
    this.division,
    this.district,
    this.homeTown,
    this.thana,
    this.postCode,
    this.city,
    this.state = '',
    this.country = '',
    this.isMultipleLocation = false,
    final List<Branch> branches = const [],
    this.lat,
    this.long,
  }) : _branches = branches;

  factory _$LocationDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationDetailsImplFromJson(json);

  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String exactBusinessLocation;
  @override
  final String? division;
  @override
  final String? district;
  @override
  final String? homeTown;
  @override
  final String? thana;
  @override
  final String? postCode;
  @override
  final String? city;
  @override
  @JsonKey()
  final String state;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final bool isMultipleLocation;
  final List<Branch> _branches;
  @override
  @JsonKey()
  List<Branch> get branches {
    if (_branches is EqualUnmodifiableListView) return _branches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branches);
  }

  @override
  final String? lat;
  @override
  final String? long;

  @override
  String toString() {
    return 'LocationDetails(address: $address, exactBusinessLocation: $exactBusinessLocation, division: $division, district: $district, homeTown: $homeTown, thana: $thana, postCode: $postCode, city: $city, state: $state, country: $country, isMultipleLocation: $isMultipleLocation, branches: $branches, lat: $lat, long: $long)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationDetailsImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.exactBusinessLocation, exactBusinessLocation) ||
                other.exactBusinessLocation == exactBusinessLocation) &&
            (identical(other.division, division) ||
                other.division == division) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.homeTown, homeTown) ||
                other.homeTown == homeTown) &&
            (identical(other.thana, thana) || other.thana == thana) &&
            (identical(other.postCode, postCode) ||
                other.postCode == postCode) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isMultipleLocation, isMultipleLocation) ||
                other.isMultipleLocation == isMultipleLocation) &&
            const DeepCollectionEquality().equals(other._branches, _branches) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.long, long) || other.long == long));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    address,
    exactBusinessLocation,
    division,
    district,
    homeTown,
    thana,
    postCode,
    city,
    state,
    country,
    isMultipleLocation,
    const DeepCollectionEquality().hash(_branches),
    lat,
    long,
  );

  /// Create a copy of LocationDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationDetailsImplCopyWith<_$LocationDetailsImpl> get copyWith =>
      __$$LocationDetailsImplCopyWithImpl<_$LocationDetailsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationDetailsImplToJson(this);
  }
}

abstract class _LocationDetails implements LocationDetails {
  const factory _LocationDetails({
    final String address,
    final String exactBusinessLocation,
    final String? division,
    final String? district,
    final String? homeTown,
    final String? thana,
    final String? postCode,
    final String? city,
    final String state,
    final String country,
    final bool isMultipleLocation,
    final List<Branch> branches,
    final String? lat,
    final String? long,
  }) = _$LocationDetailsImpl;

  factory _LocationDetails.fromJson(Map<String, dynamic> json) =
      _$LocationDetailsImpl.fromJson;

  @override
  String get address;
  @override
  String get exactBusinessLocation;
  @override
  String? get division;
  @override
  String? get district;
  @override
  String? get homeTown;
  @override
  String? get thana;
  @override
  String? get postCode;
  @override
  String? get city;
  @override
  String get state;
  @override
  String get country;
  @override
  bool get isMultipleLocation;
  @override
  List<Branch> get branches;
  @override
  String? get lat;
  @override
  String? get long;

  /// Create a copy of LocationDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationDetailsImplCopyWith<_$LocationDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OperationDetails _$OperationDetailsFromJson(Map<String, dynamic> json) {
  return _OperationDetails.fromJson(json);
}

/// @nodoc
mixin _$OperationDetails {
  Map<String, dynamic> get businessHours => throw _privateConstructorUsedError;
  bool get provideHomeDelivery => throw _privateConstructorUsedError;
  bool get provideOnlineService => throw _privateConstructorUsedError;
  bool get offerInStorePickup => throw _privateConstructorUsedError;
  bool get isParkingAvailable => throw _privateConstructorUsedError;
  bool get offerOnlineBooking => throw _privateConstructorUsedError;
  String get onlineBookingLink => throw _privateConstructorUsedError;
  String get whatsappNumber => throw _privateConstructorUsedError;
  String get menuLink => throw _privateConstructorUsedError;

  /// Serializes this OperationDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OperationDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OperationDetailsCopyWith<OperationDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationDetailsCopyWith<$Res> {
  factory $OperationDetailsCopyWith(
    OperationDetails value,
    $Res Function(OperationDetails) then,
  ) = _$OperationDetailsCopyWithImpl<$Res, OperationDetails>;
  @useResult
  $Res call({
    Map<String, dynamic> businessHours,
    bool provideHomeDelivery,
    bool provideOnlineService,
    bool offerInStorePickup,
    bool isParkingAvailable,
    bool offerOnlineBooking,
    String onlineBookingLink,
    String whatsappNumber,
    String menuLink,
  });
}

/// @nodoc
class _$OperationDetailsCopyWithImpl<$Res, $Val extends OperationDetails>
    implements $OperationDetailsCopyWith<$Res> {
  _$OperationDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OperationDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessHours = null,
    Object? provideHomeDelivery = null,
    Object? provideOnlineService = null,
    Object? offerInStorePickup = null,
    Object? isParkingAvailable = null,
    Object? offerOnlineBooking = null,
    Object? onlineBookingLink = null,
    Object? whatsappNumber = null,
    Object? menuLink = null,
  }) {
    return _then(
      _value.copyWith(
            businessHours: null == businessHours
                ? _value.businessHours
                : businessHours // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            provideHomeDelivery: null == provideHomeDelivery
                ? _value.provideHomeDelivery
                : provideHomeDelivery // ignore: cast_nullable_to_non_nullable
                      as bool,
            provideOnlineService: null == provideOnlineService
                ? _value.provideOnlineService
                : provideOnlineService // ignore: cast_nullable_to_non_nullable
                      as bool,
            offerInStorePickup: null == offerInStorePickup
                ? _value.offerInStorePickup
                : offerInStorePickup // ignore: cast_nullable_to_non_nullable
                      as bool,
            isParkingAvailable: null == isParkingAvailable
                ? _value.isParkingAvailable
                : isParkingAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            offerOnlineBooking: null == offerOnlineBooking
                ? _value.offerOnlineBooking
                : offerOnlineBooking // ignore: cast_nullable_to_non_nullable
                      as bool,
            onlineBookingLink: null == onlineBookingLink
                ? _value.onlineBookingLink
                : onlineBookingLink // ignore: cast_nullable_to_non_nullable
                      as String,
            whatsappNumber: null == whatsappNumber
                ? _value.whatsappNumber
                : whatsappNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            menuLink: null == menuLink
                ? _value.menuLink
                : menuLink // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OperationDetailsImplCopyWith<$Res>
    implements $OperationDetailsCopyWith<$Res> {
  factory _$$OperationDetailsImplCopyWith(
    _$OperationDetailsImpl value,
    $Res Function(_$OperationDetailsImpl) then,
  ) = __$$OperationDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, dynamic> businessHours,
    bool provideHomeDelivery,
    bool provideOnlineService,
    bool offerInStorePickup,
    bool isParkingAvailable,
    bool offerOnlineBooking,
    String onlineBookingLink,
    String whatsappNumber,
    String menuLink,
  });
}

/// @nodoc
class __$$OperationDetailsImplCopyWithImpl<$Res>
    extends _$OperationDetailsCopyWithImpl<$Res, _$OperationDetailsImpl>
    implements _$$OperationDetailsImplCopyWith<$Res> {
  __$$OperationDetailsImplCopyWithImpl(
    _$OperationDetailsImpl _value,
    $Res Function(_$OperationDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OperationDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessHours = null,
    Object? provideHomeDelivery = null,
    Object? provideOnlineService = null,
    Object? offerInStorePickup = null,
    Object? isParkingAvailable = null,
    Object? offerOnlineBooking = null,
    Object? onlineBookingLink = null,
    Object? whatsappNumber = null,
    Object? menuLink = null,
  }) {
    return _then(
      _$OperationDetailsImpl(
        businessHours: null == businessHours
            ? _value._businessHours
            : businessHours // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        provideHomeDelivery: null == provideHomeDelivery
            ? _value.provideHomeDelivery
            : provideHomeDelivery // ignore: cast_nullable_to_non_nullable
                  as bool,
        provideOnlineService: null == provideOnlineService
            ? _value.provideOnlineService
            : provideOnlineService // ignore: cast_nullable_to_non_nullable
                  as bool,
        offerInStorePickup: null == offerInStorePickup
            ? _value.offerInStorePickup
            : offerInStorePickup // ignore: cast_nullable_to_non_nullable
                  as bool,
        isParkingAvailable: null == isParkingAvailable
            ? _value.isParkingAvailable
            : isParkingAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        offerOnlineBooking: null == offerOnlineBooking
            ? _value.offerOnlineBooking
            : offerOnlineBooking // ignore: cast_nullable_to_non_nullable
                  as bool,
        onlineBookingLink: null == onlineBookingLink
            ? _value.onlineBookingLink
            : onlineBookingLink // ignore: cast_nullable_to_non_nullable
                  as String,
        whatsappNumber: null == whatsappNumber
            ? _value.whatsappNumber
            : whatsappNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        menuLink: null == menuLink
            ? _value.menuLink
            : menuLink // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OperationDetailsImpl implements _OperationDetails {
  const _$OperationDetailsImpl({
    final Map<String, dynamic> businessHours = const {},
    this.provideHomeDelivery = false,
    this.provideOnlineService = false,
    this.offerInStorePickup = false,
    this.isParkingAvailable = false,
    this.offerOnlineBooking = false,
    this.onlineBookingLink = '',
    this.whatsappNumber = '',
    this.menuLink = '',
  }) : _businessHours = businessHours;

  factory _$OperationDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OperationDetailsImplFromJson(json);

  final Map<String, dynamic> _businessHours;
  @override
  @JsonKey()
  Map<String, dynamic> get businessHours {
    if (_businessHours is EqualUnmodifiableMapView) return _businessHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_businessHours);
  }

  @override
  @JsonKey()
  final bool provideHomeDelivery;
  @override
  @JsonKey()
  final bool provideOnlineService;
  @override
  @JsonKey()
  final bool offerInStorePickup;
  @override
  @JsonKey()
  final bool isParkingAvailable;
  @override
  @JsonKey()
  final bool offerOnlineBooking;
  @override
  @JsonKey()
  final String onlineBookingLink;
  @override
  @JsonKey()
  final String whatsappNumber;
  @override
  @JsonKey()
  final String menuLink;

  @override
  String toString() {
    return 'OperationDetails(businessHours: $businessHours, provideHomeDelivery: $provideHomeDelivery, provideOnlineService: $provideOnlineService, offerInStorePickup: $offerInStorePickup, isParkingAvailable: $isParkingAvailable, offerOnlineBooking: $offerOnlineBooking, onlineBookingLink: $onlineBookingLink, whatsappNumber: $whatsappNumber, menuLink: $menuLink)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationDetailsImpl &&
            const DeepCollectionEquality().equals(
              other._businessHours,
              _businessHours,
            ) &&
            (identical(other.provideHomeDelivery, provideHomeDelivery) ||
                other.provideHomeDelivery == provideHomeDelivery) &&
            (identical(other.provideOnlineService, provideOnlineService) ||
                other.provideOnlineService == provideOnlineService) &&
            (identical(other.offerInStorePickup, offerInStorePickup) ||
                other.offerInStorePickup == offerInStorePickup) &&
            (identical(other.isParkingAvailable, isParkingAvailable) ||
                other.isParkingAvailable == isParkingAvailable) &&
            (identical(other.offerOnlineBooking, offerOnlineBooking) ||
                other.offerOnlineBooking == offerOnlineBooking) &&
            (identical(other.onlineBookingLink, onlineBookingLink) ||
                other.onlineBookingLink == onlineBookingLink) &&
            (identical(other.whatsappNumber, whatsappNumber) ||
                other.whatsappNumber == whatsappNumber) &&
            (identical(other.menuLink, menuLink) ||
                other.menuLink == menuLink));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_businessHours),
    provideHomeDelivery,
    provideOnlineService,
    offerInStorePickup,
    isParkingAvailable,
    offerOnlineBooking,
    onlineBookingLink,
    whatsappNumber,
    menuLink,
  );

  /// Create a copy of OperationDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationDetailsImplCopyWith<_$OperationDetailsImpl> get copyWith =>
      __$$OperationDetailsImplCopyWithImpl<_$OperationDetailsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OperationDetailsImplToJson(this);
  }
}

abstract class _OperationDetails implements OperationDetails {
  const factory _OperationDetails({
    final Map<String, dynamic> businessHours,
    final bool provideHomeDelivery,
    final bool provideOnlineService,
    final bool offerInStorePickup,
    final bool isParkingAvailable,
    final bool offerOnlineBooking,
    final String onlineBookingLink,
    final String whatsappNumber,
    final String menuLink,
  }) = _$OperationDetailsImpl;

  factory _OperationDetails.fromJson(Map<String, dynamic> json) =
      _$OperationDetailsImpl.fromJson;

  @override
  Map<String, dynamic> get businessHours;
  @override
  bool get provideHomeDelivery;
  @override
  bool get provideOnlineService;
  @override
  bool get offerInStorePickup;
  @override
  bool get isParkingAvailable;
  @override
  bool get offerOnlineBooking;
  @override
  String get onlineBookingLink;
  @override
  String get whatsappNumber;
  @override
  String get menuLink;

  /// Create a copy of OperationDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OperationDetailsImplCopyWith<_$OperationDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Features _$FeaturesFromJson(Map<String, dynamic> json) {
  return _Features.fromJson(json);
}

/// @nodoc
mixin _$Features {
  String get officialLanguage => throw _privateConstructorUsedError;
  String? get secondLanguage => throw _privateConstructorUsedError;
  bool get offerSpecialDiscount => throw _privateConstructorUsedError;
  bool get isWheelChairAccessible => throw _privateConstructorUsedError;
  String? get foodOptions => throw _privateConstructorUsedError;

  /// Serializes this Features to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Features
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeaturesCopyWith<Features> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeaturesCopyWith<$Res> {
  factory $FeaturesCopyWith(Features value, $Res Function(Features) then) =
      _$FeaturesCopyWithImpl<$Res, Features>;
  @useResult
  $Res call({
    String officialLanguage,
    String? secondLanguage,
    bool offerSpecialDiscount,
    bool isWheelChairAccessible,
    String? foodOptions,
  });
}

/// @nodoc
class _$FeaturesCopyWithImpl<$Res, $Val extends Features>
    implements $FeaturesCopyWith<$Res> {
  _$FeaturesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Features
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? officialLanguage = null,
    Object? secondLanguage = freezed,
    Object? offerSpecialDiscount = null,
    Object? isWheelChairAccessible = null,
    Object? foodOptions = freezed,
  }) {
    return _then(
      _value.copyWith(
            officialLanguage: null == officialLanguage
                ? _value.officialLanguage
                : officialLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            secondLanguage: freezed == secondLanguage
                ? _value.secondLanguage
                : secondLanguage // ignore: cast_nullable_to_non_nullable
                      as String?,
            offerSpecialDiscount: null == offerSpecialDiscount
                ? _value.offerSpecialDiscount
                : offerSpecialDiscount // ignore: cast_nullable_to_non_nullable
                      as bool,
            isWheelChairAccessible: null == isWheelChairAccessible
                ? _value.isWheelChairAccessible
                : isWheelChairAccessible // ignore: cast_nullable_to_non_nullable
                      as bool,
            foodOptions: freezed == foodOptions
                ? _value.foodOptions
                : foodOptions // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeaturesImplCopyWith<$Res>
    implements $FeaturesCopyWith<$Res> {
  factory _$$FeaturesImplCopyWith(
    _$FeaturesImpl value,
    $Res Function(_$FeaturesImpl) then,
  ) = __$$FeaturesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String officialLanguage,
    String? secondLanguage,
    bool offerSpecialDiscount,
    bool isWheelChairAccessible,
    String? foodOptions,
  });
}

/// @nodoc
class __$$FeaturesImplCopyWithImpl<$Res>
    extends _$FeaturesCopyWithImpl<$Res, _$FeaturesImpl>
    implements _$$FeaturesImplCopyWith<$Res> {
  __$$FeaturesImplCopyWithImpl(
    _$FeaturesImpl _value,
    $Res Function(_$FeaturesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Features
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? officialLanguage = null,
    Object? secondLanguage = freezed,
    Object? offerSpecialDiscount = null,
    Object? isWheelChairAccessible = null,
    Object? foodOptions = freezed,
  }) {
    return _then(
      _$FeaturesImpl(
        officialLanguage: null == officialLanguage
            ? _value.officialLanguage
            : officialLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        secondLanguage: freezed == secondLanguage
            ? _value.secondLanguage
            : secondLanguage // ignore: cast_nullable_to_non_nullable
                  as String?,
        offerSpecialDiscount: null == offerSpecialDiscount
            ? _value.offerSpecialDiscount
            : offerSpecialDiscount // ignore: cast_nullable_to_non_nullable
                  as bool,
        isWheelChairAccessible: null == isWheelChairAccessible
            ? _value.isWheelChairAccessible
            : isWheelChairAccessible // ignore: cast_nullable_to_non_nullable
                  as bool,
        foodOptions: freezed == foodOptions
            ? _value.foodOptions
            : foodOptions // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeaturesImpl implements _Features {
  const _$FeaturesImpl({
    this.officialLanguage = '',
    this.secondLanguage,
    this.offerSpecialDiscount = false,
    this.isWheelChairAccessible = false,
    this.foodOptions,
  });

  factory _$FeaturesImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeaturesImplFromJson(json);

  @override
  @JsonKey()
  final String officialLanguage;
  @override
  final String? secondLanguage;
  @override
  @JsonKey()
  final bool offerSpecialDiscount;
  @override
  @JsonKey()
  final bool isWheelChairAccessible;
  @override
  final String? foodOptions;

  @override
  String toString() {
    return 'Features(officialLanguage: $officialLanguage, secondLanguage: $secondLanguage, offerSpecialDiscount: $offerSpecialDiscount, isWheelChairAccessible: $isWheelChairAccessible, foodOptions: $foodOptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeaturesImpl &&
            (identical(other.officialLanguage, officialLanguage) ||
                other.officialLanguage == officialLanguage) &&
            (identical(other.secondLanguage, secondLanguage) ||
                other.secondLanguage == secondLanguage) &&
            (identical(other.offerSpecialDiscount, offerSpecialDiscount) ||
                other.offerSpecialDiscount == offerSpecialDiscount) &&
            (identical(other.isWheelChairAccessible, isWheelChairAccessible) ||
                other.isWheelChairAccessible == isWheelChairAccessible) &&
            (identical(other.foodOptions, foodOptions) ||
                other.foodOptions == foodOptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    officialLanguage,
    secondLanguage,
    offerSpecialDiscount,
    isWheelChairAccessible,
    foodOptions,
  );

  /// Create a copy of Features
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeaturesImplCopyWith<_$FeaturesImpl> get copyWith =>
      __$$FeaturesImplCopyWithImpl<_$FeaturesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeaturesImplToJson(this);
  }
}

abstract class _Features implements Features {
  const factory _Features({
    final String officialLanguage,
    final String? secondLanguage,
    final bool offerSpecialDiscount,
    final bool isWheelChairAccessible,
    final String? foodOptions,
  }) = _$FeaturesImpl;

  factory _Features.fromJson(Map<String, dynamic> json) =
      _$FeaturesImpl.fromJson;

  @override
  String get officialLanguage;
  @override
  String? get secondLanguage;
  @override
  bool get offerSpecialDiscount;
  @override
  bool get isWheelChairAccessible;
  @override
  String? get foodOptions;

  /// Create a copy of Features
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeaturesImplCopyWith<_$FeaturesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpeningHour _$OpeningHourFromJson(Map<String, dynamic> json) {
  return _OpeningHour.fromJson(json);
}

/// @nodoc
mixin _$OpeningHour {
  String get day => throw _privateConstructorUsedError;
  String? get start => throw _privateConstructorUsedError;
  String? get end => throw _privateConstructorUsedError;

  /// Serializes this OpeningHour to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpeningHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpeningHourCopyWith<OpeningHour> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpeningHourCopyWith<$Res> {
  factory $OpeningHourCopyWith(
    OpeningHour value,
    $Res Function(OpeningHour) then,
  ) = _$OpeningHourCopyWithImpl<$Res, OpeningHour>;
  @useResult
  $Res call({String day, String? start, String? end});
}

/// @nodoc
class _$OpeningHourCopyWithImpl<$Res, $Val extends OpeningHour>
    implements $OpeningHourCopyWith<$Res> {
  _$OpeningHourCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpeningHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String,
            start: freezed == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as String?,
            end: freezed == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpeningHourImplCopyWith<$Res>
    implements $OpeningHourCopyWith<$Res> {
  factory _$$OpeningHourImplCopyWith(
    _$OpeningHourImpl value,
    $Res Function(_$OpeningHourImpl) then,
  ) = __$$OpeningHourImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String day, String? start, String? end});
}

/// @nodoc
class __$$OpeningHourImplCopyWithImpl<$Res>
    extends _$OpeningHourCopyWithImpl<$Res, _$OpeningHourImpl>
    implements _$$OpeningHourImplCopyWith<$Res> {
  __$$OpeningHourImplCopyWithImpl(
    _$OpeningHourImpl _value,
    $Res Function(_$OpeningHourImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpeningHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(
      _$OpeningHourImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        start: freezed == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as String?,
        end: freezed == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpeningHourImpl implements _OpeningHour {
  const _$OpeningHourImpl({this.day = '', this.start, this.end});

  factory _$OpeningHourImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpeningHourImplFromJson(json);

  @override
  @JsonKey()
  final String day;
  @override
  final String? start;
  @override
  final String? end;

  @override
  String toString() {
    return 'OpeningHour(day: $day, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpeningHourImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, day, start, end);

  /// Create a copy of OpeningHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpeningHourImplCopyWith<_$OpeningHourImpl> get copyWith =>
      __$$OpeningHourImplCopyWithImpl<_$OpeningHourImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpeningHourImplToJson(this);
  }
}

abstract class _OpeningHour implements OpeningHour {
  const factory _OpeningHour({
    final String day,
    final String? start,
    final String? end,
  }) = _$OpeningHourImpl;

  factory _OpeningHour.fromJson(Map<String, dynamic> json) =
      _$OpeningHourImpl.fromJson;

  @override
  String get day;
  @override
  String? get start;
  @override
  String? get end;

  /// Create a copy of OpeningHour
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpeningHourImplCopyWith<_$OpeningHourImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Business _$BusinessFromJson(Map<String, dynamic> json) {
  return _Business.fromJson(json);
}

/// @nodoc
mixin _$Business {
  @JsonKey(name: '_id', fromJson: _idFromObject)
  String get id => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get checkoutNumber => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner', fromJson: _idFromObject)
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category', fromJson: _idFromObject)
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subCategory', fromJson: _idFromObject)
  String? get subCategoryId => throw _privateConstructorUsedError;
  String? get selectedType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get established => throw _privateConstructorUsedError;
  String get about => throw _privateConstructorUsedError;
  String get logo => throw _privateConstructorUsedError;
  ContactDetails get contactDetails => throw _privateConstructorUsedError;
  LocationDetails get locations => throw _privateConstructorUsedError;
  OperationDetails get operationDetails => throw _privateConstructorUsedError;
  Features get features => throw _privateConstructorUsedError;
  Media get media => throw _privateConstructorUsedError;
  String get howToHearAboutDesiTracker => throw _privateConstructorUsedError;
  bool get agreeToTermsConditions => throw _privateConstructorUsedError;
  bool get hasCustomerTestimonials => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isHalal => throw _privateConstructorUsedError;
  bool get isTrash => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  List<OpeningHour> get openingHours => throw _privateConstructorUsedError;
  List<String> get paymentMethods => throw _privateConstructorUsedError;

  /// Serializes this Business to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessCopyWith<Business> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessCopyWith<$Res> {
  factory $BusinessCopyWith(Business value, $Res Function(Business) then) =
      _$BusinessCopyWithImpl<$Res, Business>;
  @useResult
  $Res call({
    @JsonKey(name: '_id', fromJson: _idFromObject) String id,
    String businessName,
    String checkoutNumber,
    String slug,
    @JsonKey(name: 'owner', fromJson: _idFromObject) String ownerId,
    @JsonKey(name: 'category', fromJson: _idFromObject) String categoryId,
    @JsonKey(name: 'subCategory', fromJson: _idFromObject)
    String? subCategoryId,
    String? selectedType,
    String description,
    DateTime? established,
    String about,
    String logo,
    ContactDetails contactDetails,
    LocationDetails locations,
    OperationDetails operationDetails,
    Features features,
    Media media,
    String howToHearAboutDesiTracker,
    bool agreeToTermsConditions,
    bool hasCustomerTestimonials,
    bool isActive,
    bool isHalal,
    bool isTrash,
    bool isDeleted,
    List<OpeningHour> openingHours,
    List<String> paymentMethods,
  });

  $ContactDetailsCopyWith<$Res> get contactDetails;
  $LocationDetailsCopyWith<$Res> get locations;
  $OperationDetailsCopyWith<$Res> get operationDetails;
  $FeaturesCopyWith<$Res> get features;
  $MediaCopyWith<$Res> get media;
}

/// @nodoc
class _$BusinessCopyWithImpl<$Res, $Val extends Business>
    implements $BusinessCopyWith<$Res> {
  _$BusinessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? checkoutNumber = null,
    Object? slug = null,
    Object? ownerId = null,
    Object? categoryId = null,
    Object? subCategoryId = freezed,
    Object? selectedType = freezed,
    Object? description = null,
    Object? established = freezed,
    Object? about = null,
    Object? logo = null,
    Object? contactDetails = null,
    Object? locations = null,
    Object? operationDetails = null,
    Object? features = null,
    Object? media = null,
    Object? howToHearAboutDesiTracker = null,
    Object? agreeToTermsConditions = null,
    Object? hasCustomerTestimonials = null,
    Object? isActive = null,
    Object? isHalal = null,
    Object? isTrash = null,
    Object? isDeleted = null,
    Object? openingHours = null,
    Object? paymentMethods = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            businessName: null == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String,
            checkoutNumber: null == checkoutNumber
                ? _value.checkoutNumber
                : checkoutNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            subCategoryId: freezed == subCategoryId
                ? _value.subCategoryId
                : subCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedType: freezed == selectedType
                ? _value.selectedType
                : selectedType // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            established: freezed == established
                ? _value.established
                : established // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            about: null == about
                ? _value.about
                : about // ignore: cast_nullable_to_non_nullable
                      as String,
            logo: null == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as String,
            contactDetails: null == contactDetails
                ? _value.contactDetails
                : contactDetails // ignore: cast_nullable_to_non_nullable
                      as ContactDetails,
            locations: null == locations
                ? _value.locations
                : locations // ignore: cast_nullable_to_non_nullable
                      as LocationDetails,
            operationDetails: null == operationDetails
                ? _value.operationDetails
                : operationDetails // ignore: cast_nullable_to_non_nullable
                      as OperationDetails,
            features: null == features
                ? _value.features
                : features // ignore: cast_nullable_to_non_nullable
                      as Features,
            media: null == media
                ? _value.media
                : media // ignore: cast_nullable_to_non_nullable
                      as Media,
            howToHearAboutDesiTracker: null == howToHearAboutDesiTracker
                ? _value.howToHearAboutDesiTracker
                : howToHearAboutDesiTracker // ignore: cast_nullable_to_non_nullable
                      as String,
            agreeToTermsConditions: null == agreeToTermsConditions
                ? _value.agreeToTermsConditions
                : agreeToTermsConditions // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasCustomerTestimonials: null == hasCustomerTestimonials
                ? _value.hasCustomerTestimonials
                : hasCustomerTestimonials // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isHalal: null == isHalal
                ? _value.isHalal
                : isHalal // ignore: cast_nullable_to_non_nullable
                      as bool,
            isTrash: null == isTrash
                ? _value.isTrash
                : isTrash // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            openingHours: null == openingHours
                ? _value.openingHours
                : openingHours // ignore: cast_nullable_to_non_nullable
                      as List<OpeningHour>,
            paymentMethods: null == paymentMethods
                ? _value.paymentMethods
                : paymentMethods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactDetailsCopyWith<$Res> get contactDetails {
    return $ContactDetailsCopyWith<$Res>(_value.contactDetails, (value) {
      return _then(_value.copyWith(contactDetails: value) as $Val);
    });
  }

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationDetailsCopyWith<$Res> get locations {
    return $LocationDetailsCopyWith<$Res>(_value.locations, (value) {
      return _then(_value.copyWith(locations: value) as $Val);
    });
  }

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OperationDetailsCopyWith<$Res> get operationDetails {
    return $OperationDetailsCopyWith<$Res>(_value.operationDetails, (value) {
      return _then(_value.copyWith(operationDetails: value) as $Val);
    });
  }

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeaturesCopyWith<$Res> get features {
    return $FeaturesCopyWith<$Res>(_value.features, (value) {
      return _then(_value.copyWith(features: value) as $Val);
    });
  }

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MediaCopyWith<$Res> get media {
    return $MediaCopyWith<$Res>(_value.media, (value) {
      return _then(_value.copyWith(media: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BusinessImplCopyWith<$Res>
    implements $BusinessCopyWith<$Res> {
  factory _$$BusinessImplCopyWith(
    _$BusinessImpl value,
    $Res Function(_$BusinessImpl) then,
  ) = __$$BusinessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id', fromJson: _idFromObject) String id,
    String businessName,
    String checkoutNumber,
    String slug,
    @JsonKey(name: 'owner', fromJson: _idFromObject) String ownerId,
    @JsonKey(name: 'category', fromJson: _idFromObject) String categoryId,
    @JsonKey(name: 'subCategory', fromJson: _idFromObject)
    String? subCategoryId,
    String? selectedType,
    String description,
    DateTime? established,
    String about,
    String logo,
    ContactDetails contactDetails,
    LocationDetails locations,
    OperationDetails operationDetails,
    Features features,
    Media media,
    String howToHearAboutDesiTracker,
    bool agreeToTermsConditions,
    bool hasCustomerTestimonials,
    bool isActive,
    bool isHalal,
    bool isTrash,
    bool isDeleted,
    List<OpeningHour> openingHours,
    List<String> paymentMethods,
  });

  @override
  $ContactDetailsCopyWith<$Res> get contactDetails;
  @override
  $LocationDetailsCopyWith<$Res> get locations;
  @override
  $OperationDetailsCopyWith<$Res> get operationDetails;
  @override
  $FeaturesCopyWith<$Res> get features;
  @override
  $MediaCopyWith<$Res> get media;
}

/// @nodoc
class __$$BusinessImplCopyWithImpl<$Res>
    extends _$BusinessCopyWithImpl<$Res, _$BusinessImpl>
    implements _$$BusinessImplCopyWith<$Res> {
  __$$BusinessImplCopyWithImpl(
    _$BusinessImpl _value,
    $Res Function(_$BusinessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? checkoutNumber = null,
    Object? slug = null,
    Object? ownerId = null,
    Object? categoryId = null,
    Object? subCategoryId = freezed,
    Object? selectedType = freezed,
    Object? description = null,
    Object? established = freezed,
    Object? about = null,
    Object? logo = null,
    Object? contactDetails = null,
    Object? locations = null,
    Object? operationDetails = null,
    Object? features = null,
    Object? media = null,
    Object? howToHearAboutDesiTracker = null,
    Object? agreeToTermsConditions = null,
    Object? hasCustomerTestimonials = null,
    Object? isActive = null,
    Object? isHalal = null,
    Object? isTrash = null,
    Object? isDeleted = null,
    Object? openingHours = null,
    Object? paymentMethods = null,
  }) {
    return _then(
      _$BusinessImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessName: null == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String,
        checkoutNumber: null == checkoutNumber
            ? _value.checkoutNumber
            : checkoutNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        subCategoryId: freezed == subCategoryId
            ? _value.subCategoryId
            : subCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedType: freezed == selectedType
            ? _value.selectedType
            : selectedType // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        established: freezed == established
            ? _value.established
            : established // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        about: null == about
            ? _value.about
            : about // ignore: cast_nullable_to_non_nullable
                  as String,
        logo: null == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as String,
        contactDetails: null == contactDetails
            ? _value.contactDetails
            : contactDetails // ignore: cast_nullable_to_non_nullable
                  as ContactDetails,
        locations: null == locations
            ? _value.locations
            : locations // ignore: cast_nullable_to_non_nullable
                  as LocationDetails,
        operationDetails: null == operationDetails
            ? _value.operationDetails
            : operationDetails // ignore: cast_nullable_to_non_nullable
                  as OperationDetails,
        features: null == features
            ? _value.features
            : features // ignore: cast_nullable_to_non_nullable
                  as Features,
        media: null == media
            ? _value.media
            : media // ignore: cast_nullable_to_non_nullable
                  as Media,
        howToHearAboutDesiTracker: null == howToHearAboutDesiTracker
            ? _value.howToHearAboutDesiTracker
            : howToHearAboutDesiTracker // ignore: cast_nullable_to_non_nullable
                  as String,
        agreeToTermsConditions: null == agreeToTermsConditions
            ? _value.agreeToTermsConditions
            : agreeToTermsConditions // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasCustomerTestimonials: null == hasCustomerTestimonials
            ? _value.hasCustomerTestimonials
            : hasCustomerTestimonials // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isHalal: null == isHalal
            ? _value.isHalal
            : isHalal // ignore: cast_nullable_to_non_nullable
                  as bool,
        isTrash: null == isTrash
            ? _value.isTrash
            : isTrash // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        openingHours: null == openingHours
            ? _value._openingHours
            : openingHours // ignore: cast_nullable_to_non_nullable
                  as List<OpeningHour>,
        paymentMethods: null == paymentMethods
            ? _value._paymentMethods
            : paymentMethods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessImpl implements _Business {
  const _$BusinessImpl({
    @JsonKey(name: '_id', fromJson: _idFromObject) required this.id,
    this.businessName = '',
    this.checkoutNumber = '',
    this.slug = '',
    @JsonKey(name: 'owner', fromJson: _idFromObject) this.ownerId = '',
    @JsonKey(name: 'category', fromJson: _idFromObject) this.categoryId = '',
    @JsonKey(name: 'subCategory', fromJson: _idFromObject) this.subCategoryId,
    this.selectedType,
    this.description = '',
    this.established,
    this.about = '',
    this.logo = '',
    required this.contactDetails,
    required this.locations,
    required this.operationDetails,
    required this.features,
    required this.media,
    this.howToHearAboutDesiTracker = '',
    this.agreeToTermsConditions = false,
    this.hasCustomerTestimonials = false,
    this.isActive = true,
    this.isHalal = true,
    this.isTrash = false,
    this.isDeleted = false,
    final List<OpeningHour> openingHours = const [],
    final List<String> paymentMethods = const [],
  }) : _openingHours = openingHours,
       _paymentMethods = paymentMethods;

  factory _$BusinessImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessImplFromJson(json);

  @override
  @JsonKey(name: '_id', fromJson: _idFromObject)
  final String id;
  @override
  @JsonKey()
  final String businessName;
  @override
  @JsonKey()
  final String checkoutNumber;
  @override
  @JsonKey()
  final String slug;
  @override
  @JsonKey(name: 'owner', fromJson: _idFromObject)
  final String ownerId;
  @override
  @JsonKey(name: 'category', fromJson: _idFromObject)
  final String categoryId;
  @override
  @JsonKey(name: 'subCategory', fromJson: _idFromObject)
  final String? subCategoryId;
  @override
  final String? selectedType;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? established;
  @override
  @JsonKey()
  final String about;
  @override
  @JsonKey()
  final String logo;
  @override
  final ContactDetails contactDetails;
  @override
  final LocationDetails locations;
  @override
  final OperationDetails operationDetails;
  @override
  final Features features;
  @override
  final Media media;
  @override
  @JsonKey()
  final String howToHearAboutDesiTracker;
  @override
  @JsonKey()
  final bool agreeToTermsConditions;
  @override
  @JsonKey()
  final bool hasCustomerTestimonials;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isHalal;
  @override
  @JsonKey()
  final bool isTrash;
  @override
  @JsonKey()
  final bool isDeleted;
  final List<OpeningHour> _openingHours;
  @override
  @JsonKey()
  List<OpeningHour> get openingHours {
    if (_openingHours is EqualUnmodifiableListView) return _openingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_openingHours);
  }

  final List<String> _paymentMethods;
  @override
  @JsonKey()
  List<String> get paymentMethods {
    if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentMethods);
  }

  @override
  String toString() {
    return 'Business(id: $id, businessName: $businessName, checkoutNumber: $checkoutNumber, slug: $slug, ownerId: $ownerId, categoryId: $categoryId, subCategoryId: $subCategoryId, selectedType: $selectedType, description: $description, established: $established, about: $about, logo: $logo, contactDetails: $contactDetails, locations: $locations, operationDetails: $operationDetails, features: $features, media: $media, howToHearAboutDesiTracker: $howToHearAboutDesiTracker, agreeToTermsConditions: $agreeToTermsConditions, hasCustomerTestimonials: $hasCustomerTestimonials, isActive: $isActive, isHalal: $isHalal, isTrash: $isTrash, isDeleted: $isDeleted, openingHours: $openingHours, paymentMethods: $paymentMethods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.checkoutNumber, checkoutNumber) ||
                other.checkoutNumber == checkoutNumber) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subCategoryId, subCategoryId) ||
                other.subCategoryId == subCategoryId) &&
            (identical(other.selectedType, selectedType) ||
                other.selectedType == selectedType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.established, established) ||
                other.established == established) &&
            (identical(other.about, about) || other.about == about) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.contactDetails, contactDetails) ||
                other.contactDetails == contactDetails) &&
            (identical(other.locations, locations) ||
                other.locations == locations) &&
            (identical(other.operationDetails, operationDetails) ||
                other.operationDetails == operationDetails) &&
            (identical(other.features, features) ||
                other.features == features) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(
                  other.howToHearAboutDesiTracker,
                  howToHearAboutDesiTracker,
                ) ||
                other.howToHearAboutDesiTracker == howToHearAboutDesiTracker) &&
            (identical(other.agreeToTermsConditions, agreeToTermsConditions) ||
                other.agreeToTermsConditions == agreeToTermsConditions) &&
            (identical(
                  other.hasCustomerTestimonials,
                  hasCustomerTestimonials,
                ) ||
                other.hasCustomerTestimonials == hasCustomerTestimonials) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isHalal, isHalal) || other.isHalal == isHalal) &&
            (identical(other.isTrash, isTrash) || other.isTrash == isTrash) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            const DeepCollectionEquality().equals(
              other._openingHours,
              _openingHours,
            ) &&
            const DeepCollectionEquality().equals(
              other._paymentMethods,
              _paymentMethods,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessName,
    checkoutNumber,
    slug,
    ownerId,
    categoryId,
    subCategoryId,
    selectedType,
    description,
    established,
    about,
    logo,
    contactDetails,
    locations,
    operationDetails,
    features,
    media,
    howToHearAboutDesiTracker,
    agreeToTermsConditions,
    hasCustomerTestimonials,
    isActive,
    isHalal,
    isTrash,
    isDeleted,
    const DeepCollectionEquality().hash(_openingHours),
    const DeepCollectionEquality().hash(_paymentMethods),
  ]);

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessImplCopyWith<_$BusinessImpl> get copyWith =>
      __$$BusinessImplCopyWithImpl<_$BusinessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessImplToJson(this);
  }
}

abstract class _Business implements Business {
  const factory _Business({
    @JsonKey(name: '_id', fromJson: _idFromObject) required final String id,
    final String businessName,
    final String checkoutNumber,
    final String slug,
    @JsonKey(name: 'owner', fromJson: _idFromObject) final String ownerId,
    @JsonKey(name: 'category', fromJson: _idFromObject) final String categoryId,
    @JsonKey(name: 'subCategory', fromJson: _idFromObject)
    final String? subCategoryId,
    final String? selectedType,
    final String description,
    final DateTime? established,
    final String about,
    final String logo,
    required final ContactDetails contactDetails,
    required final LocationDetails locations,
    required final OperationDetails operationDetails,
    required final Features features,
    required final Media media,
    final String howToHearAboutDesiTracker,
    final bool agreeToTermsConditions,
    final bool hasCustomerTestimonials,
    final bool isActive,
    final bool isHalal,
    final bool isTrash,
    final bool isDeleted,
    final List<OpeningHour> openingHours,
    final List<String> paymentMethods,
  }) = _$BusinessImpl;

  factory _Business.fromJson(Map<String, dynamic> json) =
      _$BusinessImpl.fromJson;

  @override
  @JsonKey(name: '_id', fromJson: _idFromObject)
  String get id;
  @override
  String get businessName;
  @override
  String get checkoutNumber;
  @override
  String get slug;
  @override
  @JsonKey(name: 'owner', fromJson: _idFromObject)
  String get ownerId;
  @override
  @JsonKey(name: 'category', fromJson: _idFromObject)
  String get categoryId;
  @override
  @JsonKey(name: 'subCategory', fromJson: _idFromObject)
  String? get subCategoryId;
  @override
  String? get selectedType;
  @override
  String get description;
  @override
  DateTime? get established;
  @override
  String get about;
  @override
  String get logo;
  @override
  ContactDetails get contactDetails;
  @override
  LocationDetails get locations;
  @override
  OperationDetails get operationDetails;
  @override
  Features get features;
  @override
  Media get media;
  @override
  String get howToHearAboutDesiTracker;
  @override
  bool get agreeToTermsConditions;
  @override
  bool get hasCustomerTestimonials;
  @override
  bool get isActive;
  @override
  bool get isHalal;
  @override
  bool get isTrash;
  @override
  bool get isDeleted;
  @override
  List<OpeningHour> get openingHours;
  @override
  List<String> get paymentMethods;

  /// Create a copy of Business
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessImplCopyWith<_$BusinessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
