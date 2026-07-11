import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final String id;
  final String userId;
  final String? fullName;
  final String? city;
  final String? avatarUrl;
  final int totalPoints;
  final String? level;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.userId,
    this.fullName,
    this.city,
    this.avatarUrl,
    required this.totalPoints,
    this.level,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      fullName: map['full_name'] as String?,
      city: map['city'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      totalPoints: (map['total_points'] as num?)?.toInt() ?? 0,
      level: map['level'] as String?,
      isAdmin: map['is_admin'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'city': city,
      'avatar_url': avatarUrl,
      'total_points': totalPoints,
      'level': level,
      'is_admin': isAdmin,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

@immutable
class Report {
  final String id;
  final String userId;
  final String? description;
  final String? photoUrl;
  final String status;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Report({
    required this.id,
    required this.userId,
    this.description,
    this.photoUrl,
    required this.status,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      description: map['description'] as String?,
      photoUrl: map['photo_url'] as String?,
      status: map['status'] as String? ?? 'pending',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
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

@immutable
class CollectionAssignment {
  final String id;
  final String? collectorId;
  final String reportId;
  final DateTime? scheduledAt;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CollectionAssignment({
    required this.id,
    this.collectorId,
    required this.reportId,
    this.scheduledAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CollectionAssignment.fromMap(Map<String, dynamic> map) {
    return CollectionAssignment(
      id: map['id'] as String,
      collectorId: map['collector_id'] as String?,
      reportId: map['report_id'] as String,
      scheduledAt: map['scheduled_at'] != null
          ? DateTime.parse(map['scheduled_at'] as String)
          : null,
      status: map['status'] as String? ?? 'assigned',
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collector_id': collectorId,
      'report_id': reportId,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

@immutable
class Reward {
  final String id;
  final String title;
  final int pointsCost;
  final String? description;
  final String? imageUrl;
  final bool available;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reward({
    required this.id,
    required this.title,
    required this.pointsCost,
    this.description,
    this.imageUrl,
    required this.available,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'] as String,
      title: map['title'] as String,
      pointsCost: (map['points_cost'] as num).toInt(),
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      available: map['available'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'points_cost': pointsCost,
      'description': description,
      'image_url': imageUrl,
      'available': available,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

@immutable
class Redemption {
  final String id;
  final String userId;
  final String rewardId;
  final String status;
  final DateTime requestedAt;
  final DateTime? reviewedAt;
  final DateTime updatedAt;

  const Redemption({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.status,
    required this.requestedAt,
    this.reviewedAt,
    required this.updatedAt,
  });

  factory Redemption.fromMap(Map<String, dynamic> map) {
    return Redemption(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      rewardId: map['reward_id'] as String,
      status: map['status'] as String? ?? 'requested',
      requestedAt: DateTime.parse(map['requested_at'] as String),
      reviewedAt: map['reviewed_at'] != null
          ? DateTime.parse(map['reviewed_at'] as String)
          : null,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'reward_id': rewardId,
      'status': status,
      'requested_at': requestedAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
