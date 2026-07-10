import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';

import 'package:ecotrack/core/utils/trace.dart';
class MdpResetScreen extends StatelessWidget {
  const MdpResetScreen({super.key});

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
                onTap: traceCallback("mdp_reset_screen.dart:27:onTap", () => context.pop()),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'Vérification'),
              const SizedBox(height: 8),
              Text(
                'Nouveau mot de passe',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 20),
              const Eyebrow(text: 'CODE DE VÉRIFICATION'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildOtpBox(context, '7', true),
                  const SizedBox(width: 9),
                  _buildOtpBox(context, '1', true),
                  const SizedBox(width: 9),
                  _buildOtpBox(context, '·', false),
                  const SizedBox(width: 9),
                  _buildOtpBox(context, '·', false),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Code envoyé · ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.4),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showToast(context, 'Nouveau code envoyé');
                    },
                    child: Text(
                      'Renvoyer',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: accentColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'NOUVEAU MOT DE PASSE'),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: _inputDecoration(context, '••••••••'),
                style: _inputStyle(context),
              ),
              const SizedBox(height: 15),
              const Eyebrow(text: 'CONFIRMER LE MOT DE PASSE'),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: _inputDecoration(context, '••••••••'),
                style: _inputStyle(context),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: traceCallback("mdp_reset_screen.dart:105:onPressed", () => context.push('/mdp_confirmation')),
                  child: const Text('Réinitialiser le mot de passe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(BuildContext context, String value, bool active) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Expanded(
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: active
                ? accentColor.withValues(alpha: 0.4)
                : accentColor.withValues(alpha: 0.16),
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: active ? accentColor : textColor.withValues(alpha: 0.5),
              fontFamily: 'Space Grotesk',
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    );
  }

  TextStyle _inputStyle(BuildContext context) {
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
