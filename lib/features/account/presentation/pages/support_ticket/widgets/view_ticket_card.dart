import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart' as intl;
import 'package:meshwar_user/features/account/presentation/pages/support_ticket/widgets/ticket_info_item.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/view_ticket_model.dart';
import 'attachment_preview_list.dart';

class ViewTicketCard extends StatelessWidget {
  final Size size;
  final SupportTicket ticketData;

  const ViewTicketCard({
    super.key,
    required this.size,
    required this.ticketData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.047),
      padding: EdgeInsets.all(size.width * 0.025),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: AppColors.borderColor),
      ),
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: ticketData.user.profilePicture.isNotEmpty
                    ? NetworkImage(ticketData.user.profilePicture)
                    : null,
              ),
              SizedBox(width: size.width * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.65,
                    child: MyText(
                      text: ticketData.user.name,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14),
                      maxLines: 2,
                    ),
                  ),
                  MyText(
                    text: intl.DateFormat('d MMM, h:mm a')
                        .format(ticketData.user.createdAt)
                        .toString(),
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: size.width * 0.025,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyText(
                    text: AppLocalizations.of(context)!.ticketId,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).hintColor),
                  ),
                  MyText(
                    text: " ${ticketData.ticketId}",
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
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
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: ticketData.status == 1
                          ? 14
                          : ticketData.status == 2
                              ? 10
                              : 14,
                      color: AppColors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.width * 0.025,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.titleColonText,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).hintColor),
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: MyText(
                    text: " ${ticketData.ticketTitle.title}",
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold),
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.width * 0.025),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.description,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).disabledColor),
              ),
              SizedBox(
                width: size.width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: MyText(
                    text: " ${ticketData.description}",
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                    maxLines: 5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.width * 0.025,
          ),
          TicketInfoItem(
            title: AppLocalizations.of(context)!.supportType,
            value: " ${ticketData.supportType}",
          ),
          SizedBox(height: size.width * 0.025),
          TicketInfoItem(
            title: AppLocalizations.of(context)!.assignTo,
            value: ticketData.adminName ??
                " ${AppLocalizations.of(context)!.notAssigned}",
          ),
          SizedBox(
            height: size.width * 0.025,
          ),
          if (context
              .read<AccBloc>()
              .viewAttachments
              .map((e) => e.image)
              .toList()
              .isNotEmpty) ...[
            Container(
              width: size.width,
              height: size.width * 0.002,
              color: AppColors.borderColors,
            ),
            SizedBox(height: size.width * 0.025),
            Row(
              children: [
                MyText(
                  text: AppLocalizations.of(context)!.attachments,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
            SizedBox(height: size.width * 0.03),
            SizedBox(
              height: size.width * 0.2,
              width: size.width,
              child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
                return AttachmentPreviewList(
                  imageUrls: context
                      .read<AccBloc>()
                      .viewAttachments
                      .map((e) => e.image)
                      .toList(),
                );
              }),
            ),
            SizedBox(height: size.width * 0.02),
          ],
        ],
      ),
    );
  }
}
