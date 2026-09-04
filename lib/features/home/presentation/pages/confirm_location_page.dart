// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;

import '../../../../common/common.dart';
import '../../../../common/liquid_glass_container.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/stop_address_model.dart';
import '../widgets/select_booking_type.dart';
import '../widgets/select_contact.dart';

class ConfirmLocationPage extends StatefulWidget {
  static const String routeName = '/confirmLocationPage';
  final ConfirmLocationPageArguments arg;

  const ConfirmLocationPage({super.key, required this.arg});

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(ConfirmLocationPageInitEvent(arg: widget.arg)),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is HomeInitialState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is LogoutState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is ConfirmAddressState) {
            Navigator.pop(context, state.address);
          } else if (state is SelectBookingTypeState) {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<HomeBloc>(),
                    child: const SelectBookingType(),
                  );
                });
          } else if (state is SelectContactDetailsState) {
            context.read<HomeBloc>().isMyself = false;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: const SelectFromContactList(),
                );
              },
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            context.read<HomeBloc>().userData ??= widget.arg.userData;
            if (widget.arg.mapType == 'google_map') {
              if (Theme.of(context).brightness == Brightness.dark) {
                if (context.read<HomeBloc>().googleMapController != null) {
                  context
                      .read<HomeBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<HomeBloc>().darkMapString);
                }
              } else {
                if (context.read<HomeBloc>().googleMapController != null) {
                  context
                      .read<HomeBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<HomeBloc>().lightMapString);
                }
              }
            }
            return Directionality(
              textDirection: context.read<HomeBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: true,
                body: bodyMapBuilder(context, size),
                bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) =>
                      current is UpdateLocationState ||
                      current is HomeUpdateState ||
                      current is SelectContactDetailsState ||
                      current is SelectBookingTypeState,
                  builder: (context, state) {
                    return bottomConfirmationWidget(size, context);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bodyMapBuilder(BuildContext context, Size size) {
    final homeBloc = context.read<HomeBloc>();
    return Stack(
      children: [
        Stack(
          children: [
            (widget.arg.mapType == 'google_map')
                ? ExcludeSemantics(
              child: GoogleMap(
                  mapType: homeBloc.selectedMapType,
                  onMapCreated: (GoogleMapController controller) {
                    if (homeBloc.googleMapController == null) {
                      homeBloc.add(GoogleControllAssignEvent(
                          controller: controller,
                          isFromHomePage: false,
                          isEditAddress: widget.arg.isEditAddress,
                          latlng: homeBloc.currentLatLng));
                    }
                  },
                  compassEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: widget.arg.latlng ?? homeBloc.currentLatLng,
                    zoom: 15.0,
                  ),
                  onCameraMoveStarted: () {
                    homeBloc.setDragging(true);
                    homeBloc.isCameraMoveComplete = true;
                  },
                  onCameraMove: (CameraPosition position) {
                    if (!context.mounted) return;
                    homeBloc.currentLatLng = position.target;
                    // No UpdateEvent here to prevent rapid rebuilds
                  },
                  onCameraIdle: () {
                    homeBloc.setDragging(false);
                    if (homeBloc.isCameraMoveComplete) {
                      if (widget.arg.isPickupEdit &&
                          homeBloc.pickupAddressList.isEmpty) {
                        homeBloc.add(UpdateLocationEvent(
                            isFromHomePage: false,
                            latLng: homeBloc.currentLatLng,
                            mapType: widget.arg.mapType));
                      } else {
                        homeBloc.confirmPinAddress = true;
                        homeBloc.add(UpdateEvent());
                      }
                    }
                  },
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
                  buildingsEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false),
            )
                : ExcludeSemantics(
              child: fm.FlutterMap(
                mapController: homeBloc.fmController,
                options: fm.MapOptions(
                  onTap: (tapPosition, latLng) {
                    homeBloc.currentLatLng =
                        LatLng(latLng.latitude, latLng.longitude);
                    if (homeBloc.fmController != null) {
                      homeBloc.fmController!.move(latLng, 15);
                    }
                    homeBloc.add(UpdateLocationEvent(
                        isFromHomePage: true,
                        latLng: homeBloc.currentLatLng,
                        mapType: widget.arg.mapType));
                  },
                  onMapEvent: (v) async {
                    if (v.source == fm.MapEventSource.nonRotatedSizeChange) {
                      homeBloc.fmLatLng = fmlt.LatLng(
                          v.camera.center.latitude, v.camera.center.longitude);
                      homeBloc.currentLatLng = LatLng(
                          v.camera.center.latitude, v.camera.center.longitude);
                      if (v.camera.center.latitude != 0.0 &&
                          v.camera.center.longitude != 0.0) {
                        homeBloc.add(UpdateLocationEvent(
                            isFromHomePage: true,
                            latLng: homeBloc.currentLatLng,
                            mapType: widget.arg.mapType));
                      } else {
                        homeBloc.add(UpdateLocationEvent(
                            isFromHomePage: true,
                            latLng: AppConstants.currentLocations,
                            mapType: widget.arg.mapType));
                      }
                    }
                    if (v.source == fm.MapEventSource.onDrag) {
                      homeBloc.currentLatLng = LatLng(
                          v.camera.center.latitude, v.camera.center.longitude);
                      // Minimal updates during drag
                    }
                    if (v.source == fm.MapEventSource.dragEnd) {
                      homeBloc.add(UpdateLocationEvent(
                          isFromHomePage: true,
                          latLng: LatLng(v.camera.center.latitude,
                              v.camera.center.longitude),
                          mapType: widget.arg.mapType));
                    }
                  },
                  onPositionChanged: (p, l) async {
                    if (l == false) {
                      homeBloc.currentLatLng =
                          LatLng(p.center.latitude, p.center.longitude);
                    }
                  },
                  initialCenter: fmlt.LatLng(homeBloc.currentLatLng.latitude,
                      homeBloc.currentLatLng.longitude),
                  initialZoom: 16,
                  minZoom: 13,
                  maxZoom: 20,
                ),
                children: [
                  fm.TileLayer(
                    urlTemplate: (homeBloc.userData!.osmMapSettings.enableMapbox ==
                        true &&
                        homeBloc.userData!.osmMapSettings.mapboxPublicKey
                            .isNotEmpty)
                        ? 'https://api.mapbox.com/styles/v1/{style}/tiles/{z}/{x}/{y}?access_token=${homeBloc.userData!.osmMapSettings.mapboxPublicKey}'
                        : (homeBloc.userData!.osmMapSettings.enableThunderforest ==
                        true &&
                        homeBloc.userData!.osmMapSettings.thunderforestApiKey
                            .isNotEmpty)
                        ? 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=${homeBloc.userData!.osmMapSettings.thunderforestApiKey}'
                        : (homeBloc.userData!.osmMapSettings.enableStadia ==
                        true &&
                        homeBloc.userData!.osmMapSettings.stadiaApiKey
                            .isNotEmpty)
                        ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png?api_key=${homeBloc.userData!.osmMapSettings.stadiaApiKey}'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'package name here',
                    tileProvider: const FMTCStore('mapStore').getTileProvider(),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Image.asset(
                  AppImages.confirmationPin,
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                ),
              ),
            ),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
              current is UpdateEvent || current is HomeUpdateState,
              builder: (context, state) {
                if (!homeBloc.confirmPinAddress) return const SizedBox();
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: size.width * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 65),
                          child: (widget.arg.isPickupEdit)
                              ? (homeBloc.isDragging
                              ? CustomButton(
                            buttonColor: Theme.of(context)
                                .disabledColor
                                .withAlpha((0.5 * 255).toInt()),
                            height: size.width * 0.08,
                            width: size.width * 0.25,
                            onTap: () {},
                            textSize: 12,
                            buttonName: AppLocalizations.of(context)!
                                .pickMeHere,
                          )
                              : CustomButton(
                            buttonColor: Theme.of(context).primaryColor,
                            height: size.width * 0.08,
                            width: size.width * 0.25,
                            onTap: () {
                              homeBloc.confirmPinAddress = false;
                              homeBloc.add(UpdateLocationEvent(
                                isFromHomePage: true,
                                latLng: homeBloc.currentLatLng,
                                mapType: homeBloc.mapType,
                              ));
                            },
                            textSize: 12,
                            buttonName:
                            AppLocalizations.of(context)!.confirm,
                          ))
                              : (homeBloc.isDragging
                              ? const SizedBox()
                              : CustomButton(
                            buttonColor: Theme.of(context).primaryColor,
                            height: size.width * 0.08,
                            width: size.width * 0.25,
                            onTap: () {
                              homeBloc.confirmPinAddress = false;
                              homeBloc.add(UpdateLocationEvent(
                                isFromHomePage: true,
                                latLng: homeBloc.currentLatLng,
                                mapType: homeBloc.mapType,
                              ));
                            },
                            textSize: 12,
                            buttonName:
                            AppLocalizations.of(context)!.confirm,
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              right: 16,
              child: Column(
                children: [
                  if (homeBloc.mapType == 'google_map')
                    PopupMenuButton<MapType>(
                      color: AppColors.surfaceStrong(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.surfaceBorder(context)),
                        ),
                        child: Icon(Icons.layers,
                            color: Theme.of(context).primaryColorDark),
                      ),
                      onSelected: (mapType) {
                        homeBloc.add(UpdateMapTypeEvent(mapType));
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: MapType.normal,
                            child: MyText(
                                text: AppLocalizations.of(context)!.normal,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    color:
                                    Theme.of(context).primaryColorDark))),
                        PopupMenuItem(
                            value: MapType.satellite,
                            child: MyText(
                                text: AppLocalizations.of(context)!.satellite,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    color:
                                    Theme.of(context).primaryColorDark))),
                        PopupMenuItem(
                          value: MapType.terrain,
                          child: MyText(
                              text: AppLocalizations.of(context)!.terrain,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: Theme.of(context).primaryColorDark)),
                        ),
                        PopupMenuItem(
                          value: MapType.hybrid,
                          child: MyText(
                              text: AppLocalizations.of(context)!.hybrid,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: Theme.of(context).primaryColorDark)),
                        ),
                      ],
                    ),
                  SizedBox(height: size.width * 0.02),
                  InkWell(
                    onTap: () {
                      homeBloc.confirmPinAddress = false;
                      homeBloc.add(LocateMeEvent(mapType: widget.arg.mapType));
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                          width: 1.2,
                          color: AppColors.surfaceBorder(context),
                        ),
                        boxShadow: AppColors.surfaceShadow(context),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.my_location,
                          size: size.width * 0.05,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.02)
                ],
              ),
            ),
          ],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchBarRow(context, size),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) => current is HomeUpdateState,
                  builder: (context, state) {
                    if (homeBloc.autoSearchPlaces.isEmpty) {
                      return const SizedBox();
                    }
                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        autoSearchPlacesWidget(context, size),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget searchBarRow(BuildContext context, Size size) {
    return Row(
      children: [
        NavigationIconWidget(
          onTap: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: Theme.of(context).primaryColorDark),
          isShadowWidget: true,
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.glassBlueStrong.withOpacity(0.4),
                      AppColors.glassBlue.withOpacity(0.22),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.55)),
                ),
                child: CustomTextField(
                  controller: context.read<HomeBloc>().searchController,
                  filled: true,
                  focusNode: context.read<HomeBloc>().searchFocus,


                  prefixConstraints:
                  BoxConstraints(maxWidth: size.width * 0.1),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Icon(
                      Icons.search_rounded,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  suffixConstraints:
                  BoxConstraints(maxWidth: size.width * 0.1),
                  suffixIcon: context
                      .read<HomeBloc>()
                      .searchController
                      .text
                      .isNotEmpty
                      ? Padding(
                    padding:
                    const EdgeInsets.only(left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .searchController
                            .clear();
                        context.read<HomeBloc>().searchInfoMessage =
                        '';
                        context
                            .read<HomeBloc>()
                            .autoSearchPlaces
                            .clear();
                        context.read<HomeBloc>().add(UpdateEvent());
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  )
                      : null,
                  hintText: AppLocalizations.of(context)!.searchPlaces,
                  onTap: () {},
                  onSubmitted: (p0) {},
                  onChange: (value) {
                    context.read<HomeBloc>().debouncer.run(() {
                      context.read<HomeBloc>().add(SearchPlacesEvent(
                          context: context,
                          mapType: widget.arg.mapType,
                          countryCode: widget.arg.userData.countryCode,
                          latLng: context.read<HomeBloc>().currentLatLng,
                          enbleContryRestrictMap: widget
                              .arg.userData.enableCountryRestrictOnMap,
                          searchText: value));
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget autoSearchPlacesWidget(BuildContext context, Size size) {
    return LiquidGlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView.separated(
        itemCount: context.read<HomeBloc>().autoSearchPlaces.length > 5
            ? 5
            : context.read<HomeBloc>().autoSearchPlaces.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final autoAddres = context
              .read<HomeBloc>()
              .autoSearchPlaces
              .elementAt(index);
          return InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              final List<AddressModel> addressesToVerify = [];
              if (context
                  .read<HomeBloc>()
                  .pickupAddressList
                  .isNotEmpty) {
                addressesToVerify.add(
                    context.read<HomeBloc>().pickupAddressList.first);
              }
              addressesToVerify.add(autoAddres);

              context.read<HomeBloc>().add(RecentSearchPlaceSelectEvent(
                transportType: widget.arg.isOutstationRide
                    ? 'outstation'
                    : widget.arg.transportType,
                address: autoAddres,
                isPickupSelect:
                context.read<HomeBloc>().isPickupSelect,
                serviceTypeIndex: widget.arg.selectedServiceIndex,
              ));

              context.read<HomeBloc>().add(
                  ConfirmLocationSearchPlaceSelectEvent(
                      address: autoAddres,
                      mapType: widget.arg.mapType));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.width * 0.02),
              child: Row(
                children: [
                  Container(
                    height: size.height * 0.06,
                    width: size.width * 0.09,
                    decoration: BoxDecoration(
                        color: AppColors.meshwarRed.withOpacity(0.08),
                        shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.location_pin,
                      size: 20,
                      color: AppColors.meshwarRed,
                    ),
                  ),
                  SizedBox(width: size.width * 0.025),
                  Expanded(
                    child: MyText(
                        text: autoAddres.address,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                            color:
                            Theme.of(context).primaryColorDark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
              color: AppColors.surfaceBorder(context),
              height: 1,
              indent: 44);
        },
      ),
    );
  }

  Widget bottomConfirmationWidget(Size size, BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong(context),
        border: Border(top: BorderSide(color: AppColors.surfaceBorder(context))),
        boxShadow: AppColors.surfaceShadow(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: size.width * 0.01),
              if (widget.arg.isPickupEdit) ...[
                SizedBox(
                  width: size.width * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(SelectBookingTypeEvent());
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                              size.width * 0.03,
                              size.width * 0.015,
                              size.width * 0.03,
                              size.width * 0.015),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 1,
                                  color: AppColors.primary.withOpacity(0.25))),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: size.width * 0.05,
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              MyText(
                                text: context
                                    .read<HomeBloc>()
                                    .bookingDisplayName
                                    .toString(),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: AppColors.primary,
                                size: size.width * 0.05,
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.025,
                )
              ],
              MyText(
                  maxLines: 3,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  text: context.read<HomeBloc>().currentLocation),
              SizedBox(height: size.width * 0.05),
              CustomButton(
                buttonName: widget.arg.isPickupEdit
                    ? '${AppLocalizations.of(context)!.confirm} ${AppLocalizations.of(context)!.pickupLocation}'
                    : AppLocalizations.of(context)!.confirmLocation,
                width: size.width,
                textSize:
                context.read<HomeBloc>().languageCode == 'fr' ? 14 : null,
                onTap: () {
                  context.read<HomeBloc>().add(ConfirmAddressEvent(
                    isDelivery:
                    widget.arg.transportType.toString().toLowerCase() ==
                        'delivery'
                        ? true
                        : false,
                    isEditAddress: widget.arg.isEditAddress,
                    isPickUpEdit: widget.arg.isPickupEdit,
                    isMyself: context.read<HomeBloc>().isMyselfSelected,
                    contactNumber:
                    context.read<HomeBloc>().selectedContactMobile,
                    contactName:
                    context.read<HomeBloc>().selectedContactName,
                  ));
                },
              ),
              SizedBox(height: size.width * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}