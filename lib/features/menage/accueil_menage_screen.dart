import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/botton_nav.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import '../../core/constants/mock_data.dart';
import '../../providers/theme_provider.dart';

import 'package:ecotrack/core/utils/trace.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccueilMenageScreen extends ConsumerStatefulWidget {
  const AccueilMenageScreen({super.key});

  @override
  ConsumerState<AccueilMenageScreen> createState() =>
      _AccueilMenageScreenState();
}

class _AccueilMenageScreenState extends ConsumerState<AccueilMenageScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _scanPingController;

  @override
  void initState() {
    super.initState();
    _scanPingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _scanPingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final dangerColor = isDark ? AppTheme.danger : AppTheme.dangerLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/recycling-symbol-svgrepo-com.svg',
                                  width: 17,
                                  height: 17,
                                  colorFilter: const ColorFilter.mode(
                                    AppTheme.accentInk,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'EcoTrack',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                fontFamily: 'Space Grotesk',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildThemeButton(),
                            const SizedBox(width: 9),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconBtn(
                                  onTap: traceCallback(
                                    "accueil_menage_screen.dart:99:onTap",
                                    () => context.push('/notifications'),
                                  ),
                                  icon: Icons.notifications_outlined,
                                  color: textColor,
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: dangerColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? AppTheme.surface
                                            : AppTheme.surfaceLight,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 9),
                            IconBtn(
                              onTap: traceCallback(
                                "accueil_menage_screen.dart:125:onTap",
                                () => context.push('/profil'),
                              ),
                              icon: Icons.person_outline,
                              color: textColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bonjour,',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textColor.withValues(alpha: 0.5),
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                    Text(
                      'Aya · Cocody',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Scanner hero
                    GestureDetector(
                      onTap: traceCallback(
                        "accueil_menage_screen.dart:155:onTap",
                        () => context.push('/scanner'),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: RadialGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.18),
                              cardColor,
                            ],
                            center: Alignment.centerRight,
                            radius: 0.8,
                          ),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: GridPainter(
                                  accentColor.withValues(alpha: 0.05),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Eyebrow(text: 'SCANNER IA'),
                                      const SizedBox(height: 7),
                                      Text(
                                        'Trier\nun déchet',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                          fontFamily: 'Space Grotesk',
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Bouton scan + halo animé
                                  SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedBuilder(
                                          animation: _scanPingController,
                                          builder: (context, _) {
                                            return Stack(
                                              alignment: Alignment.center,
                                              children: List.generate(2, (i) {
                                                final t =
                                                    (_scanPingController.value +
                                                        i / 2) %
                                                    1.0;
                                                final eased = Curves.easeOut
                                                    .transform(t);
                                                final scale =
                                                    0.7 + eased * (1.6 - 0.7);
                                                final opacity =
                                                    (0.35 * (1 - eased)).clamp(
                                                      0.0,
                                                      1.0,
                                                    );
                                                return Opacity(
                                                  opacity: opacity,
                                                  child: Transform.scale(
                                                    scale: scale,
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: accentColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: accentColor.withValues(
                                                  alpha: 0.3,
                                                ),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.center_focus_strong_outlined,
                                            color: AppTheme.accentInk,
                                            size: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Signalement button
                    GestureDetector(
                      onTap: traceCallback(
                        "accueil_menage_screen.dart:285:onTap",
                        () => context.push('/signalement'),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              dangerColor.withValues(alpha: 0.1),
                              cardColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: dangerColor.withValues(alpha: 0.32),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: dangerColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: dangerColor,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Signaler un dépôt sauvage',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                      fontFamily: 'Space Grotesk',
                                    ),
                                  ),
                                  Text(
                                    'Photo + localisation',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: textColor.withValues(alpha: 0.5),
                                      fontFamily: 'Space Grotesk',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: dangerColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Stats
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          children: [
                            _buildStatCard('1 240', 'points', accentColor),
                            const SizedBox(width: 9),
                            _buildStatCard(
                              '38 kg',
                              'triés / mois',
                              textColor,
                              onTap: traceCallback(
                                "accueil_menage_screen.dart:400:onTap",
                                () => context.push('/historique'),
                              ),
                            ),
                            const SizedBox(width: 9),
                            _buildStatCard('6', 'collectes', textColor),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    // Passage du collecteur
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Passage du collecteur',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                        GestureDetector(
                          onTap: traceCallback(
                            "accueil_menage_screen.dart:423:onTap",
                            () => context.push('/carte'),
                          ),
                          child: Text(
                            'Carte →',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: accentColor,
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: AppTheme.accent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aujourd\'hui · 16h–17h',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                                Text(
                                  'Ibrahim K. · notation 4.8 ★',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                    color: textColor.withValues(alpha: 0.5),
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () =>
                                context.push('/notation_collecteur'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: accentColor,
                              side: BorderSide(
                                color: accentColor.withValues(alpha: 0.35),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                            ),
                            child: const Text('Noter'),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Récompenses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          _buildRewardCard('Recharge mobile', 400, goldColor),
                          const SizedBox(width: 12),
                          _buildRewardCard('Kit scolaire', 900, goldColor),
                          const SizedBox(width: 12),
                          _buildRewardCard(
                            'Bon d\'achat CDCI',
                            1500,
                            goldColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    context.push('/carte');
                    break;
                  case 2:
                    context.push('/signalement');
                    break;
                  case 3:
                    context.push('/profil');
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconBtn(
      onTap: () {
        ref.read(themeProvider.notifier).toggleTheme();
      },
      icon: isDark ? Icons.wb_sunny_outlined : Icons.mode_night_outlined,
      color: isDark ? AppTheme.soft : AppTheme.softLight,
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color valueColor, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                  fontFamily: 'Space Grotesk',
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard(String title, int points, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return GestureDetector(
      onTap: () {
        showToast(
          context,
          'Récompense « $title » échangée contre $points points',
        );
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$points PTS',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.14,
                color: color.withValues(alpha: 0.85),
                fontFamily: 'Space Grotesk',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Space Grotesk',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
