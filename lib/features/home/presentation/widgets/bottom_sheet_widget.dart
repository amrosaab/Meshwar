// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/destination_page.dart';
import 'home_on_going_rides.dart';
import 'home_upcoming_rides.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/ride_modules_model.dart';
import 'bottom_sheet_shimmer.dart';

class BottomSheetWidget extends StatelessWidget {
  final HomeBloc home;

  const BottomSheetWidget({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
        value: home,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final homeBloc = context.read<HomeBloc>();
            if (homeBloc.userData == null) {
              return const SizedBox.shrink();
            }

            final uniqueTransportTypes = homeBloc.rideModules
                .map((m) => m.transportType)
                .toSet()
                .toList();

            final filteredModules = homeBloc.rideModules
                .where((m) => m.transportType == homeBloc.transportType)
                .toList();

            if (filteredModules.isEmpty) {
              if (homeBloc.isLoading) {
                return const BottomSheetShimmer();
              } else {
                return Column(
                  children: [
                    SizedBox(height: size.width * 0.03),
                    Image.asset(AppImages.noDataFound,
                        height: size.width * 0.5, width: size.width),
                    SizedBox(height: size.width * 0.02),
                    MyText(
                        text: AppLocalizations.of(context)!.serviceNotAvailable)
                  ],
                );
              }
            }

            final displayModules =
            _getBottomSheetDisplayModules(filteredModules, homeBloc);

            return Container(
              height: double.infinity,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: SafeArea(
                bottom: false,
                top: homeBloc.isSheetAtTop ? true : false,
                child: Column(
                  children: [
                    SizedBox(height: size.width * 0.05),
                    Container(
                      width: size.width * 0.1,
                      height: size.width * 0.01,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    if (uniqueTransportTypes.length > 1) ...[
                      SizedBox(height: size.width * 0.05),
                      _buildCategorySelector(context, size, homeBloc),
                      SizedBox(height: size.width * 0.025),
                    ] else
                      SizedBox(height: size.width * 0.05),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: homeBloc.isSheetAtTop
                            ? const BouncingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (filteredModules.isNotEmpty)
                              _buildAllServices(
                                context,
                                size,
                                displayModules,
                                homeBloc,
                                showSeeAll: homeBloc.sheetSize <= 0.7 &&
                                    filteredModules.length > 4,
                                allModules: filteredModules,
                              ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(size.width * 0.03),
                              decoration: BoxDecoration(
                                color: AppColors.surface(context),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppColors.surfaceShadow(context),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSearchBar(context, size, homeBloc),
                                  if (homeBloc.recentSearchPlaces.isNotEmpty &&
                                      homeBloc.selectedServiceIndex != 2 &&
                                      homeBloc.isSheetAtTop) ...[
                                    SizedBox(height: size.width * 0.05),
                                    _buildRecentSearch(context, size, homeBloc),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: size.width * 0.03),
                            if (homeBloc.sheetSize > 0.7 &&
                                homeBloc.userData != null &&
                                homeBloc.userData!.bannerImage != null &&
                                homeBloc
                                    .userData!.bannerImage.data.isNotEmpty) ...[
                              Builder(builder: (ctx) {
                                // Normal banners
                                final normalBanners =
                                homeBloc.userData!.bannerImage != null
                                    ? homeBloc.userData!.bannerImage.data
                                    : [];
                                // App-module banners — show ALL active banners
                                final allModule = homeBloc
                                    .userData!.appModuleBannerImage?.data ??
                                    [];
                                final moduleBanners = allModule
                                    .where((b) => b.active == 1)
                                    .toList();

                                final int normalCount =
                                normalBanners.length as int;
                                final int totalCount =
                                    normalCount + (moduleBanners.length as int);
                                if (totalCount == 0) {
                                  return const SizedBox.shrink();
                                }

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5.0, left: 8.0, right: 8.0),
                                      child: CarouselSlider(
                                        items:
                                        List.generate(totalCount, (index) {
                                          final bool isModule =
                                              index >= normalCount;
                                          final String imageUrl = isModule
                                              ? moduleBanners[
                                          index - normalCount]
                                              .previewImage as String
                                              : normalBanners[index].image
                                          as String;

                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (isModule) {
                                                // Navigate only when module data exists
                                                if (homeBloc.userData == null) {
                                                  return;
                                                }
                                                final module = moduleBanners[
                                                index - normalCount]
                                                    .module;
                                                // No module → image-only, no action
                                                if (module == null) return;
                                                final String
                                                resolvedTransportType =
                                                    module.transportType;
                                                int resolvedServiceIndex;
                                                switch (module.serviceType) {
                                                  case 'rental':
                                                    resolvedServiceIndex = 2;
                                                    break;
                                                  case 'outstation':
                                                    resolvedServiceIndex = 3;
                                                    break;
                                                  case 'bidding':
                                                    resolvedServiceIndex = 4;
                                                    break;
                                                  case 'shared_ride':
                                                    resolvedServiceIndex = 5;
                                                    break;
                                                  default:
                                                    resolvedServiceIndex = 0;
                                                }
                                                if (resolvedServiceIndex == 2) {
                                                  homeBloc.add(
                                                      ServiceTypeChangeEvent(
                                                        transportType:
                                                        resolvedTransportType,
                                                        serviceTypeIndex:
                                                        resolvedServiceIndex,
                                                        shouldNavigate: true,
                                                      ));
                                                } else {
                                                  Navigator.pushNamed(
                                                    ctx,
                                                    DestinationPage.routeName,
                                                    arguments:
                                                    DestinationPageArguments(
                                                      title: 'Taxi',
                                                      pickupAddress: homeBloc
                                                          .currentLocation,
                                                      pickupLatLng: homeBloc
                                                          .currentLatLng,
                                                      userData:
                                                      homeBloc.userData!,
                                                      pickUpChange: false,
                                                      transportType:
                                                      resolvedTransportType,
                                                      isOutstationRide:
                                                      resolvedServiceIndex ==
                                                          3,
                                                      isBiddingRide:
                                                      resolvedServiceIndex ==
                                                          4,
                                                      isSharedRide:
                                                      resolvedServiceIndex ==
                                                          5,
                                                      selectedServiceIndex:
                                                      resolvedServiceIndex,
                                                      mapType: homeBloc.mapType,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                // Launch URL for normal banner
                                                final url = normalBanners[index]
                                                    .imageUrl as String;
                                                if (url.isNotEmpty) {
                                                  final uri = Uri.parse(url);
                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri,
                                                        mode: LaunchMode
                                                            .externalApplication);
                                                  }
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                  size.width * 0.01),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(16.0),
                                                color: AppColors.surface(context),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(16.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: imageUrl,
                                                  width: size.width,
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        child: const Center(
                                                          child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                      Container(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        child: const Center(
                                                          child: Icon(
                                                              Icons.error_outline,
                                                              color: Colors.grey),
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        options: CarouselOptions(
                                          height: size.width * 0.2,
                                          viewportFraction: 0.9,
                                          initialPage: 0,
                                          enableInfiniteScroll: totalCount > 1,
                                          autoPlay: totalCount > 1,
                                          autoPlayInterval:
                                          const Duration(seconds: 4),
                                          autoPlayAnimationDuration:
                                          const Duration(milliseconds: 600),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          enlargeFactor: 0.15,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (idx, reason) {
                                            homeBloc.bannerIndex = idx;
                                            homeBloc.add(UpdateEvent());
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: List.generate(
                                        totalCount,
                                            (index) {
                                          final isSelected =
                                              homeBloc.bannerIndex == index;
                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            height: 6,
                                            width: isSelected ? 20 : 6,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(6),
                                              color: isSelected
                                                  ? Theme.of(context)
                                                  .primaryColor
                                                  : AppColors.greyHeader
                                                  .withOpacity(0.5),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
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
                            if (homeBloc.isMultipleRide &&
                                homeBloc.sheetSize > 0.7 &&
                                context
                                    .read<HomeBloc>()
                                    .onGoingRideList
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
                            SizedBox(
                                height: MediaQuery.of(context).padding.bottom +
                                    20),
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

  Widget _buildCategorySelector(
      BuildContext context, Size size, HomeBloc homeBloc) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(50),
          boxShadow: AppColors.surfaceShadow(context),
        ),
        height: homeBloc.isSheetAtTop ? size.width * 0.12 : size.width * 0.10,
        padding: EdgeInsets.all(size.width * 0.01),
        child: Row(
          children: [
            _categoryButton(context, size, homeBloc, 'taxi',
                AppLocalizations.of(context)!.taxi, Icons.local_taxi_outlined),
            _categoryButton(
                context,
                size,
                homeBloc,
                'delivery',
                AppLocalizations.of(context)!.delivery,
                Icons.card_giftcard_outlined),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(BuildContext context, Size size, HomeBloc homeBloc,
      String type, String label, IconData icon) {
    bool isSelected = homeBloc.transportType == type;
    return Expanded(
      child: InkWell(
        onTap: () {
          homeBloc.add(ServiceTypeChangeEvent(
              transportType: type,
              serviceTypeIndex: type == 'taxi' ? 0 : 1,
              shouldNavigate: false));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            boxShadow: isSelected
                ? [
              BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ]
                : [],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: homeBloc.isSheetAtTop ? 18 : 16,
                  color: isSelected ? Colors.white : Theme.of(context).primaryColorDark),
              SizedBox(width: size.width * 0.02),
              MyText(
                text: label,
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: homeBloc.isSheetAtTop ? 16 : 14,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Theme.of(context).primaryColorDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ModulesData> _getBottomSheetDisplayModules(
      List<ModulesData> modules, HomeBloc homeBloc) {
    // Only apply reordering in collapsed bottom sheet.
    if (homeBloc.sheetSize > 0.7) return modules;
    if (modules.length <= 4) return modules;

    final selectedIndex = modules.indexWhere(
            (m) => homeBloc.getServiceIndex(m) == homeBloc.selectedServiceIndex);
    final base = modules.sublist(0, 4);
    if (selectedIndex <= 3 || selectedIndex == -1) return base;

    return [
      base[0],
      base[1],
      base[2],
      modules[selectedIndex],
    ];
  }

  Widget _buildAllServices(BuildContext context, Size size,
      List<ModulesData> modules, HomeBloc homeBloc,
      {String? title,
        bool showSeeAll = false,
        bool showHeader = true,
        List<ModulesData>? allModules}) {
    if (modules.length < 2) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // OLD HEADER (kept for safety)
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
        if (modules.length == 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.44, height: size.width * 0.18),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.44, height: size.width * 0.18),
            ],
          ),
        if (modules.length == 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.28,
                  height: size.width * 0.30,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.28,
                  height: size.width * 0.30,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.28,
                  height: size.width * 0.30,
                  isRow: false),
            ],
          ),
        if (modules.length == 4)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[0], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.36,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.36,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.36,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.36,
                  isMedium: true,
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
                            height: size.width * 0.24,
                            isRow: false),
                        _buildServiceItem(context, size, modules[1], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.24,
                            isRow: false),
                      ],
                    ),
                    SizedBox(height: size.width * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceItem(context, size, modules[2], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.24,
                            isRow: false),
                        _buildServiceItem(context, size, modules[3], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.24,
                            isRow: false),
                      ],
                    )
                  ],
                ),
              ),
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.5,
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
                  height: size.width * 0.36,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.36,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.36,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.36,
                  isMedium: true,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.03),
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
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
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
                        height: size.width * 0.25,
                        isMedium: true,
                        isRow: false),
                    _buildServiceItem(context, size, modules[5], homeBloc,
                        width: size.width * 0.21,
                        height: size.width * 0.25,
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
                height: size.width * 0.25,
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
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
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
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
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
                            height: size.width * 0.24,
                            isRow: false),
                        _buildServiceItem(context, size, modules[5], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.24,
                            isRow: false),
                      ],
                    ),
                    SizedBox(height: size.width * 0.0175),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceItem(context, size, modules[6], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.24,
                            isRow: false),
                        _buildServiceItem(context, size, modules[7], homeBloc,
                            width: size.width * 0.21,
                            height: size.width * 0.24,
                            isRow: false),
                      ],
                    )
                  ],
                ),
              ),
              _buildServiceItem(context, size, modules[8], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.5,
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
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[8], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.18,
                  isLarge: true),
              _buildServiceItem(context, size, modules[9], homeBloc,
                  width: size.width * 0.44,
                  height: size.width * 0.18,
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
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
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
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isMedium: true,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
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
                        height: size.width * 0.25,
                        isMedium: true,
                        isRow: false),
                    _buildServiceItem(context, size, modules[9], homeBloc,
                        width: size.width * 0.21,
                        height: size.width * 0.25,
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
                height: size.width * 0.25,
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
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[1], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[2], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[3], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[4], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[5], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[6], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[7], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
            ],
          ),
          SizedBox(height: size.width * 0.0175),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(context, size, modules[8], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[9], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[10], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
              _buildServiceItem(context, size, modules[11], homeBloc,
                  width: size.width * 0.21,
                  height: size.width * 0.25,
                  isRow: false),
            ],
          ),
        ],
      ],
    );
  }

  Widget _viewAllServicesFiltered(Size size, BuildContext context,
      HomeBloc homeBloc, List<ModulesData> modules) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: AppColors.surfaceStrong(context),
                border: Border(top: BorderSide(color: AppColors.surfaceBorder(context))),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
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

            // Close Button
            Positioned(
              top: -37,
              right: 5,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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

    bool isSelected = homeBloc.selectedServiceIndex == moduleIndex;

    return InkWell(
      onTap: () {
        homeBloc.add(ServiceTypeChangeEvent(
            transportType: module.transportType,
            serviceTypeIndex: moduleIndex,
            shouldNavigate: false));
      },
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(size.width * 0.01),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.meshwarRed.withOpacity(0.06)
              : AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : AppColors.surfaceShadow(context),
        ),
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
                    color: AppColors.meshwarRed,
                    borderRadius: BorderRadius.circular(4),
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
                  _buildIconCircle(context, size, module,
                      isSmall: width != null && width < size.width * 0.3,
                      isMedium: isMedium,
                      isLarge: isLarge,
                      isSelected: isSelected),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: MyText(
                      text: module.name,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 2,
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
                      isLarge: isLarge,
                      isSelected: isSelected),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(BuildContext context, Size size, ModulesData module,
      {bool isSmall = false, bool isMedium = false, bool isLarge = false, bool isSelected = false})
  {
    double iconSize = isLarge ? 68 : (isMedium ? 48 : (isSmall ? 36 : 52));
    double circleSize = iconSize * 1.3;
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white
            : AppColors.meshwarRed.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: CachedNetworkImage(
          imageUrl: module.menuIcon,
          placeholder: (context, url) => const Loader(),
          errorWidget: (context, url, error) => Icon(
            Icons.directions_car,
            size: iconSize * 0.6,
            color: AppColors.meshwarRed,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, Size size, HomeBloc homeBloc) {
    return InkWell(
      onTap: () {
        if (homeBloc.pickupAddressList.isNotEmpty) {
          homeBloc.add(ServiceTypeChangeEvent(
              transportType: homeBloc.transportType,
              serviceTypeIndex: homeBloc.selectedServiceIndex,
              shouldNavigate: true));
        }
      },
      child: ClipRRect(
        borderRadius: homeBloc.isSheetAtTop
            ? BorderRadius.circular(16)
            : BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: homeBloc.isSheetAtTop
                ? BorderRadius.circular(16)
                : BorderRadius.circular(8),
          ),
          padding: homeBloc.isSheetAtTop
              ? const EdgeInsets.symmetric(vertical: 12)
              : const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.search, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MyText(
                  text: homeBloc.selectedServiceIndex == 2
                      ? AppLocalizations.of(context)!.choosePickupLocation
                      : AppLocalizations.of(context)!.whereAreYouGoing,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.hintColor,
                    fontSize: 16,
                  ),
                ),
              ),
              if (homeBloc.selectedServiceIndex != 2) ...[
                if (homeBloc.userData?.showRideWithoutDestination == "1")
                  InkWell(
                    onTap: () => homeBloc.add(RideWithoutDestinationEvent()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MyText(
                        text: AppLocalizations.of(context)!.skip,
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearch(
      BuildContext context, Size size, HomeBloc homeBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.recentSearch,
              textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: homeBloc.isSheetAtTop ? 18 : 14,
                  fontWeight: FontWeight.bold),
            ),
            if (homeBloc.recentSearchPlaces.length > 2)
              InkWell(
                onTap: () {
                  // TODO: wire to a full recent-searches view once that
                  // screen/route exists — visual-only for now.
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
        SizedBox(height: size.width * 0.02),
        ListView.builder(
          itemCount: (homeBloc.sheetSize <= 0.7)
              ? (homeBloc.recentSearchPlaces.isNotEmpty ? 1 : 0)
              : (homeBloc.recentSearchPlaces.length > 2
              ? 2
              : homeBloc.recentSearchPlaces.length),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final recentPlace =
            homeBloc.recentSearchPlaces.reversed.elementAt(index);
            return InkWell(
              onTap: () {
                if (homeBloc.pickupAddressList.isNotEmpty) {
                  homeBloc.add(RecentSearchPlaceSelectEvent(
                      address: recentPlace,
                      isPickupSelect: false,
                      transportType: homeBloc.transportType,
                      serviceTypeIndex: homeBloc.selectedServiceIndex));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    homeBloc.isSheetAtTop
                        ? Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.meshwarRed.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time_filled,
                        size: 18,
                        color: AppColors.meshwarRed,
                      ),
                    )
                        : Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.meshwarRed.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time_filled,
                        size: 18,
                        color: AppColors.meshwarRed,
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: recentPlace.address.split(',')[0],
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          MyText(
                            text: recentPlace.address,
                            textStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.hintColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     // TODO: wire to a "save as favorite" action once
                    //     // that exists for recent searches — visual-only
                    //     // for now, matching the reference's star icon.
                    //   },
                    //   icon: const Icon(Icons.star_border,
                    //       color: AppColors.hintColor),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}