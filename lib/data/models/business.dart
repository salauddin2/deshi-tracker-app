import 'package:freezed_annotation/freezed_annotation.dart';

part 'business.freezed.dart';
part 'business.g.dart';

@freezed
class MediaUnit with _$MediaUnit {
  const factory MediaUnit({
    @Default('') String url,
    @Default('') String description,
  }) = _MediaUnit;

  factory MediaUnit.fromJson(Map<String, dynamic> json) => _$MediaUnitFromJson(json);
}

@freezed
class Media with _$Media {
  const factory Media({
    @Default([]) List<MediaUnit> thumbnail,
    @Default([]) List<MediaUnit> images,
    @Default([]) List<MediaUnit> videos,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

@freezed
class ContactDetails with _$ContactDetails {
  const factory ContactDetails({
    @Default('') String phoneNumber,
    @Default('') String email,
    @Default('') String websiteUrl,
    @Default('') String facebook,
    @Default('') String instagram,
    @Default('') String linkedin,
    @Default('') String twitter,
  }) = _ContactDetails;

  factory ContactDetails.fromJson(Map<String, dynamic> json) => _$ContactDetailsFromJson(json);
}

@freezed
class Branch with _$Branch {
  const factory Branch({
    String? branchName,
    @Default('') String address,
    @Default('') String postCode,
    @Default('') String city,
    @Default('') String state,
    @Default('') String country,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}

@freezed
class LocationDetails with _$LocationDetails {
  const factory LocationDetails({
    @Default('') String address,
    @Default('') String exactBusinessLocation,
    String? division,
    String? district,
    String? homeTown,
    String? thana,
    String? postCode,
    String? city,
    @Default('') String state,
    @Default('') String country,
    @Default(false) bool isMultipleLocation,
    @Default([]) List<Branch> branches,
    String? lat,
    String? long,
  }) = _LocationDetails;

  factory LocationDetails.fromJson(Map<String, dynamic> json) => _$LocationDetailsFromJson(json);
}

@freezed
class OperationDetails with _$OperationDetails {
  const factory OperationDetails({
    @Default({}) Map<String, dynamic> businessHours,
    @Default(false) bool provideHomeDelivery,
    @Default(false) bool provideOnlineService,
    @Default(false) bool offerInStorePickup,
    @Default(false) bool isParkingAvailable,
    @Default(false) bool offerOnlineBooking,
    @Default('') String onlineBookingLink,
    @Default('') String whatsappNumber,
    @Default('') String menuLink,
  }) = _OperationDetails;

  factory OperationDetails.fromJson(Map<String, dynamic> json) => _$OperationDetailsFromJson(json);
}

@freezed
class Features with _$Features {
  const factory Features({
    @Default('') String officialLanguage,
    String? secondLanguage,
    @Default(false) bool offerSpecialDiscount,
    @Default(false) bool isWheelChairAccessible,
    String? foodOptions,
  }) = _Features;

  factory Features.fromJson(Map<String, dynamic> json) => _$FeaturesFromJson(json);
}

@freezed
class OpeningHour with _$OpeningHour {
  const factory OpeningHour({
    @Default('') String day,
    String? start,
    String? end,
  }) = _OpeningHour;

  factory OpeningHour.fromJson(Map<String, dynamic> json) => _$OpeningHourFromJson(json);
}

@freezed
class Business with _$Business {
  const factory Business({
    @JsonKey(name: '_id') required String id,
    @Default('') String businessName,
    @Default('') String checkoutNumber,
    @Default('') String slug,
    @Default('') String ownerId,
    @Default('') String categoryId,
    String? subCategoryId,
    String? selectedType,
    @Default('') String description,
    DateTime? established,
    @Default('') String about,
    @Default('') String logo,
    required ContactDetails contactDetails,
    required LocationDetails locations,
    required OperationDetails operationDetails,
    required Features features,
    required Media media,
    @Default('') String howToHearAboutDesiTracker,
    @Default(false) bool agreeToTermsConditions,
    @Default(false) bool hasCustomerTestimonials,
    @Default(true) bool isActive,
    @Default(true) bool isHalal,
    @Default(false) bool isDeleted,
    @Default([]) List<OpeningHour> openingHours,
    @Default([]) List<String> paymentMethods,
  }) = _Business;

  factory Business.fromJson(Map<String, dynamic> json) => _$BusinessFromJson(json);
}
