import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';
class VoteCommunautaireScreen extends StatefulWidget {
  const VoteCommunautaireScreen({super.key});

  @override
  State<VoteCommunautaireScreen> createState() =>
      _VoteCommunautaireScreenState();
}

class _VoteCommunautaireScreenState extends State<VoteCommunautaireScreen> {
  bool _voted = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final plasticColor = isDark ? AppTheme.plastic : AppTheme.plasticLight;
    final blueColor = isDark ? AppTheme.blue : AppTheme.blueLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: traceCallback("vote_communautaire_screen.dart:35:onTap", () => context.pop()),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 22),
              const Eyebrow(
                  text: 'Confiance IA faible · 54%', color: AppTheme.gold),
              const SizedBox(height: 8),
              Text(
                'Aidez-nous à trancher',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'L\'IA hésite entre deux catégories. Votre vote aide la communauté à confirmer.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              _buildVoteOption('Plastique', '54%', plasticColor),
              const SizedBox(height: 11),
              _buildVoteOption('Métal / verre', '46%', blueColor),
              const SizedBox(height: 20),
              if (_voted)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Merci ! Votre vote a été enregistré.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ),
              const Spacer(),
              OutlinedButton(
                onPressed: traceCallback("vote_communautaire_screen.dart:91:onPressed", () => context.pop()),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Retour au résultat'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoteOption(String label, String score, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return GestureDetector(
      onTap: _voted
          ? null
          : () {
              setState(() => _voted = true);
            },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: _voted ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            Text(
              score,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Space Grotesk',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
