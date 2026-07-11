import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import '../../core/constants/mock_data.dart';

import 'package:ecotrack/core/utils/trace.dart';

class ImpactCarboneScreen extends StatelessWidget {
  const ImpactCarboneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final blueColor = isDark ? AppTheme.blue : AppTheme.blueLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: traceCallback(
                  "impact_carbone_screen.dart:29:onTap",
                  () => context.pop(),
                ),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'Monétisation carbone'),
              const SizedBox(height: 8),
              Text(
                'Impact carbone généré',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.16),
                          cardColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${MockData.impact.tonnesCO2eEvitees.toStringAsFixed(1)} t',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'CO₂e évitées depuis mars 2026',
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
                  Positioned(
                    top: -10,
                    right: 16,
                    child: Transform.rotate(
                      angle: 0.08,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: textColor,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.28),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Text(
                          '✓ CERTIFIÉ',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.03,
                            color: bgColor,
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'ÉQUIVALENCE'),
              const SizedBox(height: 11),
              _buildEquivalence(
                context,
                '🌳',
                '≈ ${MockData.impact.equivalentArbres} arbres plantés sur un an',
              ),
              const SizedBox(height: 9),
              _buildEquivalence(
                context,
                '🚗',
                '≈ ${MockData.impact.equivalentKmVoiture.toInt()} km évités en voiture',
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'GÉNÉRATION MENSUELLE'),
              const SizedBox(height: 11),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.14),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildChartBar(context, 30, 0.3),
                        _buildChartBar(context, 48, 0.45),
                        _buildChartBar(context, 62, 0.6),
                        _buildChartBar(context, 82, 1.0),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mars → Juillet 2026',
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
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: blueColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: blueColor.withValues(alpha: 0.28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pour les partenaires institutionnels',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: blueColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ces crédits carbone certifiés peuvent être valorisés auprès de bailleurs (AFD, PNUD) ou d\'entreprises en compensation volontaire.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textColor.withValues(alpha: 0.6),
                        fontFamily: 'Space Grotesk',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showToast(context, 'Certificat carbone exporté');
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        context.push('/historique');
                      }
                    });
                  },
                  child: const Text('Exporter le certificat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquivalence(BuildContext context, String emoji, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: textColor.withValues(alpha: 0.75),
                fontFamily: 'Space Grotesk',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, double height, double opacity) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: height,
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
