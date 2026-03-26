
class Member {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? serial;
  final String businessId;
  final String? slug;
  final bool isVerified;

  Member({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.serial,
    required this.businessId,
    this.slug,
    this.isVerified = false,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      serial: json['serial'],
      businessId: json['businessId'] ?? '',
      slug: json['slug'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (serial != null) 'serial': serial,
      'businessId': businessId,
      if (slug != null) 'slug': slug,
      'isVerified': isVerified,
    };
  }
}
