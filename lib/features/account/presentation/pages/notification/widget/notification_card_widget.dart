import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/app_images.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/notifications_model.dart';

class NotificationCardWidget extends StatelessWidget {
  final BuildContext cont;
  final NotificationData notificationData;

  const NotificationCardWidget({
    super.key,
    required this.cont,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      margin: EdgeInsets.only(bottom: size.width * 0.04),
      child: LiquidGlassContainer(
        borderRadius: 10,
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row (Title + Date + Delete button)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: size.width * 0.01),
                  child: Image.asset(
                    AppImages.bellRing,
                    width: size.width * 0.05,
                    height: size.width * 0.05,
                    color: AppColors.primary,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: size.width * 0.03),

                /// TITLE + DATE + DELETE BTN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + time row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NOTIFICATION TITLE
                          Expanded(
                            child: MyText(
                              text: notificationData.title,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColorDark),
                              maxLines: 3,
                            ),
                          ),

                          /// DATE TIME
                          Row(
                            children: [
                              MyText(
                                text: notificationData.convertedCreatedAt
                                    .split(' ')[0],
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                    color:
                                    Theme.of(context).primaryColorDark),
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              MyText(
                                text: notificationData.convertedCreatedAt
                                    .split(' ')[1],
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                    color:
                                    Theme.of(context).primaryColorDark),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: size.width * 0.02),

                      /// MESSAGE BODY + DELETE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Notification Body Text
                          Expanded(
                            child: MyText(
                              text: notificationData.body,
                              textStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              maxLines: 5,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),

                          /// Delete Button (X)
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext _) {
                                  return BlocProvider.value(
                                    value: context.read<AccBloc>(),
                                    child: CustomSingleButtonDialoge(
                                      title: AppLocalizations.of(context)!
                                          .deleteNotification,
                                      content: AppLocalizations.of(context)!
                                          .deleteNotificationText,
                                      btnName:
                                      AppLocalizations.of(context)!.confirm,
                                      onTap: () {
                                        context.read<AccBloc>().add(
                                            DeleteNotificationEvent(
                                                id: notificationData.id));
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              AppImages.cancelIcon,
                              fit: BoxFit.contain,
                              width: size.width * 0.05,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// IMAGE SECTION
            if (notificationData.image != null &&
                notificationData.image!.isNotEmpty) ...[
              SizedBox(height: size.height * 0.015),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  notificationData.image!,
                  width: double.infinity,
                  height: size.width * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}