import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_divider.dart';
import '../../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../core/utils/functions.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../home/domain/models/user_details_model.dart';
import '../../../../../application/booking_bloc.dart';

class SOSAlertWidget extends StatelessWidget {
  const SOSAlertWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
      return Container(
        width: size.width,
        height: size.height * 0.7,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            children: [
              const CustomDivider(),
              SizedBox(height: size.width * 0.02),
              MyText(
                text: AppLocalizations.of(context)!.sosRideEmergencyText,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).disabledColor),
                maxLines: 2,
              ),
              SizedBox(height: size.width * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    width: size.width * 0.65,
                    buttonName: AppLocalizations.of(context)!.notifyAdmin,
                    onTap: () {
                      context.read<BookingBloc>().add(NotifyAdminEvent(
                          requestId:
                              context.read<BookingBloc>().requestData!.id,
                          serviceLocId: context
                              .read<BookingBloc>()
                              .requestData!
                              .serviceLocationId));
                      showToast(
                          message: AppLocalizations.of(context)!
                              .notifiedSuccessfully);
                      context.read<BookingBloc>().add(UpdateEvent());
                    },
                  ),
                  const Icon(Icons.notification_add_rounded)
                ],
              ),
              SizedBox(height: size.width * 0.05),
              if (context.read<BookingBloc>().userData != null &&
                  context
                      .read<BookingBloc>()
                      .userData!
                      .sos
                      .data
                      .isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    text: AppLocalizations.of(context)!.sosContacts,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: size.width * 0.02),
                sosData(size, context.read<BookingBloc>().userData!.sos.data)
              ]
            ],
          ),
        ),
      );
    });
  }

  Widget sosData(Size size, List<SOSDatum> sosList) {
    return sosList.isNotEmpty
        ? RawScrollbar(
            radius: const Radius.circular(20),
            child: ListView.separated(
              itemCount: sosList.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final sosData = sosList.elementAt(index);
                return InkWell(
                  onTap: () async {
                    await openUrl("tel:${sosData.number}");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                              text: sosData.name,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          SizedBox(height: size.width * 0.02),
                          MyText(
                              text: sosData.number,
                              textStyle:
                                  Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      Icon(Icons.call,
                          color: Theme.of(context).primaryColorDark)
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(color: Theme.of(context).dividerColor);
              },
            ),
          )
        : const SizedBox();
  }
}
