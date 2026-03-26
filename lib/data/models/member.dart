import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    String? id,
    @Default('') String name,
    @Default('') String email,
    String? phone,
    String? serial,
    @Default('') String businessId,
    String? slug,
    @Default(false) bool isVerified,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
