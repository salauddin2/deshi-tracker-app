enum UserStatus { newStatus, suspicious, verified }

enum UserRole { user, admin, businessOwner }

class UserContact {
  final String address;
  final String subArea;
  final String district;
  final String state;
  final String country;

  UserContact({
    required this.address,
    required this.subArea,
    required this.district,
    required this.state,
    required this.country,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) {
    return UserContact(
      address: json['address'] ?? '',
      subArea: json['subArea'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'subArea': subArea,
      'district': district,
      'state': state,
      'country': country,
    };
  }
}

class User {
  final String id;
  final String name;
  final UserStatus userStatus;
  final String email;
  final String phone;
  final String fbProfile;
  final String profilePic;
  final UserRole role;
  final UserContact contact;
  final bool isBlocked;
  final bool isDeleted;
  final String? profilePicUrl;

  User({
    required this.id,
    required this.name,
    required this.userStatus,
    required this.email,
    required this.phone,
    required this.fbProfile,
    required this.profilePic,
    required this.role,
    required this.contact,
    required this.isBlocked,
    required this.isDeleted,
    this.profilePicUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      userStatus: _parseUserStatus(json['userStatus']),
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      fbProfile: json['fbProfile'] ?? '',
      profilePic: json['profilePic'] ?? '',
      role: _parseUserRole(json['role']),
      contact: UserContact.fromJson(json['contact'] ?? {}),
      isBlocked: json['isBlocked'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      profilePicUrl: json['profilePicUrl'],
    );
  }

  static UserStatus _parseUserStatus(String? status) {
    switch (status) {
      case 'suspicious':
        return UserStatus.suspicious;
      case 'verified':
        return UserStatus.verified;
      default:
        return UserStatus.newStatus;
    }
  }

  static UserRole _parseUserRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'business_owner':
        return UserRole.businessOwner;
      default:
        return UserRole.user;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'userStatus': userStatus.name.replaceAll('Status', ''),
      'email': email,
      'phone': phone,
      'fbProfile': fbProfile,
      'profilePic': profilePic,
      'role': role == UserRole.businessOwner ? 'business_owner' : role.name,
      'contact': contact.toJson(),
      'isBlocked': isBlocked,
      'isDeleted': isDeleted,
      'profilePicUrl': profilePicUrl,
    };
  }
}
