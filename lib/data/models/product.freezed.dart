// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductOption _$ProductOptionFromJson(Map<String, dynamic> json) {
  return _ProductOption.fromJson(json);
}

/// @nodoc
mixin _$ProductOption {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;

  /// Serializes this ProductOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductOptionCopyWith<ProductOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductOptionCopyWith<$Res> {
  factory $ProductOptionCopyWith(
    ProductOption value,
    $Res Function(ProductOption) then,
  ) = _$ProductOptionCopyWithImpl<$Res, ProductOption>;
  @useResult
  $Res call({String id, String name, List<String> choices});
}

/// @nodoc
class _$ProductOptionCopyWithImpl<$Res, $Val extends ProductOption>
    implements $ProductOptionCopyWith<$Res> {
  _$ProductOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? choices = null}) {
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
            choices: null == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductOptionImplCopyWith<$Res>
    implements $ProductOptionCopyWith<$Res> {
  factory _$$ProductOptionImplCopyWith(
    _$ProductOptionImpl value,
    $Res Function(_$ProductOptionImpl) then,
  ) = __$$ProductOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<String> choices});
}

/// @nodoc
class __$$ProductOptionImplCopyWithImpl<$Res>
    extends _$ProductOptionCopyWithImpl<$Res, _$ProductOptionImpl>
    implements _$$ProductOptionImplCopyWith<$Res> {
  __$$ProductOptionImplCopyWithImpl(
    _$ProductOptionImpl _value,
    $Res Function(_$ProductOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? choices = null}) {
    return _then(
      _$ProductOptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        choices: null == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductOptionImpl implements _ProductOption {
  const _$ProductOptionImpl({
    required this.id,
    this.name = '',
    final List<String> choices = const [],
  }) : _choices = choices;

  factory _$ProductOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductOptionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  final List<String> _choices;
  @override
  @JsonKey()
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  String toString() {
    return 'ProductOption(id: $id, name: $name, choices: $choices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._choices, _choices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_choices),
  );

  /// Create a copy of ProductOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductOptionImplCopyWith<_$ProductOptionImpl> get copyWith =>
      __$$ProductOptionImplCopyWithImpl<_$ProductOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductOptionImplToJson(this);
  }
}

abstract class _ProductOption implements ProductOption {
  const factory _ProductOption({
    required final String id,
    final String name,
    final List<String> choices,
  }) = _$ProductOptionImpl;

  factory _ProductOption.fromJson(Map<String, dynamic> json) =
      _$ProductOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get choices;

  /// Create a copy of ProductOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductOptionImplCopyWith<_$ProductOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get thumbnail => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  DateTime? get discountStart => throw _privateConstructorUsedError;
  DateTime? get discountEnd => throw _privateConstructorUsedError;
  double get finalPrice => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  List<dynamic> get options => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    double price,
    String currency,
    String thumbnail,
    List<String> images,
    double discountPercent,
    DateTime? discountStart,
    DateTime? discountEnd,
    double finalPrice,
    String businessId,
    String categoryId,
    List<dynamic> options,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? thumbnail = null,
    Object? images = null,
    Object? discountPercent = null,
    Object? discountStart = freezed,
    Object? discountEnd = freezed,
    Object? finalPrice = null,
    Object? businessId = null,
    Object? categoryId = null,
    Object? options = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnail: null == thumbnail
                ? _value.thumbnail
                : thumbnail // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            discountPercent: null == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                      as double,
            discountStart: freezed == discountStart
                ? _value.discountStart
                : discountStart // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            discountEnd: freezed == discountEnd
                ? _value.discountEnd
                : discountEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            finalPrice: null == finalPrice
                ? _value.finalPrice
                : finalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            businessId: null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    double price,
    String currency,
    String thumbnail,
    List<String> images,
    double discountPercent,
    DateTime? discountStart,
    DateTime? discountEnd,
    double finalPrice,
    String businessId,
    String categoryId,
    List<dynamic> options,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? thumbnail = null,
    Object? images = null,
    Object? discountPercent = null,
    Object? discountStart = freezed,
    Object? discountEnd = freezed,
    Object? finalPrice = null,
    Object? businessId = null,
    Object? categoryId = null,
    Object? options = null,
  }) {
    return _then(
      _$ProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnail: null == thumbnail
            ? _value.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        discountPercent: null == discountPercent
            ? _value.discountPercent
            : discountPercent // ignore: cast_nullable_to_non_nullable
                  as double,
        discountStart: freezed == discountStart
            ? _value.discountStart
            : discountStart // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        discountEnd: freezed == discountEnd
            ? _value.discountEnd
            : discountEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        finalPrice: null == finalPrice
            ? _value.finalPrice
            : finalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.id,
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.currency = 'GBP',
    this.thumbnail = '',
    final List<String> images = const [],
    this.discountPercent = 0.0,
    this.discountStart,
    this.discountEnd,
    this.finalPrice = 0.0,
    this.businessId = '',
    this.categoryId = '',
    final List<dynamic> options = const [],
  }) : _images = images,
       _options = options;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final String thumbnail;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final double discountPercent;
  @override
  final DateTime? discountStart;
  @override
  final DateTime? discountEnd;
  @override
  @JsonKey()
  final double finalPrice;
  @override
  @JsonKey()
  final String businessId;
  @override
  @JsonKey()
  final String categoryId;
  final List<dynamic> _options;
  @override
  @JsonKey()
  List<dynamic> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, currency: $currency, thumbnail: $thumbnail, images: $images, discountPercent: $discountPercent, discountStart: $discountStart, discountEnd: $discountEnd, finalPrice: $finalPrice, businessId: $businessId, categoryId: $categoryId, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountStart, discountStart) ||
                other.discountStart == discountStart) &&
            (identical(other.discountEnd, discountEnd) ||
                other.discountEnd == discountEnd) &&
            (identical(other.finalPrice, finalPrice) ||
                other.finalPrice == finalPrice) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    price,
    currency,
    thumbnail,
    const DeepCollectionEquality().hash(_images),
    discountPercent,
    discountStart,
    discountEnd,
    finalPrice,
    businessId,
    categoryId,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String id,
    final String name,
    final String description,
    final double price,
    final String currency,
    final String thumbnail,
    final List<String> images,
    final double discountPercent,
    final DateTime? discountStart,
    final DateTime? discountEnd,
    final double finalPrice,
    final String businessId,
    final String categoryId,
    final List<dynamic> options,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  String get currency;
  @override
  String get thumbnail;
  @override
  List<String> get images;
  @override
  double get discountPercent;
  @override
  DateTime? get discountStart;
  @override
  DateTime? get discountEnd;
  @override
  double get finalPrice;
  @override
  String get businessId;
  @override
  String get categoryId;
  @override
  List<dynamic> get options;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
