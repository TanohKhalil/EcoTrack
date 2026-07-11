import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/services/voice_store.dart';
import '../../core/services/ai_analysis_service.dart';

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
  late final stt.SpeechToText _speech;
  bool _listening = false;
  String _lastWords = '';

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
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: (s) {
          if (s == 'notListening') setState(() => _listening = false);
        },
        onError: (e) {
          setState(() => _listening = false);
        },
      );
      if (!available) {
        // Speech not available on device
        setState(() => _listening = false);
      }
    } catch (e) {
      setState(() => _listening = false);
    }
  }

  void _startListening() async {
    final available = await _speech.initialize();
    if (!available) return;
    setState(() => _listening = true);
    _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          _lastWords = result.recognizedWords;
          VoiceStore.lastText = _lastWords;
        });
      },
      listenOptions: stt.SpeechListenOptions(
        listenFor: const Duration(seconds: 30),
      ),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() => _listening = false);
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
                      onTap: traceCallback(
                        "assistant_vocal_screen.dart:79:onTap",
                        () => context.pop(),
                      ),
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
                              GestureDetector(
                                onTap: () {
                                  if (_listening) {
                                    _stopListening();
                                  } else {
                                    _startListening();
                                  }
                                },
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _listening
                                        ? accentColor.withValues(alpha: 0.95)
                                        : accentColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: accentColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 22,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _listening ? Icons.mic : Icons.mic_none,
                                    color: accentInkColor,
                                    size: 30,
                                  ),
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
                          _lastWords.isNotEmpty
                              ? '"$_lastWords"'
                              : 'Je vous écoute…',
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
                          onPressed: traceCallback(
                            "assistant_vocal_screen.dart:217:onPressed",
                            () => context.push(
                              '/signalement',
                              extra: VoiceStore.lastText,
                            ),
                          ),
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
