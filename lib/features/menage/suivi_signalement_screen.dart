import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';
class SuiviSignalementScreen extends StatelessWidget {
  const SuiviSignalementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: traceCallback("suivi_signalement_screen.dart:26:onTap", () => context.pop()),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 22),
              const Eyebrow(
                  text: 'Suivi du signalement', color: AppTheme.danger),
              const SizedBox(height: 8),
              Text(
                'Dépôt sauvage — Rue 12',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.2,
                ),
              ),
              Text(
                'Signalé le 8 juillet 2026 à 17:40',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 24),
              _buildTimelineStep(
                context,
                icon: Icons.check,
                title: 'Signalement envoyé',
                subtitle: '08/07 · 17:40',
                isCompleted: true,
              ),
              _buildTimelineStep(
                context,
                icon: Icons.check,
                title: 'Pris en charge par la mairie de Koumassi',
                subtitle: '09/07 · 08:12 · Agent : K. Yao',
                isCompleted: true,
              ),
              _buildTimelineStep(
                context,
                icon: Icons.access_time,
                title: 'Intervention planifiée',
                subtitle: 'Prévue le 11/07 · équipe de collecte',
                isCompleted: false,
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(14),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Photo jointe · voie ferrée, Koumassi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: textColor.withValues(alpha: 0.6),
                          fontFamily: 'Space Grotesk',
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

  Widget _buildTimelineStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isCompleted ? accentColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isCompleted
                      ? null
                      : Border.all(color: goldColor, width: 2),
                ),
                child: Icon(
                  icon,
                  size: 13,
                  color: isCompleted ? AppTheme.accentInk : goldColor,
                ),
              ),
              Container(
                width: 2,
                height: 38,
                color:
                    isCompleted ? accentColor : accentColor.withValues(alpha: 0.25),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? textColor : goldColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.45),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
