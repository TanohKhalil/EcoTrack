import '../../models/models.dart';

export '../../models/models.dart';

class MockData {
  static const user = AppUser(
    id: '1',
    prenom: 'Aya',
    nom: 'Konan',
    localisation: 'Cocody',
    roleActif: UserRole.menage,
    rolesDisponibles: [UserRole.menage, UserRole.collecteur, UserRole.mairie],
    points: 1240,
    kgValorises: 184,
    moisActifs: 4,
    dateInscription: 'mars 2026',
  );

  static const collecteur = Collecteur(
    nom: 'Ibrahim K.',
    notation: 4.8,
    nombreCollectes: 214,
    zone: 'Koumassi',
    soldeFCFA: 36500,
    kgCollectesSemaine: 312,
  );

  static const impact = ImpactCarbone(
    tonnesCO2eEvitees: 2.4,
    equivalentArbres: 110,
    equivalentKmVoiture: 9800,
    certifie: true,
  );

  static const dashboard = DashboardMairie(
    commune: 'Koumassi',
    tauxCollectePct: 63,
    tonnesValoriseesMois: 14.2,
    depotsSauvagesActifs: 9,
    emploisSoutenus: 47,
  );

  static const pointsCollecte = [
    CollectPoint(
      nom: 'Bac communautaire — Rue 12',
      categorie: WasteCategory.organique,
      distanceKm: 0.9,
      remplissageIoTPct: 42,
      horaires: '6h – 19h',
      dechetsAcceptes: ['Épluchures', 'Résidus de marché'],
      dechetsExclus: ['Plastique'],
      gestionnaire: 'Mairie de Koumassi',
      colorName: 'accent',
    ),
    CollectPoint(
      nom: 'Point plastique — Cité SOGEFIHA',
      categorie: WasteCategory.plastique,
      distanceKm: 1.4,
      remplissageIoTPct: 63,
      horaires: '24h/24',
      dechetsAcceptes: ['Plastique', 'Verre', 'Métal'],
      dechetsExclus: ['Organique'],
      gestionnaire: 'Coopérative EcoTerre CI',
      colorName: 'plastic',
    ),
    CollectPoint(
      nom: 'Marché de Koumassi',
      categorie: WasteCategory.organique,
      distanceKm: 2.3,
      remplissageIoTPct: 91,
      horaires: '5h – 20h',
      dechetsAcceptes: ['Épluchures', 'Résidus alimentaires'],
      dechetsExclus: ['Plastique', 'Verre'],
      gestionnaire: 'Mairie de Koumassi',
      colorName: 'gold',
    ),
    CollectPoint(
      nom: 'Point verre / métal — Marcory Résidentiel',
      categorie: WasteCategory.metalVerre,
      distanceKm: 2.7,
      remplissageIoTPct: 55,
      horaires: '6h – 21h',
      dechetsAcceptes: ['Verre', 'Métal'],
      dechetsExclus: ['Organique', 'Plastique'],
      gestionnaire: 'Mairie de Marcory',
      colorName: 'blue',
    ),
  ];

  static const produitsMarketplace = [
    ProduitMarketplace(
      nom: 'Pavés recyclés (lot de 10)',
      fournisseur: 'EcoTerre CI · plastique valorisé',
      prixFCFA: 7500,
      categorie: 'Construction',
    ),
    ProduitMarketplace(
      nom: 'Compost bio — sac 25 kg',
      fournisseur: 'Unité de compost Yopougon',
      prixFCFA: 3000,
      categorie: 'Compost',
    ),
    ProduitMarketplace(
      nom: 'Mobilier scolaire (table-banc)',
      fournisseur: 'Coopérative Treichville · plastique + bois',
      prixFCFA: 28000,
      categorie: 'Mobilier',
    ),
    ProduitMarketplace(
      nom: 'Briquettes combustibles (5 kg)',
      fournisseur: 'Résidus organiques compactés',
      prixFCFA: 1500,
      categorie: 'Compost',
    ),
  ];

  static final scanHistory = [
    ScanHistoryEntry(
      categorie: 'Organique',
      points: 25,
      date: DateTime.now(),
      kg: 2.1,
      label: 'Aujourd\'hui, 09:14',
    ),
    ScanHistoryEntry(
      categorie: 'Plastique',
      points: 30,
      date: DateTime.now().subtract(Duration(days: 1)),
      kg: 1.4,
      label: 'Hier, 18:02',
    ),
    ScanHistoryEntry(
      categorie: 'Verre / métal',
      points: 20,
      date: DateTime.now().subtract(Duration(days: 2)),
      kg: 3.0,
      label: 'Lundi, 12:47',
    ),
    ScanHistoryEntry(
      categorie: 'Organique',
      points: 25,
      date: DateTime.now().subtract(Duration(days: 3)),
      kg: 1.9,
      label: 'Dimanche, 08:30',
    ),
    ScanHistoryEntry(
      categorie: 'Dangereux (pile)',
      points: 40,
      date: DateTime.now().subtract(Duration(days: 4)),
      kg: 0.2,
      label: 'Samedi, 16:12',
    ),
  ];

  static const itineraire = [
    ItineraireArret(
      ordre: 1,
      lieu: 'Rue 12, Marcory',
      categorie: WasteCategory.plastique,
      remplissagePct: 78,
    ),
    ItineraireArret(
      ordre: 2,
      lieu: 'Marché Koumassi',
      categorie: WasteCategory.organique,
      remplissagePct: 91,
    ),
    ItineraireArret(
      ordre: 3,
      lieu: 'Cité SOGEFIHA',
      categorie: WasteCategory.plastique,
      remplissagePct: 54,
    ),
  ];
}
