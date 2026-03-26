import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserContact with _$UserContact {
  const factory UserContact({
    @Default('') String address,
    @Default('') String subArea,
    @Default('') String district,
    @Default('') String state,
    @Default('') String country,
  }) = _UserContact;

  factory UserContact.fromJson(Map<String, dynamic> json) => _$UserContactFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    required String name,
    @Default('new') String userStatus,
    required String email,
    required String phone,
    String? fbProfile,
    String? profilePic,
    @Default('user') String role,
    @Default(UserContact()) UserContact contact,
    @Default(false) bool isBlocked,
    @Default(false) bool isDeleted,
    String? profilePicUrl,
    String? serialNumber,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
