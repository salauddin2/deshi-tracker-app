
class RotaRole {
  final String? id;
  final String name;
  final String businessId;
  final String? description;

  RotaRole({
    this.id,
    required this.name,
    required this.businessId,
    this.description,
  });

  factory RotaRole.fromJson(Map<String, dynamic> json) {
    return RotaRole(
      id: json['_id'],
      name: json['name'] ?? '',
      businessId: json['businessId'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'businessId': businessId,
      if (description != null) 'description': description,
    };
  }
}

class RotaEmployee {
  final String? id;
  final String userId;
  final String businessId;
  final List<String> roleIds;
  final String status;

  RotaEmployee({
    this.id,
    required this.userId,
    required this.businessId,
    required this.roleIds,
    this.status = 'active',
  });

  factory RotaEmployee.fromJson(Map<String, dynamic> json) {
    return RotaEmployee(
      id: json['_id'],
      userId: json['userId'] ?? '',
      businessId: json['businessId'] ?? '',
      roleIds: List<String>.from(json['roleIds'] ?? []),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'businessId': businessId,
      'roleIds': roleIds,
      'status': status,
    };
  }
}

class RotaShift {
  final String? id;
  final String employeeId;
  final String businessId;
  final DateTime startTime;
  final DateTime endTime;
  final String? notes;

  RotaShift({
    this.id,
    required this.employeeId,
    required this.businessId,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  factory RotaShift.fromJson(Map<String, dynamic> json) {
    return RotaShift(
      id: json['_id'],
      employeeId: json['employeeId'] ?? '',
      businessId: json['businessId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'employeeId': employeeId,
      'businessId': businessId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      if (notes != null) 'notes': notes,
    };
  }
}
