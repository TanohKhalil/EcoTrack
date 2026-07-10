import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';

import 'package:ecotrack/core/utils/trace.dart';
class NotationCollecteurScreen extends StatefulWidget {
  const NotationCollecteurScreen({super.key});

  @override
  State<NotationCollecteurScreen> createState() =>
      _NotationCollecteurScreenState();
}

class _NotationCollecteurScreenState extends State<NotationCollecteurScreen> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconBtn(
                  onTap: traceCallback("notation_collecteur_screen.dart:38:onTap", () => context.pop()),
                  icon: Icons.arrow_back_ios_new,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Noter Ibrahim K.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Passage du 9 juillet · 16h20',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: traceCallback("notation_collecteur_screen.dart:79:onTap", () => setState(() => _rating = index + 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '★',
                        style: TextStyle(
                          fontSize: 34,
                          color: index < _rating
                              ? goldColor
                              : textColor.withValues(alpha: 0.2),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Un commentaire ? (optionnel)',
                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
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
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showToast(context, 'Merci pour votre évaluation !');
                    context.pop();
                  },
                  child: const Text('Envoyer la note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
