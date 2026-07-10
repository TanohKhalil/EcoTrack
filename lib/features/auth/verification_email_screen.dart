import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class VerificationEmailScreen extends StatelessWidget {
  const VerificationEmailScreen({super.key});

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
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: AppTheme.accent,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Vérifiez votre boîte mail',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Un lien de confirmation a été envoyé à votre adresse email. Cliquez dessus pour activer votre compte.',
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
                    // showToast(context, 'Email confirmé');
                    context.push('/onboarding');
                  },
                  child: const Text('J\'ai confirmé, continuer'),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pas reçu ? ',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.45),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // showToast(context, 'Email renvoyé');
                    },
                    child: Text(
                      'Renvoyer le lien',
                      style: TextStyle(
                        fontSize: 12.5,
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
