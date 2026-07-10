import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class ErreurCameraScreen extends StatelessWidget {
  const ErreurCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final dangerColor = isDark ? AppTheme.danger : AppTheme.dangerLight;

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
                  color: dangerColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: dangerColor.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppTheme.danger,
                  size: 34,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Accès à la caméra refusé',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'EcoTrack a besoin de la caméra pour scanner vos déchets. Autorisez l\'accès dans les réglages de votre téléphone.',
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
                  onPressed: () => context.push('/scanner'),
                  child: const Text('Réessayer'),
                ),
              ),
              const SizedBox(height: 11),
              OutlinedButton(
                onPressed: () {
                  // openGallery
                  context.push('/analyse');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Utiliser une photo de la galerie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
