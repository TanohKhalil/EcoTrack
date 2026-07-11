import 'package:flutter/foundation.dart';

@immutable
class ImpactCarbone {
  final String id;
  final String userId;
  final double tonnesCo2eEvitees;
  final int equivalentArbres;
  final int equivalentKmVoiture;
  final bool certifie;

  const ImpactCarbone({
    required this.id,
    required this.userId,
    required this.tonnesCo2eEvitees,
    required this.equivalentArbres,
    required this.equivalentKmVoiture,
    required this.certifie,
  });

  factory ImpactCarbone.fromJson(Map<String, dynamic> json) {
    return ImpactCarbone(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      tonnesCo2eEvitees: (json['tonnes_co2e_evitees'] as num).toDouble(),
      equivalentArbres: (json['equivalent_arbres'] as num).toInt(),
      equivalentKmVoiture: (json['equivalent_km_voiture'] as num).toInt(),
      certifie: json['certifie'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tonnes_co2e_evitees': tonnesCo2eEvitees,
      'equivalent_arbres': equivalentArbres,
      'equivalent_km_voiture': equivalentKmVoiture,
      'certifie': certifie,
    };
  }
}
