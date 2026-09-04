// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/stop_address_model.dart';
import '../../../../../home/presentation/pages/confirm_location_page.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/delete_address_widget.dart';
import '../widget/favourites_shimmer_loading.dart';
import 'confirm_fav_location.dart';

class FavoriteLocationPage extends StatelessWidget {
  final FavouriteLocationPageArguments arg;
  static const String routeName = '/favoriteLocation';

  const FavoriteLocationPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(GetFavListEvent(
            userData: arg.userData,
            favAddressList: arg.userData.favouriteLocations.data))
        ..add(AccGetUserDetailsEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is SelectFromFavAddressState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                arguments: ConfirmLocationPageArguments(
                  isEditAddress: false,
                  userData: arg.userData,
                  isOutstationRide: false,
                  isPickupEdit: false,
                  mapType: context.read<AccBloc>().userData!.mapType,
                  transportType: '',
                  selectedServiceIndex: arg.selectedServiceIndex,
                )).then(
                  (value) {
                if (!context.mounted) return;
                if (value != null) {
                  final address = value as AddressModel;
                  if (state.addressType == 'Home' ||
                      state.addressType == 'Work') {
                    context.read<AccBloc>().add(AddFavAddressEvent(
                        isOther: false,
                        address: address.address,
                        name: state.addressType,
                        lat: address.lat.toString(),
                        lng: address.lng.toString()));
                  } else {
                    if (context.read<AccBloc>().userData != null) {
                      Navigator.pushNamed(context, ConfirmFavLocation.routeName,
                          arguments: ConfirmFavouriteLocationPageArguments(
                            userData: context.read<AccBloc>().userData!,
                            selectedAddress: address,
                            selectedServiceIndex: arg.selectedServiceIndex,
                          )).then(
                            (value) {
                          if (!context.mounted) return;
                          context.read<AccBloc>().add(AccGetUserDetailsEvent());
                        },
                      );
                    }
                  }
                }
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.favoriteLocation,
              automaticallyImplyLeading: true,
              titleFontSize: 18,
              textColor: Theme.of(context).primaryColorDark,
            ),
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (context.read<AccBloc>().isFavLoading)
                            ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return FavouriteShimmerLoading(size: size);
                              },
                            ),
                          if (!context.read<AccBloc>().isFavLoading) ...[
                            // Home Address Card
                            (context.read<AccBloc>().home.isNotEmpty)
                                ? LiquidGlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.home_rounded,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(
                                                context)!
                                                .home,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          MyText(
                                            text: context
                                                .read<AccBloc>()
                                                .home[0]
                                                .pickAddress,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                color: AppColors
                                                    .greyHintColor,
                                                fontSize: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor:
                                          AppColors.surfaceStrong(
                                              context),
                                          builder: (_) {
                                            return DeleteAddressWidget(
                                                cont: context,
                                                isHome: true,
                                                isWork: false,
                                                isOthers: false,
                                                addressId: context
                                                    .read<AccBloc>()
                                                    .home[0]
                                                    .id);
                                          });
                                    },
                                    child: Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.red
                                                .withOpacity(0.1)),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 20,
                                          color: AppColors.red,
                                        )),
                                  ),
                                ],
                              ),
                            )
                                : InkWell(
                              onTap: () {
                                context.read<AccBloc>().add(
                                    SelectFromFavAddressEvent(
                                        addressType: 'Home'));
                              },
                              child: LiquidGlassContainer(
                                borderRadius: 12,
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceBorder(
                                            context),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.home_rounded,
                                        color: Theme.of(context)
                                            .hintColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: AppLocalizations.of(
                                                  context)!
                                                  .home,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                  color: Theme.of(
                                                      context)
                                                      .primaryColorDark,
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            const SizedBox(height: 4),
                                            MyText(
                                              text: AppLocalizations.of(
                                                  context)!
                                                  .tapAddAddress,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                  color: AppColors
                                                      .greyHintColor,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        )),
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Work Address Card
                            (context.read<AccBloc>().work.isNotEmpty)
                                ? LiquidGlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.work_rounded,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(
                                                context)!
                                                .work,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          MyText(
                                            text: context
                                                .read<AccBloc>()
                                                .work[0]
                                                .pickAddress,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                color: AppColors
                                                    .greyHintColor,
                                                fontSize: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor:
                                          AppColors.surfaceStrong(
                                              context),
                                          builder: (_) {
                                            return DeleteAddressWidget(
                                                cont: context,
                                                isHome: false,
                                                isWork: true,
                                                isOthers: false,
                                                addressId: context
                                                    .read<AccBloc>()
                                                    .work[0]
                                                    .id);
                                          });
                                    },
                                    child: Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.red
                                                .withOpacity(0.1)),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 20,
                                          color: AppColors.red,
                                        )),
                                  ),
                                ],
                              ),
                            )
                                : InkWell(
                              onTap: () {
                                context.read<AccBloc>().add(
                                    SelectFromFavAddressEvent(
                                        addressType: 'Work'));
                              },
                              child: LiquidGlassContainer(
                                borderRadius: 12,
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceBorder(
                                            context),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.work_rounded,
                                        color: Theme.of(context)
                                            .hintColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: AppLocalizations.of(
                                                  context)!
                                                  .work,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                  color: Theme.of(
                                                      context)
                                                      .primaryColorDark,
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            const SizedBox(height: 4),
                                            MyText(
                                              text: AppLocalizations.of(
                                                  context)!
                                                  .tapAddAddress,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                  color: AppColors
                                                      .greyHintColor,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        )),
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Other Addresses List
                            if (context.read<AccBloc>().others.isNotEmpty)
                              ListView.builder(
                                itemCount:
                                context.read<AccBloc>().others.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 12),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      LiquidGlassContainer(
                                        borderRadius: 12,
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                              const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.bookmark_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    MyText(
                                                      text: context
                                                          .read<AccBloc>()
                                                          .others[index]
                                                          .addressName,
                                                      textStyle: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                          color: Theme.of(
                                                              context)
                                                              .primaryColorDark,
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    MyText(
                                                      text: context
                                                          .read<AccBloc>()
                                                          .others[index]
                                                          .pickAddress,
                                                      textStyle: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                          color: AppColors
                                                              .greyHintColor,
                                                          fontSize: 14),
                                                      maxLines: 2,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                )),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    AppColors
                                                        .surfaceStrong(
                                                        context),
                                                    builder: (_) {
                                                      return DeleteAddressWidget(
                                                          cont: context,
                                                          isHome: false,
                                                          isWork: false,
                                                          isOthers: true,
                                                          addressId: context
                                                              .read<AccBloc>()
                                                              .others[index]
                                                              .id);
                                                    });
                                              },
                                              child: Container(
                                                  height: 36,
                                                  width: 36,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors.red
                                                          .withOpacity(0.1)),
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    size: 20,
                                                    color: AppColors.red,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  );
                                },
                              ),
                            // Add More Button
                            if (context.read<AccBloc>().others.length < 2)
                              InkWell(
                                onTap: () async {
                                  context
                                      .read<AccBloc>()
                                      .newAddressController
                                      .text = '';
                                  context.read<AccBloc>().add(
                                      SelectFromFavAddressEvent(
                                          addressType: context
                                              .read<AccBloc>()
                                              .newAddressController
                                              .text));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline_rounded,
                                        size: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .addMore,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}