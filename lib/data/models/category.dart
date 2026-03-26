import 'package:freezed_annotation/freezed_annotation.dart';


part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: '_id') required String id,
    @Default('') String name,
    @Default('') String icon,
    @Default('') String slug,
    @Default('') String details,
    @Default([]) List<String> subCategories,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
