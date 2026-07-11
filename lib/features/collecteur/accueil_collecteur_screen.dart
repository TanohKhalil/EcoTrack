import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import '../../core/constants/mock_data.dart';

import 'package:ecotrack/core/utils/trace.dart';

class AccueilCollecteurScreen extends StatelessWidget {
  const AccueilCollecteurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final plasticColor = isDark ? AppTheme.plastic : AppTheme.plasticLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconBtn(
                    onTap: traceCallback(
                      "accueil_collecteur_screen.dart:33:onTap",
                      () => context.pop(),
                    ),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: plasticColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: plasticColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      'Espace Collecteur',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: plasticColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                  IconBtn(
                    onTap: traceCallback(
                      "accueil_collecteur_screen.dart:59:onTap",
                      () => context.push('/profil'),
                    ),
                    icon: Icons.person_outline,
                    color: textColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                MockData.collecteur.nom,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '★ ${MockData.collecteur.notation}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: goldColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '· ${MockData.collecteur.nombreCollectes} collectes · ${MockData.collecteur.zone}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.45),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              // Itinéraire
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: plasticColor.withValues(alpha: 0.28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Eyebrow(
                          text: 'ITINÉRAIRE OPTIMISÉ · IA',
                          color: AppTheme.plastic,
                        ),
                        Text(
                          '7 arrêts',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: plasticColor,
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...MockData.itineraire
                        .map((arret) => _buildItineraireItem(context, arret))
                        .toList(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: traceCallback(
                          "accueil_collecteur_screen.dart:139:onPressed",
                          () => context.push('/carte'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: plasticColor,
                          foregroundColor: const Color(0xFF04222E),
                        ),
                        child: const Text('Démarrer la tournée'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: traceCallback(
                        "accueil_collecteur_screen.dart:155:onTap",
                        () => context.push('/retrait_collecteur'),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '36 500',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                                fontFamily: 'Space Grotesk',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'FCFA · cette semaine',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w400,
                                color: textColor.withValues(alpha: 0.5),
                                fontFamily: 'Space Grotesk',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '312 kg',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'collectés · semaine',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              color: textColor.withValues(alpha: 0.5),
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'FORMATIONS COURTES'),
              const SizedBox(height: 11),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    _buildTrainingCard(
                      context,
                      'Tri & sécurité',
                      '6 min · vidéo',
                    ),
                    const SizedBox(width: 10),
                    _buildTrainingCard(
                      context,
                      'Hygiène terrain',
                      '4 min · vidéo',
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

  Widget _buildItineraireItem(BuildContext context, ItineraireArret arret) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final plasticColor = isDark ? AppTheme.plastic : AppTheme.plasticLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: arret.ordre == 1
                  ? plasticColor
                  : plasticColor.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                arret.ordre.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: arret.ordre == 1 ? AppTheme.accentInk : plasticColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showToast(context, 'Ouverture du détail de ${arret.lieu}');
                  },
                  child: Text(
                    arret.lieu,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ),
                Text(
                  '${arret.categorie.name} · ${arret.remplissagePct}% plein',
                  style: TextStyle(
                    fontSize: 11,
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
    );
  }

  Widget _buildTrainingCard(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return GestureDetector(
      onTap: () {
        showToast(context, 'Ouverture de la formation : $title');
        context.push('/aide');
      },
      child: Container(
        width: 132,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: textColor.withValues(alpha: 0.45),
                fontFamily: 'Space Grotesk',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
