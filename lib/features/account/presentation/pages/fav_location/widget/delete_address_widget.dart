import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class DeleteAddressWidget extends StatelessWidget {
  final BuildContext cont;
  final String addressId;
  final bool isHome;
  final bool isWork;
  final bool isOthers;
  const DeleteAddressWidget(
      {super.key,
        required this.cont,
        required this.addressId,
        required this.isHome,
        required this.isWork,
        required this.isOthers});

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
                    color: AppColors.surfaceStrong(context),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.width * 0.05),
                        topRight: Radius.circular(size.width * 0.05)),
                    boxShadow: AppColors.surfaceShadow(context)),
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: AppLocalizations.of(context)!.deleteAddress,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                            maxLines: 2,
                          ),
                          SizedBox(height: size.width * 0.025),
                          MyText(
                            text: AppLocalizations.of(context)!
                                .deleteAddressSubText,
                            maxLines: 2,
                          ),
                          SizedBox(height: size.width * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                  width: size.width * 0.44,
                                  borderRadius: size.width * 0.025,
                                  isBorder: true,
                                  buttonColor: AppColors.surface(context),
                                  textColor: Theme.of(context).primaryColor,
                                  buttonName:
                                  AppLocalizations.of(context)!.cancel,
                                  onTap: () {
                                    Navigator.pop(context);
                                  }),
                              CustomButton(
                                  width: size.width * 0.44,
                                  borderRadius: size.width * 0.025,
                                  buttonName:
                                  AppLocalizations.of(context)!.delete,
                                  onTap: () {
                                    context.read<AccBloc>().add(
                                        DeleteFavAddressEvent(
                                            id: addressId,
                                            isHome: isHome,
                                            isWork: isWork,
                                            isOthers: isOthers));
                                    Navigator.pop(context);
                                  }),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}