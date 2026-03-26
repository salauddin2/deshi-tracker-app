class MediaUnit {
  final String url;
  final String description;

  MediaUnit({required this.url, required this.description});

  factory MediaUnit.fromJson(Map<String, dynamic> json) {
    return MediaUnit(
      url: json['url'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'description': description};
}

class Media {
  final List<MediaUnit> thumbnail;
  final List<MediaUnit> images;
  final List<MediaUnit> videos;

  Media({required this.thumbnail, required this.images, required this.videos});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      thumbnail: (json['thumbnail'] as List? ?? [])
          .map((e) => MediaUnit.fromJson(e))
          .toList(),
      images: (json['images'] as List? ?? [])
          .map((e) => MediaUnit.fromJson(e))
          .toList(),
      videos: (json['videos'] as List? ?? [])
          .map((e) => MediaUnit.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'thumbnail': thumbnail.map((e) => e.toJson()).toList(),
        'images': images.map((e) => e.toJson()).toList(),
        'videos': videos.map((e) => e.toJson()).toList(),
      };
}

class ContactDetails {
  final String phoneNumber;
  final String email;
  final String websiteUrl;
  final String facebook;
  final String instagram;
  final String linkedin;
  final String twitter;

  ContactDetails({
    required this.phoneNumber,
    required this.email,
    required this.websiteUrl,
    required this.facebook,
    required this.instagram,
    required this.linkedin,
    required this.twitter,
  });

  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return ContactDetails(
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      websiteUrl: json['websiteUrl'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      linkedin: json['linkedin'] ?? '',
      twitter: json['twitter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'email': email,
        'websiteUrl': websiteUrl,
        'facebook': facebook,
        'instagram': instagram,
        'linkedin': linkedin,
        'twitter': twitter,
      };
}

class Branch {
  final String? branchName;
  final String address;
  final String postCode;
  final String city;
  final String state;
  final String country;

  Branch({
    this.branchName,
    required this.address,
    required this.postCode,
    required this.city,
    required this.state,
    required this.country,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchName: json['branchName'],
      address: json['address'] ?? '',
      postCode: json['postCode'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'branchName': branchName,
        'address': address,
        'postCode': postCode,
        'city': city,
        'state': state,
        'country': country,
      };
}

class LocationDetails {
  final String address;
  final String exactBusinessLocation;
  final String? division;
  final String? district;
  final String? homeTown;
  final String? thana;
  final String? postCode;
  final String? city;
  final String state;
  final String country;
  final bool isMultipleLocation;
  final List<Branch> branches;
  final String? lat;
  final String? long;

  LocationDetails({
    required this.address,
    required this.exactBusinessLocation,
    this.division,
    this.district,
    this.homeTown,
    this.thana,
    this.postCode,
    this.city,
    required this.state,
    required this.country,
    required this.isMultipleLocation,
    required this.branches,
    this.lat,
    this.long,
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      address: json['address'] ?? '',
      exactBusinessLocation: json['exactBusinessLocation'] ?? '',
      division: json['division'],
      district: json['district'],
      homeTown: json['homeTown'],
      thana: json['thana'],
      postCode: json['postCode'],
      city: json['city'],
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      isMultipleLocation: json['isMultipleLocation'] ?? false,
      branches: (json['branches'] as List? ?? [])
          .map((e) => Branch.fromJson(e))
          .toList(),
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'exactBusinessLocation': exactBusinessLocation,
        'division': division,
        'district': district,
        'homeTown': homeTown,
        'thana': thana,
        'postCode': postCode,
        'city': city,
        'state': state,
        'country': country,
        'isMultipleLocation': isMultipleLocation,
        'branches': branches.map((e) => e.toJson()).toList(),
        'lat': lat,
        'long': long,
      };
}

class OperationDetails {
  final Map<String, dynamic> businessHours;
  final bool provideHomeDelivery;
  final bool provideOnlineService;
  final bool offerInStorePickup;
  final bool isParkingAvailable;
  final bool offerOnlineBooking;
  final String onlineBookingLink;
  final String whatsappNumber;
  final String menuLink;

  OperationDetails({
    required this.businessHours,
    required this.provideHomeDelivery,
    required this.provideOnlineService,
    required this.offerInStorePickup,
    required this.isParkingAvailable,
    required this.offerOnlineBooking,
    required this.onlineBookingLink,
    required this.whatsappNumber,
    required this.menuLink,
  });

  factory OperationDetails.fromJson(Map<String, dynamic> json) {
    return OperationDetails(
      businessHours: json['businessHours'] ?? {},
      provideHomeDelivery: json['provideHomeDelivery'] ?? false,
      provideOnlineService: json['provideOnlineService'] ?? false,
      offerInStorePickup: json['offerInStorePickup'] ?? false,
      isParkingAvailable: json['isParkingAvailable'] ?? false,
      offerOnlineBooking: json['offerOnlineBooking'] ?? false,
      onlineBookingLink: json['onlineBookingLink'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      menuLink: json['menuLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'businessHours': businessHours,
        'provideHomeDelivery': provideHomeDelivery,
        'provideOnlineService': provideOnlineService,
        'offerInStorePickup': offerInStorePickup,
        'isParkingAvailable': isParkingAvailable,
        'offerOnlineBooking': offerOnlineBooking,
        'onlineBookingLink': onlineBookingLink,
        'whatsappNumber': whatsappNumber,
        'menuLink': menuLink,
      };
}

class Features {
  final String officialLanguage;
  final String? secondLanguage;
  final bool offerSpecialDiscount;
  final bool isWheelChairAccessible;
  final String? foodOptions;

  Features({
    required this.officialLanguage,
    this.secondLanguage,
    required this.offerSpecialDiscount,
    required this.isWheelChairAccessible,
    this.foodOptions,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      officialLanguage: json['officialLanguage'] ?? '',
      secondLanguage: json['secondLanguage'],
      offerSpecialDiscount: json['offerSpecialDiscount'] ?? false,
      isWheelChairAccessible: json['isWheelChairAccessible'] ?? false,
      foodOptions: json['foodOptions'],
    );
  }

  Map<String, dynamic> toJson() => {
        'officialLanguage': officialLanguage,
        'secondLanguage': secondLanguage,
        'offerSpecialDiscount': offerSpecialDiscount,
        'isWheelChairAccessible': isWheelChairAccessible,
        'foodOptions': foodOptions,
      };
}

class OpeningHour {
  final String day;
  final String? start;
  final String? end;

  OpeningHour({required this.day, this.start, this.end});

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    return OpeningHour(
      day: json['day'] ?? '',
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() => {'day': day, 'start': start, 'end': end};
}

class Business {
  final String id;
  final String businessName;
  final String checkoutNumber;
  final String slug;
  final String ownerId;
  final String categoryId;
  final String? subCategoryId;
  final String? selectedType;
  final String description;
  final DateTime? established;
  final String about;
  final String logo;
  final ContactDetails contactDetails;
  final LocationDetails locations;
  final OperationDetails operationDetails;
  final Features features;
  final Media media;
  final String howToHearAboutDesiTracker;
  final bool agreeToTermsConditions;
  final bool hasCustomerTestimonials;
  final bool isActive;
  final bool isHalal;
  final bool isDeleted;
  final List<OpeningHour> openingHours;
  final List<String> paymentMethods;

  Business({
    required this.id,
    required this.businessName,
    required this.checkoutNumber,
    required this.slug,
    required this.ownerId,
    required this.categoryId,
    this.subCategoryId,
    this.selectedType,
    required this.description,
    this.established,
    required this.about,
    required this.logo,
    required this.contactDetails,
    required this.locations,
    required this.operationDetails,
    required this.features,
    required this.media,
    required this.howToHearAboutDesiTracker,
    required this.agreeToTermsConditions,
    required this.hasCustomerTestimonials,
    required this.isActive,
    required this.isHalal,
    required this.isDeleted,
    required this.openingHours,
    required this.paymentMethods,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['_id'] ?? '',
      businessName: json['businessName'] ?? '',
      checkoutNumber: json['checkoutNumber'] ?? '',
      slug: json['slug'] ?? '',
      ownerId: json['owner']?['_id'] ?? json['owner'] ?? '',
      categoryId: json['category']?['_id'] ?? json['category'] ?? '',
      subCategoryId: json['subCategory']?['_id'] ?? json['subCategory'],
      selectedType: json['selectedType'],
      description: json['description'] ?? '',
      established: json['established'] != null
          ? DateTime.tryParse(json['established'])
          : null,
      about: json['about'] ?? '',
      logo: json['logo'] ?? '',
      contactDetails: ContactDetails.fromJson(json['contactDetails'] ?? {}),
      locations: LocationDetails.fromJson(json['locations'] ?? {}),
      operationDetails: OperationDetails.fromJson(json['operationDetails'] ?? {}),
      features: Features.fromJson(json['features'] ?? {}),
      media: Media.fromJson(json['media'] ?? {}),
      howToHearAboutDesiTracker: json['howToHearAboutDesiTracker'] ?? '',
      agreeToTermsConditions: json['agreeToTermsConditions'] ?? false,
      hasCustomerTestimonials: json['hasCustomerTestimonials'] ?? false,
      isActive: json['isActive'] ?? true,
      isHalal: json['isHalal'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
      openingHours: (json['openingHours'] as List? ?? [])
          .map((e) => OpeningHour.fromJson(e))
          .toList(),
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'businessName': businessName,
        'checkoutNumber': checkoutNumber,
        'slug': slug,
        'owner': ownerId,
        'category': categoryId,
        'subCategory': subCategoryId,
        'selectedType': selectedType,
        'description': description,
        'established': established?.toIso8601String(),
        'about': about,
        'logo': logo,
        'contactDetails': contactDetails.toJson(),
        'locations': locations.toJson(),
        'operationDetails': operationDetails.toJson(),
        'features': features.toJson(),
        'media': media.toJson(),
        'howToHearAboutDesiTracker': howToHearAboutDesiTracker,
        'agreeToTermsConditions': agreeToTermsConditions,
        'hasCustomerTestimonials': hasCustomerTestimonials,
        'isActive': isActive,
        'isHalal': isHalal,
        'isDeleted': isDeleted,
        'openingHours': openingHours.map((e) => e.toJson()).toList(),
        'paymentMethods': paymentMethods,
      };
}
