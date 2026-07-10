import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class BottomNav extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.surface : AppTheme.surfaceLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: accentColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Accueil',
            index: 0,
          ),
          _buildNavItem(
            context,
            icon: Icons.map_outlined,
            activeIcon: Icons.map,
            label: 'Carte',
            index: 1,
          ),
          _buildNavItem(
            context,
            icon: Icons.warning_amber_outlined,
            activeIcon: Icons.warning_amber,
            label: 'Signaler',
            index: 2,
          ),
          _buildNavItem(
            context,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profil',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;
    final color =
        isActive ? AppTheme.accent : AppTheme.text.withValues(alpha: 0.4);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            size: 22,
            color: color,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color,
              fontFamily: 'Space Grotesk',
            ),
          ),
        ],
      ),
    );
  }
}
