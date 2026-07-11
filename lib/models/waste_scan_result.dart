import 'package:flutter/foundation.dart';

@immutable
class WasteScanResult {
  final String id;
  final String userId;
  final String categorie;
  final int confiance;
  final String detail;
  final String recommendation;
  final String depositPoint;
  final double distanceKm;
  final int points;
  final int impactKg;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WasteScanResult({
    required this.id,
    required this.userId,
    required this.categorie,
    required this.confiance,
    required this.detail,
    required this.recommendation,
    required this.depositPoint,
    required this.distanceKm,
    required this.points,
    required this.impactKg,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WasteScanResult.fromJson(Map<String, dynamic> json) {
    return WasteScanResult(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categorie: json['categorie'] as String,
      confiance: (json['confiance'] as num).toInt(),
      detail: json['detail'] as String,
      recommendation: json['recommendation'] as String,
      depositPoint: json['deposit_point'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      points: (json['points'] as num).toInt(),
      impactKg: (json['impact_kg'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'categorie': categorie,
      'confiance': confiance,
      'detail': detail,
      'recommendation': recommendation,
      'deposit_point': depositPoint,
      'distance_km': distanceKm,
      'points': points,
      'impact_kg': impactKg,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
