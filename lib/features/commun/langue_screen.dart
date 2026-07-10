import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class LangueScreen extends StatefulWidget {
  const LangueScreen({super.key});

  @override
  State<LangueScreen> createState() => _LangueScreenState();
}

class _LangueScreenState extends State<LangueScreen> {
  String _selected = 'Français';

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: () => context.pop(),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'Langue'),
              const SizedBox(height: 8),
              Text(
                'Choisir la langue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 20),
              _buildLanguageOption('Français'),
              const SizedBox(height: 9),
              _buildLanguageOption('English'),
              const SizedBox(height: 9),
              _buildLanguageOption('Dioula'),
              const SizedBox(height: 9),
              _buildLanguageOption('Baoulé'),
              const SizedBox(height: 9),
              _buildLanguageOption('Nouchi'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String name) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    final isSelected = _selected == name;

    return GestureDetector(
      onTap: () {
        setState(() => _selected = name);
        // showToast(context, 'Langue : $name');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? accentColor.withValues(alpha: 0.4)
                : accentColor.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppTheme.accent,
                size: 15,
              ),
          ],
        ),
      ),
    );
  }
}
