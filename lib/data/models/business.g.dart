// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaUnitImpl _$$MediaUnitImplFromJson(Map<String, dynamic> json) =>
    _$MediaUnitImpl(
      url: json['url'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$$MediaUnitImplToJson(_$MediaUnitImpl instance) =>
    <String, dynamic>{'url': instance.url, 'description': instance.description};

_$MediaImpl _$$MediaImplFromJson(Map<String, dynamic> json) => _$MediaImpl(
  thumbnail:
      (json['thumbnail'] as List<dynamic>?)
          ?.map((e) => MediaUnit.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => MediaUnit.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  videos:
      (json['videos'] as List<dynamic>?)
          ?.map((e) => MediaUnit.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MediaImplToJson(_$MediaImpl instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'images': instance.images,
      'videos': instance.videos,
    };

_$ContactDetailsImpl _$$ContactDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ContactDetailsImpl(
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
      facebook: json['facebook'] as String? ?? '',
      instagram: json['instagram'] as String? ?? '',
      linkedin: json['linkedin'] as String? ?? '',
      twitter: json['twitter'] as String? ?? '',
    );

Map<String, dynamic> _$$ContactDetailsImplToJson(
  _$ContactDetailsImpl instance,
) => <String, dynamic>{
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'websiteUrl': instance.websiteUrl,
  'facebook': instance.facebook,
  'instagram': instance.instagram,
  'linkedin': instance.linkedin,
  'twitter': instance.twitter,
};

_$BranchImpl _$$BranchImplFromJson(Map<String, dynamic> json) => _$BranchImpl(
  branchName: json['branchName'] as String?,
  address: json['address'] as String? ?? '',
  postCode: json['postCode'] as String? ?? '',
  city: json['city'] as String? ?? '',
  state: json['state'] as String? ?? '',
  country: json['country'] as String? ?? '',
);

Map<String, dynamic> _$$BranchImplToJson(_$BranchImpl instance) =>
    <String, dynamic>{
      'branchName': instance.branchName,
      'address': instance.address,
      'postCode': instance.postCode,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
    };

_$LocationDetailsImpl _$$LocationDetailsImplFromJson(
  Map<String, dynamic> json,
) => _$LocationDetailsImpl(
  address: json['address'] as String? ?? '',
  exactBusinessLocation: json['exactBusinessLocation'] as String? ?? '',
  division: json['division'] as String?,
  district: json['district'] as String?,
  homeTown: json['homeTown'] as String?,
  thana: json['thana'] as String?,
  postCode: json['postCode'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String? ?? '',
  country: json['country'] as String? ?? '',
  isMultipleLocation: json['isMultipleLocation'] as bool? ?? false,
  branches:
      (json['branches'] as List<dynamic>?)
          ?.map((e) => Branch.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  lat: json['lat'] as String?,
  long: json['long'] as String?,
);

Map<String, dynamic> _$$LocationDetailsImplToJson(
  _$LocationDetailsImpl instance,
) => <String, dynamic>{
  'address': instance.address,
  'exactBusinessLocation': instance.exactBusinessLocation,
  'division': instance.division,
  'district': instance.district,
  'homeTown': instance.homeTown,
  'thana': instance.thana,
  'postCode': instance.postCode,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
  'isMultipleLocation': instance.isMultipleLocation,
  'branches': instance.branches,
  'lat': instance.lat,
  'long': instance.long,
};

_$OperationDetailsImpl _$$OperationDetailsImplFromJson(
  Map<String, dynamic> json,
) => _$OperationDetailsImpl(
  businessHours: json['businessHours'] as Map<String, dynamic>? ?? const {},
  provideHomeDelivery: json['provideHomeDelivery'] as bool? ?? false,
  provideOnlineService: json['provideOnlineService'] as bool? ?? false,
  offerInStorePickup: json['offerInStorePickup'] as bool? ?? false,
  isParkingAvailable: json['isParkingAvailable'] as bool? ?? false,
  offerOnlineBooking: json['offerOnlineBooking'] as bool? ?? false,
  onlineBookingLink: json['onlineBookingLink'] as String? ?? '',
  whatsappNumber: json['whatsappNumber'] as String? ?? '',
  menuLink: json['menuLink'] as String? ?? '',
);

Map<String, dynamic> _$$OperationDetailsImplToJson(
  _$OperationDetailsImpl instance,
) => <String, dynamic>{
  'businessHours': instance.businessHours,
  'provideHomeDelivery': instance.provideHomeDelivery,
  'provideOnlineService': instance.provideOnlineService,
  'offerInStorePickup': instance.offerInStorePickup,
  'isParkingAvailable': instance.isParkingAvailable,
  'offerOnlineBooking': instance.offerOnlineBooking,
  'onlineBookingLink': instance.onlineBookingLink,
  'whatsappNumber': instance.whatsappNumber,
  'menuLink': instance.menuLink,
};

_$FeaturesImpl _$$FeaturesImplFromJson(Map<String, dynamic> json) =>
    _$FeaturesImpl(
      officialLanguage: json['officialLanguage'] as String? ?? '',
      secondLanguage: json['secondLanguage'] as String?,
      offerSpecialDiscount: json['offerSpecialDiscount'] as bool? ?? false,
      isWheelChairAccessible: json['isWheelChairAccessible'] as bool? ?? false,
      foodOptions: json['foodOptions'] as String?,
    );

Map<String, dynamic> _$$FeaturesImplToJson(_$FeaturesImpl instance) =>
    <String, dynamic>{
      'officialLanguage': instance.officialLanguage,
      'secondLanguage': instance.secondLanguage,
      'offerSpecialDiscount': instance.offerSpecialDiscount,
      'isWheelChairAccessible': instance.isWheelChairAccessible,
      'foodOptions': instance.foodOptions,
    };

_$OpeningHourImpl _$$OpeningHourImplFromJson(Map<String, dynamic> json) =>
    _$OpeningHourImpl(
      day: json['day'] as String? ?? '',
      start: json['start'] as String?,
      end: json['end'] as String?,
    );

Map<String, dynamic> _$$OpeningHourImplToJson(_$OpeningHourImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'start': instance.start,
      'end': instance.end,
    };

_$BusinessImpl _$$BusinessImplFromJson(
  Map<String, dynamic> json,
) => _$BusinessImpl(
  id: json['_id'] as String,
  businessName: json['businessName'] as String? ?? '',
  checkoutNumber: json['checkoutNumber'] as String? ?? '',
  slug: json['slug'] as String? ?? '',
  ownerId: json['ownerId'] as String? ?? '',
  categoryId: json['categoryId'] as String? ?? '',
  subCategoryId: json['subCategoryId'] as String?,
  selectedType: json['selectedType'] as String?,
  description: json['description'] as String? ?? '',
  established: json['established'] == null
      ? null
      : DateTime.parse(json['established'] as String),
  about: json['about'] as String? ?? '',
  logo: json['logo'] as String? ?? '',
  contactDetails: ContactDetails.fromJson(
    json['contactDetails'] as Map<String, dynamic>,
  ),
  locations: LocationDetails.fromJson(
    json['locations'] as Map<String, dynamic>,
  ),
  operationDetails: OperationDetails.fromJson(
    json['operationDetails'] as Map<String, dynamic>,
  ),
  features: Features.fromJson(json['features'] as Map<String, dynamic>),
  media: Media.fromJson(json['media'] as Map<String, dynamic>),
  howToHearAboutDesiTracker: json['howToHearAboutDesiTracker'] as String? ?? '',
  agreeToTermsConditions: json['agreeToTermsConditions'] as bool? ?? false,
  hasCustomerTestimonials: json['hasCustomerTestimonials'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  isHalal: json['isHalal'] as bool? ?? true,
  isDeleted: json['isDeleted'] as bool? ?? false,
  openingHours:
      (json['openingHours'] as List<dynamic>?)
          ?.map((e) => OpeningHour.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  paymentMethods:
      (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$BusinessImplToJson(_$BusinessImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'businessName': instance.businessName,
      'checkoutNumber': instance.checkoutNumber,
      'slug': instance.slug,
      'ownerId': instance.ownerId,
      'categoryId': instance.categoryId,
      'subCategoryId': instance.subCategoryId,
      'selectedType': instance.selectedType,
      'description': instance.description,
      'established': instance.established?.toIso8601String(),
      'about': instance.about,
      'logo': instance.logo,
      'contactDetails': instance.contactDetails,
      'locations': instance.locations,
      'operationDetails': instance.operationDetails,
      'features': instance.features,
      'media': instance.media,
      'howToHearAboutDesiTracker': instance.howToHearAboutDesiTracker,
      'agreeToTermsConditions': instance.agreeToTermsConditions,
      'hasCustomerTestimonials': instance.hasCustomerTestimonials,
      'isActive': instance.isActive,
      'isHalal': instance.isHalal,
      'isDeleted': instance.isDeleted,
      'openingHours': instance.openingHours,
      'paymentMethods': instance.paymentMethods,
    };
