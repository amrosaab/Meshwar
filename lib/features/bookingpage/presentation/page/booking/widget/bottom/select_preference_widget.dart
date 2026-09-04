// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/app_arguments.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';

class SelectPreferenceWidget extends StatefulWidget {
  final BuildContext cont;
  final dynamic thisValue;
  final BookingPageArguments arg;
  const SelectPreferenceWidget(
      {super.key, required this.cont, this.thisValue, required this.arg});

  @override
  State<SelectPreferenceWidget> createState() => _SelectPreferenceWidgetState();
}

class _SelectPreferenceWidgetState extends State<SelectPreferenceWidget> {
  @override
  void initState() {
    super.initState();
    final bloc = widget.cont.read<BookingBloc>();
    bloc.selectPreference = List<int>.from(bloc.selectedPreferenceDetailsList);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: widget.cont.read<BookingBloc>(),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final bookingBloc = context.read<BookingBloc>();
            return SafeArea(
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: size.width * 0.12,
                        margin: EdgeInsets.only(bottom: size.height * 0.02),
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.preference,
                          textStyle:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            final bloc = context.read<BookingBloc>();
                            bloc.tempSelectPreference = List<int>.from(
                                bloc.selectedPreferenceDetailsList);
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Expanded(
                      child: SingleChildScrollView(
                        child: (bookingBloc.isRentalRide == false)
                            ? _buildNormalPreferences(
                                size, bookingBloc, context, widget)
                            : _buildRentalPreferences(
                                size, bookingBloc, context, widget),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    CustomButton(
                      width: size.width * 0.80,
                      height: 50,
                      borderRadius: 16,
                      isBorder: false,
                      buttonColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      buttonName: AppLocalizations.of(context)!.confirm,
                      onTap: () {
                        final bloc = context.read<BookingBloc>();
                        final bookingBloc = context.read<BookingBloc>();

                        bloc.add(ConfirmPreferenceSelectionEvent(
                          arg: widget.arg,
                          selectedPreferences:
                              List<int>.from(bloc.tempSelectPreference),
                        ));

                        if (bookingBloc.isRentalRide == true) {
                          bookingBloc.add(BookingRentalEtaRequestEvent(
                            picklat: widget.arg.picklat,
                            picklng: widget.arg.picklng,
                            transporttype: bookingBloc.transportType,
                            preferenceId: bloc.tempSelectPreference.isNotEmpty
                                ? bloc.tempSelectPreference
                                : null,
                          ));
                        } else {
                          bookingBloc.add(BookingEtaRequestEvent(
                            picklat: widget.arg.picklat,
                            picklng: widget.arg.picklng,
                            droplat: widget.arg.droplat,
                            droplng: widget.arg.droplng,
                            ridetype: 1,
                            transporttype: widget.arg.transportType,
                            distance: bookingBloc.distance,
                            duration: bookingBloc.duration,
                            polyLine: bookingBloc.polyLine,
                            pickupAddressList: widget.arg.pickupAddressList,
                            dropAddressList: widget.arg.stopAddressList,
                            isOutstationRide: widget.arg.isOutstationRide,
                            isWithoutDestinationRide:
                                widget.arg.isWithoutDestinationRide ?? false,
                            preferenceId: bloc.tempSelectPreference.isNotEmpty
                                ? bloc.tempSelectPreference
                                : null,
                            sharedRide:
                                widget.arg.isSharedRide == true ? 1 : null,
                            seatsTaken: widget.arg.isSharedRide == true
                                ? bloc.selectedSharedSeats
                                : null,
                          ));
                        }

                        Navigator.pop(context, bloc.tempSelectPreference);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildNormalPreferences(
    Size size, BookingBloc bookingBloc, BuildContext context, widget) {
  if (bookingBloc.preferenceDetailsList!.isEmpty) {
    return _emptyState(size, context);
  }

  return Column(
    children: List.generate(
      bookingBloc.preferenceDetailsList!.length,
      (index) {
        final pref = bookingBloc.preferenceDetailsList![index];
        final isSelected =
            bookingBloc.tempSelectPreference.contains(pref.preferenceId);

        return _modernPreferenceTile(
          context: context,
          title: pref.name,
          price: pref.price,
          currency: bookingBloc.userData!.wallet.data.currencySymbol,
          isSelected: isSelected,
          onChanged: (value) {
            bookingBloc.add(SelectedPreferenceEvent(
              prefId: pref.preferenceId,
              prefIcon: pref.icon,
              isSelected: value ?? false,
            ));
          },
        );
      },
    ),
  );
}

Widget _buildRentalPreferences(
    Size size, BookingBloc bookingBloc, BuildContext context, widget) {
  if (bookingBloc.rentalPreferenceDetailsList!.isEmpty) {
    return _emptyState(size, context);
  }

  return Column(
    children: List.generate(
      bookingBloc.rentalPreferenceDetailsList!.length,
      (index) {
        final pref = bookingBloc.rentalPreferenceDetailsList![index];
        final isSelected =
            bookingBloc.tempSelectPreference.contains(pref.preferenceId);

        return _modernPreferenceTile(
          context: context,
          title: pref.name,
          price: pref.price,
          currency: bookingBloc.userData!.wallet.data.currencySymbol,
          isSelected: isSelected,
          onChanged: (value) {
            bookingBloc.add(SelectedPreferenceEvent(
              prefId: pref.preferenceId,
              prefIcon: pref.icon,
              isSelected: value ?? false,
            ));
          },
        );
      },
    ),
  );
}

Widget _modernPreferenceTile({
  required BuildContext context,
  required String title,
  required num price,
  required String currency,
  required bool isSelected,
  required Function(bool?) onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: isSelected
          ? Theme.of(context).primaryColor.withAlpha((0.08 * 255).toInt())
          : Theme.of(context).dividerColor.withAlpha((0.15 * 255).toInt()),
    ),
    child: CheckboxListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      value: isSelected,
      activeColor: Theme.of(context).primaryColor,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColorDark,
        ),
      ),
      subtitle: price != 0
          ? Text(
              "$currency $price",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            )
          : null,
      controlAffinity: ListTileControlAffinity.trailing,
    ),
  );
}

Widget _emptyState(Size size, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.08),
    child: Column(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 60,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          AppLocalizations.of(context)!.preferenceNotAvailable,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    ),
  );
}
