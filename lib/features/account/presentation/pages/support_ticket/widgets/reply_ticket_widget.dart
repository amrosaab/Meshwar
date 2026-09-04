import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';


class ReplyContainer extends StatelessWidget {
  final Size size;
  final String id;

  const ReplyContainer({
    super.key,
    required this.size,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.325,
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
              const RotatedBox(
                quarterTurns: 2, // 1 = 90°, 2 = 180°, 3 = 270°
                child: Icon(
                  Icons.arrow_outward_sharp,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              MyText(
                text: AppLocalizations.of(context)!.replyText,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColorDark, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: size.width * 0.025),
          Row(
            children: [
              MyText(
                text: AppLocalizations.of(context)!.messageText,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColorDark, fontSize: 14),
              ),
              MyText(
                text: '*',
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.red, fontSize: 14),
              ),
            ],
          ),
          SizedBox(
            height: size.width * 0.025,
          ),
          Expanded(
            child: CustomTextField(
              borderRadius: 6,
              controller: context.read<AccBloc>().supportMessageReplyController,
              hintText: AppLocalizations.of(context)!.enterMessage,
              hintTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: 14, color: Theme.of(context).hintColor),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).primaryColorDark,
                  ),
              maxLine: 5,
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.borderColors, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.borderColors, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.borderColors, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: BlocConsumer<AccBloc, AccState>(
              listener: (cont, state) {},
              builder: (cont, state) {
                return CustomButton(
                  width: size.width,
                  buttonColor:
                      cont.read<AccBloc>().supportTicketData!.status != 3
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                  buttonName: AppLocalizations.of(context)!.send,
                  onTap: cont.read<AccBloc>().supportTicketData!.status != 3
                      ? () {
                          if (context
                              .read<AccBloc>()
                              .supportMessageReplyController
                              .text
                              .isNotEmpty) {
                            cont.read<AccBloc>().add(
                                  TicketReplyMessageEvent(
                                    context: context,
                                    id: id,
                                    messageText: context
                                        .read<AccBloc>()
                                        .supportMessageReplyController
                                        .text,
                                  ),
                                );
                          } else {
                            showToast(
                                message: AppLocalizations.of(context)!
                                    .fillTheMessageField);
                          }
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
