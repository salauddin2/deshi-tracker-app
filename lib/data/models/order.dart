import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    @Default('') String product,
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
    String? id,
    @Default('') String user,
    @Default('') String business,
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
