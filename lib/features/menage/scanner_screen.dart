import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deepColor = isDark ? AppTheme.deep : AppTheme.deepLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final dangerColor = isDark ? AppTheme.danger : AppTheme.dangerLight;
    final organicColor = isDark ? AppTheme.organic : AppTheme.organicLight;
    final plasticColor = isDark ? AppTheme.plastic : AppTheme.plasticLight;
    final patternColorA = isDark ? AppTheme.phA : AppTheme.phALight;
    final patternColorB = isDark ? AppTheme.phB : AppTheme.phBLight;

    return Scaffold(
      backgroundColor: deepColor,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalPainter(
                patternColorA.withValues(alpha: 0.5),
                patternColorB.withValues(alpha: 0.5),
              ),
            ),
          ),
          // Radial overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    deepColor.withValues(alpha: 0.9),
                  ],
                  center: Alignment.center,
                  radius: 0.8,
                ),
              ),
            ),
          ),
          // Header
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBtn(
                  onTap: () => context.pop(),
                  icon: Icons.close,
                  color: textColor,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: dangerColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: dangerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.14,
                          color: dangerColor,
                          fontFamily: 'Space Grotesk',
                        ),
                      ),
                    ],
                  ),
                ),
                IconBtn(
                  onTap: () => context.push('/assistant_vocal'),
                  icon: Icons.mic_none_outlined,
                  color: accentColor,
                ),
              ],
            ),
          ),
          // Center - Scanner viewport
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 256,
                  height: 256,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 256,
                        height: 256,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.28),
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      Container(
                        width: 256,
                        height: 256,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.65),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Corner brackets
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: accentColor, width: 2),
                              left: BorderSide(color: accentColor, width: 2),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: accentColor, width: 2),
                              right: BorderSide(color: accentColor, width: 2),
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: accentColor, width: 2),
                              left: BorderSide(color: accentColor, width: 2),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: accentColor, width: 2),
                              right: BorderSide(color: accentColor, width: 2),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -28,
                        child: Text(
                          'CADRAGE · FORME · MATIÈRE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.14,
                            color: accentColor.withValues(alpha: 0.7),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCategoryChip(
                        context, 'Plastique', plasticColor, true),
                    _buildCategoryChip(
                        context, 'Organique', organicColor, false),
                    _buildCategoryChip(
                        context, 'Métal/verre', plasticColor, false),
                    _buildCategoryChip(
                        context, 'Dangereux', dangerColor, false),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildControlButton(
                      context,
                      icon: Icons.photo_library_outlined,
                      onTap: () {
                        // openGallery
                        context.push('/analyse');
                      },
                    ),
                    GestureDetector(
                      onTap: () => context.push('/analyse'),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.4),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.6),
                                  blurRadius: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildControlButton(
                      context,
                      icon: Icons.map_outlined,
                      onTap: () => context.push('/carte'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.push('/erreur_camera'),
                  child: Text(
                    'Problème avec la caméra ?',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.35),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    Color color,
    bool active,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: active ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? color : color.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: active ? AppTheme.accentInk : color,
          fontFamily: 'Space Grotesk',
        ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softColor = isDark ? AppTheme.soft : AppTheme.softLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.22),
          ),
        ),
        child: Icon(
          icon,
          color: softColor,
          size: 20,
        ),
      ),
    );
  }
}

class DiagonalPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  DiagonalPainter(this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var i = -size.height; i < size.width; i += 18) {
      path.moveTo(i, 0);
      path.lineTo(i + 18, 18);
      path.lineTo(i + 36, 0);
      path.close();
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color1
        ..style = PaintingStyle.fill,
    );

    final secondaryPath = Path();
    for (var i = -size.height + 9; i < size.width; i += 18) {
      secondaryPath.moveTo(i, 18);
      secondaryPath.lineTo(i + 18, 36);
      secondaryPath.lineTo(i + 36, 18);
      secondaryPath.close();
    }

    canvas.drawPath(
      secondaryPath,
      Paint()
        ..color = color2
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
