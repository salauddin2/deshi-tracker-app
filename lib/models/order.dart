
class OrderItem {
  final String product;
  final String productName;
  final double price;
  final int quantity;
  final List<String>? selectedOptions;

  OrderItem({
    required this.product,
    required this.productName,
    required this.price,
    required this.quantity,
    this.selectedOptions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: json['product'] ?? '',
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      selectedOptions: json['selectedOptions'] != null 
          ? List<String>.from(json['selectedOptions']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      if (selectedOptions != null) 'selectedOptions': selectedOptions,
    };
  }
}

enum OrderStatus { pending, confirmed, processing, shipped, delivered, cancelled }

class Order {
  final String? id;
  final String user;
  final String business;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? shippingAddress;
  final DateTime? createdAt;

  Order({
    this.id,
    required this.user,
    required this.business,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    this.paymentStatus,
    this.paymentMethod,
    this.shippingAddress,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      user: json['user'] ?? '',
      business: json['business'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: _parseOrderStatus(json['status']),
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      shippingAddress: json['shippingAddress'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  static OrderStatus _parseOrderStatus(String? status) {
    switch (status) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'user': user,
      'business': business,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (shippingAddress != null) 'shippingAddress': shippingAddress,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
