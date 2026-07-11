import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../providers/profile_provider.dart';
import '../../services/supabase_service.dart';

import 'package:ecotrack/core/utils/trace.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    Future<void> selectRole(String role) async {
      final currentUser = SupabaseService.client.auth.currentUser;
      if (currentUser == null) {
        if (context.mounted) {
          context.push('/connexion');
        }
        return;
      }

      await ref
          .read(profileProvider.notifier)
          .changeRoleActif(currentUser.id, role);
      if (!context.mounted) return;
      context.go('/tutoriel');
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: traceCallback(
                  "onboarding_screen.dart:26:onTap",
                  () => context.pop(),
                ),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'Créer un compte'),
              const SizedBox(height: 8),
              Text(
                'Je rejoins EcoTrack en tant que…',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choisissez votre profil. Vous pourrez en ajouter d\'autres plus tard.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRoleCard(
                        context,
                        icon: Icons.home_outlined,
                        title: 'Ménage / Commerce',
                        subtitle: 'Je trie, signale, gagne des points',
                        color: accentColor,
                        onTap: traceCallback(
                          "onboarding_screen.dart:64:onTap",
                          () => selectRole('menage'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRoleCard(
                        context,
                        icon: Icons.local_shipping_outlined,
                        title: 'Collecteur informel',
                        subtitle: 'Charrette, moto ou à pied',
                        color: AppTheme.plastic,
                        onTap: traceCallback(
                          "onboarding_screen.dart:73:onTap",
                          () => selectRole('collecteur'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRoleCard(
                        context,
                        icon: Icons.eco_outlined,
                        title: 'Filière de valorisation',
                        subtitle: 'Recycleur, compost, biogaz, e-waste',
                        color: AppTheme.organic,
                        onTap: traceCallback(
                          "onboarding_screen.dart:82:onTap",
                          () => selectRole('filiere'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRoleCard(
                        context,
                        icon: Icons.apartment_outlined,
                        title: 'Mairie / Collectivité',
                        subtitle: 'Dashboard B2G · pilotage territorial',
                        color: AppTheme.blue,
                        onTap: traceCallback(
                          "onboarding_screen.dart:91:onTap",
                          () => selectRole('mairie'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
