import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final softColor = isDark ? AppTheme.soft : AppTheme.softLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: () => context.pop(),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 44),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.24),
                  ),
                ),
                child: const Icon(
                  Icons.recycling,
                  color: AppTheme.accent,
                  size: 32,
                ),
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'Connexion'),
              const SizedBox(height: 8),
              Text(
                'Bon retour\nparmi nous',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'TÉLÉPHONE OU EMAIL'),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'aya@exemple.ci',
                  hintStyle: TextStyle(
                    color: textColor.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: accentColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 15),
              const Eyebrow(text: 'MOT DE PASSE'),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(
                    color: textColor.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: accentColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.push('/mdp_oublie'),
                  child: Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: softColor.withValues(alpha: 0.85),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/accueil_menage'),
                  child: const Text('Se connecter →'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pas de compte ? ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.5),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/inscription'),
                    child: Text(
                      'S\'inscrire',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
