import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

String _idFromObject(dynamic val) {
  if (val == null) return '';
  if (val is Map) return val['_id'] as String? ?? val['id'] as String? ?? '';
  if (val is String) return val;
  return '';
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    @JsonKey(name: 'productId', fromJson: _idFromObject) @Default('') String product,
    @Default('') String productName,
    @Default(0.0) double price,
    @Default(0) int quantity,
    List<String>? selectedOptions,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

enum OrderStatus { pending, confirmed, processing, shipped, delivered, cancelled }

@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'user_id', fromJson: _idFromObject) @Default('') String user,
    @JsonKey(name: 'business_id', fromJson: _idFromObject) @Default('') String business,
    @Default([]) List<OrderItem> items,
    @Default(0.0) double totalAmount,
    @Default(OrderStatus.pending) OrderStatus status,
    String? paymentStatus,
    String? paymentMethod,
    String? shippingAddress,
    DateTime? createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
