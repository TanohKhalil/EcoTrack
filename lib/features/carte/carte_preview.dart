import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/mock_data.dart';
import '../../core/theme/app_theme.dart';

class CartePreview extends StatefulWidget {
  final VoidCallback? onTap;
  final String title;

  const CartePreview({super.key, this.onTap, this.title = 'Carte'});

  @override
  State<CartePreview> createState() => _CartePreviewState();
}

class _CartePreviewState extends State<CartePreview> {
  final MapController _mapController = MapController();
  final LatLng _defaultCenter = const LatLng(5.3200, -4.0000);
  LatLng? _currentLocation;
  final double _zoom = 13.0;
  CollectPoint? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

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
    if (!mounted) return;

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation ?? _defaultCenter, _zoom);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 170,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withValues(alpha: 0.1)),
            ),
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
                        point: LatLng(point.latitude, point.longitude),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPoint = point),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _getPinColor(point.colorName ?? 'accent'),
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
                    }).toList(),
                    if (_currentLocation != null)
                      Marker(
                        width: 34,
                        height: 34,
                        point: _currentLocation!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accent.withValues(alpha: 0.25),
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
        ),
      ),
    );
  }
}
