// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      product: json['productId'] == null
          ? ''
          : _idFromObject(json['productId']),
      productName: json['productName'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      selectedOptions: (json['selectedOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.product,
      'productName': instance.productName,
      'price': instance.price,
      'quantity': instance.quantity,
      'selectedOptions': instance.selectedOptions,
    };

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['_id'] as String?,
  user: json['user_id'] == null ? '' : _idFromObject(json['user_id']),
  business: json['business_id'] == null
      ? ''
      : _idFromObject(json['business_id']),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.pending,
  paymentStatus: json['paymentStatus'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  shippingAddress: json['shippingAddress'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.user,
      'business_id': instance.business,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'paymentStatus': instance.paymentStatus,
      'paymentMethod': instance.paymentMethod,
      'shippingAddress': instance.shippingAddress,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};
