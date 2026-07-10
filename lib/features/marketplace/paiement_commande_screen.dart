import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class PaiementCommandeScreen extends StatefulWidget {
  const PaiementCommandeScreen({super.key});

  @override
  State<PaiementCommandeScreen> createState() => _PaiementCommandeScreenState();
}

class _PaiementCommandeScreenState extends State<PaiementCommandeScreen> {
  String _selectedMethod = 'mobile';

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
              const Eyebrow(text: 'Paiement'),
              const SizedBox(height: 8),
              Text(
                'Choisir un mode de paiement',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 20),
              _buildPaymentOption('Mobile Money', 'mobile'),
              const SizedBox(height: 9),
              _buildPaymentOption('Espèces à la livraison', 'cash'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/confirmation_commande'),
                  child: const Text('Confirmer la commande'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    final isSelected = _selectedMethod == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? accentColor.withValues(alpha: 0.4)
                : accentColor.withValues(alpha: 0.14),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              value == 'mobile' ? Icons.credit_card : Icons.money,
              size: 18,
              color: isSelected ? accentColor : textColor.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
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
