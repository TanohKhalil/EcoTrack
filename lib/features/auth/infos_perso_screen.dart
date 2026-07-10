import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';

import 'package:ecotrack/core/utils/trace.dart';
class InfosPersoScreen extends StatefulWidget {
  const InfosPersoScreen({super.key});

  @override
  State<InfosPersoScreen> createState() => _InfosPersoScreenState();
}

class _InfosPersoScreenState extends State<InfosPersoScreen> {
  bool _cguAccepted = false;
  String _locationStatus = 'Position non détectée';

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
                onTap: traceCallback("infos_perso_screen.dart:36:onTap", () => context.pop()),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'Dernière étape'),
              const SizedBox(height: 8),
              Text(
                'Vos informations',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Dites-nous qui vous êtes et où vous vous trouvez.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow(text: 'PRÉNOM'),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: _inputDecoration('Aya'),
                          style: _inputStyle(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow(text: 'NOM'),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: _inputDecoration('Konan'),
                          style: _inputStyle(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Eyebrow(text: 'LOCALISATION'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.accent,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _locationStatus,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _locationStatus == 'Position non détectée'
                                  ? textColor.withValues(alpha: 0.5)
                                  : textColor,
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Utilisé pour vous localiser les points de collecte proches',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: textColor.withValues(alpha: 0.4),
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _locationStatus = 'Cocody, Abidjan');
                        showToast(context, 'Localisation confirmée : Cocody');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Localiser'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _cguAccepted,
                    onChanged: (v) => setState(() => _cguAccepted = v ?? false),
                    activeColor: accentColor,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: textColor.withValues(alpha: 0.6),
                          fontFamily: 'Space Grotesk',
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'J\'accepte les '),
                          TextSpan(
                            text: 'CGU et la politique de confidentialité',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push('/cgu');
                              },
                          ),
                          const TextSpan(text: ' d\'EcoTrack.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_cguAccepted) {
                      showToast(
                        context,
                        'Veuillez accepter les CGU pour continuer',
                      );
                      return;
                    }
                    context.push('/onboarding');
                  },
                  child: const Text('Terminer l\'inscription'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.text.withValues(alpha: 0.5)),
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.16)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: accentColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    );
  }

  TextStyle _inputStyle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textColor,
      fontFamily: 'Space Grotesk',
    );
  }
}
