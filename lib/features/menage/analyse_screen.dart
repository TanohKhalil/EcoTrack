import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class AnalyseScreen extends StatefulWidget {
  const AnalyseScreen({super.key});

  @override
  State<AnalyseScreen> createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.push('/resultat');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deepColor = isDark ? AppTheme.deep : AppTheme.deepLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return Scaffold(
      backgroundColor: deepColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(accentColor.withValues(alpha: 0.045)),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Eyebrow(
                  text: 'CLASSIFICATION EN COURS',
                  color: AppTheme.accent,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.3),
                              Colors.transparent,
                              accentColor.withValues(alpha: 0.3),
                            ],
                            stops: const [0, 0.34, 1],
                          ),
                        ),
                      ),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.recycling,
                        color: AppTheme.accent,
                        size: 54,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 224,
                  height: 3,
                  child: Stack(
                    children: [
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(seconds: 3),
                        builder: (context, value, child) {
                          return FractionallySizedBox(
                            widthFactor: value,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'L\'IA identifie le déchet',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Modèle MobileNetV3 · on-device',
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
        ],
      ),
    );
  }
}
