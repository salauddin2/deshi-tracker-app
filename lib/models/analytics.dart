
class BusinessAnalytics {
  final String businessId;
  final int totalOrders;
  final double totalRevenue;
  final int totalVisits;
  final List<CategoryShare> categoryDistribution;
  final List<DailyStats> dailyTrend;

  BusinessAnalytics({
    required this.businessId,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalVisits,
    required this.categoryDistribution,
    required this.dailyTrend,
  });

  factory BusinessAnalytics.fromJson(Map<String, dynamic> json) {
    return BusinessAnalytics(
      businessId: json['businessId'] ?? '',
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalVisits: json['totalVisits'] ?? 0,
      categoryDistribution: (json['categoryDistribution'] as List?)
              ?.map((e) => CategoryShare.fromJson(e))
              .toList() ??
          [],
      dailyTrend: (json['dailyTrend'] as List?)
              ?.map((e) => DailyStats.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CategoryShare {
  final String categoryName;
  final int count;
  final double percentage;

  CategoryShare({
    required this.categoryName,
    required this.count,
    required this.percentage,
  });

  factory CategoryShare.fromJson(Map<String, dynamic> json) {
    return CategoryShare(
      categoryName: json['categoryName'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}

class DailyStats {
  final String date;
  final int orders;
  final double revenue;

  DailyStats({
    required this.date,
    required this.orders,
    required this.revenue,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: json['date'] ?? '',
      orders: json['orders'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}
