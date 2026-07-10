import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/toast.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';
class FichePointScreen extends StatelessWidget {
  const FichePointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final organicColor = isDark ? AppTheme.organic : AppTheme.organicLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(color: cardColor),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 20,
                    child: IconBtn(
                      onTap: traceCallback("fiche_point_screen.dart:34:onTap", () => context.pop()),
                      icon: Icons.arrow_back_ios_new,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow(text: 'POINT DE COLLECTE · ORGANIQUE'),
                  const SizedBox(height: 6),
                  Text(
                    'Bac communautaire — Rue 12',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoCard(context, '42%', 'remplissage IoT'),
                      const SizedBox(width: 9),
                      _buildInfoCard(context, '6h – 19h', 'horaires d\'accès'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Eyebrow(text: 'DÉCHETS ACCEPTÉS'),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChipWidget(label: 'Épluchures', color: organicColor),
                      ChipWidget(
                        label: 'Résidus de marché',
                        color: organicColor,
                      ),
                      ChipWidget(label: '✕ Plastique', color: textColor),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Eyebrow(text: 'GESTIONNAIRE'),
                  const SizedBox(height: 9),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.apartment_outlined,
                            color: AppTheme.accent,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mairie de Koumassi',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                  fontFamily: 'Space Grotesk',
                                ),
                              ),
                              Text(
                                'Service de propreté urbaine',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: textColor.withValues(alpha: 0.45),
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
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: traceCallback("fiche_point_screen.dart:140:onPressed", () => context.push('/signalement')),
                          child: const Text('Signaler un problème'),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showToast(context, 'Itinéraire ouvert');
                          },
                          child: const Text('Itinéraire'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: textColor.withValues(alpha: 0.5),
                fontFamily: 'Space Grotesk',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
