import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/functions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/presentation/pages/home_page.dart';
import '../../../../application/booking_bloc.dart';

class NoVehicleFound extends StatelessWidget {
  final Size size;
  const NoVehicleFound({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.05),
            topRight: Radius.circular(size.width * 0.05)),
      ),
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.width * 0.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  context
                      .read<BookingBloc>()
                      .nearByVechileSubscription
                      ?.cancel();
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.routeName, (route) => false);
                },
                child: Icon(Icons.cancel_rounded,
                    color: Theme.of(context).primaryColorDark),
              )
            ],
          ),
          SizedBox(height: size.width * 0.025),
          Center(
            child: MyText(
              text: AppLocalizations.of(context)!.noVehicleTypes,
              textStyle:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
              maxLines: 2,
            ),
          ),
          SizedBox(height: size.width * 0.025),
          Center(
            child: MyText(
              text: AppLocalizations.of(context)!.pleaseContactAdminToBook,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 14),
              maxLines: 2,
            ),
          ),
          SizedBox(height: size.width * 0.1),
          Center(
              child: CustomButton(
            width: size.width,
            buttonName: AppLocalizations.of(context)!.callAdmin,
            onTap: () async {
              await openUrl(
                  "tel:${context.read<BookingBloc>().userData!.contactBookingNumber}");
            },
          )),
          SizedBox(height: size.width * 0.025),
        ],
      ),
    );
  }
}
