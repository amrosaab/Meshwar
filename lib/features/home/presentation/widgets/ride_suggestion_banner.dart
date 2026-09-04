// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_arguments.dart';
import '../../../../common/app_colors.dart';
import '../../application/home_bloc.dart';
import '../pages/destination_page.dart';

class RideSuggestionBanner extends StatelessWidget {
  final BuildContext cont;
  const RideSuggestionBanner({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
        value: cont.read<HomeBloc>(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final homeBloc = context.read<HomeBloc>();
            final allAppModuleBanners =
                homeBloc.userData?.appModuleBannerImage?.data ?? [];

            // Show based on appModuleBannerImage is not empty and not null
            if (homeBloc.userData?.appModuleBannerImage == null ||
                allAppModuleBanners.isEmpty) {
              return const SizedBox.shrink();
            }

            // Show active module banners
            final appModuleBannerData =
                allAppModuleBanners.where((b) => b.active == 1).toList();

            if (appModuleBannerData.isEmpty) return const SizedBox.shrink();

            final bannerData = appModuleBannerData;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider(
                  items: List.generate(
                    bannerData.length,
                    (index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (homeBloc.userData == null) return;

                          // Resolve module for this banner item
                          final module = bannerData[index].module;

                          // No module → image-only, no navigation
                          if (module == null) return;

                          final String resolvedTransportType =
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
                            homeBloc.add(ServiceTypeChangeEvent(
                              transportType: resolvedTransportType,
                              serviceTypeIndex: resolvedServiceIndex,
                              shouldNavigate: true,
                            ));
                          } else {
                            Navigator.pushNamed(
                              context,
                              DestinationPage.routeName,
                              arguments: DestinationPageArguments(
                                title: 'Taxi',
                                pickupAddress: homeBloc.currentLocation,
                                pickupLatLng: homeBloc.currentLatLng,
                                userData: homeBloc.userData!,
                                pickUpChange: false,
                                transportType: resolvedTransportType,
                                isOutstationRide: resolvedServiceIndex == 3,
                                isBiddingRide: resolvedServiceIndex == 4,
                                isSharedRide: resolvedServiceIndex == 5,
                                selectedServiceIndex: resolvedServiceIndex,
                                mapType: homeBloc.mapType,
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 1,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedNetworkImage(
                              imageUrl: bannerData[index].previewImage,
                              width: size.width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.withOpacity(0.1),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.withOpacity(0.1),
                                child: const Center(
                                  child: Icon(Icons.error_outline,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  options: CarouselOptions(
                    height: homeBloc.isHomeLayoutSelected == 'morden_layout'
                        ? size.width * 0.35
                        : size.width * 0.2,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: bannerData.length > 1,
                    reverse: false,
                    autoPlay: bannerData.length > 1,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 600),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.15,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      homeBloc.appModuleBannerIndex = index;
                      homeBloc.add(UpdateEvent());
                    },
                  ),
                ),
                if (appModuleBannerData.length > 1) ...[
                  SizedBox(height: size.width * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      appModuleBannerData.length,
                      (index) {
                        final isSelected =
                            context.read<HomeBloc>().appModuleBannerIndex ==
                                index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          height: 6,
                          width: isSelected ? 20 : 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : AppColors.greyHeader.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ],
            );
          },
        ));
  }
}
