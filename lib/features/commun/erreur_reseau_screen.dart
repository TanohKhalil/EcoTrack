import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/toast.dart';

class ErreurReseauScreen extends StatelessWidget {
  const ErreurReseauScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: textColor.withValues(alpha: 0.18)),
                ),
                child: const Icon(
                  Icons.wifi_off_outlined,
                  color: AppTheme.text,
                  size: 34,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Pas de connexion',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Impossible de joindre le serveur. Activez le mode hors-ligne pour continuer à trier — vos actions se synchroniseront plus tard.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showToast(context, 'Reconnexion réussie');
                    context.push('/accueil_menage');
                  },
                  child: const Text('Réessayer'),
                ),
              ),
              const SizedBox(height: 11),
              OutlinedButton(
                onPressed: () {
                  // toggleOffline
                  context.push('/accueil_menage');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Continuer hors-ligne'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
