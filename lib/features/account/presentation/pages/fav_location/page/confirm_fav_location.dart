import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/stop_address_model.dart';
import '../../../../../home/presentation/pages/confirm_location_page.dart';
import '../../../../application/acc_bloc.dart';

class ConfirmFavLocation extends StatelessWidget {
  final ConfirmFavouriteLocationPageArguments arg;
  static const String routeName = '/confirmFavoriteLocation';
  const ConfirmFavLocation({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(FavNewAddressInitEvent(arg: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AddFavAddressSuccessState) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.newaddress,
                  automaticallyImplyLeading: true,
                ),
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: (context.read<AccBloc>().favNewAddress != null)
                        ? Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      ConfirmLocationPage.routeName,
                                      arguments:
                                      ConfirmLocationPageArguments(
                                          isEditAddress: false,
                                          userData: context
                                              .read<AccBloc>()
                                              .userData!,
                                          isPickupEdit: false,
                                          isOutstationRide: false,
                                          latlng: LatLng(
                                              context
                                                  .read<AccBloc>()
                                                  .favNewAddress!
                                                  .lat,
                                              context
                                                  .read<AccBloc>()
                                                  .favNewAddress!
                                                  .lng),
                                          transportType: '',
                                          selectedServiceIndex:
                                          arg
                                              .selectedServiceIndex,
                                          mapType: context
                                              .read<AccBloc>()
                                              .userData!
                                              .mapType))
                                      .then((value) {
                                    if (!context.mounted) return;
                                    if (value != null) {
                                      final address =
                                      value as AddressModel;
                                      context
                                          .read<AccBloc>()
                                          .favNewAddress = address;
                                      context
                                          .read<AccBloc>()
                                          .googleMapController!
                                          .animateCamera(
                                          CameraUpdate.newLatLng(
                                              LatLng(
                                                  context
                                                      .read<AccBloc>()
                                                      .favNewAddress!
                                                      .lat,
                                                  context
                                                      .read<AccBloc>()
                                                      .favNewAddress!
                                                      .lng)));
                                      context
                                          .read<AccBloc>()
                                          .add(AccUpdateEvent());
                                    }
                                  });
                                },
                                child: LiquidGlassContainer(
                                  height: size.width * 0.7,
                                  borderRadius: 20,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: size.width * 0.4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withAlpha(
                                                      (0.5 * 255)
                                                          .toInt())),
                                            )),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                              child: GoogleMap(
                                                  onMapCreated:
                                                      (GoogleMapController
                                                  controller) {
                                                    context
                                                        .read<AccBloc>()
                                                        .googleMapController =
                                                        controller;
                                                  },
                                                  initialCameraPosition:
                                                  CameraPosition(
                                                    target: LatLng(
                                                        context
                                                            .read<
                                                            AccBloc>()
                                                            .favNewAddress!
                                                            .lat,
                                                        context
                                                            .read<
                                                            AccBloc>()
                                                            .favNewAddress!
                                                            .lng),
                                                    zoom: 15.0,
                                                  ),
                                                  onCameraMove:
                                                      (CameraPosition
                                                  position) async {},
                                                  minMaxZoomPreference:
                                                  const MinMaxZoomPreference(
                                                      0, 20),
                                                  scrollGesturesEnabled:
                                                  false,
                                                  buildingsEnabled: false,
                                                  zoomControlsEnabled:
                                                  false,
                                                  myLocationEnabled:
                                                  false,
                                                  myLocationButtonEnabled:
                                                  false),
                                            ),
                                            Positioned(
                                              child: Container(
                                                height:
                                                size.height * 0.77,
                                                width: size.width * 1,
                                                alignment:
                                                Alignment.center,
                                                margin:
                                                const EdgeInsets.only(
                                                    bottom: 30),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            2),
                                                        color: Theme.of(
                                                            context)
                                                            .disabledColor
                                                            .withAlpha(
                                                            (0.5 * 255)
                                                                .toInt())),
                                                    padding:
                                                    EdgeInsets.all(
                                                        size.width *
                                                            0.005),
                                                    child: Icon(
                                                      Icons.bookmark,
                                                      color: Theme.of(
                                                          context)
                                                          .disabledColor,
                                                      size: size.width *
                                                          0.05,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: size.width * 0.05),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.025,
                                            right: size.width * 0.025),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: MyText(
                                                text: context
                                                    .read<AccBloc>()
                                                    .favNewAddress!
                                                    .address,
                                                maxLines: 3,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  size.width * 0.05,
                                                  size.width * 0.0125,
                                                  size.width * 0.05,
                                                  size.width *
                                                      0.0125),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(25),
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withAlpha(
                                                      (0.25 * 255)
                                                          .toInt())),
                                              child: MyText(
                                                text: AppLocalizations.of(
                                                    context)!
                                                    .edit,
                                                textStyle:
                                                Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: size.width * 0.05),
                              CustomTextField(
                                controller: context
                                    .read<AccBloc>()
                                    .newAddressController,
                                autofocus: true,
                                hintText:
                                AppLocalizations.of(context)!.name,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        : const SizedBox(),
                  ),
                ),
                bottomNavigationBar: (context.read<AccBloc>().favNewAddress !=
                    null)
                    ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomButton(
                        buttonName: AppLocalizations.of(context)!.save,
                        isLoader: context.read<AccBloc>().isLoading,
                        onTap: () {
                          if (context
                              .read<AccBloc>()
                              .newAddressController
                              .text !=
                              '') {
                            context.read<AccBloc>().add(
                                AddFavAddressEvent(
                                    isOther: true,
                                    address: context
                                        .read<AccBloc>()
                                        .favNewAddress!
                                        .address,
                                    name: context
                                        .read<AccBloc>()
                                        .newAddressController
                                        .text,
                                    lat: context
                                        .read<AccBloc>()
                                        .favNewAddress!
                                        .lat
                                        .toString(),
                                    lng: context
                                        .read<AccBloc>()
                                        .favNewAddress!
                                        .lng
                                        .toString()));
                          } else {
                            showToast(
                                message: AppLocalizations.of(context)!
                                    .enterTheCredentials);
                          }
                        }),
                  ),
                )
                    : null,
              ));
        }),
      ),
    );
  }
}