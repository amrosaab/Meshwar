// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/custom_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/staggered_reveal.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/fav_location/page/fav_location.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../bookingpage/presentation/page/booking/page/booking_page.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/stop_address_model.dart';
import '../../domain/models/user_details_model.dart';
import '../widgets/leave_instruction.dart';
import '../widgets/select_contact.dart';
import 'confirm_location_page.dart';

class DestinationPage extends StatefulWidget {
  static const String routeName = '/destinationPage';
  final DestinationPageArguments arg;

  const DestinationPage({super.key, required this.arg});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  final _routeTimelineKey = GlobalKey();
  final _pickupMarkerKey = GlobalKey();
  final _destinationMarkerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(DesinationPageInitEvent(arg: widget.arg)),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          final homeBloc = context.read<HomeBloc>();
          if (state is HomeInitialState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is LogoutState) {
            if (homeBloc.nearByVechileSubscription != null) {
              homeBloc.nearByVechileSubscription?.cancel();
              homeBloc.nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is SelectFromMapState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                    arguments: ConfirmLocationPageArguments(
                        userData: widget.arg.userData,
                        isPickupEdit: state.isPickUpEdit,
                        isOutstationRide: widget.arg.isOutstationRide,
                        isEditAddress: false,
                        mapType: widget.arg.mapType,
                        transportType: homeBloc.transportType,
                        selectedServiceIndex: widget.arg.selectedServiceIndex))
                .then(
              (value) {
                if (value != null) {
                  if (!context.mounted) return;
                  final address = value as AddressModel;
                  if (homeBloc.transportType.toLowerCase() == 'delivery') {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: false,
                      isScrollControlled: true,
                      barrierColor: Colors.black54,
                      builder: (_) {
                        return BlocProvider.value(
                          value: homeBloc,
                          child: LeaveInstructions(
                            cont: context,
                            address: address,
                            isReceiveParcel:
                                widget.arg.title == 'Receive Parcel',
                            name: widget.arg.userData.name,
                            number: widget.arg.userData.mobile,
                            transportType: widget.arg.transportType,
                          ),
                        );
                      },
                    );
                  } else {
                    homeBloc.add(AddOrEditStopAddressEvent(
                      isPickUpEdit: state.isPickUpEdit,
                      choosenAddressIndex: homeBloc.choosenAddressIndex,
                      newAddress: address,
                    ));
                  }
                }
              },
            );
          } else if (state is RecentSearchPlaceSelectState) {
            if (homeBloc.choosenAddressIndex == 0) {
              homeBloc.pickUpLatLng =
                  LatLng(state.address.lat, state.address.lng);
            }
            if (homeBloc.transportType.toLowerCase() == 'delivery') {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: true,
                barrierColor: Colors.black54,
                builder: (_) {
                  return PopScope(
                    canPop: false,
                    child: BlocProvider.value(
                      value: homeBloc,
                      child: LeaveInstructions(
                        cont: context,
                        address: state.address,
                        isReceiveParcel: widget.arg.title == 'Receive Parcel',
                        name: widget.arg.userData.name,
                        number: widget.arg.userData.mobile,
                        transportType: widget.arg.transportType,
                      ),
                    ),
                  );
                },
              );
            } else {
              homeBloc.addressList[homeBloc.choosenAddressIndex] =
                  state.address;
              context
                  .read<HomeBloc>()
                  .addressTextControllerList[homeBloc.choosenAddressIndex]
                  .text = state.address.address;
              if (!context
                  .read<HomeBloc>()
                  .addressList
                  .any((element) => element.address.isEmpty)) {
                homeBloc.add(ConfirmRideAddressEvent(
                    rideType: widget.arg.transportType,
                    addressList: homeBloc.addressList));
              }
            }
          } else if (state is AddOrEditAddressState) {
            if (!context
                .read<HomeBloc>()
                .addressList
                .any((element) => element.address.isEmpty)) {
              homeBloc.add(ConfirmRideAddressEvent(
                  rideType: widget.arg.isOutstationRide ? 'outstation' : 'taxi',
                  addressList: homeBloc.addressList));
            }
          } else if (state is ReceiverDetailsState) {
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              barrierColor: Colors.black54,
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: LeaveInstructions(
                      cont: context,
                      address: state.address,
                      transportType: widget.arg.transportType,
                      isReceiveParcel: widget.arg.title == 'Receive Parcel',
                      name: widget.arg.userData.name,
                      number: widget.arg.userData.mobile),
                );
              },
            );
          } else if (state is SelectContactDetailsState) {
            homeBloc.isMyself = false;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: const SelectFromContactList(),
                );
              },
            );
          } else if (state is ConfirmRideAddressState) {
            if (homeBloc.nearByVechileSubscription != null) {
              homeBloc.nearByVechileSubscription?.cancel();
              homeBloc.nearByVechileSubscription = null;
            }
            Navigator.pushNamed(
              context,
              BookingPage.routeName,
              arguments: BookingPageArguments(
                  picklat: homeBloc.pickupAddressList[0].lat.toString(),
                  picklng: homeBloc.pickupAddressList[0].lng.toString(),
                  droplat: homeBloc.stopAddressList.last.lat.toString(),
                  droplng: homeBloc.stopAddressList.last.lng.toString(),
                  userData: widget.arg.userData,
                  transportType: widget.arg.transportType,
                  pickupAddressList: homeBloc.pickupAddressList,
                  stopAddressList: homeBloc.stopAddressList,
                  title: widget.arg.title,
                  polyString: '',
                  distance: '',
                  duration: '',
                  isOutstationRide: widget.arg.isOutstationRide,
                  mapType: widget.arg.mapType,
                  preferenceId: widget.arg.preferenceId,
                  isBiddingRide: widget.arg.isBiddingRide,
                  isSharedRide: widget.arg.isSharedRide,
                  selectedServiceIndex: widget.arg.selectedServiceIndex,
                  isUpcomingRide: widget.arg.isUpcomingRide ?? false),
            );
          } else if (state is ServiceNotAvailableState) {
            homeBloc.pickupAddressList.clear();
            homeBloc.stopAddressList.clear();
            homeBloc.add(UpdateEvent());
            showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceStrong(context),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: AppColors.surfaceBorder(context)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.meshwarRed.withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: -8,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                                alignment: homeBloc.textDirection == 'rtl'
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.close_rounded,
                                        color: AppColors.darkGrey, size: 22))),
                            Container(
                              height: 48,
                              width: 48,
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.red,
                              ),
                              child: const Icon(Icons.info_outline_rounded,
                                  color: Colors.white, size: 24),
                            ),
                            MyText(
                              text: state.message,
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color:
                                          Theme.of(context).primaryColorDark),
                            ),
                            const SizedBox(height: 18),
                            CustomButton(
                              width: double.infinity,
                              buttonName: AppLocalizations.of(context)!.okText,
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final homeBloc = context.read<HomeBloc>();
            return Directionality(
              textDirection: Directionality.of(context),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: false,
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      elevation: 0,
                      centerTitle: false,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      leading: Padding(
                        padding: const EdgeInsets.all(10),
                        child: NavigationIconWidget(
                          onTap: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Theme.of(context).primaryColorDark),
                          isShadowWidget: true,
                        ),
                      ),
                      toolbarHeight: 60,
                      titleSpacing: 0,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 4),
                        child: MyText(
                            text: AppLocalizations.of(context)!.planYourRide,
                            textAlign: TextAlign.start,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    letterSpacing: -0.3)),
                      ),
                      actions: [
                        (homeBloc.addressList.length < 4 &&
                                !widget.arg.isOutstationRide)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: AppColors.beaconGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.meshwarRed
                                            .withValues(alpha: 0.35),
                                        blurRadius: 18,
                                        spreadRadius: -4,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<HomeBloc>()
                                          .add(AddStopEvent());
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          size: 18,
                                          color: AppColors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        MyText(
                                            text: AppLocalizations.of(context)!
                                                .addStop,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 3),
                                child: SizedBox(width: 1),
                              )
                      ],
                    ),
                    body: CustomBackground(
                      child: SafeArea(
                        top: false,
                        bottom: false,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 60 +
                                    MediaQuery.of(context).padding.top +
                                    10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StaggeredReveal(
                                  index: 0,
                                  child: buildLocationSelect(
                                      context, size, homeBloc),
                                ),
                                if (context
                                    .read<HomeBloc>()
                                    .searchInfoMessage
                                    .isEmpty) ...[
                                  SizedBox(height: size.width * 0.04),
                                  if (homeBloc.userData != null)
                                    StaggeredReveal(
                                      index: 1,
                                      child: buildFavoriteLocations(
                                          context,
                                          context
                                              .read<HomeBloc>()
                                              .userData!
                                              .favouriteLocations
                                              .data,
                                          size,
                                          homeBloc),
                                    ),
                                  SizedBox(height: size.width * 0.04),
                                  if (context
                                      .read<HomeBloc>()
                                      .recentSearchPlaces
                                      .isNotEmpty) ...[
                                    if (context
                                            .read<HomeBloc>()
                                            .recentRoutes
                                            .isNotEmpty &&
                                        homeBloc.recentRoutes.any((element) =>
                                            element.transportType ==
                                            widget.arg.transportType))
                                      buildRecentRoutes(
                                          context, size, homeBloc),
                                    SizedBox(height: size.width * 0.02),
                                    buildRecentSearchLocations(
                                        context, size, homeBloc)
                                  ],
                                ],
                                if (context
                                    .read<HomeBloc>()
                                    .searchInfoMessage
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 16, top: 16),
                                    child: MyText(
                                        text: context
                                            .read<HomeBloc>()
                                            .searchInfoMessage,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontFamily: GoogleFonts.cairo()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w600)),
                                  ),
                                if (context
                                    .read<HomeBloc>()
                                    .autoSearchPlaces
                                    .isNotEmpty) ...[
                                  SizedBox(height: size.width * 0.03),
                                  autoSearchPlacesWidget(
                                      context, size, homeBloc)
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Single persistent bottom bar — no separate "Done"
                    // button. Filling in every address already
                    // auto-advances to booking (see the
                    // RecentSearchPlaceSelectState/AddOrEditAddressState
                    // handlers above that fire ConfirmRideAddressEvent
                    // once the list has no empty entries), so "Select
                    // from map" can stay the only visible action here.
                    bottomNavigationBar:
                        buildSelectFromMap(size, context, homeBloc),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget autoSearchPlacesWidget(
      BuildContext context, Size size, HomeBloc homeBloc) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SizedBox(
        child: GestureDetector(
          onVerticalDragStart: (details) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListView.separated(
                    itemCount: homeBloc.autoSearchPlaces.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final autoAddres = context
                          .read<HomeBloc>()
                          .autoSearchPlaces
                          .elementAt(index);
                      return InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          homeBloc.add(RecentSearchPlaceSelectEvent(
                            transportType: widget.arg.isOutstationRide
                                ? 'outstation'
                                : widget.arg.transportType,
                            address: autoAddres,
                            isPickupSelect: homeBloc.isPickupSelect,
                            serviceTypeIndex: widget.arg.selectedServiceIndex,
                          ));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: size.height * 0.075,
                              width: size.width * 0.075,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withAlpha((0.25 * 255).toInt()),
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.location_pin,
                                size: 20,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withAlpha((0.75 * 255).toInt()),
                              ),
                            ),
                            SizedBox(width: size.width * 0.025),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                      text: autoAddres.address,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              fontFamily: GoogleFonts.cairo()
                                                  .fontFamily),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(color: Theme.of(context).dividerColor);
                    },
                  ),
                  SizedBox(height: size.width * 0.15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocationSelect(
      BuildContext context, Size size, HomeBloc homeBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceStrong(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 26,
              spreadRadius: -6,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (homeBloc.addressList.isNotEmpty) ...[
                Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        key: _routeTimelineKey,
                        painter: _RouteConnectorPainter(
                          timeline: _routeTimelineKey,
                          pickup: _pickupMarkerKey,
                          destination: _destinationMarkerKey,
                          color: AppColors.meshwarRed.withValues(alpha: 0.18),
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: AppColors.surface(context),
                        shadowColor: Colors.transparent,
                      ),
                      child: ReorderableListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        onReorder: (oldIndex, newIndex) {
                          homeBloc.add(ReorderEvent(
                              oldIndex: oldIndex, newIndex: newIndex));
                        },
                        children: List.generate(
                          homeBloc.addressList.length,
                          (index) {
                            TextEditingController controller = context
                                .read<HomeBloc>()
                                .addressTextControllerList
                                .elementAt(index);
                            final lastIndex =
                                context.read<HomeBloc>().addressList.length - 1;
                            return Padding(
                              key: Key('$index'),
                              padding:
                                  EdgeInsets.only(bottom: size.width * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 36, bottom: 4),
                                    child: MyText(
                                      text: (index == 0)
                                          ? AppLocalizations.of(context)!
                                              .pickupAddress
                                              .toUpperCase()
                                          : (index == lastIndex)
                                              ? AppLocalizations.of(context)!
                                                  .destinationAddress
                                                  .toUpperCase()
                                              : '${AppLocalizations.of(context)!.addStopAddress.toUpperCase()} $index',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.6,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Fixed-width marker column — the same
                                      // width for every row (pickup, stop,
                                      // destination) so the timeline line
                                      // drawn behind the list lines up with
                                      // every marker regardless of row type.
                                      SizedBox(
                                        key: index == 0
                                            ? _pickupMarkerKey
                                            : index == lastIndex
                                                ? _destinationMarkerKey
                                                : null,
                                        width: 28,
                                        child: Center(
                                          child: (index == 0)
                                              ? buildTimelineMarker(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      AppColors.routeGreen,
                                                      Color(0xFF6EE7A8),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  glowColor:
                                                      AppColors.routeGreen,
                                                  icon: Icons.circle,
                                                  iconSize: 8,
                                                )
                                              : (index ==
                                                      context
                                                              .read<HomeBloc>()
                                                              .addressList
                                                              .length -
                                                          1)
                                                  ? buildTimelineMarker(
                                                      gradient: AppColors
                                                          .beaconGradient,
                                                      glowColor:
                                                          AppColors.meshwarRed,
                                                      icon: Icons.flag_rounded,
                                                      iconSize: 11,
                                                    )
                                                  : Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              AppColors.surface(
                                                                  context),
                                                          border: Border.all(
                                                              width: 1.5,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor)),
                                                      child: Center(
                                                        child: MyText(
                                                            text: '$index',
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        11)),
                                                      ),
                                                    ),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextField(
                                                controller: controller,
                                                enabled: true,
                                                filled: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                autofocus: context
                                                        .read<HomeBloc>()
                                                        .recentSearchPlaces
                                                        .isEmpty
                                                    ? (!widget.arg
                                                                .pickUpChange &&
                                                            index == 1)
                                                        ? true
                                                        : (widget.arg
                                                                    .pickUpChange &&
                                                                index == 0)
                                                            ? true
                                                            : false
                                                    : false,
                                                keyboardType:
                                                    TextInputType.text,
                                                fillColor: Colors.transparent,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 0.8,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor)),
                                                hintText: (index ==
                                                        context
                                                                .read<
                                                                    HomeBloc>()
                                                                .addressList
                                                                .length -
                                                            1)
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .destinationAddress
                                                    : (index == 0)
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .pickupAddress
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .addStopAddress,
                                                hintTextStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(0.6)),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 0),
                                                suffixConstraints:
                                                    BoxConstraints(
                                                        maxWidth:
                                                            size.width * 0.25),
                                                suffixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (controller
                                                        .text.isNotEmpty)
                                                      InkWell(
                                                        onTap: () {
                                                          if (index == 0) {
                                                            context
                                                                .read<
                                                                    HomeBloc>()
                                                                .pickUpLatLng = null;
                                                          }
                                                          context
                                                                  .read<HomeBloc>()
                                                                  .addressList[index] =
                                                              AddressModel(
                                                                  orderId: '',
                                                                  address: '',
                                                                  lat: 0,
                                                                  lng: 0,
                                                                  name: '',
                                                                  number: '',
                                                                  pickup:
                                                                      false);
                                                          context
                                                              .read<HomeBloc>()
                                                              .addressTextControllerList[
                                                                  index]
                                                              .text = '';
                                                          if (context
                                                              .read<HomeBloc>()
                                                              .autoSearchPlaces
                                                              .isNotEmpty) {
                                                            context
                                                                .read<
                                                                    HomeBloc>()
                                                                .searchInfoMessage = '';
                                                            context
                                                                .read<
                                                                    HomeBloc>()
                                                                .autoSearchPlaces
                                                                .clear();
                                                          }
                                                          context
                                                              .read<HomeBloc>()
                                                              .add(
                                                                  UpdateEvent());
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .only(
                                                                  start: 4,
                                                                  end: 2),
                                                          child: Icon(
                                                            Icons.cancel,
                                                            size: 20,
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  context
                                                          .read<HomeBloc>()
                                                          .isPickupSelect =
                                                      (index == 0)
                                                          ? true
                                                          : false;
                                                  context
                                                          .read<HomeBloc>()
                                                          .choosenAddressIndex =
                                                      index;
                                                  context
                                                      .read<HomeBloc>()
                                                      .add(UpdateEvent());
                                                },
                                                onChange: (value) {
                                                  context
                                                      .read<HomeBloc>()
                                                      .debouncer
                                                      .run(() {
                                                    if (value.isEmpty) {
                                                      context
                                                              .read<HomeBloc>()
                                                              .addressList[index] =
                                                          AddressModel(
                                                              orderId: '',
                                                              address: '',
                                                              lat: 0,
                                                              lng: 0,
                                                              name: '',
                                                              number: '',
                                                              pickup: false);
                                                    }
                                                    homeBloc.add(SearchPlacesEvent(
                                                        context: context,
                                                        mapType: widget
                                                            .arg.mapType,
                                                        countryCode:
                                                            widget.arg.userData
                                                                .countryCode,
                                                        latLng: (context
                                                                    .read<
                                                                        HomeBloc>()
                                                                    .pickUpLatLng !=
                                                                null)
                                                            ? context
                                                                .read<
                                                                    HomeBloc>()
                                                                .pickUpLatLng!
                                                            : context
                                                                .read<
                                                                    HomeBloc>()
                                                                .currentLatLng,
                                                        enbleContryRestrictMap:
                                                            widget.arg.userData
                                                                .enableCountryRestrictOnMap,
                                                        searchText: value));
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.01),
                                          ],
                                        ),
                                      ),
                                      if (homeBloc.addressList.length > 2)
                                        InkWell(
                                          onTap: () {
                                            if (index == 0) {
                                              homeBloc.pickUpLatLng = null;
                                            }
                                            context
                                                .read<HomeBloc>()
                                                .addressList
                                                .removeAt(index);
                                            context
                                                .read<HomeBloc>()
                                                .addressTextControllerList
                                                .removeAt(index);
                                            context
                                                .read<HomeBloc>()
                                                .add(UpdateEvent());
                                          },
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: size.width * 0.02),
                                            child: Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  if (index == 0 &&
                                      homeBloc.addressList.length == 2)
                                    buildDividerWidget(context, size),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Gradient timeline marker badge — used for the pickup and destination
  // rows in the address card. A small icon-size circle with a gradient
  // fill and a soft matching glow, sitting on the faint connecting line.
  Widget buildTimelineMarker({
    required Gradient gradient,
    required Color glowColor,
    required IconData icon,
    required double iconSize,
  }) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: -1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: AppColors.white),
      ),
    );
  }

  Widget buildDividerWidget(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: size.width * 0.035,
        end: size.width * 0.02,
      ),
      child: SizedBox(
        height: 12,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  Widget buildFavoriteLocations(BuildContext context,
      List<FavoriteLocationData> favLocations, Size size, HomeBloc homeBloc) {
    bool isHomeAvailable = false;
    bool isWorkAvailable = false;
    bool isOthersAvailable = false;
    for (var element in favLocations) {
      if (element.addressName == 'Home') {
        isHomeAvailable = true;
      } else if (element.addressName == 'Work') {
        isWorkAvailable = true;
      } else {
        isOthersAvailable = true;
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.04, right: size.width * 0.04),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                favLocations.length,
                (index) {
                  final location = favLocations.elementAt(index);
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: index == 0 ? size.width * 0.032 : 0,
                        end: size.width * 0.04),
                    child: InkWell(
                      //splashColor: Colors.white24,
                      onTap: () {
                        homeBloc.add(FavLocationSelectEvent(
                          address: location,
                          isPickupSelect: homeBloc.isPickupSelect,
                        ));
                      },
                      child: buildQuickActionTile(
                        context,
                        icon: (location.addressName.toLowerCase() == 'home')
                            ? Icons.home_rounded
                            : (location.addressName.toLowerCase() == 'work')
                                ? Icons.work_rounded
                                : Icons.star_rounded,
                        label: location.addressName,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isHomeAvailable)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, FavoriteLocationPage.routeName,
                                arguments: FavouriteLocationPageArguments(
                                    userData: widget.arg.userData,
                                    selectedServiceIndex:
                                        widget.arg.selectedServiceIndex))
                            .then(
                          (value) {
                            if (!context.mounted) return;
                            if (value != null) {
                              homeBloc.userData = value as UserDetail;
                              homeBloc.add(UpdateEvent());
                            }
                          },
                        );
                      },
                      child: buildQuickActionTile(
                        context,
                        icon: Icons.home_rounded,
                        label: AppLocalizations.of(context)!.home,
                      ),
                    ),
                  ),
                if (!isWorkAvailable)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, FavoriteLocationPage.routeName,
                                arguments: FavouriteLocationPageArguments(
                                    userData: widget.arg.userData,
                                    selectedServiceIndex:
                                        widget.arg.selectedServiceIndex))
                            .then(
                          (value) {
                            if (!context.mounted) return;
                            if (value != null) {
                              homeBloc.userData = value as UserDetail;
                              homeBloc.add(UpdateEvent());
                            }
                          },
                        );
                      },
                      child: buildQuickActionTile(
                        context,
                        icon: Icons.work_rounded,
                        label: AppLocalizations.of(context)!.work,
                      ),
                    ),
                  ),
                if (!isOthersAvailable)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, FavoriteLocationPage.routeName,
                                arguments: FavouriteLocationPageArguments(
                                    userData: widget.arg.userData,
                                    selectedServiceIndex:
                                        widget.arg.selectedServiceIndex))
                            .then(
                          (value) {
                            if (!context.mounted) return;
                            if (value != null) {
                              homeBloc.userData = value as UserDetail;
                              homeBloc.add(UpdateEvent());
                            }
                          },
                        );
                      },
                      child: buildQuickActionTile(
                        context,
                        icon: Icons.star_rounded,
                        label: AppLocalizations.of(context)!.others,
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Square quick-action tile — icon in a soft tinted square, label
  // below, matching the "big single-field focus" layout's Home/Work/Map
  // action row.
  Widget buildQuickActionTile(BuildContext context,
      {required IconData icon, required String label}) {
    return SizedBox(
      width: 78,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52,
            width: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.meshwarRed.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 24, color: AppColors.meshwarRed),
          ),
          const SizedBox(height: 6),
          MyText(
            text: label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget buildRecentRoutes(BuildContext context, Size size, HomeBloc homeBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.recentSearchRoutes,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            SizedBox(height: size.width * 0.02),
            SizedBox(
              width: size.width,
              height: size.width * (homeBloc.recentRouteHeight) + 6,
              child: PageView.builder(
                controller: homeBloc.recentRoutesPageController,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: homeBloc.recentRoutes
                    .where((element) =>
                        element.transportType == widget.arg.transportType)
                    .length,
                itemBuilder: (context, index) {
                  List data = [];
                  data.addAll(homeBloc.recentRoutes.where((element) =>
                      element.transportType == widget.arg.transportType));
                  final route = data.elementAt(index);
                  return (route.transportType == widget.arg.transportType)
                      ? InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            homeBloc.add(
                                RecentRouteSelectEvent(selectedRoute: route));
                          },
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(end: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceStrong(context),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  spreadRadius: -5,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Stack(
                              children: [
                                // Timeline line — matches the address
                                // card's marker column (12 is that
                                // column's horizontal center here).
                                PositionedDirectional(
                                  start: 12,
                                  top: 20,
                                  bottom: 20,
                                  child: Container(
                                    width: 2,
                                    color: AppColors.meshwarRed
                                        .withValues(alpha: 0.18),
                                  ),
                                ),
                                PositionedDirectional(
                                  top: 0,
                                  end: 0,
                                  child: Container(
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface(context),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: const Icon(
                                        Icons.arrow_outward_rounded,
                                        size: 14,
                                        color: AppColors.meshwarRed),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 26,
                                          child: Center(
                                            child: buildTimelineMarker(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppColors.routeGreen,
                                                  Color(0xFF6EE7A8),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              glowColor: AppColors.routeGreen,
                                              icon: Icons.circle,
                                              iconSize: 8,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: MyText(
                                            text: route.pickShortAddress,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (route.searchStops.data.isNotEmpty)
                                      ListView.separated(
                                        itemCount:
                                            route.searchStops.data.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        shrinkWrap: true,
                                        itemBuilder: (context, ind) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width: 26,
                                                child: Center(
                                                  child: Container(
                                                    height: 18,
                                                    width: 18,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    child: Center(
                                                      child: MyText(
                                                        text: '${ind + 1}',
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: MyText(
                                                  text: route.searchStops
                                                      .data[ind].shortAddress,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 13,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 10),
                                      )
                                    else
                                      const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 26,
                                          child: Center(
                                            child: buildTimelineMarker(
                                              gradient:
                                                  AppColors.beaconGradient,
                                              glowColor: AppColors.meshwarRed,
                                              icon: Icons.flag_rounded,
                                              iconSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: MyText(
                                            text: route.dropShortAddress,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .primaryColorDark),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox();
                },
                onPageChanged: (value) {
                  context
                      .read<HomeBloc>()
                      .add(RecentRoutesChangeIndex(routesIndex: value));
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),
            if (homeBloc.recentRoutes
                    .where((element) =>
                        element.transportType == widget.arg.transportType)
                    .length >
                1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  context
                      .read<HomeBloc>()
                      .recentRoutes
                      .where((element) =>
                          element.transportType == widget.arg.transportType)
                      .length,
                  (index) {
                    return Container(
                      margin: const EdgeInsetsDirectional.only(end: 5),
                      height: homeBloc.routesIndex == index ? 10 : 8,
                      width: homeBloc.routesIndex == index ? 10 : 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: homeBloc.routesIndex == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).splashColor),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildRecentSearchLocations(
      BuildContext context, Size size, HomeBloc homeBloc) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.searchPlaces,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              SizedBox(height: size.width * 0.02),
              // Plain dividered list — no card wrapper, sitting directly
              // on the page background.
              ListView.separated(
                itemCount: homeBloc.recentSearchPlaces.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  final recentPlace = context
                      .read<HomeBloc>()
                      .recentSearchPlaces
                      .elementAt(index);
                  return InkWell(
                    onTap: () {
                      homeBloc.add(
                        RecentSearchPlaceSelectEvent(
                            transportType: widget.arg.isOutstationRide
                                ? 'outstation'
                                : widget.arg.transportType,
                            address: recentPlace,
                            isPickupSelect: homeBloc.isPickupSelect),
                      );
                    },
                    child: SizedBox(
                      height: size.width * 0.16,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            size: 22,
                            color: AppColors.meshwarRed,
                          ),
                          SizedBox(width: size.width * 0.03),
                          SizedBox(
                            width: size.width * 0.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                  text: recentPlace.address.split(',')[0],
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                MyText(
                                  text: recentPlace.address,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontSize: 13,
                                          color:
                                              Theme.of(context).disabledColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color:
                        Theme.of(context).primaryColorLight.withOpacity(0.19),
                    thickness: 1,
                    height: 4,
                  );
                },
              ),
              SizedBox(height: size.width * 0.15),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectFromMap(
      Size size, BuildContext context, HomeBloc homeBloc) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Opaque background matching CustomBackground's own bottom gradient
    // stop (not a "card" surface color) — this Container's bounds are the
    // whole bottomNavigationBar slot, including the safe-area strip below
    // the button, so it needs to blend into the page instead of reading
    // as a separate panel.
    return Container(
      color: isDark ? AppColors.bgAsphalt : const Color(0xFFEDF4F9),
      padding: EdgeInsets.fromLTRB(14, 0, 14, bottomInset + 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                homeBloc.add(SelectFromMapEvent(
                    selectedAddressIndex: homeBloc.choosenAddressIndex,
                    isPickUpEdit: homeBloc.isPickupSelect ? true : false));
              },
              child: Container(
                height: 58,
                width: size.width * 0.86,
                decoration: BoxDecoration(
                  gradient: AppColors.beaconGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.meshwarRed.withValues(alpha: 0.4),
                      blurRadius: 22,
                      spreadRadius: -4,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pin_drop_outlined,
                        color: AppColors.white, size: 22),
                    const SizedBox(width: 8),
                    MyText(
                      text: AppLocalizations.of(context)!.selectFromMap,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteConnectorPainter extends CustomPainter {
  _RouteConnectorPainter({
    required this.timeline,
    required this.pickup,
    required this.destination,
    required this.color,
  });

  final GlobalKey timeline, pickup, destination;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final surface = timeline.currentContext?.findRenderObject();
    final first = pickup.currentContext?.findRenderObject();
    final last = destination.currentContext?.findRenderObject();
    if (surface is! RenderBox ||
        first is! RenderBox ||
        last is! RenderBox ||
        !surface.hasSize ||
        !first.hasSize ||
        !last.hasSize) {
      return;
    }
    // Paint behind the badges, from their actual centers. Label height and
    // row spacing must not leave a tail beyond the first or last marker.
    final start = surface
        .globalToLocal(first.localToGlobal(first.size.center(Offset.zero)));
    final end = surface
        .globalToLocal(last.localToGlobal(last.size.center(Offset.zero)));
    canvas.drawLine(
        start,
        end,
        Paint()
          ..color = color
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _RouteConnectorPainter oldDelegate) => true;
}
