import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../providers/cart_provider.dart';

class PanierScreen extends ConsumerWidget {
  const PanierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final cartItems = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).total;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
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
                    'Mon panier',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'Votre panier est vide',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: textColor.withValues(alpha: 0.4),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.14),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nom,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                          fontFamily: 'Space Grotesk',
                                        ),
                                      ),
                                      Text(
                                        '${item.prixFCFA.toInt()} FCFA',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: textColor.withValues(alpha: 0.5),
                                          fontFamily: 'Space Grotesk',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .remove(index);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: AppTheme.danger,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                    Text(
                      '${total.toInt()} FCFA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cartItems.isEmpty
                      ? null
                      : () => context.push('/paiement_commande'),
                  child: const Text('Passer au paiement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
