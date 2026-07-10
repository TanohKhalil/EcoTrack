import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
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
  final MapController _mapController = MapController();
  final LatLng _defaultCenter = LatLng(5.3200, -4.0000);
  LatLng? _currentLocation;
  String _filter = 'tous';
  double _zoom = 13.0;
  String _searchQuery = '';
  CollectPoint? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation ?? _defaultCenter, _zoom);
  }

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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  IconBtn(
                    onTap: traceCallback(
                      "carte_screen.dart:41:onTap",
                      () => context.pop(),
                    ),
                    icon: Icons.arrow_back_ios_new,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow(text: 'EcoTrack'),
                        const SizedBox(height: 4),
                        Text(
                          'Cartographie intelligente',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            fontFamily: 'Space Grotesk',
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.24),
                      ),
                    ),
                    child: Text(
                      '12 actifs',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: _currentLocation ?? _defaultCenter,
                              initialZoom: _zoom,
                              minZoom: 5,
                              maxZoom: 18,
                              onTap: (_, __) {
                                setState(() => _selectedPoint = null);
                              },
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                userAgentPackageName: 'com.ecotrack.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  ...MockData.pointsCollecte.map((point) {
                                    return Marker(
                                      width: 46,
                                      height: 46,
                                      point: LatLng(
                                        point.latitude,
                                        point.longitude,
                                      ),
                                      child: GestureDetector(
                                        onTap: () => setState(
                                          () => _selectedPoint = point,
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: _getPinColor(
                                              point.colorName ?? 'accent',
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: _getPinColor(
                                                  point.colorName ?? 'accent',
                                                ).withValues(alpha: 0.28),
                                                blurRadius: 18,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  if (_currentLocation != null)
                                    Marker(
                                      width: 34,
                                      height: 34,
                                      point: _currentLocation!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.accent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.accent.withValues(
                                                alpha: 0.25,
                                              ),
                                              blurRadius: 18,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 18,
                          left: 18,
                          right: 18,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor.withValues(alpha: 0.96),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 18,
                                  color: textColor.withValues(alpha: 0.65),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) =>
                                        setState(() => _searchQuery = value),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Trouver un secteur ou un point...',
                                      hintStyle: TextStyle(
                                        color: textColor.withValues(alpha: 0.5),
                                        fontFamily: 'Space Grotesk',
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                      fontFamily: 'Space Grotesk',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 82,
                          left: 18,
                          right: 18,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilter('Tous', 'tous'),
                                const SizedBox(width: 8),
                                _buildFilter('Plastique', 'plastique'),
                                const SizedBox(width: 8),
                                _buildFilter('Organique', 'organique'),
                                const SizedBox(width: 8),
                                _buildFilter('Verre/Métal', 'verre'),
                                const SizedBox(width: 8),
                                _buildFilter('Signalements', 'danger'),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 18,
                          bottom: 108,
                          child: Column(
                            children: [
                              _buildMapControl(Icons.add, () {
                                setState(
                                  () => _zoom = (_zoom + 1.0).clamp(5.0, 18.0),
                                );
                                _mapController.move(
                                  _mapController.camera.center,
                                  _zoom,
                                );
                              }),
                              const SizedBox(height: 10),
                              _buildMapControl(Icons.remove, () {
                                setState(
                                  () => _zoom = (_zoom - 1.0).clamp(5.0, 18.0),
                                );
                                _mapController.move(
                                  _mapController.camera.center,
                                  _zoom,
                                );
                              }),
                              const SizedBox(height: 10),
                              _buildMapControl(Icons.my_location, () {
                                if (_currentLocation != null) {
                                  _mapController.move(_currentLocation!, _zoom);
                                  showToast(
                                    context,
                                    'Position recentrée sur votre position actuelle',
                                  );
                                } else {
                                  showToast(context, 'Position non disponible');
                                }
                              }),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 18,
                          right: 18,
                          bottom: 18,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 11,
                                  height: 11,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: accentColor.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedPoint == null
                                        ? 'Sélectionnez un point sur la carte pour voir les détails.'
                                        : '${_selectedPoint!.nom} • ${_selectedPoint!.distanceKm.toStringAsFixed(1)} km',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                      fontFamily: 'Space Grotesk',
                                    ),
                                  ),
                                ),
                                if (_selectedPoint != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accentColor.withValues(
                                        alpha: 0.14,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      '${_selectedPoint!.remplissageIoTPct}% rempli',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: accentColor,
                                        fontFamily: 'Space Grotesk',
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 18,
                          left: 22,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Carte en direct',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor,
                                    fontFamily: 'Space Grotesk',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surface : AppTheme.surfaceLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedPoint != null) ...[
                        _buildSelectedPointCard(_selectedPoint!),
                        const SizedBox(height: 18),
                      ],
                      Row(
                        children: [
                          _buildStatSmall('12', 'points actifs'),
                          const SizedBox(width: 10),
                          _buildStatSmall('3', 'à surveiller'),
                          const SizedBox(width: 10),
                          _buildStatSmall('2', 'signalements'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Eyebrow(text: 'LÉGENDE'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildLegendTag('Bac libre', AppTheme.accent),
                          _buildLegendTag('À surveiller', AppTheme.gold),
                          _buildLegendTag('Dépôt signalé', AppTheme.danger),
                          _buildLegendTag('Plastique', AppTheme.plastic),
                          _buildLegendTag('Verre/Métal', AppTheme.blue),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'À proximité',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          fontFamily: 'Space Grotesk',
                        ),
                      ),
                      const SizedBox(height: 10),
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
      onTap: traceCallback(
        "carte_screen.dart:341:onTap",
        () => setState(() => _filter = value),
      ),
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

  Widget _buildLegendTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: 'Space Grotesk',
        ),
      ),
    );
  }

  Widget _buildSelectedPointCard(CollectPoint point) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            point.nom,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textColor,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLegendTag(
                '${point.remplissageIoTPct}% rempli',
                _getPinColor(point.colorName ?? 'accent'),
              ),
              const SizedBox(width: 10),
              _buildLegendTag(
                '${point.distanceKm.toStringAsFixed(1)} km',
                AppTheme.accent,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            point.gestionnaire,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor.withValues(alpha: 0.7),
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Accepté: ${point.dechetsAcceptes.join(', ')}',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: textColor.withValues(alpha: 0.68),
              fontFamily: 'Space Grotesk',
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
      onTap: () => setState(() => _selectedPoint = point),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.nom,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${point.distanceKm.toStringAsFixed(1)} km · ${point.remplissageIoTPct}% plein',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.65),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.accent.withValues(alpha: 0.9),
            ),
          ],
        ),
      ),
    );
  }
}
