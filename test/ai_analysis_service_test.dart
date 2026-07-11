import 'package:flutter_test/flutter_test.dart';
import 'package:ecotrack/core/services/ai_analysis_service.dart';

void main() {
  group('AiAnalysisService', () {
    test('returns an organic result for organic keywords', () {
      final result = AiAnalysisService.buildResultFromInput(
        userText: 'Épluchures de banane et déchets alimentaires',
      );

      expect(result.category, 'ORGANIQUE · COMPOSTABLE');
      expect(result.confidence, greaterThan(80));
      expect(result.recommendation, contains('compost'));
    });

    test('returns a plastic result for plastic keywords', () {
      final result = AiAnalysisService.buildResultFromInput(
        userText: 'Bouteille en plastique',
      );

      expect(result.category, 'PLASTIQUE · RECYCLABLE');
      expect(result.confidence, greaterThan(80));
      expect(result.depositPoint, contains('Bac de tri'));
    });
  });
}
