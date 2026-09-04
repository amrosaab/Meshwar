import 'package:flutter/material.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../domain/models/ticket_list_model.dart';
import '../page/view_ticket_page.dart';


class TicketCard extends StatelessWidget {
  final Size size;
  final TicketData ticketData;
  final bool isFromViewPage;
  const TicketCard(
      {super.key,
      required this.size,
      required this.ticketData,
      required this.isFromViewPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ViewTicketPage.routeName,
          arguments: ViewTicketPageArguments(
              isViewTicketPage: true,
              ticketId: ticketData.ticketId,
              id: ticketData.id),
        );
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.047),
            padding: EdgeInsets.all(size.width * 0.025),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: AppColors.borderColor),
            ),
            width: size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.ticketId,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14),
                    ),
                    MyText(
                      text: " ${ticketData.ticketId}",
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              fontSize: 16,
                              color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.025,
                ),
                MyText(
                  text: AppLocalizations.of(context)!.title,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 14),
                ),
                MyText(
                  text: "${ticketData.ticketTitle.title}",
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 16),
                  maxLines: 3,
                ),
                SizedBox(
                  height: size.width * 0.025,
                ),
                MyText(
                    text: AppLocalizations.of(context)!.supportType,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 14)),
                MyText(
                  text: ticketData.supportType,
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 16),
                ),
                isFromViewPage
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.width * 0.025,
                          ),
                          MyText(
                            text: AppLocalizations.of(context)!.assignTo,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 14),
                          ),
                          MyText(
                            text: " ${ticketData.assignTo}",
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 16),
                            maxLines: 3,
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(
                  height: size.width * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size.width * 0.05,
                          size.width * 0.015,
                          size.width * 0.05,
                          size.width * 0.015),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          color: ticketData.status == 1
                              ? AppColors.blue
                              : ticketData.status == 2
                                  ? AppColors.orange
                                  : AppColors.red),
                      child: MyText(
                        text: ticketData.status == 1
                            ? AppLocalizations.of(context)!.pending
                            : ticketData.status == 2
                                ? AppLocalizations.of(context)!.acknowledged
                                : AppLocalizations.of(context)!.closed,
                        textStyle: const TextStyle(
                            fontSize: 12,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
