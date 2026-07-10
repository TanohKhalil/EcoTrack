import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class MdpOublieScreen extends StatelessWidget {
  const MdpOublieScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: () => context.pop(),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'Mot de passe oublié'),
              const SizedBox(height: 8),
              Text(
                'Réinitialiser votre mot de passe',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Indiquez le numéro ou l\'email associé à votre compte. Nous vous enverrons un code de vérification.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const Eyebrow(text: 'TÉLÉPHONE OU EMAIL'),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: '07 00 00 00 00 ou aya@exemple.ci',
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
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // showToast(context, 'Code envoyé');
                    context.push('/mdp_reset');
                  },
                  child: const Text('Envoyer le code'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vous vous souvenez ? ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.5),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/connexion'),
                    child: Text(
                      'Se connecter',
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
