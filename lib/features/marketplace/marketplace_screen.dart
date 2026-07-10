import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import '../../core/constants/mock_data.dart';
import '../../providers/cart_provider.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final cartItems = ref.watch(cartProvider);

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
                    'Marketplace EcoTrack',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push('/panier'),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 18,
                          ),
                        ),
                        if (cartItems.isNotEmpty)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.danger,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cartItems.length.toString(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Produits issus des filières de valorisation locales — le cycle bouclé, du déchet au produit fini.',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilter(context, 'Tous', 'tous'),
                    const SizedBox(width: 8),
                    _buildFilter(context, 'Compost', 'Compost'),
                    const SizedBox(width: 8),
                    _buildFilter(context, 'Construction', 'Construction'),
                    const SizedBox(width: 8),
                    _buildFilter(context, 'Mobilier', 'Mobilier'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ...MockData.produitsMarketplace
                  .map((product) => _buildProductCard(context, product, ref))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilter(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return GestureDetector(
      onTap: () {
        // Filtrer les produits
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: value == 'tous' ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value == 'tous'
                ? accentColor
                : accentColor.withValues(alpha: 0.35),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: value == 'tous'
                ? AppTheme.accentInk
                : textColor.withValues(alpha: 0.6),
            fontFamily: 'Space Grotesk',
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProduitMarketplace product,
    WidgetRef ref,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nom,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  product.fournisseur,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: textColor.withValues(alpha: 0.5),
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${product.prixFCFA.toInt()} FCFA',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).add(product);
              showToast(context, 'Ajouté au panier : ${product.nom}');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text('Commander'),
          ),
        ],
      ),
    );
  }
}
