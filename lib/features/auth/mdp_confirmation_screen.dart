import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class MdpConfirmationScreen extends StatelessWidget {
  const MdpConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppTheme.accent,
                  size: 38,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Mot de passe mis à jour',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/connexion'),
                  child: const Text('Retour à la connexion'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
