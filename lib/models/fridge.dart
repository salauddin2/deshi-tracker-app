
class Fridge {
  final String? id;
  final String userId;
  final String? name;
  final String? location;
  final DateTime? createdAt;

  Fridge({
    this.id,
    required this.userId,
    this.name,
    this.location,
    this.createdAt,
  });

  factory Fridge.fromJson(Map<String, dynamic> json) {
    return Fridge(
      id: json['_id'],
      userId: json['userId'] ?? '',
      name: json['name'],
      location: json['location'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}

class FridgeRecord {
  final String? id;
  final String fridgeId;
  final String? item;
  final double? temperature;
  final DateTime timestamp;

  FridgeRecord({
    this.id,
    required this.fridgeId,
    this.item,
    this.temperature,
    required this.timestamp,
  });

  factory FridgeRecord.fromJson(Map<String, dynamic> json) {
    return FridgeRecord(
      id: json['_id'],
      fridgeId: json['fridgeId'] ?? '',
      item: json['item'],
      temperature: (json['temperature'] ?? 0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'fridgeId': fridgeId,
      if (item != null) 'item': item,
      if (temperature != null) 'temperature': temperature,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
