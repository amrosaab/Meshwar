import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as fmlt;

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';
import 'bottom_sheet_without map.dart';

class HomeBodyWithoutMap extends StatefulWidget {
  final HomeBloc home;

  const HomeBodyWithoutMap({super.key, required this.home});

  @override
  State<HomeBodyWithoutMap> createState() => _HomeBodyWithoutMapState();
}

class _HomeBodyWithoutMapState extends State<HomeBodyWithoutMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _markerAnimationController;
  final Map<String, fmlt.LatLng> _startMarkerPoints = {};
  final Map<String, fmlt.LatLng> _targetMarkerPoints = {};

  @override
  void initState() {
    super.initState();
    _markerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _markerAnimationController.dispose();
    super.dispose();
  }

  void _syncMarkerAnimation(List<dynamic> markers) {
    bool hasPositionUpdates = false;
    final activeIds = <String>{};

    for (final item in markers) {
      if (item is! Marker) continue;
      final marker = item;
      final id = marker.markerId.value;
      activeIds.add(id);
      final nextPoint = fmlt.LatLng(
        marker.position.latitude,
        marker.position.longitude,
      );
      final previousTarget = _targetMarkerPoints[id];

      if (previousTarget == null) {
        _startMarkerPoints[id] = nextPoint;
        _targetMarkerPoints[id] = nextPoint;
        continue;
      }

      final isSamePoint = previousTarget.latitude == nextPoint.latitude &&
          previousTarget.longitude == nextPoint.longitude;
      if (!isSamePoint) {
        _startMarkerPoints[id] = _interpolatedPoint(id) ?? previousTarget;
        _targetMarkerPoints[id] = nextPoint;
        hasPositionUpdates = true;
      }
    }

    _startMarkerPoints.removeWhere((id, _) => !activeIds.contains(id));
    _targetMarkerPoints.removeWhere((id, _) => !activeIds.contains(id));

    if (hasPositionUpdates) {
      _markerAnimationController.forward(from: 0);
    }
  }

  fmlt.LatLng? _interpolatedPoint(String markerId) {
    final from = _startMarkerPoints[markerId];
    final to = _targetMarkerPoints[markerId];
    if (from == null || to == null) return null;

    final t = Curves.linear.transform(_markerAnimationController.value);
    return fmlt.LatLng(
      from.latitude + (to.latitude - from.latitude) * t,
      from.longitude + (to.longitude - from.longitude) * t,
    );
  }
  // OSM Map update

  @override
  Widget build(BuildContext context) {
    final home = widget.home; // OSM Map update
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: home,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          _syncMarkerAnimation(homeBloc.markerList); //OSM Map Animate

          return Stack(
            children: [
              // The map and other widgets
              SizedBox(
                height: size.height,
                width: size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Column(
                              children: [
                                if (homeBloc.userData != null )
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(30),
                                        ),
                                      ),
                                      child: homeBloc.serviceAvailable
                                          ? BottomSheetWithoutMap(
                                              home: homeBloc)
                                          : Column(
                                              children: [
                                                SizedBox(
                                                    height: size.width * 0.03),
                                                Image.asset(
                                                  AppImages.noDataFound,
                                                  height: size.width * 0.5,
                                                  width: size.width,
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.02),
                                                MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .serviceNotAvailable,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
