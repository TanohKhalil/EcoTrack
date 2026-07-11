import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';

import 'package:ecotrack/core/utils/trace.dart';

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  bool _notifications = true;
  bool _offline = false;

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
                    onTap: traceCallback(
                      "parametres_screen.dart:37:onTap",
                      () => context.pop(),
                    ),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Paramètres',
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
              const Eyebrow(text: 'INFORMATIONS PERSONNELLES'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: 'Aya',
                      decoration: _inputDecoration(),
                      style: _inputStyle(),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: TextFormField(
                      initialValue: 'Konan',
                      decoration: _inputDecoration(),
                      style: _inputStyle(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              TextFormField(
                initialValue: '+225 07 12 34 56 78',
                decoration: _inputDecoration(),
                style: _inputStyle(),
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'PRÉFÉRENCES'),
              const SizedBox(height: 10),
              _buildPreferenceItem(
                'Langue',
                'Français ›',
                () => context.push('/langue'),
              ),
              const SizedBox(height: 9),
              _buildSwitchItem(
                'Notifications push',
                _notifications,
                (v) => setState(() => _notifications = v),
              ),
              const SizedBox(height: 9),
              _buildSwitchItem(
                'Mode hors-ligne',
                _offline,
                (v) => setState(() => _offline = v),
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'SUPPORT'),
              const SizedBox(height: 10),
              _buildPreferenceItem(
                'Aide & FAQ',
                '›',
                () => context.push('/aide'),
              ),
              const SizedBox(height: 9),
              _buildPreferenceItem(
                'CGU & confidentialité',
                '›',
                () => context.push('/cgu'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final navigator = Navigator.of(context);
                    showToast(context, 'Paramètres enregistrés');
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (navigator.context.mounted) {
                        navigator.pop();
                      }
                    });
                  },
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return InputDecoration(
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.16)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    );
  }

  TextStyle _inputStyle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: textColor,
      fontFamily: 'Space Grotesk',
    );
  }

  Widget _buildPreferenceItem(String label, String value, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: textColor.withValues(alpha: 0.45),
                fontFamily: 'Space Grotesk',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String label, bool value, Function(bool) onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
              fontFamily: 'Space Grotesk',
            ),
          ),
          GestureDetector(
            onTap: traceCallback(
              "parametres_screen.dart:234:onTap",
              () => onChanged(!value),
            ),
            child: Container(
              width: 40,
              height: 22,
              decoration: BoxDecoration(
                color: value ? accentColor : textColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Align(
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
