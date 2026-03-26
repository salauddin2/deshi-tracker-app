import 'package:freezed_annotation/freezed_annotation.dart';


part 'day_offer.freezed.dart';
part 'day_offer.g.dart';

@freezed
class DayOffer with _$DayOffer {
  const factory DayOffer({
    required String id,
    @Default('') String day,
    @Default(0.0) double discountPercent,
    DateTime? startDate,
    DateTime? endDate,
    @Default('') String businessId,
    String? productCategoryId,
    @Default(true) bool isActive,
  }) = _DayOffer;

  factory DayOffer.fromJson(Map<String, dynamic> json) => _$DayOfferFromJson(json);
}
