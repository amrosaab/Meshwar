// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';

class ServicesModuleWidget extends StatelessWidget {
  final HomeBloc home;

  const ServicesModuleWidget({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: home,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          return Column(
            children: [
              SizedBox(height: size.width * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (homeBloc.rideModules.length > 1)
                    Row(
                      children: [
                        const Icon(Icons.grid_view_rounded, size: 20),
                        const SizedBox(width: 5),
                        MyText(
                          text: AppLocalizations.of(context)!.service,
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  if (homeBloc.rideModules.length > 4)
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return BlocProvider.value(
                                value: homeBloc,
                                child:
                                    viewAllServices(size, context, homeBloc));
                          },
                        );
                      },
                      child: MyText(
                        text: AppLocalizations.of(context)!.viewAll,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              SizedBox(height: size.width * 0.025),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    homeBloc.rideModules.length > 4
                        ? 4
                        : homeBloc.rideModules.length,
                    (index) {
                      final module = homeBloc.rideModules.elementAt(index);
                      final isSelected =
                          module.name == homeBloc.selectedServiceType!.name;

                      return InkWell(
                        onTap: () {
                          if (homeBloc.pickupAddressList.isNotEmpty) {
                            if (module.serviceType == 'normal') {
                              if (module.transportType == 'delivery') {
                                homeBloc.add(ServiceTypeChangeEvent(
                                    transportType: module.transportType,
                                    serviceTypeIndex: 1));
                              } else {
                                homeBloc.add(ServiceTypeChangeEvent(
                                    transportType: module.transportType,
                                    serviceTypeIndex: 0));
                              }
                            } else if (module.serviceType == 'rental') {
                              homeBloc.add(ServiceTypeChangeEvent(
                                  transportType: module.transportType,
                                  serviceTypeIndex: 2));
                            } else if (module.serviceType == 'outstation') {
                              homeBloc.add(ServiceTypeChangeEvent(
                                  transportType: module.transportType,
                                  serviceTypeIndex: 3));
                            }
                          }
                        },
                        child: Container(
                          height: size.width * 0.225,
                          width: size.width * 0.225,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF0F2FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: isSelected ? 2 : 1,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.grey,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(size.width * 0.01),
                          margin: EdgeInsets.only(right: size.width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CachedNetworkImage(
                                  imageUrl: module.menuIcon,
                                  fit: BoxFit.contain,
                                  height: size.width * 0.08,
                                  width: size.width * 0.08,
                                  placeholder: (context, url) => const Center(
                                    child: Loader(),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.directions_car,
                                    size: size.width * 0.08,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.width * 0.01,
                              ),
                              MyText(
                                text: module.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget viewAllServices(Size size, BuildContext context, HomeBloc homeBloc) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: AppLocalizations.of(context)!.service,
                  textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.width * 0.05),

            // Services Grid
            Wrap(
              spacing: size.width * 0.03,
              runSpacing: size.width * 0.03,
              children: List.generate(
                homeBloc.rideModules.length,
                (index) {
                  final module = homeBloc.rideModules.elementAt(index);
                  final isSelected =
                      module.name == homeBloc.selectedServiceType!.name;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (homeBloc.pickupAddressList.isNotEmpty) {
                        if (module.serviceType == 'normal') {
                          if (module.transportType == 'delivery') {
                            homeBloc.add(ServiceTypeChangeEvent(
                                transportType: module.transportType,
                                serviceTypeIndex: 1));
                          } else {
                            homeBloc.add(ServiceTypeChangeEvent(
                                transportType: module.transportType,
                                serviceTypeIndex: 0));
                          }
                        } else if (module.serviceType == 'rental') {
                          homeBloc.add(ServiceTypeChangeEvent(
                              transportType: module.transportType,
                              serviceTypeIndex: 2));
                        } else if (module.serviceType == 'outstation') {
                          homeBloc.add(ServiceTypeChangeEvent(
                              transportType: module.transportType,
                              serviceTypeIndex: 3));
                        }
                      }
                    },
                    child: Container(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFF0F2FF) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: isSelected ? 2 : 1,
                          color:
                              isSelected ? AppColors.primary : AppColors.grey,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(size.width * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: module.menuIcon,
                              fit: BoxFit.contain,
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              placeholder: (context, url) => const Center(
                                child: Loader(),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.directions_car,
                                size: size.width * 0.1,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.blue[700],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.width * 0.01,
                          ),
                          Center(
                            child: MyText(
                              text: module.name,
                              maxLines: 2,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: size.width * 0.1),
          ],
        ),
      ),
    );
  }
}
