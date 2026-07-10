import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

final toastProvider = StateProvider<String?>((ref) => null);

class ToastWidget extends ConsumerWidget {
  const ToastWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(toastProvider);
    if (message == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.surface : AppTheme.surfaceLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return Positioned(
      bottom: 26,
      left: 24,
      right: 24,
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: const Offset(0, 0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: accentColor,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}
