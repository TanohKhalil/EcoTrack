import 'package:flutter/foundation.dart';

@immutable
class ItineraireArret {
  final String id;
  final String collecteurId;
  final int ordre;
  final String lieu;
  final String categorie;
  final int remplissagePct;

  const ItineraireArret({
    required this.id,
    required this.collecteurId,
    required this.ordre,
    required this.lieu,
    required this.categorie,
    required this.remplissagePct,
  });

  factory ItineraireArret.fromJson(Map<String, dynamic> json) {
    return ItineraireArret(
      id: json['id'] as String,
      collecteurId: json['collecteur_id'] as String,
      ordre: (json['ordre'] as num).toInt(),
      lieu: json['lieu'] as String,
      categorie: json['categorie'] as String,
      remplissagePct: (json['remplissage_pct'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collecteur_id': collecteurId,
      'ordre': ordre,
      'lieu': lieu,
      'categorie': categorie,
      'remplissage_pct': remplissagePct,
    };
  }
}
