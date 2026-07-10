import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String _selectedCategory = 'Plastique';
  final ImagePicker _picker = ImagePicker();

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

    final size = MediaQuery.of(context).size;
    final horizontalPadding = 20.0;
    final maxAvailableWidth = size.width - horizontalPadding * 2;
    final scanSize = math.min(maxAvailableWidth, size.height * 0.52);
    final bracketSize = scanSize * 0.13; // corner bracket size
    final bracketRadius = math.max(6.0, bracketSize * 0.25);
    final outerBorderWidth = math.max(1.0, scanSize * 0.006);
    final innerBorderWidth = math.max(1.0, scanSize * 0.006);
    final captureOuter = (scanSize * 0.31).clamp(56.0, 110.0);
    final captureInner = captureOuter * 0.875;

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
            top: MediaQuery.of(context).padding.top + 6,
            left: horizontalPadding,
            right: horizontalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBtn(
                  onTap: traceCallback(
                    "scanner_screen.dart:58:onTap",
                    () => context.pop(),
                  ),
                  icon: Icons.close,
                  color: textColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
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
                  onTap: traceCallback(
                    "scanner_screen.dart:97:onTap",
                    () => context.push('/assistant_vocal'),
                  ),
                  icon: Icons.mic_none_outlined,
                  color: accentColor,
                ),
              ],
            ),
          ),

          // Center - Scanner viewport (responsive)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: scanSize,
                  height: scanSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: scanSize,
                        height: scanSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.28),
                            style: BorderStyle.solid,
                            width: outerBorderWidth,
                          ),
                        ),
                      ),
                      Container(
                        width: scanSize,
                        height: scanSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.65),
                            width: innerBorderWidth,
                          ),
                        ),
                      ),
                      // Corner brackets
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: bracketSize,
                          height: bracketSize,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                              left: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(bracketRadius),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: bracketSize,
                          height: bracketSize,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                              right: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(bracketRadius),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: bracketSize,
                          height: bracketSize,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                              left: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(bracketRadius),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: bracketSize,
                          height: bracketSize,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                              right: BorderSide(
                                color: accentColor,
                                width: math.max(1.0, outerBorderWidth),
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(bracketRadius),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -scanSize * 0.11,
                        child: Text(
                          'CADRAGE · FORME · MATIÈRE',
                          style: TextStyle(
                            fontSize: math.max(9.0, scanSize * 0.035),
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
            left: horizontalPadding,
            right: horizontalPadding,
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildCategoryChip(context, 'Plastique', plasticColor),
                    _buildCategoryChip(context, 'Organique', organicColor),
                    _buildCategoryChip(context, 'Métal/verre', plasticColor),
                    _buildCategoryChip(context, 'Dangereux', dangerColor),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildControlButton(
                      context,
                      icon: Icons.photo_library_outlined,
                      onTap: () => _openGallery(),
                    ),
                    GestureDetector(
                      onTap: traceCallback(
                        "scanner_screen.dart:260:onTap",
                        () => _openCamera(),
                      ),
                      child: Container(
                        width: captureOuter,
                        height: captureOuter,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.4),
                            width: math.max(2.0, captureOuter * 0.04),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: captureInner,
                            height: captureInner,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.6),
                                  blurRadius: math.max(
                                    12.0,
                                    captureOuter * 0.32,
                                  ),
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
                      onTap: traceCallback(
                        "scanner_screen.dart:292:onTap",
                        () => context.push('/carte'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: traceCallback(
                    "scanner_screen.dart:298:onTap",
                    () => context.push('/erreur_camera'),
                  ),
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

  Widget _buildCategoryChip(BuildContext context, String label, Color color) {
    final active = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
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
          border: Border.all(color: accentColor.withValues(alpha: 0.22)),
        ),
        child: Icon(icon, color: softColor, size: 20),
      ),
    );
  }

  Future<void> _openGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
      );
      if (picked != null) {
        if (!mounted) return;
        context.push('/analyse', extra: picked.path);
      }
    } catch (e) {
      if (!mounted) return;
      context.push('/erreur_camera');
    }
  }

  Future<void> _openCamera() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1600,
      );
      if (picked != null) {
        if (!mounted) return;
        context.push('/analyse', extra: picked.path);
      }
    } catch (e) {
      if (!mounted) return;
      context.push('/erreur_camera');
    }
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
