import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';

import 'package:ecotrack/core/utils/trace.dart';

class RetraitCollecteurScreen extends StatefulWidget {
  const RetraitCollecteurScreen({super.key});

  @override
  State<RetraitCollecteurScreen> createState() =>
      _RetraitCollecteurScreenState();
}

class _RetraitCollecteurScreenState extends State<RetraitCollecteurScreen> {
  String _selectedMethod = 'orange';

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
                onTap: traceCallback(
                  "retrait_collecteur_screen.dart:35:onTap",
                  () => context.pop(),
                ),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'Retrait de revenus'),
              const SizedBox(height: 8),
              Text(
                'Solde disponible',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor.withValues(alpha: 0.16), cardColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '36 500 FCFA',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cumul de la semaine',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: textColor.withValues(alpha: 0.5),
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Eyebrow(text: 'MOYEN DE RETRAIT'),
              const SizedBox(height: 10),
              _buildPaymentMethod('Orange Money', Colors.orange, 'orange'),
              const SizedBox(height: 9),
              _buildPaymentMethod('MTN Mobile Money', Colors.amber, 'mtn'),
              const SizedBox(height: 9),
              _buildPaymentMethod('Wave', const Color(0xFF1DC8EE), 'wave'),
              const SizedBox(height: 20),
              const Eyebrow(text: 'MONTANT À RETIRER'),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: '36 500',
                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final navigator = Navigator.of(context);
                    showToast(
                      context,
                      'Retrait initié — vous recevrez un SMS de confirmation',
                    );
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (mounted) {
                        navigator.pop();
                      }
                    });
                  },
                  child: const Text('Retirer maintenant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String name, Color color, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return GestureDetector(
      onTap: traceCallback(
        "retrait_collecteur_screen.dart:159:onTap",
        () => setState(() => _selectedMethod = value),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.card : AppTheme.cardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _selectedMethod == value
                ? accentColor.withValues(alpha: 0.4)
                : accentColor.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ),
            if (_selectedMethod == value)
              const Icon(Icons.check, color: AppTheme.accent, size: 15),
          ],
        ),
      ),
    );
  }
}
