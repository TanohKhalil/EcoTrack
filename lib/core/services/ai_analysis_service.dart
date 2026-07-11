class AiClassificationResult {
  const AiClassificationResult({
    required this.category,
    required this.confidence,
    required this.detail,
    required this.recommendation,
    required this.depositPoint,
    required this.distance,
    required this.distanceKm,
    required this.points,
    required this.impactKg,
  });

  final String category;
  final int confidence;
  final String detail;
  final String recommendation;
  final String depositPoint;
  final String distance;
  final double distanceKm;
  final int points;
  final int impactKg;
}

class AiAnalysisService {
  static AiClassificationResult buildResultFromInput({
    required String userText,
  }) {
    final normalized = userText.toLowerCase();

    if (normalized.contains('plast') ||
        normalized.contains('bouteille') ||
        normalized.contains('sac')) {
      return const AiClassificationResult(
        category: 'PLASTIQUE · RECYCLABLE',
        confidence: 92,
        detail: 'Bouteille ou emballage plastique détecté',
        recommendation: 'Unité de recyclage · Marcory',
        depositPoint: 'Bac de tri — Rue 12',
        distance: '1,2 km · dépôt sous 24h recommandé',
        distanceKm: 1.2,
        points: 25,
        impactKg: 38,
      );
    }

    if (normalized.contains('organi') ||
        normalized.contains('aliment') ||
        normalized.contains('banane') ||
        normalized.contains('épluch')) {
      return const AiClassificationResult(
        category: 'ORGANIQUE · COMPOSTABLE',
        confidence: 91,
        detail: 'Épluchures & résidus alimentaires',
        recommendation: 'Unité de compost · Yopougon',
        depositPoint: 'Bac communautaire — Rue 12',
        distance: '1,8 km · dépôt sous 24h recommandé',
        distanceKm: 1.8,
        points: 25,
        impactKg: 38,
      );
    }

    if (normalized.contains('metal') ||
        normalized.contains('verre') ||
        normalized.contains('canette')) {
      return const AiClassificationResult(
        category: 'MÉTAL/VERRE · TRI SELECTIF',
        confidence: 88,
        detail: 'Conteneur métallique ou en verre',
        recommendation: 'Centre de tri · Treichville',
        depositPoint: 'Point de collecte — Plateau',
        distance: '2,4 km · dépôt sous 24h recommandé',
        distanceKm: 2.4,
        points: 20,
        impactKg: 24,
      );
    }

    return const AiClassificationResult(
      category: 'DÉCHET MIXTE · À VALORISER',
      confidence: 84,
      detail: 'Déchet mixte identifié par l’IA',
      recommendation: 'Centre de tri · Cocody',
      depositPoint: 'Bac communautaire — Rue 12',
      distance: '1,6 km · dépôt sous 24h recommandé',
      distanceKm: 1.6,
      points: 18,
      impactKg: 22,
    );
  }
}
