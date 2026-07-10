import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';
class CguScreen extends StatelessWidget {
  const CguScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBtn(
                    onTap: traceCallback("cgu_screen.dart:27:onTap", () => context.pop()),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'CGU & confidentialité',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildSection(
                context,
                '1. Données collectées.',
                'EcoTrack collecte votre nom, numéro, localisation approximative et vos historiques de tri afin d\'améliorer la collecte et la valorisation des déchets.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                '2. Usage des photos.',
                'Les photos de déchets et de signalements sont utilisées pour entraîner le modèle de classification IA et ne sont jamais revendues.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                '3. Partage institutionnel.',
                'Des données agrégées et anonymisées peuvent être partagées avec les mairies et partenaires (AFD, PNUD).',
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                '4. Vos droits.',
                'Vous pouvez à tout moment demander l\'export ou la suppression de vos données depuis Paramètres → Aide & FAQ.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: 'Space Grotesk',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: textColor.withValues(alpha: 0.6),
            fontFamily: 'Space Grotesk',
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
