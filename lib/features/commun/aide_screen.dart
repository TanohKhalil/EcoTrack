import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class AideScreen extends StatelessWidget {
  const AideScreen({super.key});

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
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBtn(
                    onTap: () => context.pop(),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Aide & FAQ',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Eyebrow(text: 'QUESTIONS FRÉQUENTES'),
              const SizedBox(height: 11),
              _buildFAQ(
                context,
                'L\'IA se trompe sur mon déchet, que faire ?',
                'Utilisez le vote communautaire proposé après le scan pour aider à corriger la classification.',
              ),
              const SizedBox(height: 9),
              _buildFAQ(
                context,
                'Comment échanger mes points ?',
                'Rendez-vous dans l\'accueil, section "Récompenses", et sélectionnez une offre disponible.',
              ),
              const SizedBox(height: 9),
              _buildFAQ(
                context,
                'L\'application fonctionne-t-elle sans réseau ?',
                'Oui : activez le mode hors-ligne dans les paramètres. Vos actions se synchroniseront dès que le réseau revient.',
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'CONTACTER LE SUPPORT'),
              const SizedBox(height: 11),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Décrivez votre problème…',
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
                  contentPadding: const EdgeInsets.all(15),
                ),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // showToast(context, 'Message envoyé au support EcoTrack');
                  },
                  child: const Text('Envoyer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQ(BuildContext context, String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: textColor.withValues(alpha: 0.5),
              fontFamily: 'Space Grotesk',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
