import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class TutorielScreen extends StatelessWidget {
  const TutorielScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final organicColor = isDark ? AppTheme.organic : AppTheme.organicLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow(text: 'Bienvenue'),
              const SizedBox(height: 8),
              Text(
                'Comment ça marche ?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 26),
              Expanded(
                child: Column(
                  children: [
                    _buildStep(
                      context,
                      number: '1',
                      title: 'Scannez votre déchet',
                      description:
                          'L\'IA identifie la catégorie en quelques secondes.',
                      color: accentColor,
                    ),
                    const SizedBox(height: 18),
                    _buildStep(
                      context,
                      number: '2',
                      title: 'Suivez la recommandation',
                      description:
                          'Filière de valorisation et point de dépôt le plus proche.',
                      color: organicColor,
                    ),
                    const SizedBox(height: 18),
                    _buildStep(
                      context,
                      number: '3',
                      title: 'Déposez et gagnez des points',
                      description:
                          'Échangez vos points contre des récompenses locales.',
                      color: goldColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/accueil_menage'),
                  child: const Text('Commencer'),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => context.push('/accueil_menage'),
                child: Center(
                  child: Text(
                    'Passer',
                    style: TextStyle(
                      fontSize: 12.5,
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
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Space Grotesk',
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
