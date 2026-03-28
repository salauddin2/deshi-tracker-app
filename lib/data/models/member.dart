import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    @JsonKey(name: '_id') String? id,
    @Default('') String name,
    @Default('') String email,
    String? phone,
    @JsonKey(name: 'serialNumber') String? serial,
    @JsonKey(name: 'qrSlug') String? slug,
    @JsonKey(name: 'active') @Default(false) bool isActive,
    String? profileImageUrl,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
