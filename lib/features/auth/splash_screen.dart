import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

import 'package:ecotrack/core/utils/trace.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pingController;
  late final AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final accentInkColor = isDark
        ? AppTheme.accentInk
        : AppTheme.accentInkLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;
    final subtitleColor = isDark
        ? textColor.withValues(alpha: 0.62)
        : textColor.withValues(alpha: 0.78);
    final buttonForegroundColor = isDark ? accentInkColor : Colors.white;
    final iconColor = isDark ? accentInkColor : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Ligne du haut : badge supprimé

            // Bloc central : parfaitement centré dans l'espace restant
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo animé : ping rings + arc rotatif + icône
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _pingController,
                              builder: (context, _) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: List.generate(3, (i) {
                                    final t =
                                        (_pingController.value + i / 3) % 1.0;
                                    final eased = Curves.easeOut.transform(t);
                                    final scale = 0.4 + eased * (2.3 - 0.4);
                                    final opacity = (0.55 * (1 - eased)).clamp(
                                      0.0,
                                      1.0,
                                    );

                                    return Opacity(
                                      opacity: opacity,
                                      child: Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          width: 176,
                                          height: 176,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: accentColor,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: _sweepController,
                              builder: (context, _) {
                                return Transform.rotate(
                                  angle: _sweepController.value * 2 * pi,
                                  child: CustomPaint(
                                    size: const Size(200, 200),
                                    painter: _SweepArcPainter(
                                      color: accentColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Center(
                              child: SvgPicture.asset(
                                'assets/images/logo.svg',
                                width: 110,
                                height: 110,
                            Container(
                              width: 160,
                              height: 160,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/recycling-symbol-svgrepo-com.svg',
                                width: 98,
                                height: 98,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        'IA + IOT · GESTION DES DÉCHETS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                          color: accentColor,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'EcoTrack',
                        style: GoogleFonts.fraunces(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        'Signalement → tri → collecte → valorisation → revenu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bas de l'écran : bouton + lien (position fixe, pas de Spacer)
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: traceCallback(
                        "splash_screen.dart:234:onPressed",
                        () => context.push('/inscription'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: buttonForegroundColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Commencer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Déjà membre ? ',
                        style: TextStyle(fontSize: 14, color: subtitleColor),
                      ),
                      GestureDetector(
                        onTap: traceCallback(
                          "splash_screen.dart:262:onTap",
                          () => context.push('/connexion'),
                        ),
                        child: Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SweepArcPainter extends CustomPainter {
  final Color color;

  _SweepArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const sweepAngle = 75 * pi / 180;
    canvas.drawArc(
      rect.deflate(paint.strokeWidth / 2),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SweepArcPainter oldDelegate) =>
      oldDelegate.color != color;
}
