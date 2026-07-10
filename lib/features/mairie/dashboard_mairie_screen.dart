import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import '../../core/constants/mock_data.dart';

import 'package:ecotrack/core/utils/trace.dart';
class DashboardMairieScreen extends StatelessWidget {
  const DashboardMairieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final blueColor = isDark ? AppTheme.blue : AppTheme.blueLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final dangerColor = isDark ? AppTheme.danger : AppTheme.dangerLight;
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
                    onTap: traceCallback("dashboard_mairie_screen.dart:33:onTap", () => context.pop()),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: blueColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: blueColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      'Dashboard B2G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: blueColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Commune de Koumassi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Rapport d\'impact · juillet 2026',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  _buildStatCard(context, '63%', 'taux de collecte', blueColor),
                  const SizedBox(width: 11),
                  _buildStatCard(
                    context,
                    '14,2 t',
                    'valorisées / mois',
                    textColor,
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  _buildStatCard(
                    context,
                    '9',
                    'dépôts sauvages actifs',
                    dangerColor,
                  ),
                  const SizedBox(width: 11),
                  _buildStatCard(
                    context,
                    '47',
                    'emplois soutenus',
                    accentColor,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Eyebrow(
                text: 'ZONES À RISQUE DE DÉPÔT SAUVAGE',
                color: AppTheme.blue,
              ),
              const SizedBox(height: 11),
              GestureDetector(
                onTap: traceCallback("dashboard_mairie_screen.dart:119:onTap", () => context.push('/carte')),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: blueColor.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: GridPainter(
                            blueColor.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      Positioned(top: 30, left: 35, child: _buildDangerPin()),
                      Positioned(top: 56, left: 64, child: _buildDangerPin()),
                      Positioned(
                        bottom: 10,
                        left: 12,
                        child: Text(
                          'Imagerie Sentinel-2 · caméras terrain',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textColor.withValues(alpha: 0.65),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Eyebrow(
                text: 'STATISTIQUES PAR QUARTIER',
                color: AppTheme.blue,
              ),
              const SizedBox(height: 11),
              _buildQuartierStat(context, 'Marcory', 74),
              const SizedBox(height: 9),
              _buildQuartierStat(context, 'Koumassi', 58),
              const SizedBox(height: 9),
              _buildQuartierStat(context, 'Treichville', 41),
              const SizedBox(height: 22),
              OutlinedButton(
                onPressed: traceCallback("dashboard_mairie_screen.dart:170:onPressed", () => context.push('/impact_carbone')),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: BorderSide(color: blueColor.withValues(alpha: 0.35)),
                  foregroundColor: blueColor,
                ),
                child: const Text('Voir les crédits carbone générés'),
              ),
              const SizedBox(height: 11),
              OutlinedButton(
                onPressed: () {
                  showToast(context, 'Génération du rapport PDF en cours…');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: BorderSide(color: blueColor.withValues(alpha: 0.35)),
                  foregroundColor: blueColor,
                ),
                child: const Text('Générer le rapport PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    Color valueColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: valueColor.withValues(alpha: 0.24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: valueColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
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
    );
  }

  Widget _buildDangerPin() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.danger.withValues(alpha: 0.5)),
          ),
        ),
        Container(
          width: 13,
          height: 13,
          decoration: const BoxDecoration(
            color: AppTheme.danger,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildQuartierStat(BuildContext context, String name, int percentage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final blueColor = isDark ? AppTheme.blue : AppTheme.blueLight;

    return Row(
      children: [
        SizedBox(
          width: 82,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor.withValues(alpha: 0.7),
              fontFamily: 'Space Grotesk',
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: blueColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: blueColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
