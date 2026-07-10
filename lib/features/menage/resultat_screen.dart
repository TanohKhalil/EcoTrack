import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class ResultatScreen extends StatelessWidget {
  const ResultatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final organicColor = isDark ? AppTheme.organic : AppTheme.organicLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with image
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.deep.withValues(alpha: 0.5),
                      Colors.transparent,
                      bgColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 22,
                      child: IconBtn(
                        onTap: () => context.pop(),
                        icon: Icons.arrow_back_ios_new,
                        color: textColor,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 22,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: accentColor),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '91%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                                fontFamily: 'Space Grotesk',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CONFIANCE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: accentColor.withValues(alpha: 0.9),
                                    fontFamily: 'Space Grotesk',
                                    height: 1.2,
                                  ),
                                ),
                                Text(
                                  'IA',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: accentColor.withValues(alpha: 0.9),
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Eyebrow(
                            text: 'ORGANIQUE · COMPOSTABLE',
                            color: AppTheme.organic,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Épluchures & résidus\n'
                            'alimentaires',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontFamily: 'Space Grotesk',
                              height: 0.98,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow(text: 'FILIÈRE DE VALORISATION RECOMMANDÉE'),
                    const SizedBox(height: 11),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: organicColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: organicColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.eco_outlined,
                              color: AppTheme.organic,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unité de compost · Yopougon',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                                Text(
                                  '1,8 km · dépôt sous 24h recommandé',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                    color: textColor.withValues(alpha: 0.5),
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Eyebrow(text: 'POINT DE DÉPÔT LE PLUS PROCHE'),
                    const SizedBox(height: 11),
                    GestureDetector(
                      onTap: () => context.push('/carte'),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: AppTheme.accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bac communautaire — Rue 12',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                      fontFamily: 'Space Grotesk',
                                    ),
                                  ),
                                  Text(
                                    'Remplissage capteur IoT : 42%',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: textColor.withValues(alpha: 0.5),
                                      fontFamily: 'Space Grotesk',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: accentColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            goldColor.withValues(alpha: 0.14),
                            goldColor.withValues(alpha: 0.03),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: goldColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: goldColor.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Icon(
                              Icons.bolt,
                              color: AppTheme.gold,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '+ 25 points gagnés',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: goldColor,
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                                Text(
                                  'Impact cumulé : 38 kg valorisés ce mois-ci',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: textColor.withValues(alpha: 0.55),
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push('/signalement'),
                            child: const Text('Signaler un dépôt'),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.push('/accueil_menage'),
                            child: const Text('Terminer'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => context.push('/vote_communautaire'),
                      child: Center(
                        child: Text(
                          'Classification incorrecte ? Aider à corriger',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: textColor.withValues(alpha: 0.4),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
