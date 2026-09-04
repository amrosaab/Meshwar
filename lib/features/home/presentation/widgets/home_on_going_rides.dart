// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';

class HomeOnGoingRidesWidget extends StatelessWidget {
  final BuildContext cont;
  const HomeOnGoingRidesWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          final hasActiveOnGoingRide =
              homeBloc.onGoingRideList.any((ride) => ride.isCompleted != 1);
          if (!hasActiveOnGoingRide) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: List.generate(
                    (context.read<HomeBloc>().onGoingRideList.length > 3
                        ? 3
                        : context.read<HomeBloc>().onGoingRideList.length),
                    (index) {
                      final ride = context
                          .read<HomeBloc>()
                          .onGoingRideList
                          .elementAt(index);
                      final driverData = ride.driverDetail?.data;
                      final carNumber = driverData?.carNumber ?? ride.carNumber;
                      final vehicleTypeName =
                          driverData?.vehicleTypeName?.toString() ??
                              ride.vehicleTypeName;
                      final driverName = (driverData?.name ?? '').trim();
                      final carColor = (driverData?.carColor ?? '').trim();
                      final carMakeName =
                          (driverData?.carMakeName ?? '').trim();

                      return InkWell(
                          onTap: () {
                            context.read<HomeBloc>().add(
                                OnGoingRideOnTapEvent(selectedIndex: index));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 6, bottom: 6, top: 2, left: 1),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? const Color.fromARGB(255, 31, 32, 32)
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          //"ACTIVE RIDE"
                                          AppLocalizations.of(context)!
                                              .activeride,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MyText(
                                            text: (ride.acceptedAt != "" &&
                                                    ride.isDriverArrived == 0)
                                                ? AppLocalizations.of(context)!
                                                    .accepted
                                                : (ride.isDriverArrived == 1 &&
                                                        ride.isTripStart == 0)
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .arrived
                                                    : (ride.isCompleted == 1)
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .completed
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .tripStarted,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: (ride.acceptedAt !=
                                                              "" &&
                                                          ride.isDriverArrived ==
                                                              0)
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : (ride.isDriverArrived ==
                                                                  1 &&
                                                              ride.isTripStart ==
                                                                  0)
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : AppColors
                                                              .bottomNavigationBarUnSelectedColorDark,
                                                )),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FC),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                            color: const Color(0xFFE5E7EB),
                                            width: 0.2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: CachedNetworkImage(
                                          imageUrl: ride.vehicleTypeImage,
                                          height: 40,
                                          width: 40,
                                          placeholder: (_, __) =>
                                              const Loader(),
                                          errorWidget: (_, __, ___) =>
                                              Image.asset(AppImages.noImage),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  vehicleTypeName,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                "︱",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                flex: 3,
                                                child: MyText(
                                                  text: carMakeName,
                                                  textStyle: const TextStyle(
                                                      fontSize: 11),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                "•",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                flex: 2,
                                                child: MyText(
                                                  text: carColor,
                                                  textStyle: const TextStyle(
                                                      fontSize: 11),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark)
                                                      ? const Color.fromARGB(
                                                          255, 64, 65, 65)
                                                      : const Color(0xFFEDEFF3),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  carNumber,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              const Text(
                                                "•",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: MyText(
                                                  text: driverName,
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FC),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0xFFE5E7EB),
                                            width: 0.2),
                                      ),
                                      child: Icon(Icons.chevron_right,
                                          size: 25,
                                          color:
                                              (Theme.of(context).brightness ==
                                                      Brightness.dark)
                                                  ? const Color.fromARGB(
                                                      255, 31, 32, 32)
                                                  : Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                  options: CarouselOptions(
                    height: 110,
                    // aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    autoPlayCurve: Curves.ease,
                    enlargeCenterPage: false,
                    padEnds: false,
                    //enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      context.read<HomeBloc>().onGoingRideIndex = index;
                      context.read<HomeBloc>().add(UpdateEvent());
                    },
                  ),
                ),
                // SizedBox(height: size.width * 0.025),
                if (context.read<HomeBloc>().onGoingRideList.length > 1) ...[
                  SizedBox(height: size.width * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      (context.read<HomeBloc>().onGoingRideList.length > 3
                          ? 3
                          : context.read<HomeBloc>().onGoingRideList.length),
                      (index) {
                        final isSelected =
                            context.read<HomeBloc>().onGoingRideIndex == index;
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
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
