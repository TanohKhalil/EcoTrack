import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/toast.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';
class AccueilFiliereScreen extends StatelessWidget {
  const AccueilFiliereScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final organicColor = isDark ? AppTheme.organic : AppTheme.organicLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
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
                    onTap: traceCallback("accueil_filiere_screen.dart:31:onTap", () => context.pop()),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: organicColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: organicColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      'Filière de valorisation',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: organicColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Unité de compost — Yopougon',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Coopérative EcoTerre CI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 22),
              const Eyebrow(
                text: 'VOLUMES DISPONIBLES PAR ZONE',
                color: AppTheme.organic,
              ),
              const SizedBox(height: 11),
              _buildVolumeCard(context, 'Marcory', '1,2 t disponible'),
              const SizedBox(height: 10),
              _buildVolumeCard(context, 'Koumassi', '870 kg disponible'),
              const SizedBox(height: 10),
              _buildVolumeCard(context, 'Cocody', '2,4 t disponible'),
              const SizedBox(height: 22),
              const Eyebrow(text: 'PRÉVISION IA · 7 PROCHAINS JOURS'),
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
                        _buildChartBar(context, 38, 0.35),
                        _buildChartBar(context, 52, 0.45),
                        _buildChartBar(context, 44, 0.55),
                        _buildChartBar(context, 70, 1.0),
                        _buildChartBar(context, 58, 0.55),
                        _buildChartBar(context, 34, 0.4),
                        _buildChartBar(context, 48, 0.5),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Pic attendu jeudi (jour de marché) · Random Forest',
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showToast(
                      context,
                      'Lot réservé — le collecteur sera notifié',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: organicColor,
                    foregroundColor: const Color(0xFF1A0E04),
                  ),
                  child: const Text('Réserver un lot'),
                ),
              ),
              const SizedBox(height: 11),
              OutlinedButton(
                onPressed: traceCallback("accueil_filiere_screen.dart:148:onPressed", () => context.push('/marketplace')),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Voir la marketplace des produits recyclés'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeCard(BuildContext context, String zone, String volume) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final organicColor = isDark ? AppTheme.organic : AppTheme.organicLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: organicColor.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            zone,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
              fontFamily: 'Space Grotesk',
            ),
          ),
          Text(
            volume,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: organicColor,
              fontFamily: 'Space Grotesk',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, double height, double opacity) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final organicColor = isDark ? AppTheme.organic : AppTheme.organicLight;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: height,
        decoration: BoxDecoration(
          color: organicColor.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
