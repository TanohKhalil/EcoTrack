import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import '../../core/constants/mock_data.dart';

import 'package:ecotrack/core/utils/trace.dart';
class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {
  String _filter = 'tous';
  double _zoom = 1.0;
  String _searchQuery = '';
  CollectPoint? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final dangerColor = isDark ? AppTheme.danger : AppTheme.dangerLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              child: Row(
                children: [
                  IconBtn(
                    onTap: traceCallback("carte_screen.dart:41:onTap", () => context.pop()),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow(text: 'EcoTrack'),
                        Text(
                          'Carte des points de collecte',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontFamily: 'Space Grotesk',
                            letterSpacing: -0.01,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '12 actifs',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Map area
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [accentColor.withValues(alpha: 0.12), bgColor],
                  center: Alignment.topLeft,
                  radius: 0.6,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(accentColor.withValues(alpha: 0.05)),
                    ),
                  ),
                  // Search
                  Positioned(
                    top: 14,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 14,
                            color: textColor.withValues(alpha: 0.45),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Rechercher un quartier…',
                                hintStyle: TextStyle(
                                  color: textColor.withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                                fontFamily: 'Space Grotesk',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Filters
                  Positioned(
                    top: 64,
                    left: 20,
                    right: 20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilter('Tous', 'tous'),
                          const SizedBox(width: 7),
                          _buildFilter('Plastique', 'plastique'),
                          const SizedBox(width: 7),
                          _buildFilter('Organique', 'organique'),
                          const SizedBox(width: 7),
                          _buildFilter('Verre/Métal', 'verre'),
                          const SizedBox(width: 7),
                          _buildFilter('Signalements', 'danger'),
                        ],
                      ),
                    ),
                  ),
                  // Pins
                  ...MockData.pointsCollecte.map((point) => _buildPin(point)),
                  // Controls
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Column(
                      children: [
                        _buildMapControl(
                          Icons.add,
                          () => setState(
                            () => _zoom = (_zoom + 0.15)
                                .clamp(0.7, 1.8)
                                .toDouble(),
                          ),
                        ),
                        const SizedBox(height: 9),
                        _buildMapControl(
                          Icons.remove,
                          () => setState(
                            () => _zoom = (_zoom - 0.15)
                                .clamp(0.7, 1.8)
                                .toDouble(),
                          ),
                        ),
                        const SizedBox(height: 9),
                        _buildMapControl(Icons.my_location, () {
                          setState(() => _zoom = 1.0);
                          showToast(
                            context,
                            'Position recentrée sur votre position actuelle',
                          );
                        }),
                      ],
                    ),
                  ),
                  // Signal FAB
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: ElevatedButton.icon(
                      onPressed: traceCallback("carte_screen.dart:231:onPressed", () => context.push('/signalement')),
                      icon: const Icon(Icons.warning_amber_rounded, size: 15),
                      label: const Text('Signaler ici'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dangerColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Lower panel
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surface : AppTheme.surfaceLight,
                  border: Border(
                    top: BorderSide(color: accentColor.withValues(alpha: 0.14)),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildStatSmall('12', 'points actifs'),
                          const SizedBox(width: 9),
                          _buildStatSmall('3', 'à surveiller'),
                          const SizedBox(width: 9),
                          _buildStatSmall('2', 'signalements'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Eyebrow(
                        text: 'LÉGENDE · NIVEAU DE REMPLISSAGE (CAPTEUR IoT)',
                      ),
                      const SizedBox(height: 11),
                      _buildLegendItem(
                        'Bac libre / faible remplissage',
                        AppTheme.accent,
                      ),
                      _buildLegendItem(
                        'Remplissage moyen — à surveiller',
                        AppTheme.gold,
                      ),
                      _buildLegendItem(
                        'Dépôt sauvage signalé',
                        AppTheme.danger,
                      ),
                      _buildLegendItem(
                        'Point de collecte plastique',
                        AppTheme.plastic,
                      ),
                      _buildLegendItem('Point verre / métal', AppTheme.blue),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Points à proximité',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                          Text(
                            'trié par distance',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textColor.withValues(alpha: 0.4),
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11),
                      ...MockData.pointsCollecte
                          .take(4)
                          .map((point) => _buildPointItem(point)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    final isActive = _filter == value;
    return GestureDetector(
      onTap: traceCallback("carte_screen.dart:341:onTap", () => setState(() => _filter = value)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? accentColor : textColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? accentColor : accentColor.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: isActive
                ? AppTheme.accentInk
                : textColor.withValues(alpha: 0.65),
            fontFamily: 'Space Grotesk',
          ),
        ),
      ),
    );
  }

  Widget _buildPin(CollectPoint point) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getPinColor(point.colorName ?? 'accent');

    final show =
        _filter == 'tous' ||
        point.categorie.name == _filter ||
        (_filter == 'danger' && point.colorName == 'danger');

    if (!show) return const SizedBox.shrink();

    return Positioned(
      left: 20 + 260 * (0.2 + (point.nom.hashCode % 10) / 20),
      top: 20 + 160 * (0.2 + (point.nom.hashCode % 8) / 16),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPoint = point);
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPinColor(String name) {
    switch (name) {
      case 'gold':
        return AppTheme.gold;
      case 'danger':
        return AppTheme.danger;
      case 'plastic':
        return AppTheme.plastic;
      case 'blue':
        return AppTheme.blue;
      default:
        return AppTheme.accent;
    }
  }

  Widget _buildMapControl(IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: cardColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, size: 16, color: textColor),
      ),
    );
  }

  Widget _buildStatSmall(String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.16)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.accent,
                fontFamily: 'Space Grotesk',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w400,
                color: textColor.withValues(alpha: 0.5),
                fontFamily: 'Space Grotesk',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: textColor.withValues(alpha: 0.7),
                fontFamily: 'Space Grotesk',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointItem(CollectPoint point) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final color = _getPinColor(point.colorName ?? 'accent');

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPoint = point);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.nom,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  Text(
                    '${point.distanceKm.toStringAsFixed(1)} km · ${point.remplissageIoTPct}% plein',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.45),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: AppTheme.accent.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}
