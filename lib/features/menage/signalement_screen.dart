import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

import 'package:ecotrack/core/utils/trace.dart';
class SignalementScreen extends StatefulWidget {
  const SignalementScreen({super.key});

  @override
  State<SignalementScreen> createState() => _SignalementScreenState();
}

class _SignalementScreenState extends State<SignalementScreen> {
  bool _hasPhoto = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final dangerColor = isDark ? AppTheme.danger : AppTheme.dangerLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconBtn(
                    onTap: traceCallback("signalement_screen.dart:37:onTap", () => context.pop()),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  IconBtn(
                    onTap: traceCallback("signalement_screen.dart:41:onTap", () => context.push('/assistant_vocal')),
                    icon: Icons.mic_none_outlined,
                    color: accentColor,
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const Eyebrow(
                  text: 'Signalement citoyen', color: AppTheme.danger),
              const SizedBox(height: 8),
              Text(
                'Un dépôt sauvage ?',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 20),
              // Photo area
              GestureDetector(
                onTap: traceCallback("signalement_screen.dart:64:onTap", () => setState(() => _hasPhoto = !_hasPhoto)),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _hasPhoto
                          ? accentColor.withValues(alpha: 0.5)
                          : dangerColor.withValues(alpha: 0.4),
                      width: _hasPhoto ? 2 : 1,
                      style: _hasPhoto ? BorderStyle.solid : BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: _hasPhoto
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: AppTheme.accent,
                                size: 26,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Photo ajoutée',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: accentColor,
                                  fontFamily: 'Space Grotesk',
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 26,
                                color: textColor.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ajouter une photo',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: textColor.withValues(alpha: 0.6),
                                  fontFamily: 'Space Grotesk',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Eyebrow(text: 'LOCALISATION'),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Position GPS détectée · Marcory',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: textColor.withValues(alpha: 0.7),
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Eyebrow(text: 'DESCRIPTION'),
              const SizedBox(height: 8),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Type de déchets, ampleur, depuis quand…',
                  hintStyle: TextStyle(
                    color: textColor.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: accentColor),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: traceCallback("signalement_screen.dart:197:onPressed", () => context.push('/signalement_doublon')),
                  child: const Text('Envoyer le signalement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
