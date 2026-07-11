import 'package:flutter/foundation.dart';

@immutable
class Collecteur {
  final String id;
  final String userId;
  final double notation;
  final int nombreCollectes;
  final String zone;
  final double soldeFcfa;
  final double kgCollectesSemaine;

  const Collecteur({
    required this.id,
    required this.userId,
    required this.notation,
    required this.nombreCollectes,
    required this.zone,
    required this.soldeFcfa,
    required this.kgCollectesSemaine,
  });

  factory Collecteur.fromJson(Map<String, dynamic> json) {
    return Collecteur(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      notation: (json['notation'] as num).toDouble(),
      nombreCollectes: (json['nombre_collectes'] as num).toInt(),
      zone: json['zone'] as String,
      soldeFcfa: (json['solde_fcfa'] as num).toDouble(),
      kgCollectesSemaine: (json['kg_collectes_semaine'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'notation': notation,
      'nombre_collectes': nombreCollectes,
      'zone': zone,
      'solde_fcfa': soldeFcfa,
      'kg_collectes_semaine': kgCollectesSemaine,
    };
  }
}
