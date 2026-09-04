import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../features/bookingpage/presentation/page/booking/widget/futuristic_car_widget.dart';
import 'tobitmap.dart';

class VehicleMarkerHelper {
  static final Map<String, BitmapDescriptor> _cache = {};
  static final Map<String, Map<int, BitmapDescriptor>> _sprites = {
    'car': {},
    'bike': {},
    'van': {},
  };
  static bool _isInitialized = false;

  static Future<void> preCacheMarkers() async {
    if (_isInitialized) return;

    // 1. Load Sprite-based markers
    // Car, Bike and Van: 60 frames (0001.png - 0060.png)
    final sixtyFrameTypes = {
      'car': 'assets/car_sprites/',
      'bike': 'assets/bike_sprites/',
      'van': 'assets/van_sprites/',
    };

    for (var entry in sixtyFrameTypes.entries) {
      final type = entry.key;
      final path = entry.value;
      for (int i = 1; i <= 60; i++) {
        String assetPath = '$path${i.toString().padLeft(4, '0')}.png';
        try {
          // Map index to angle: (i-1) * (360/60) = (i-1) * 6 degrees
          int angle = (i - 1) * 6;
          _sprites[type]![angle] = await BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(80, 80)),
            assetPath,
          );
        } catch (e) {
          debugPrint('Could not load $type sprite: $assetPath');
        }
      }
    }

    // Load remaining sprite types (if any)
    final twelveFrameTypes = {
    };

    for (var entry in twelveFrameTypes.entries) {
      final type = entry.key;
      final path = entry.value;
      for (int angle = 0; angle < 360; angle += 30) {
        String assetPath = '${path}heading_${angle.toString().padLeft(3, '0')}.png';
        try {
          _sprites[type]![angle] = await BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(80, 80)),
            assetPath,
          );
        } catch (e) {
          debugPrint('Could not load $type sprite: $assetPath');
        }
      }
    }

    final vehicleConfigs = {
      'car': {'color': Colors.white, 'type': FuturisticVehicleType.car},
      'taxi': {'color': const Color(0xFFFFD700), 'type': FuturisticVehicleType.car}, 
      'hatchback': {'color': Colors.white, 'type': FuturisticVehicleType.car},
      'premium': {'color': const Color(0xFFC0C0C0), 'type': FuturisticVehicleType.car}, 
      'luxury': {'color': const Color(0xFF1A1A1A), 'type': FuturisticVehicleType.car}, 
      'suv': {'color': const Color(0xFF4682B4), 'type': FuturisticVehicleType.car}, 
      'bike': {'color': Colors.grey, 'type': FuturisticVehicleType.bike},
      'motor_bike': {'color': Colors.grey, 'type': FuturisticVehicleType.bike},
      'auto': {'color': Colors.green, 'type': FuturisticVehicleType.auto},
      'truck': {'color': Colors.white, 'type': FuturisticVehicleType.van},
      'hcv': {'color': Colors.white, 'type': FuturisticVehicleType.van},
      'mcv': {'color': Colors.white, 'type': FuturisticVehicleType.van},
      'lcv': {'color': Colors.white, 'type': FuturisticVehicleType.van},
      'ehcv': {'color': Colors.white, 'type': FuturisticVehicleType.van},
      'van': {'color': Colors.white, 'type': FuturisticVehicleType.van},
    };

    try {
      for (var entry in vehicleConfigs.entries) {
        final config = entry.value;
        _cache[entry.key] = await FuturisticCarWidget(
          primaryColor: config['color'] as Color,
          type: config['type'] as FuturisticVehicleType,
          size: 55,
          bearing: 0, 
        ).toBitmapDescriptor(
          logicalSize: const Size(60, 60),
          imageSize: const Size(120, 120),
        );
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error pre-caching markers: $e');
    }
  }

  static BitmapDescriptor getMarker(String iconName, {double bearing = 0}) {
    if (!_isInitialized) {
      return BitmapDescriptor.defaultMarker;
    }

    String? category;
    int step = 30; // default for 12 frames
    if (['car', 'taxi', 'hatchback', 'premium', 'luxury', 'suv'].contains(iconName)) {
      category = 'car';
      step = 6; // 60 frames
    } else if (['bike', 'motor_bike'].contains(iconName)) {
      category = 'bike';
      step = 6; // 60 frames (Updated!)
    } else if (['truck', 'hcv', 'mcv', 'lcv', 'ehcv', 'van'].contains(iconName)) {
      category = 'van';
      step = 6; // 60 frames (Updated!)
    }

    if (category != null && _sprites[category]!.isNotEmpty) {
      // Normalize bearing to 0-359
      double normalized = (bearing % 360 + 360) % 360;
      // Round to nearest step (6 for car, 30 for others)
      int rounded = ((normalized / step).round() * step) % 360;
      
      return _sprites[category]![rounded] ?? _cache[iconName] ?? _cache['car'] ?? BitmapDescriptor.defaultMarker;
    }

    return _cache[iconName] ?? _cache['car'] ?? BitmapDescriptor.defaultMarker;
  }

  static bool isSpriteBased(String iconName) {
    return true; 
  }

  static Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await preCacheMarkers();
    }
  }
}
