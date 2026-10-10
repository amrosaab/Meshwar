// Native Google Maps visual check, using the production car projection.
// Run: flutter run -t tools/sedan_map_preview.dart -d <device-id>
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwar_user/common/sedan_pose.dart';
import 'package:meshwar_user/common/vehicle_marker_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VehicleMarkerHelper.preCacheSedanMarkers();
  runApp(const MaterialApp(home: SedanMapPreview()));
}

class SedanMapPreview extends StatefulWidget {
  const SedanMapPreview({super.key});
  @override
  State<SedanMapPreview> createState() => _SedanMapPreviewState();
}

class _SedanMapPreviewState extends State<SedanMapPreview>
    with SingleTickerProviderStateMixin {
  static const _center = LatLng(29.3759, 47.9774);
  static const _autoCheck = bool.fromEnvironment('SEDAN_AUTO_CHECK');
  GoogleMapController? _map;
  double _bearing = 0, _tilt = 0;
  bool _turning = false;
  bool _checking = _autoCheck;
  double _heading = 91.4;
  late final AnimationController _motion =
      AnimationController(vsync: this, duration: const Duration(seconds: 12))
        ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _motion.dispose();
    _map?.dispose();
    super.dispose();
  }

  Future<void> _camera({double? bearing, double? tilt}) async {
    await _map?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _center,
      zoom: 19,
      bearing: bearing ?? _bearing,
      tilt: tilt ?? _tilt,
    )));
  }

  // Optional repeatable native-device check. Uses no account or ride data.
  Future<void> _checkCameraViews() async {
    await Future<void>.delayed(const Duration(seconds: 8));
    for (final view in const [
      (0.0, 0.0, 91.4),
      (90.0, 45.0, 91.4),
      (180.0, 60.0, 359.0),
      (270.0, 45.0, 181.0),
    ]) {
      if (!mounted) return;
      setState(() {
        _turning = false;
        _heading = view.$3;
      });
      _motion.stop();
      await _camera(bearing: view.$1, tilt: view.$2);
      await Future<void>.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      debugPrint('SEDAN_CHECK: map=${_bearing.toStringAsFixed(1)} '
          'tilt=${_tilt.toStringAsFixed(1)} car=$_heading');
      await Future<void>.delayed(const Duration(seconds: 8));
    }
    if (!mounted) return;
    setState(() {
      _turning = true;
      _checking = false;
    });
    _motion.repeat();
    debugPrint('SEDAN_CHECK: continuous turning started');
  }

  Marker _car(String id, LatLng position, double heading) =>
      VehicleMarkerHelper.projectForCamera(
        Marker(
          markerId: MarkerId(id),
          position: position,
          rotation: VehicleMarkerHelper.sourceRotation('car', heading),
          icon: VehicleMarkerHelper.getMarker('car', bearing: heading),
        ),
        cameraBearing: _bearing,
        cameraTilt: _tilt,
      );

  @override
  Widget build(BuildContext context) {
    final progress = _motion.value;
    final heading = _turning ? progress * 360 : _heading;
    final moving = LatLng(
        _center.latitude,
        _center.longitude +
            (_turning ? math.sin(progress * 2 * math.pi) * .00012 : 0));
    return Scaffold(
      appBar: AppBar(title: const Text('Sedan map preview')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: _center, zoom: 19),
        onMapCreated: (map) {
          _map = map;
          if (_autoCheck) _checkCameraViews();
        },
        onCameraMove: (camera) => setState(() {
          _bearing = camera.bearing;
          _tilt = camera.tilt;
        }),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        scrollGesturesEnabled: !_checking,
        rotateGesturesEnabled: !_checking,
        tiltGesturesEnabled: !_checking,
        zoomGesturesEnabled: !_checking,
        markers: {
          _car('moving', moving, heading),
          _car('north', const LatLng(29.37610, 47.97740), 0),
          _car('south', const LatLng(29.37570, 47.97740), 180),
          _car('west', const LatLng(29.37590, 47.97715), 270),
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Car ${SedanPose.normalize(heading).toStringAsFixed(1)}° · '
              'Map ${_bearing.toStringAsFixed(1)}° · Tilt ${_tilt.toStringAsFixed(1)}°'),
          const SizedBox(height: 12),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: _checking
                        ? null
                        : () => _camera(bearing: (_bearing + 90) % 360),
                    child: const Text('Rotate map')),
                OutlinedButton(
                    onPressed: _checking
                        ? null
                        : () => _camera(
                            tilt: _tilt < 30
                                ? 45
                                : _tilt < 55
                                    ? 60
                                    : 0),
                    child: const Text('Tilt map')),
                FilledButton(
                    onPressed: _checking
                        ? null
                        : () {
                            setState(() => _turning = !_turning);
                            if (_turning) {
                              _motion.repeat();
                            } else {
                              _motion.stop();
                            }
                          },
                    child: Text(_turning ? 'Stop car' : 'Turn car')),
              ]),
        ]),
      ),
    );
  }
}
