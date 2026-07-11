import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/constants/mock_data.dart';
import '../../providers/theme_provider.dart';
import '../../providers/offline_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecotrack/core/utils/trace.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final softColor = isDark ? AppTheme.soft : AppTheme.softLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final user = MockData.user;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 34),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                    center: Alignment.topRight,
                    radius: 0.6,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconBtn(
                          onTap: traceCallback(
                            "profil_screen.dart:48:onTap",
                            () => context.pop(),
                          ),
                          icon: Icons.arrow_back_ios_new,
                        ),
                        Row(
                          children: [
                            IconBtn(
                              onTap: () {
                                ref.read(offlineProvider.notifier).toggle();
                              },
                              icon: Icons.wifi_off_outlined,
                              color: softColor,
                            ),
                            const SizedBox(width: 9),
                            IconBtn(
                              onTap: () {
                                ref.read(themeProvider.notifier).toggleTheme();
                              },
                              icon: isDark
                                  ? Icons.wb_sunny_outlined
                                  : Icons.mode_night_outlined,
                              color: softColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 38,
                            color: AppTheme.soft,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${user.prenom} ${user.nom}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user.roleActif.name} · ${user.localisation} · membre depuis ${user.dateInscription}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: softColor.withValues(alpha: 0.85),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatCard(
                          context,
                          '${user.points}',
                          'points',
                          accentColor,
                        ),
                        const SizedBox(width: 9),
                        _buildStatCard(
                          context,
                          '${user.kgValorises.toInt()} kg',
                          'valorisés',
                          textColor,
                        ),
                        const SizedBox(width: 9),
                        _buildStatCard(
                          context,
                          '${user.moisActifs}',
                          'mois actifs',
                          textColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Eyebrow(text: 'HISTORIQUE & COMPTE'),
                    const SizedBox(height: 11),
                    _buildMenuItem(
                      context,
                      'Historique de tri',
                      () => context.push('/historique'),
                    ),
                    const SizedBox(height: 9),
                    _buildMenuItem(
                      context,
                      'Paramètres',
                      () => context.push('/parametres'),
                    ),
                    const SizedBox(height: 9),
                    _buildMenuItem(
                      context,
                      'Aide & FAQ',
                      () => context.push('/aide'),
                    ),
                    const SizedBox(height: 24),
                    // Multi-profile selection removed for single-role onboarding
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withValues(alpha: 0.14),
                            cardColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.eco_outlined,
                              color: AppTheme.accent,
                              size: 17,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mon impact carbone',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                                Text(
                                  'Voir mes crédits CO₂ générés',
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
                          GestureDetector(
                            onTap: traceCallback(
                              "profil_screen.dart:219:onTap",
                              () => context.push('/impact_carbone'),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: AppTheme.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: traceCallback(
                        "profil_screen.dart:231:onPressed",
                        () => context.push('/connexion'),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Se déconnecter'),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: valueColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            const SizedBox(height: 4),
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

  Widget _buildMenuItem(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.text),
          ],
        ),
      ),
    );
  }
}
