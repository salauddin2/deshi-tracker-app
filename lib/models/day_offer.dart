
class DayOffer {
  final String? id;
  final String productId;
  final String businessId;
  final double offerPrice;
  final String day; // e.g., 'Monday', 'Tuesday'
  final bool isActive;

  DayOffer({
    this.id,
    required this.productId,
    required this.businessId,
    required this.offerPrice,
    required this.day,
    this.isActive = true,
  });

  factory DayOffer.fromJson(Map<String, dynamic> json) {
    return DayOffer(
      id: json['_id'],
      productId: json['productId'] ?? '',
      businessId: json['businessId'] ?? '',
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      day: json['day'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'productId': productId,
      'businessId': businessId,
      'offerPrice': offerPrice,
      'day': day,
      'isActive': isActive,
    };
  }
}
