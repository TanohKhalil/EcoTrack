import 'package:flutter/foundation.dart';

import 'signalement_etape.dart';

@immutable
class Signalement {
  final String id;
  final String userId;
  final String? description;
  final String? photoUrl;
  final String status;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SignalementEtape> timeline;

  const Signalement({
    required this.id,
    required this.userId,
    this.description,
    this.photoUrl,
    required this.status,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.timeline = const [],
  });

  factory Signalement.fromJson(Map<String, dynamic> json) {
    return Signalement(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      description: json['description'] as String?,
      photoUrl: json['photo_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      timeline:
          (json['timeline'] as List<dynamic>?)
              ?.map(
                (item) =>
                    SignalementEtape.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'description': description,
      'photo_url': photoUrl,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
