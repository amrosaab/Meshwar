import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class CancelRideWidget extends StatelessWidget {
  final BuildContext cont;
  final String requestId;
  const CancelRideWidget(
      {super.key, required this.cont, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * 0.05),
                      topRight: Radius.circular(size.width * 0.05))),
              width: size.width,
              child: Container(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.rideLaterCancelText,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    CustomButton(
                        width: size.width * 0.5,
                        buttonName: AppLocalizations.of(context)!.cancel,
                        onTap: () {
                          context.read<AccBloc>().add(
                                RideLaterCancelRequestEvent(
                                    requestId: requestId),
                              );
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
