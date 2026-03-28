import 'package:freezed_annotation/freezed_annotation.dart';


part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: '_id', fromJson: _idFromObject) required String id,
    @Default('') String name,
    @Default('') String icon,
    @Default('') String slug,
    @Default('') String details,
    @JsonKey(fromJson: _idsFromList) @Default([]) List<String> subCategories,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

String _idFromObject(dynamic val) {
  if (val is Map) return val['_id']?.toString() ?? val['id']?.toString() ?? '';
  return val?.toString() ?? '';
}

List<String> _idsFromList(dynamic val) {
  if (val is List) {
    return val.map<String>((e) {
      if (e is Map) return e['_id']?.toString() ?? e['id']?.toString() ?? '';
      return e.toString();
    }).toList();
  }
  return [];
}
