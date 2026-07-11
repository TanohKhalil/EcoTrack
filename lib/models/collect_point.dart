import 'package:flutter/foundation.dart';

@immutable
class CollectPoint {
  final String id;
  final String nom;
  final String categorie;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final int remplissageIotPct;
  final String horaires;
  final List<String> dechetsAcceptes;
  final List<String> dechetsExclus;
  final String gestionnaire;
  final String? colorName;

  const CollectPoint({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.remplissageIotPct,
    required this.horaires,
    required this.dechetsAcceptes,
    required this.dechetsExclus,
    required this.gestionnaire,
    this.colorName,
  });

  factory CollectPoint.fromJson(Map<String, dynamic> json) {
    return CollectPoint(
      id: json['id'] as String,
      nom: json['nom'] as String,
      categorie: json['categorie'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      remplissageIotPct: (json['remplissage_iot_pct'] as num).toInt(),
      horaires: json['horaires'] as String,
      dechetsAcceptes:
          (json['dechets_acceptes'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
      dechetsExclus:
          (json['dechets_exclus'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
      gestionnaire: json['gestionnaire'] as String,
      colorName: json['color_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'categorie': categorie,
      'latitude': latitude,
      'longitude': longitude,
      'distance_km': distanceKm,
      'remplissage_iot_pct': remplissageIotPct,
      'horaires': horaires,
      'dechets_acceptes': dechetsAcceptes,
      'dechets_exclus': dechetsExclus,
      'gestionnaire': gestionnaire,
      'color_name': colorName,
    };
  }
}
