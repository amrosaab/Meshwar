import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_divider.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/stop_address_model.dart';
import '../../../../../home/presentation/pages/confirm_location_page.dart';
import '../../../../application/booking_bloc.dart';
import 'eta_list_view_widget.dart';
import 'rental_ride/rental_eta_list_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RidePreviewWidget extends StatelessWidget {
  final BuildContext cont;
  final BookingPageArguments arg;

  const RidePreviewWidget({super.key, required this.cont, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: !context.read<BookingBloc>().showBiddingVehicles
                      ? size.width * 0.05
                      : size.width * 0.05,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CustomDivider()),
                  ],
                ),
                SizedBox(height: size.width * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: size.width * 0.04,
                        horizontal: size.width * 0.01),
                    child: Stack(
                      children: [
                        Positioned(
                          left: size.width * 0.048 + 12,
                          top: size.width * 0.11,
                          bottom: size.width * 0.11,
                          child: Container(
                            width: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.green.withValues(alpha: 0.35),
                                  AppColors.meshwarRed.withValues(alpha: 0.35),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            // Pickup location with enhanced UI
                            ListView.builder(
                              itemCount: arg.pickupAddressList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemBuilder: (context, index) {
                                final address =
                                    arg.pickupAddressList.elementAt(index);
                                return _buildLocationTile(
                                  stop: index,
                                  isDrop: false,
                                  bookingBloc: bookingBloc,
                                  context: context,
                                  icon: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF34C77E),
                                          AppColors.green,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.green
                                              .withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                  address: address.address,
                                  label: AppLocalizations.of(context)!.pickup,
                                  labelColor: AppColors.green,
                                  size: size,
                                );
                              },
                            ),
                            SizedBox(height: size.width * 0.03),
                            if (bookingBloc.dropAddressList.isNotEmpty) ...[
                              // Stop locations with connecting line
                              ListView.separated(
                                itemCount: bookingBloc.dropAddressList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemBuilder: (context, index) {
                                  final address = bookingBloc.dropAddressList
                                      .elementAt(index);
                                  final isDrop = true;
                                  return _buildLocationTile(
                                    stop: index,
                                    isDrop: isDrop,
                                    bookingBloc: bookingBloc,
                                    context: context,
                                    icon: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFF0546F),
                                            AppColors.meshwarRed,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.meshwarRed
                                                .withValues(alpha: 0.35),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        (index ==
                                                bookingBloc.dropAddressList
                                                        .length -
                                                    1)
                                            ? Icons.flag_rounded
                                            : Icons.add_location_alt,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                    address: address.address,
                                    label: (index ==
                                            bookingBloc.dropAddressList.length -
                                                1)
                                        ? AppLocalizations.of(context)!
                                            .dropLocation
                                        : AppLocalizations.of(context)!
                                            .stop
                                            .replaceAll('111', '${index + 1}'),
                                    labelColor: AppColors.red,
                                    size: size,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: size.width * 0.02);
                                },
                              ),
                              SizedBox(height: size.width * 0.02),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!context.read<BookingBloc>().isRentalRide &&
                    context.read<BookingBloc>().etaDetailsList.isNotEmpty) ...[
                  EtaListViewWidget(cont: context, arg: arg, thisValue: this),
                ],
                if (context.read<BookingBloc>().isRentalRide &&
                    context
                        .read<BookingBloc>()
                        .rentalEtaDetailsList
                        .isNotEmpty) ...[
                  SizedBox(height: size.width * 0.02),
                  RentalEtaListViewWidget(
                      cont: context, arg: arg, thisValue: this),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build location tile with modern UI
  Widget _buildLocationTile(
      {required BuildContext context,
      required Widget icon,
      required String address,
      required String label,
      required Color labelColor,
      required Size size,
      required BookingBloc bookingBloc,
      required bool isDrop,
      required int stop}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width * 0.014),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: size.width * 0.005),
                MyText(
                  text: address,
                  maxLines: 1,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withAlpha((0.9 * 255).toInt()),
                      ),
                ),
              ],
            ),
          ),
          if (isDrop && bookingBloc.transportType == 'taxi') ...[
            SizedBox(width: size.width * 0.01),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ConfirmLocationPage.routeName,
                  arguments: ConfirmLocationPageArguments(
                    userData: bookingBloc.userData!,
                    isPickupEdit: false,
                    isEditAddress: false,
                    isOutstationRide: arg.isOutstationRide,
                    mapType: bookingBloc.mapType,
                    transportType: bookingBloc.transportType,
                    selectedServiceIndex: arg.selectedServiceIndex,
                    latlng: LatLng(
                      bookingBloc.dropAddressList[stop].lat,
                      bookingBloc.dropAddressList[stop].lng,
                    ),
                  ),
                ).then((value) {
                  if (value is! AddressModel) return;

                  bookingBloc.dropAddressList[stop] = value;

                  bookingBloc.add(PolylineEvent(
                    isInitCall: true,
                    arg: BookingPageArguments(
                      picklat:
                          bookingBloc.pickUpAddressList.first.lat.toString(),
                      picklng:
                          bookingBloc.pickUpAddressList.first.lng.toString(),
                      droplat: value.lat.toString(),
                      droplng: value.lng.toString(),
                      pickupAddressList: bookingBloc.pickUpAddressList,
                      stopAddressList: bookingBloc.dropAddressList,
                      userData: bookingBloc.userData!,
                      transportType: bookingBloc.transportType,
                      polyString: '',
                      distance: '',
                      duration: '',
                      mapType: bookingBloc.mapType,
                      isOutstationRide: arg.isOutstationRide,
                      isRentalRide: arg.isRentalRide,
                      isWithoutDestinationRide: arg.isWithoutDestinationRide,
                      isMyself: arg.isMyself,
                      contactName: arg.contactName,
                      contactNumber: arg.contactNumber,
                      isBiddingRide: arg.isBiddingRide,
                      isSharedRide: arg.isSharedRide,
                      selectedServiceIndex: arg.selectedServiceIndex,
                    ),
                    pickLat: bookingBloc.pickUpAddressList.first.lat,
                    pickLng: bookingBloc.pickUpAddressList.first.lng,
                    dropLat: bookingBloc.dropAddressList.last.lat,
                    dropLng: bookingBloc.dropAddressList.last.lng,
                    pickAddress: bookingBloc.pickUpAddressList.first.address,
                    dropAddress: bookingBloc.dropAddressList.last.address,
                    stops: (bookingBloc.dropAddressList.length > 1)
                        ? bookingBloc.dropAddressList
                        : [],
                  ));
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.hintColor),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
