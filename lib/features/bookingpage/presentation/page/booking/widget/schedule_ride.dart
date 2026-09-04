import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intel;
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../application/booking_bloc.dart';

class ScheduleRideWidget extends StatelessWidget {
  final Size size;
  final BookingPageArguments arg;
  final bool isReturnTime;

  const ScheduleRideWidget({
    super.key,
    required this.size,
    required this.arg,
    required this.isReturnTime,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccessState) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
        final bookingBloc = context.read<BookingBloc>();
        return StatefulBuilder(builder: (_, set) {
          return Container(
            width: size.width,
            height: size.width,
            padding: EdgeInsets.all(size.width * 0.05),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.scheduleRide,
                      textStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).primaryColorDark,
                              ),
                    ),
                    if (context
                            .read<BookingBloc>()
                            .scheduleDateTime
                            .isNotEmpty &&
                        !arg.isOutstationRide)
                      (!bookingBloc.isEtaLoading)
                          ? InkWell(
                              onTap: () {
                                context.read<BookingBloc>().showDateTime = '';
                                context.read<BookingBloc>().scheduleDateTime =
                                    '';
                                context.read<BookingBloc>().showReturnDateTime =
                                    '';
                                context
                                    .read<BookingBloc>()
                                    .scheduleDateTimeForReturn = '';
                                context.read<BookingBloc>().add(UpdateEvent());
                                context.read<BookingBloc>().add(UpdateEvent());
                                if (bookingBloc.isEtaLoading) return;
                                if (!context.read<BookingBloc>().isRentalRide) {
                                  context
                                      .read<BookingBloc>()
                                      .add(BookingEtaRequestEvent(
                                        picklat: arg.picklat,
                                        picklng: arg.picklng,
                                        droplat: arg.droplat,
                                        droplng: arg.droplng,
                                        ridetype: 1,
                                        transporttype: arg.transportType,
                                        distance: context
                                            .read<BookingBloc>()
                                            .distance,
                                        duration: context
                                            .read<BookingBloc>()
                                            .duration,
                                        polyLine: context
                                            .read<BookingBloc>()
                                            .polyLine,
                                        pickupAddressList:
                                            arg.pickupAddressList,
                                        dropAddressList: arg.stopAddressList,
                                        isOutstationRide: arg.isOutstationRide,
                                        isWithoutDestinationRide:
                                            arg.isWithoutDestinationRide ??
                                                false,
                                        preferenceId: context
                                                .read<BookingBloc>()
                                                .selectedPreferenceDetailsList
                                                .isNotEmpty
                                            ? context
                                                .read<BookingBloc>()
                                                .selectedPreferenceDetailsList
                                            : null,
                                        isLater: null,
                                        tripStartTime: null,
                                      ));
                                } else {
                                  context
                                      .read<BookingBloc>()
                                      .add(BookingRentalEtaRequestEvent(
                                        picklat: arg.picklat,
                                        picklng: arg.picklng,
                                        transporttype: arg.transportType,
                                        preferenceId: context
                                            .read<BookingBloc>()
                                            .selectPreference,
                                        isLater: null,
                                        tripStartTime: null,
                                      ));
                                }
                              },
                              child: MyText(
                                text: AppLocalizations.of(context)!.reset,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                              ))
                          : SizedBox(
                              height: size.width * 0.05,
                              width: size.width * 0.05,
                              child: const Loader()),
                  ],
                ),
                SizedBox(height: size.width * 0.05),
                Container(
                  height: size.width * 0.5,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(width: 1, color: AppColors.borderColors)),
                  child: CupertinoDatePicker(
                      minimumDate: isReturnTime
                          ? DateTime.tryParse(
                                  context.read<BookingBloc>().scheduleDateTime)!
                              .add(const Duration(minutes: 30))
                          : DateTime.now().add(Duration(
                              minutes: int.parse(arg
                                  .userData.userCanMakeARideAfterXMiniutes))),
                      initialDateTime: isReturnTime
                          ? DateTime.tryParse(
                                  context.read<BookingBloc>().scheduleDateTime)!
                              .add(const Duration(minutes: 30))
                          : DateTime.now().add(Duration(
                              minutes:
                                  int.parse(arg.userData.userCanMakeARideAfterXMiniutes))),
                      maximumDate: isReturnTime ? DateTime.tryParse(context.read<BookingBloc>().scheduleDateTime)!.add(const Duration(days: 15)) : DateTime.now().add(const Duration(days: 14)),
                      onDateTimeChanged: (val) {
                        debugPrint(val.toString().substring(0, 19));
                        final date = intel.DateFormat('dd/MM/yyyy (hh:mm a)')
                            .format(val);
                        final apiDate =
                            intel.DateFormat('yyyy-MM-dd HH:mm:ss').format(val);
                        if (!isReturnTime) {
                          context.read<BookingBloc>().showDateTime = date;
                          context.read<BookingBloc>().scheduleDateTime =
                              apiDate;
                        } else {
                          context.read<BookingBloc>().showReturnDateTime = date;
                          context
                              .read<BookingBloc>()
                              .scheduleDateTimeForReturn = apiDate;
                        }
                      }),
                ),
                SizedBox(height: size.width * 0.05),
                Center(
                  child: CustomButton(
                    width: size.width,
                    borderRadius: 10,
                    buttonColor: Theme.of(context).primaryColor,
                    buttonName: AppLocalizations.of(context)!.confirm,
                    isLoader: bookingBloc.isEtaLoading,
                    onTap: () {
                      final bloc = context.read<BookingBloc>();
                      if (!isReturnTime) {
                        if (bloc.scheduleDateTime.isEmpty) {
                          final defaultDate = DateTime.now().add(Duration(
                              minutes: int.parse(arg
                                  .userData.userCanMakeARideAfterXMiniutes)));
                          bloc.showDateTime =
                              intel.DateFormat('dd/MM/yyyy (hh:mm a)')
                                  .format(defaultDate);
                          bloc.scheduleDateTime =
                              intel.DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(defaultDate);
                        }
                      } else {
                        if (bloc.scheduleDateTimeForReturn.isEmpty) {
                          final defaultReturnDate =
                              DateTime.tryParse(bloc.scheduleDateTime)!
                                  .add(const Duration(minutes: 30));
                          bloc.showReturnDateTime =
                              intel.DateFormat('dd/MM/yyyy (hh:mm a)')
                                  .format(defaultReturnDate);
                          bloc.scheduleDateTimeForReturn =
                              intel.DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(defaultReturnDate);
                        }
                      }
                      bloc.add(UpdateEvent());
                      if (!bloc.isRentalRide) {
                        bloc.add(BookingEtaRequestEvent(
                          picklat: arg.picklat,
                          picklng: arg.picklng,
                          droplat: arg.droplat,
                          droplng: arg.droplng,
                          ridetype: 1,
                          transporttype: arg.transportType,
                          distance: bloc.distance,
                          duration: bloc.duration,
                          polyLine: bloc.polyLine,
                          pickupAddressList: arg.pickupAddressList,
                          dropAddressList: arg.stopAddressList,
                          isOutstationRide: arg.isOutstationRide,
                          isWithoutDestinationRide:
                              arg.isWithoutDestinationRide ?? false,
                          preferenceId:
                              bloc.selectedPreferenceDetailsList.isNotEmpty
                                  ? bloc.selectedPreferenceDetailsList
                                  : null,
                          isLater: 1,
                          tripStartTime: bloc.scheduleDateTime,
                        ));
                      } else {
                        bloc.add(BookingRentalEtaRequestEvent(
                          picklat: arg.picklat,
                          picklng: arg.picklng,
                          transporttype: arg.transportType,
                          preferenceId: bloc.selectPreference,
                          isLater: 1,
                          tripStartTime: bloc.scheduleDateTime,
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
