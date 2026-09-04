// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;

import '../../../../../../common/common.dart';
import '../../../../../../common/pickup_icon.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/presentation/pages/login_page.dart';
import '../../../../../home/domain/models/stop_address_model.dart';
import '../../../../../home/presentation/pages/confirm_location_page.dart';
import '../../../../application/booking_bloc.dart';
import '../../../../domain/models/edit_location_model.dart';
import '../widget/booking_select_contacts.dart';
import '../widget/delivery_instruction_widget.dart';

class EditLocationPage extends StatefulWidget {
  static const String routeName = '/editLocationPage';
  final EditLocationPageArguments arg;

  const EditLocationPage({super.key, required this.arg});

  @override
  State<EditLocationPage> createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
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
      create: (context) => BookingBloc()
        ..add(GetDirectionEvent(vsync: this))
        ..add(EditLocationPageInitEvent(arg: widget.arg)),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) async {
          if (state is BookingInitialState) {
            CustomLoader.loader(context);
          } else if (state is BookingLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is BookingLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is LogoutState) {
            final bookingBloc = context.read<BookingBloc>();
            if (bookingBloc.nearByVechileSubscription != null) {
              bookingBloc.nearByVechileSubscription?.cancel();
              bookingBloc.nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is SelectFromMapState) {
            final bookingBloc = context.read<BookingBloc>();
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                arguments: ConfirmLocationPageArguments(
                    userData: widget.arg.userData,
                    isPickupEdit: false,
                    isEditAddress: true,
                    isOutstationRide:
                    widget.arg.requestData.isOutStation == '1',
                    mapType: widget.arg.mapType,
                    latlng: LatLng(
                        bookingBloc
                            .dropAddressList[
                        bookingBloc.choosenAddressIndex]
                            .lat,
                        bookingBloc
                            .dropAddressList[
                        bookingBloc.choosenAddressIndex]
                            .lng),
                    transportType: widget.arg.requestData.transportType,
                    selectedServiceIndex: widget.arg.selectedServiceIndex))
                .then(
                  (value) {
                if (value != null) {
                  if (!context.mounted) return;
                  final address = value as AddressModel;
                  final bookingBloc = context.read<BookingBloc>();
                  if (widget.arg.requestData.transportType.toLowerCase() ==
                      'delivery') {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: false,
                      isScrollControlled: true,
                      barrierColor: Colors.black54,
                      builder: (_) {
                        return BlocProvider.value(
                          value: bookingBloc,
                          child: DeliveryInstructions(
                            cont: context,
                            address: address,
                            isReceiveParcel:
                            widget.arg.requestData.parcelType ==
                                'Receive Parcel',
                            name: widget.arg.userData.name,
                            number: widget.arg.userData.mobile,
                            transportType: widget.arg.requestData.transportType,
                          ),
                        );
                      },
                    );
                  } else {
                    bookingBloc.add(BookingAddOrEditStopAddressEvent(
                      choosenAddressIndex: bookingBloc.choosenAddressIndex,
                      newAddress: address,
                    ));
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                }
              },
            );
          } else if (state is SelectContactDetailsState) {
            final bookingBloc = context.read<BookingBloc>();
            bookingBloc.isMyself = false;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const BookingSelectContacts(),
                );
              },
            );
          } else if (state is DestinationChangeSuccessState) {
            Navigator.pop(
                context,
                EditLocation(
                    requestData: state.requestData,
                    dropAddressList: state.dropAddressList));
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final bookingBloc = context.read<BookingBloc>();
            if (widget.arg.mapType == 'google_map') {
              if (Theme.of(context).brightness == Brightness.dark) {
                if (bookingBloc.googleMapController != null) {
                  context
                      .read<BookingBloc>()
                      .googleMapController!
                      .setMapStyle(bookingBloc.darkMapString);
                }
              } else {
                if (bookingBloc.googleMapController != null) {
                  context
                      .read<BookingBloc>()
                      .googleMapController!
                      .setMapStyle(bookingBloc.lightMapString);
                }
              }
            }

            return Directionality(
              textDirection: bookingBloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: true,
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.edit,
                  automaticallyImplyLeading: true,
                ),
                body: bodyMapBuilder(size, bookingBloc),
                bottomNavigationBar:
                bottomConfirmationWidget(size, bookingBloc),
              ),
            );
          },
        ),
      ),
    );
  }

  Stack bodyMapBuilder(Size size, BookingBloc bookingBloc) {
    return Stack(
      children: [
        Stack(
          children: [
            (widget.arg.mapType == 'google_map')
                ? ExcludeSemantics(
              child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    bookingBloc.googleMapController ??= controller;
                  },
                  compassEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      AppConstants.currentLocations.latitude,
                      AppConstants.currentLocations.longitude,
                    ),
                    zoom: 15.0,
                  ),
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
                  markers: Set.from(bookingBloc.markerList),
                  polylines: bookingBloc.polylines,
                  rotateGesturesEnabled: true,
                  buildingsEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false),
            )
                : ExcludeSemantics(
              child: fm.FlutterMap(
              mapController: bookingBloc.fmController,
              options: fm.MapOptions(
                onTap: (tapPosition, latLng) {},
                onMapEvent: (v) async {},
                onPositionChanged: (p, l) async {},
                initialCenter: fmlt.LatLng(
                    AppConstants.currentLocations.latitude,
                    AppConstants.currentLocations.longitude),
                initialZoom: 16,
                minZoom: 5,
                maxZoom: 20,
              ),
              children: [
                fm.TileLayer(
                  urlTemplate: (bookingBloc.userData!.osmMapSettings
                      .enableMapbox ==
                      true &&
                      bookingBloc.userData!.osmMapSettings
                          .mapboxPublicKey.isNotEmpty)
                      ? 'https://api.mapbox.com/styles/v1/{style}/tiles/{z}/{x}/{y}?access_token=${bookingBloc.userData!.osmMapSettings.mapboxPublicKey}'
                      : (bookingBloc.userData!.osmMapSettings
                      .enableThunderforest ==
                      true &&
                      bookingBloc.userData!.osmMapSettings
                          .thunderforestApiKey.isNotEmpty)
                      ? 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=${bookingBloc.userData!.osmMapSettings.thunderforestApiKey}'
                      : (bookingBloc.userData!.osmMapSettings
                      .enableStadia ==
                      true &&
                      bookingBloc.userData!.osmMapSettings
                          .stadiaApiKey.isNotEmpty)
                      ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png?api_key=${bookingBloc.userData!.osmMapSettings.stadiaApiKey}'
                      : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'package name here',
                  tileProvider:
                  const FMTCStore('mapStore').getTileProvider(),
                ),
                if (bookingBloc.markerList.isNotEmpty)
                  fm.MarkerLayer(
                    markers: List.generate(bookingBloc.markerList.length,
                            (index) {
                          final marker = bookingBloc.markerList[index];
                          return fm.Marker(
                            point: fmlt.LatLng(
                              marker.position.latitude,
                              marker.position.longitude,
                            ),
                            alignment: Alignment.topCenter,
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(
                                  marker.rotation / 360),
                              child: Image.asset(
                                marker.markerId.value.toString() == 'pick'
                                    ? AppImages.pickPin
                                    : (marker.markerId.value.toString() ==
                                    'drop' ||
                                    marker.markerId.value
                                        .toString()
                                        .contains('drop'))
                                    ? AppImages.dropPin
                                    : '',
                                width: 16,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox();
                                },
                              ),
                            ),
                          );
                        }),
                  ),
                if (bookingBloc.fmpoly.isNotEmpty)
                  fm.PolylineLayer(
                    polylines: [
                      fm.Polyline(
                        points: bookingBloc.fmpoly,
                        color: Theme.of(context).brightness ==
                            Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                const fm.RichAttributionWidget(attributions: []),
              ],
            ),
            ),
            Positioned(
              bottom: 0,
              right: 16,
              child: InkWell(
                onTap: () {
                  context.read<BookingBloc>().add(BookingLocateMeEvent(
                      mapType: widget.arg.mapType,
                      controller: (widget.arg.mapType == 'google_map')
                          ? bookingBloc.googleMapController
                          : bookingBloc.fmController));
                },
                child: Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.surfaceBorder(context)),
                      boxShadow: AppColors.surfaceShadow(context)),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Center(
                      child: Icon(
                        Icons.my_location,
                        size: 20,
                        color: Colors.white,
                      )),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget bottomConfirmationWidget(Size size, BookingBloc bookingBloc) {
    return SafeArea(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.surfaceStrong(context),
          boxShadow: AppColors.surfaceShadow(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.width * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      text: AppLocalizations.of(context)!.destinationAddress),
                  if (bookingBloc.dropAddressList.length < 3)
                    InkWell(
                      onTap: () {
                        bookingBloc.add(AddStopEvent());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: 20,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          MyText(
                              text: AppLocalizations.of(context)!.addStop,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                ],
              ),
              SizedBox(height: size.width * 0.05),
              buildLocationSelect(size, bookingBloc),
              SizedBox(height: size.width * 0.05),
              CustomButton(
                buttonName: AppLocalizations.of(context)!.continueN,
                width: size.width,
                textSize: bookingBloc.languageCode == 'fr' ? 14 : null,
                onTap: () {
                  bookingBloc.add(ChangeDestinationEvent(
                      requestId: bookingBloc.requestData!.id,
                      duration: bookingBloc.duration,
                      distance: bookingBloc.distance,
                      polyLine: bookingBloc.polyLine,
                      dropAddressList: bookingBloc.dropAddressList));
                  bookingBloc.add(UpdateEvent());
                },
              ),
              SizedBox(height: size.width * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLocationSelect(Size size, BookingBloc bookingBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bookingBloc.dropAddressList.isNotEmpty) ...[
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: AppColors.surfaceStrong(context),
              shadowColor: Colors.transparent,
            ),
            child: ReorderableListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              onReorder: (oldIndex, newIndex) {
                bookingBloc
                    .add(ReorderEvent(oldIndex: oldIndex, newIndex: newIndex));
              },
              children: List.generate(
                bookingBloc.dropAddressList.length,
                    (index) {
                  TextEditingController controller =
                  bookingBloc.addressTextControllerList.elementAt(index);
                  return Padding(
                    key: Key('$index'),
                    padding: EdgeInsets.only(bottom: size.width * 0.02),
                    child: Row(
                      children: [
                        if (index != 0 &&
                            index !=
                                bookingBloc.dropAddressList.length - 1) ...[
                          Container(
                            height: size.width * 0.05,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 0.3,
                                    color: Theme.of(context).disabledColor)),
                            child: Center(
                              child: MyText(
                                  text: '$index',
                                  textStyle:
                                  Theme.of(context).textTheme.bodySmall),
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                        ],
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 0.3,
                                    color: Theme.of(context).disabledColor)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller,
                                    enabled: true,
                                    filled: true,
                                    autofocus: false,
                                    keyboardType: TextInputType.none,
                                    fillColor: Theme.of(context)
                                        .disabledColor
                                        .withAlpha((0.1 * 255).toInt()),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.5,
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withAlpha(
                                                (0.3 * 255).toInt()))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.8,
                                            color: Theme.of(context)
                                                .disabledColor)),
                                    hintText: (index ==
                                        bookingBloc.dropAddressList.length -
                                            1)
                                        ? AppLocalizations.of(context)!
                                        .destinationAddress
                                        : AppLocalizations.of(context)!
                                        .addStopAddress,
                                    hintTextStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                    prefixConstraints: BoxConstraints(
                                        maxWidth: size.width * 0.065),
                                    prefixIcon: (index == 0 ||
                                        index ==
                                            bookingBloc.dropAddressList
                                                .length -
                                                1)
                                        ? const Center(child: DropIcon())
                                        : null,
                                    suffixConstraints: BoxConstraints(
                                        maxWidth: size.width * 0.2),
                                    suffixIcon: controller.text.isNotEmpty
                                        ? Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: InkWell(
                                        onTap: () {
                                          bookingBloc
                                              .choosenAddressIndex =
                                              index;
                                          bookingBloc.add(UpdateEvent());
                                          bookingBloc
                                              .add(SelectFromMapEvent());
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withAlpha(
                                              (0.4 * 255).toInt()),
                                        ),
                                      ),
                                    )
                                        : null,
                                    onTap: () {
                                      bookingBloc.choosenAddressIndex = index;
                                      bookingBloc.add(UpdateEvent());
                                      bookingBloc.add(SelectFromMapEvent());
                                    },
                                  ),
                                ),
                                if (bookingBloc.dropAddressList.length > 1) ...[
                                  SizedBox(width: size.width * 0.01),
                                  Icon(Icons.drag_indicator_rounded,
                                      color: Theme.of(context).primaryColorDark,
                                      size: 20),
                                  SizedBox(width: size.width * 0.01),
                                ],
                              ],
                            ),
                          ),
                        ),
                        (bookingBloc.dropAddressList.length > 1)
                            ? InkWell(
                          onTap: () {
                            bookingBloc.dropAddressList.removeAt(index);
                            bookingBloc.addressTextControllerList
                                .removeAt(index);
                            bookingBloc.add(PolylineEvent(
                              pickLat: double.parse(
                                  bookingBloc.requestData!.pickLat),
                              pickLng: double.parse(
                                  bookingBloc.requestData!.pickLng),
                              dropLat:
                              bookingBloc.dropAddressList.last.lat,
                              dropLng:
                              bookingBloc.dropAddressList.last.lng,
                              stops:
                              (bookingBloc.dropAddressList.length > 1)
                                  ? bookingBloc.dropAddressList
                                  : [],
                              pickAddress:
                              bookingBloc.requestData!.pickAddress,
                              dropAddress: bookingBloc
                                  .dropAddressList.last.address,
                              isDropChanged: true,
                            ));
                            bookingBloc.add(AddMarkersEvent(
                                requestData: bookingBloc.requestData!,
                                addressList:
                                bookingBloc.dropAddressList));
                            bookingBloc.add(UpdateEvent());
                          },
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: size.width * 0.015),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        )
                            : const SizedBox()
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}