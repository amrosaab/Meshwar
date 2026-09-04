// ignore_for_file: deprecated_member_use, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/notification/page/notification_page.dart';
import 'home_on_going_rides.dart';
import 'home_upcoming_rides.dart';

import '../../../../common/common.dart';
import '../../../../common/liquid_glass_container.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/ride_modules_model.dart';
import 'bottom_sheet_shimmer.dart';
import 'banner_widget.dart';
import 'ride_suggestion_banner.dart';

class BottomSheetWithoutMap extends StatefulWidget {
  final HomeBloc home;

  const BottomSheetWithoutMap({super.key, required this.home});

  @override
  State<BottomSheetWithoutMap> createState() => _BottomSheetWithoutMapState();
}

class _BottomSheetWithoutMapState extends State<BottomSheetWithoutMap> {
  final Map<String, String> _selectedModuleIdByTransport = {};

  String? _getSelectedModuleId(HomeBloc homeBloc, ModulesData module) {
    final cachedId = _selectedModuleIdByTransport[module.transportType];
    if (cachedId != null) {
      return cachedId;
    }

    final selectedType = homeBloc.selectedServiceType;
    if (selectedType != null &&
        selectedType.transportType == module.transportType &&
        selectedType.id.isNotEmpty) {
      return selectedType.id;
    }

    for (final m in homeBloc.rideModules) {
      if (m.transportType == module.transportType &&
          homeBloc.getServiceIndex(m) == homeBloc.selectedServiceIndex) {
        return m.id;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
        value: widget.home,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final homeBloc = context.read<HomeBloc>();
            if (homeBloc.userData == null) {
              return const SizedBox.shrink();
            }

            final taxiModules = homeBloc.rideModules
                .where((m) => m.transportType == 'taxi')
                .toList();
            final deliveryModules = homeBloc.rideModules
                .where((m) => m.transportType == 'delivery')
                .toList();
            final hasModules =
                taxiModules.isNotEmpty || deliveryModules.isNotEmpty;
            final bool showCombinedRideOptions =
                taxiModules.length == 1 && deliveryModules.length == 1;
            final hasActiveOnGoingRide =
            homeBloc.onGoingRideList.any((ride) => ride.isCompleted != 1);

            if (!hasModules) {
              if (homeBloc.isLoading) {
                return const BottomSheetShimmer();
              } else {
                return Column(
                  children: [
                    SizedBox(height: size.width * 0.03),
                    Image.asset(AppImages.noDataFound,
                        height: size.width * 0.62, width: size.width),
                    SizedBox(height: size.width * 0.02),
                    MyText(
                        text:
                        AppLocalizations.of(context)?.serviceNotAvailable ??
                            'Service not available for this location')
                  ],
                );
              }
            }

            return Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              decoration: BoxDecoration(
                color: AppColors.surfaceStrong(context),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: SafeArea(
                bottom: false,
                top: homeBloc.isSheetAtTop ? true : false,
                child: Column(
                  children: [
                    SizedBox(height: size.width * 0.01),
                    _buildCustomTopBar(context, size, homeBloc),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: homeBloc.isSheetAtTop
                            ? const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        )
                            : const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (homeBloc.userData!.appModuleBannerImage !=
                                null &&
                                homeBloc.userData!.appModuleBannerImage.data
                                    .isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, top: 10.0),
                                child: RideSuggestionBanner(cont: context),
                              ),
                            ],
                            if (homeBloc.isMultipleRide &&
                                hasActiveOnGoingRide) ...[
                              SizedBox(height: size.width * 0.04),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.autorenew),
                                        SizedBox(width: size.width * 0.01),
                                        MyText(
                                            text: AppLocalizations.of(context)!
                                                .onGoingRides,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColorDark)),
                                      ],
                                    ),
                                    if (context
                                        .read<HomeBloc>()
                                        .isMultipleRide) ...[
                                      if (context
                                          .read<HomeBloc>()
                                          .onGoingRideList
                                          .length >
                                          3)
                                        InkWell(
                                          onTap: () {
                                            context.read<HomeBloc>().add(
                                                NavigateToOnGoingRidesPageEvent());
                                          },
                                          child: MyText(
                                              text:
                                              AppLocalizations.of(context)!
                                                  .view,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColorDark)),
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(height: size.width * 0.01),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.0),
                                child: HomeOnGoingRidesWidget(cont: context),
                              ),
                            ],
                            SizedBox(height: size.width * 0.02),
                            if (showCombinedRideOptions)
                              _buildAllServices(
                                context,
                                size,
                                [
                                  taxiModules.first,
                                  deliveryModules.first,
                                ],
                                homeBloc,
                                title:
                                AppLocalizations.of(context)!.rideoptions,
                                showSeeAll: false,
                                showHeader: true,
                              ),
                            if (!showCombinedRideOptions) ...[
                              if (taxiModules.isNotEmpty)
                                _buildAllServices(
                                  context,
                                  size,
                                  _visibleModulesForSection(
                                      homeBloc, taxiModules),
                                  homeBloc,
                                  title: AppLocalizations.of(context)!.taxi,
                                  showSeeAll: taxiModules.length > 4,
                                  allModules: taxiModules,
                                ),
                              if (taxiModules.isNotEmpty &&
                                  deliveryModules.isNotEmpty)
                                SizedBox(height: size.width * 0.025),
                              if (deliveryModules.isNotEmpty)
                                _buildAllServices(
                                  context,
                                  size,
                                  _visibleModulesForSection(
                                      homeBloc, deliveryModules),
                                  homeBloc,
                                  title: AppLocalizations.of(context)!.delivery,
                                  showSeeAll: deliveryModules.length > 4,
                                  allModules: deliveryModules,
                                ),
                            ],
                            if (homeBloc.sheetSize > 0.7 &&
                                homeBloc.userData != null &&
                                homeBloc.userData!.bannerImage != null &&
                                homeBloc.userData!.bannerImage.data.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: BannerWidget(cont: context),
                              ),
                            if (homeBloc.sheetSize > 0.7 &&
                                context
                                    .read<HomeBloc>()
                                    .upcomingRideList
                                    .isNotEmpty) ...[
                              SizedBox(height: size.width * 0.05),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.autorenew),
                                        SizedBox(width: size.width * 0.01),
                                        MyText(
                                            text: AppLocalizations.of(context)!
                                                .upcoming,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColorDark)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.width * 0.01),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.0),
                                child: HomeUpcomingRidesWidget(cont: context),
                              ),
                            ],
                            SizedBox(height: size.width * 0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  List<ModulesData> _visibleModulesForSection(
      HomeBloc homeBloc, List<ModulesData> modules,
      {int maxVisible = 4}) {
    List<ModulesData> list = List<ModulesData>.from(modules);
    int idx = list.indexWhere(
            (m) => homeBloc.getServiceIndex(m) == homeBloc.selectedServiceIndex);
    if (idx >= maxVisible) {
      ModulesData selected = list.removeAt(idx);
      list.insert(0, selected);
    }
    return list.length > maxVisible ? list.sublist(0, maxVisible) : list;
  }

  Widget _buildAllServices(BuildContext context, Size size,
      List<ModulesData> modules, HomeBloc homeBloc,
      {String? title,
        bool showSeeAll = false,
        bool showHeader = true,
        List<ModulesData>? allModules}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: title ?? AppLocalizations.of(context)!.services,
                textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: homeBloc.isSheetAtTop ? 18 : 16,
                    fontWeight: FontWeight.w600),
              ),
              if (showSeeAll && allModules != null)
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppColors.surfaceStrong(context),
                      builder: (context) {
                        return BlocProvider.value(
                            value: homeBloc,
                            child: _viewAllServicesFiltered(
                                size, context, homeBloc, allModules));
                      },
                    );
                  },
                  child: MyText(
                    text: AppLocalizations.of(context)!.viewAll,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        SizedBox(height: size.width * 0.025),
        if (modules.length == 1)
          Row(
            children: [
              _buildServiceItem(
                context,
                size,
                modules[0],
                homeBloc,
                width: size.width * 0.61,
                height: size.width * 0.36,
              ),
            ],
          ),
        if (modules.length == 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.46, height: size.width * 0.36),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.46, height: size.width * 0.36),
            ],
          ),
        if (modules.length == 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.30,
                  height: size.width * 0.36,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.30,
                  height: size.width * 0.36,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.30,
                  height: size.width * 0.36,
                  isRow: false),
            ],
          ),
        if (modules.length == 4)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.22,
                  height: size.width * 0.34,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.22,
                  height: size.width * 0.34,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.22,
                  height: size.width * 0.34,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.22,
                  height: size.width * 0.34,
                  isRow: false),
            ],
          ),
        if (modules.length == 5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.44,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceItem(context, size, modules[0], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                        _buildServiceItem(context, size, modules[1], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                      ],
                    ),
                    SizedBox(height: size.width * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceItem(context, size, modules[2], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                        _buildServiceItem(context, size, modules[3], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                      ],
                    )
                  ],
                ),
              ),
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.62,
                  isRow: false,
                  isLarge: true),
            ],
          ),
        if (modules.length == 6) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.26,
                  isLarge: true),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.26,
                  isLarge: true),
            ],
          ),
        ],
        if (modules.length == 7) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceItem(context, size, modules[4], homeBloc,
                        width: size.width * 0.21,
                        height: size.width * 0.35,
                        isMedium: true,
                        isRow: false),
                    _buildServiceItem(context, size, modules[5], homeBloc,
                        width: size.width * 0.21,
                        height: size.width * 0.35,
                        isMedium: true,
                        isRow: false),
                  ],
                ),
              ),
              _buildServiceItem(
                context,
                size,
                modules[6],
                homeBloc,
                width: size.width * 0.44,
                height: size.width * 0.35,
                isLarge: true,
              ),
            ],
          ),
        ],
        if (modules.length == 8) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
        ],
        if (modules.length == 9) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.44,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceItem(context, size, modules[4], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                        _buildServiceItem(context, size, modules[5], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                      ],
                    ),
                    SizedBox(height: size.width * 0.0175),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceItem(context, size, modules[6], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                        _buildServiceItem(context, size, modules[7], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.34,
                            isRow: false),
                      ],
                    )
                  ],
                ),
              ),
              _buildServiceItem(context, size, modules[8], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.62,
                  isRow: false,
                  isLarge: true),
            ],
          ),
        ],
        if (modules.length == 10) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[8], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.26,
                  isLarge: true),
              _buildServiceItem(context, size, modules[9], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.26,
                  isLarge: true),
            ],
          ),
        ],
        SizedBox(height: size.width * 0.0175),
        if (modules.length == 11) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isMedium: true,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceItem(context, size, modules[8], homeBloc,
                        width: size.width * 0.21,
                        height: size.width * 0.35,
                        isMedium: true,
                        isRow: false),
                    _buildServiceItem(context, size, modules[9], homeBloc,
                        width: size.width * 0.21,
                        height: size.width * 0.35,
                        isMedium: true,
                        isRow: false),
                  ],
                ),
              ),
              _buildServiceItem(
                context,
                size,
                modules[10],
                homeBloc,
                width: size.width * 0.44,
                height: size.width * 0.35,
                isMedium: true,
              ),
            ],
          ),
        ],
        SizedBox(height: size.width * 0.0175),
        if (modules.length == 12) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[8], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[9], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[10], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
              _buildServiceItem(context, size, modules[11], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.35,
                  isRow: false),
            ],
          ),
        ],
      ],
    );
  }

  Widget _viewAllServicesFiltered(Size size, BuildContext context,
      HomeBloc homeBloc, List<ModulesData> modules) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.surfaceStrong(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAllServices(
                context,
                size,
                modules,
                homeBloc,
                showHeader: true,
              ),
              SizedBox(height: size.width * 0.1),
            ],
          ),
        ),
      ),
      Positioned(
        top: -37,
        right: 5,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceStrong(context),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surfaceBorder(context)),
            ),
            child: Icon(
              Icons.close,
              size: 20,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildServiceItem(
      BuildContext context, Size size, ModulesData module, HomeBloc homeBloc,
      {bool isRow = true,
        double? width,
        double? height,
        bool hasBadge = false,
        String? badgeText,
        bool isMedium = false,
        bool isLarge = false}) {
    int moduleIndex = homeBloc.getServiceIndex(module);
    _getSelectedModuleId(homeBloc, module);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedModuleIdByTransport[module.transportType] = module.id;
        });
        homeBloc.add(ServiceTypeChangeEvent(
            transportType: module.transportType,
            serviceTypeIndex: moduleIndex,
            shouldNavigate: false));
        if (homeBloc.pickupAddressList.isNotEmpty) {
          homeBloc.add(ServiceTypeChangeEvent(
              transportType: module.transportType,
              serviceTypeIndex: moduleIndex,
              shouldNavigate: true));
        }
      },
      child: LiquidGlassContainer(
        width: width,
        height: height,
        borderRadius: 20,
        padding: EdgeInsets.all(size.width * 0.01),
        child: Stack(
          children: [
            if (hasBadge && badgeText != null)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MyText(
                    text: badgeText,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Center(
              child: isRow
                  ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsGeometry.all(6),
                    child: _buildIconCircle(context, size, module,
                        isSmall:
                        width != null && width < size.width * 0.3,
                        isMedium: isMedium,
                        isLarge: isLarge),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyText(
                          text: module.name,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                        ),
                        if (module.shortDescription.isNotEmpty)
                          MyText(
                            text: module.shortDescription,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                              fontSize: 12,
                              color: AppColors.greyHintColor,
                            ),
                            maxLines: 2,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIconCircle(context, size, module,
                      isSmall: width != null && width < size.width * 0.3,
                      isMedium: isMedium,
                      isLarge: isLarge),
                  const SizedBox(height: 2),
                  Flexible(
                    child: MyText(
                      text: module.name,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                          fontSize: isLarge
                              ? (module.name
                              .split(' ')
                              .any((word) => word.length > 9)
                              ? 14
                              : 16)
                              : (module.name
                              .split(' ')
                              .any((word) => word.length > 9)
                              ? 10
                              : 12),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  if (module.shortDescription.isNotEmpty)
                    Flexible(
                      child: MyText(
                        text: module.shortDescription,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                          fontSize: isLarge ? 12 : 10,
                          color: AppColors.greyHintColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(BuildContext context, Size size, ModulesData module,
      {bool isSmall = false, bool isMedium = false, bool isLarge = false}) {
    double iconSize = isLarge ? 92 : (isMedium ? 72 : (isSmall ? 52 : 76));
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        // Pale brand-tinted backing per the reference design — same fixed
        // (non-theme-branching) value in both modes, since it's meant as
        // a deliberate brand accent behind the icon, not a neutral surface.
        color: AppColors.primary.withOpacity(0.08),
        shape: BoxShape.circle,
        boxShadow: AppColors.surfaceShadow(context),
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(iconSize * 0.16),
          child: CachedNetworkImage(
            imageUrl: module.menuIcon,
            placeholder: (context, url) => const Loader(),
            errorWidget: (context, url, error) => Icon(
              Icons.directions_car,
              size: iconSize * 0.6,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCustomTopBar(BuildContext context, Size size, HomeBloc homeBloc) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(0),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.borderColor,
                border: Border.all(color: AppColors.surfaceBorder(context)),
              ),
              clipBehavior: Clip.antiAlias,
              child: (homeBloc.userData?.profilePicture != null &&
                  homeBloc.userData!.profilePicture.isNotEmpty)
                  ? Image.network(
                homeBloc.userData!.profilePicture,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 22,
                    color: AppColors.hintColor,
                  );
                },
              )
                  : const Icon(
                Icons.person,
                size: 22,
                color: AppColors.hintColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    text:
                    '${ AppLocalizations.of(context)!.welcome}, ${homeBloc.userData?.name.split(' ').first ?? ''}',
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  ),
                  MyText(
                    text: AppLocalizations.of(context)!.whereAreYouGoing,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.greyHintColor,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceBorder(context)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // add your notification navigation here
                      Navigator.pushNamed(context, NotificationPage.routeName);
                    },
                    icon: Icon(
                      Icons.notifications_none,
                      color: Theme.of(context).primaryColorDark,
                      size: 22,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(top: 12, bottom: 0),
          child: Center(
            child: Container(
              height: 0.4,
              width: double.infinity,
              color: AppColors.surfaceBorder(context),
            ),
          ),
        ),
      ],
    ),
  );
}