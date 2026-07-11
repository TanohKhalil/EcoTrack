import 'package:flutter/foundation.dart';

@immutable
class DashboardMairie {
  final String id;
  final String commune;
  final double tauxCollectePct;
  final double tonnesValoriseesMois;
  final int depotsSauvagesActifs;
  final int emploisSoutenus;

  const DashboardMairie({
    required this.id,
    required this.commune,
    required this.tauxCollectePct,
    required this.tonnesValoriseesMois,
    required this.depotsSauvagesActifs,
    required this.emploisSoutenus,
  });

  factory DashboardMairie.fromJson(Map<String, dynamic> json) {
    return DashboardMairie(
      id: json['id'] as String,
      commune: json['commune'] as String,
      tauxCollectePct: (json['taux_collecte_pct'] as num).toDouble(),
      tonnesValoriseesMois: (json['tonnes_valorisees_mois'] as num).toDouble(),
      depotsSauvagesActifs: (json['depots_sauvages_actifs'] as num).toInt(),
      emploisSoutenus: (json['emplois_soutenus'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commune': commune,
      'taux_collecte_pct': tauxCollectePct,
      'tonnes_valorisees_mois': tonnesValoriseesMois,
      'depots_sauvages_actifs': depotsSauvagesActifs,
      'emplois_soutenus': emploisSoutenus,
    };
  }
}
