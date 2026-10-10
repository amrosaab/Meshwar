import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../features/bookingpage/presentation/page/booking/widget/futuristic_car_widget.dart';
import 'tobitmap.dart';
import 'sedan_pose.dart';

class VehicleMarkerHelper {
  static final Map<String, BitmapDescriptor> _cache = {};
  static final Map<String, Map<int, BitmapDescriptor>> _sprites = {
    'car': {},
    'bike': {},
    'van': {},
  };
  static bool _isInitialized = false;
  // Source icons retain their world heading. Only the map view projects them
  // into a camera-relative frame, so movement interpolation stays unchanged.
  static final Map<BitmapDescriptor, int> _sedanHeadings = {};
  static final Map<SedanPose, BitmapDescriptor> _sedanViews = {};

  static BitmapDescriptor _sedanView(SedanPose pose) => _sedanViews.putIfAbsent(
      pose, () => AssetMapBitmap(pose.assetPath, width: 64, height: 64));

  static int headingFrame(double bearing, {double cameraBearing = 0}) {
    return SedanPose.forCamera(bearing, cameraBearing: cameraBearing).heading;
  }

  static double? worldBearingFor(Marker marker) {
    final heading = _sedanHeadings[marker.icon];
    if (heading == null) return null;
    return marker.rotation != 0 && marker.rotation.isFinite
        ? SedanPose.normalize(marker.rotation)
        : heading.toDouble();
  }

  static double rotationForCamera(Marker marker,
      {double cameraBearing = 0, double cameraTilt = 0}) {
    final bearing = worldBearingFor(marker);
    if (bearing == null) return marker.rotation;
    return SedanPose.forCamera(bearing,
            cameraBearing: cameraBearing, cameraTilt: cameraTilt)
        .rotationCorrection(bearing, cameraBearing);
  }

  static bool isSedanMarker(Marker marker) =>
      _sedanHeadings.containsKey(marker.icon);

  static bool isSedanType(String iconName) => const {
        'car',
        'taxi',
        'hatchback',
        'premium',
        'luxury',
        'suv'
      }.contains(iconName);

  /// Keep the precise world heading alongside the rounded sedan sprite.
  /// Camera projection uses it for smooth turns on both native map SDKs.
  static double sourceRotation(String iconName, double bearing) =>
      isSedanType(iconName) || !isSpriteBased(iconName)
          ? SedanPose.normalize(bearing)
          : 0;

  static String? sedanAssetFor(Marker marker,
      {double cameraBearing = 0, double cameraTilt = 0}) {
    final bearing = worldBearingFor(marker);
    if (bearing == null) return null;
    return SedanPose.forCamera(bearing,
            cameraBearing: cameraBearing, cameraTilt: cameraTilt)
        .assetPath;
  }

  static Marker projectForCamera(Marker marker,
      {double cameraBearing = 0, double cameraTilt = 0}) {
    final bearing = worldBearingFor(marker);
    if (bearing == null) return marker;
    final pose = SedanPose.forCamera(bearing,
        cameraBearing: cameraBearing, cameraTilt: cameraTilt);
    return marker.copyWith(
      iconParam: _sedanView(pose),
      rotationParam: pose.rotationCorrection(bearing, cameraBearing),
      flatParam: false,
      anchorParam: const Offset(0.5, 0.5),
    );
  }

  static void preCacheSedanMarkers() {
    // The native SDK loads only views that are displayed. Do not decode or
    // preload the entire heading/tilt atlas into memory on app startup.
    for (var angle = 0; angle < 360; angle += SedanPose.headingStep) {
      final icon = _sedanView(SedanPose(angle, 0));
      _sprites['car']![angle] = icon;
      _sedanHeadings[icon] = angle;
    }
  }

  static Future<void> preCacheMarkers() async {
    if (_isInitialized) return;
    preCacheSedanMarkers();

    // 1. Load Sprite-based markers
    // Car, Bike and Van: 60 frames (0001.png - 0060.png)
    final sixtyFrameTypes = {
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
            const ImageConfiguration(size: Size(52, 52)),
            assetPath,
            width: type == 'car' ? 64 : 52,
            height: type == 'car' ? 64 : 52,
          );
          if (type == 'car') {
            _sedanHeadings[_sprites[type]![angle]!] = angle;
          }
        } catch (e) {
          debugPrint('Could not load $type sprite: $assetPath');
        }
      }
    }

    // Load remaining sprite types (if any)
    final twelveFrameTypes = {};

    for (var entry in twelveFrameTypes.entries) {
      final type = entry.key;
      final path = entry.value;
      for (int angle = 0; angle < 360; angle += 30) {
        String assetPath =
            '${path}heading_${angle.toString().padLeft(3, '0')}.png';
        try {
          _sprites[type]![angle] = await BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(52, 52)),
            assetPath,
          );
        } catch (e) {
          debugPrint('Could not load $type sprite: $assetPath');
        }
      }
    }

    final vehicleConfigs = {
      'car': {'color': Colors.white, 'type': FuturisticVehicleType.car},
      'taxi': {
        'color': const Color(0xFFFFD700),
        'type': FuturisticVehicleType.car
      },
      'hatchback': {'color': Colors.white, 'type': FuturisticVehicleType.car},
      'premium': {
        'color': const Color(0xFFC0C0C0),
        'type': FuturisticVehicleType.car
      },
      'luxury': {
        'color': const Color(0xFF1A1A1A),
        'type': FuturisticVehicleType.car
      },
      'suv': {
        'color': const Color(0xFF4682B4),
        'type': FuturisticVehicleType.car
      },
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
          size: 36,
          bearing: 0,
        ).toBitmapDescriptor(
          logicalSize: const Size(40, 40),
          imageSize: const Size(80, 80),
        );
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error pre-caching markers: $e');
    }
  }

  static BitmapDescriptor getMarker(String iconName, {double bearing = 0}) {
    if (isSedanType(iconName) && _sprites['car']!.isNotEmpty) {
      return _sprites['car']![headingFrame(bearing)]!;
    }
    if (!_isInitialized) {
      return BitmapDescriptor.defaultMarker;
    }

    String? category;
    int step = 30; // default for 12 frames
    if (isSedanType(iconName)) {
      category = 'car';
      step = SedanPose.headingStep;
    } else if (['bike', 'motor_bike'].contains(iconName)) {
      category = 'bike';
      step = 6; // 60 frames (Updated!)
    } else if (['truck', 'hcv', 'mcv', 'lcv', 'ehcv', 'van']
        .contains(iconName)) {
      category = 'van';
      step = 6; // 60 frames (Updated!)
    }

    if (category != null && _sprites[category]!.isNotEmpty) {
      // Normalize bearing to 0-359
      double normalized = bearing.isFinite ? (bearing % 360 + 360) % 360 : 0;
      // Round to nearest step (6 for car, 30 for others)
      int rounded = ((normalized / step).round() * step) % 360;

      return _sprites[category]![rounded] ??
          _cache[iconName] ??
          _cache['car'] ??
          BitmapDescriptor.defaultMarker;
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
