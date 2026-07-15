import '../../domain/entities/revenue_point.dart';

class RevenuePointModel extends RevenuePoint {
  const RevenuePointModel({required super.date, required super.totalRevenue});

  factory RevenuePointModel.fromJson(Map<String, dynamic> json) {
    return RevenuePointModel(
      date: DateTime.parse(json['date'] as String),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }

  RevenuePoint toEntity() => this;
}
