import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  final String id;
  final String userId;
  final String? fullName;
  final String? city;
  final String? avatarUrl;
  final int totalPoints;
  final String roleActif;
  final List<String> rolesDisponibles;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUser({
    required this.id,
    required this.userId,
    this.fullName,
    this.city,
    this.avatarUrl,
    required this.totalPoints,
    required this.roleActif,
    required this.rolesDisponibles,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String?,
      city: json['city'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      roleActif: json['role_actif'] as String? ?? '',
      rolesDisponibles:
          (json['roles_disponibles'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
      isAdmin: json['is_admin'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'role_actif': roleActif,
      'roles_disponibles': rolesDisponibles,
      'is_admin': isAdmin,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
