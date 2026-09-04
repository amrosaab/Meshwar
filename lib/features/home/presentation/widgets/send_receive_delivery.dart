import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';
import '../pages/destination_page.dart';

class SendOrReceiveDelivery extends StatelessWidget {
  final BuildContext cont;
  const SendOrReceiveDelivery({
    super.key,
    required this.cont,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              width: size.width,
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.width * 0.05),
                  Image.asset(AppImages.parcel, height: size.width * 0.2),
                  SizedBox(height: size.width * 0.01),
                  MyText(
                      text: AppLocalizations.of(context)!.sendAndReceive,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold)),
                  SizedBox(height: size.width * 0.01),
                  MyText(
                    text: AppLocalizations.of(context)!.ourParcelService,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.width * 0.1),
                  CustomButton(
                    buttonName: AppLocalizations.of(context)!.sendParcel,
                    borderRadius: 20,
                    width: size.width * 0.8,
                    height: size.width * 0.12,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        DestinationPage.routeName,
                        arguments: DestinationPageArguments(
                          title: 'Send Parcel',
                          pickupAddress:
                              context.read<HomeBloc>().currentLocation,
                          pickupLatLng: context.read<HomeBloc>().currentLatLng,
                          userData: context.read<HomeBloc>().userData!,
                          pickUpChange: false,
                          mapType: context.read<HomeBloc>().mapType,
                          isOutstationRide: false,
                          transportType: 'delivery',
                          selectedServiceIndex:
                              context.read<HomeBloc>().selectedServiceIndex,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.width * 0.05),
                  CustomButton(
                    buttonName: AppLocalizations.of(context)!.receiveParcel,
                    borderRadius: 20,
                    isBorder: true,
                    textColor: Theme.of(context).primaryColor,
                    buttonColor: Theme.of(context).scaffoldBackgroundColor,
                    width: size.width * 0.8,
                    height: size.width * 0.12,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        DestinationPage.routeName,
                        arguments: DestinationPageArguments(
                            title: 'Receive Parcel',
                            dropAddress:
                                context.read<HomeBloc>().currentLocation,
                            dropLatLng: context.read<HomeBloc>().currentLatLng,
                            userData: context.read<HomeBloc>().userData!,
                            pickUpChange: true,
                            mapType: context.read<HomeBloc>().mapType,
                            isOutstationRide: false,
                            transportType: 'delivery',
                            selectedServiceIndex:
                                context.read<HomeBloc>().selectedServiceIndex),
                      );
                    },
                  ),
                  SizedBox(height: size.width * 0.1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
