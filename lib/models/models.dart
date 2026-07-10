import 'package:flutter/foundation.dart';

enum UserRole { menage, collecteur, filiere, mairie }

enum WasteCategory {
  plastique,
  organique,
  metalVerre,
  dangereux,
  eWaste,
  carton,
}

@immutable
class AppUser {
  final String id;
  final String prenom;
  final String nom;
  final String localisation;
  final UserRole roleActif;
  final List<UserRole> rolesDisponibles;
  final int points;
  final double kgValorises;
  final int moisActifs;
  final String dateInscription;

  const AppUser({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.localisation,
    required this.roleActif,
    required this.rolesDisponibles,
    required this.points,
    required this.kgValorises,
    required this.moisActifs,
    required this.dateInscription,
  });
}

@immutable
class WasteScanResult {
  final WasteCategory categorie;
  final double confianceIA;
  final String sousDetail;
  final String filiereRecommandee;
  final double distanceFiliereKm;
  final CollectPoint pointDepotProche;
  final int pointsGagnes;

  const WasteScanResult({
    required this.categorie,
    required this.confianceIA,
    required this.sousDetail,
    required this.filiereRecommandee,
    required this.distanceFiliereKm,
    required this.pointDepotProche,
    required this.pointsGagnes,
  });
}

@immutable
class CollectPoint {
  final String nom;
  final WasteCategory categorie;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final int remplissageIoTPct;
  final String horaires;
  final List<String> dechetsAcceptes;
  final List<String> dechetsExclus;
  final String gestionnaire;
  final String? colorName;

  const CollectPoint({
    required this.nom,
    required this.categorie,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.remplissageIoTPct,
    required this.horaires,
    required this.dechetsAcceptes,
    required this.dechetsExclus,
    required this.gestionnaire,
    this.colorName,
  });
}

@immutable
class Signalement {
  final String id;
  final String localisation;
  final String description;
  final String? photoUrl;
  final DateTime dateEnvoi;
  final List<SignalementEtape> timeline;

  const Signalement({
    required this.id,
    required this.localisation,
    required this.description,
    this.photoUrl,
    required this.dateEnvoi,
    required this.timeline,
  });
}

@immutable
class SignalementEtape {
  final String titre;
  final DateTime date;
  final String? agent;

  const SignalementEtape({required this.titre, required this.date, this.agent});
}

@immutable
class Collecteur {
  final String nom;
  final double notation;
  final int nombreCollectes;
  final String zone;
  final double soldeFCFA;
  final double kgCollectesSemaine;

  const Collecteur({
    required this.nom,
    required this.notation,
    required this.nombreCollectes,
    required this.zone,
    required this.soldeFCFA,
    required this.kgCollectesSemaine,
  });
}

@immutable
class ItineraireArret {
  final int ordre;
  final String lieu;
  final WasteCategory categorie;
  final int remplissagePct;

  const ItineraireArret({
    required this.ordre,
    required this.lieu,
    required this.categorie,
    required this.remplissagePct,
  });
}

@immutable
class ProduitMarketplace {
  final String nom;
  final String fournisseur;
  final int prixFCFA;
  final String categorie;

  const ProduitMarketplace({
    required this.nom,
    required this.fournisseur,
    required this.prixFCFA,
    required this.categorie,
  });
}

@immutable
class ImpactCarbone {
  final double tonnesCO2eEvitees;
  final int equivalentArbres;
  final int equivalentKmVoiture;
  final bool certifie;

  const ImpactCarbone({
    required this.tonnesCO2eEvitees,
    required this.equivalentArbres,
    required this.equivalentKmVoiture,
    required this.certifie,
  });
}

@immutable
class DashboardMairie {
  final String commune;
  final double tauxCollectePct;
  final double tonnesValoriseesMois;
  final int depotsSauvagesActifs;
  final int emploisSoutenus;

  const DashboardMairie({
    required this.commune,
    required this.tauxCollectePct,
    required this.tonnesValoriseesMois,
    required this.depotsSauvagesActifs,
    required this.emploisSoutenus,
  });
}

@immutable
class ScanHistoryEntry {
  final String categorie;
  final int points;
  final DateTime date;
  final double kg;
  final String label;

  const ScanHistoryEntry({
    required this.categorie,
    required this.points,
    required this.date,
    required this.kg,
    required this.label,
  });
}
