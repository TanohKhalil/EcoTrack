import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';
class AssistantVocalScreen extends StatefulWidget {
  const AssistantVocalScreen({super.key});

  @override
  State<AssistantVocalScreen> createState() => _AssistantVocalScreenState();
}

class _AssistantVocalScreenState extends State<AssistantVocalScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pingController;
  late final AnimationController _waveController;

  // Hauteur de base de chaque barre + un décalage de phase pour désynchroniser
  final List<double> _barBaseHeights = [10, 22, 14, 24, 9, 18];
  final List<double> _barPhases = [0.0, 0.15, 0.3, 0.45, 0.6, 0.75];

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    _waveController.dispose();
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

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  center: Alignment.center,
                  radius: 0.65,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 14),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconBtn(
                      onTap: traceCallback("assistant_vocal_screen.dart:79:onTap", () => context.pop()),
                      icon: Icons.close,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Eyebrow(text: 'ASSISTANT VOCAL EcoTrack'),
                        const SizedBox(height: 22),

                        // Micro + anneaux radar
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _pingController,
                                builder: (context, _) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: List.generate(2, (i) {
                                      final t =
                                          (_pingController.value + i / 2) % 1.0;
                                      final eased = Curves.easeOut.transform(t);
                                      final scale =
                                          0.65 + eased * (1.55 - 0.65);
                                      final opacity = (0.4 * (1 - eased)).clamp(
                                        0.0,
                                        1.0,
                                      );

                                      return Opacity(
                                        opacity: opacity,
                                        child: Transform.scale(
                                          scale: scale,
                                          child: Container(
                                            width: 140,
                                            height: 140,
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
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accentColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withValues(alpha: 0.4),
                                      blurRadius: 22,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.mic,
                                  color: accentInkColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        // Waveform animé
                        AnimatedBuilder(
                          animation: _waveController,
                          builder: (context, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (i) {
                                final phase = _barPhases[i];
                                final t = (_waveController.value + phase) % 1.0;
                                // Oscillation douce entre 0.4 et 1.0 de la hauteur de base
                                final factor =
                                    0.4 + 0.6 * (0.5 + 0.5 * sin(t * 2 * pi));
                                final height = _barBaseHeights[i] * factor;

                                return Container(
                                  width: 4,
                                  height: height.clamp(4.0, 26.0),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            );
                          },
                        ),

                        const SizedBox(height: 22),
                        Text(
                          '« Il y a des ordures dans la rue derrière le marché »',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Je vous écoute… décrivez le déchet ou le dépôt en langue locale ou en français',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: textColor.withValues(alpha: 0.5),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                        const SizedBox(height: 30),
                        OutlinedButton(
                          onPressed: traceCallback("assistant_vocal_screen.dart:217:onPressed", () => context.push('/signalement')),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(220, 48),
                          ),
                          child: const Text('Repasser en mode texte'),
                        ),
                      ],
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
}
