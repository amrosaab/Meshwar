import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../application/acc_bloc.dart';

class SupportReplyMessageList extends StatelessWidget {
  final Size size;
  const SupportReplyMessageList({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AccBloc>();
    final replyMessages = bloc.replyMessages;
    final supportTicketData = bloc.supportTicketData!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.047),
      padding: EdgeInsets.all(size.width * 0.025),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: replyMessages.isNotEmpty
            ? Border.all(color: AppColors.borderColor)
            : null,
      ),
      width: size.width * 0.9,
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: replyMessages.length,
            itemBuilder: (context, index) {
              final message = replyMessages[index];
              final isUser = message.senderId == supportTicketData.usersId;
              final profilePicture = isUser
                  ? supportTicketData.user.profilePicture
                  : (supportTicketData.adminDetails != null)
                      ? supportTicketData.adminDetails!.profilePicture
                      : supportTicketData.user.profilePicture;
              return Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.width * 0.025,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser)
                        SizedBox(
                          height: size.width * 0.075,
                          width: size.width * 0.075,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profilePicture),
                          ),
                        ),
                      if (!isUser)
                        SizedBox(
                          width: size.width * 0.025,
                        ),
                      Container(
                        width: size.width * 0.725,
                        padding: EdgeInsets.all(size.width * 0.025),
                        decoration: BoxDecoration(
                            color: isUser
                                ? Colors.transparent
                                : const Color(0xFFF0F2FF),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: message.message!
                                  .replaceAll('<p>', '')
                                  .replaceAll('</p>', ''),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: (isUser)
                                          ? Theme.of(context).primaryColorDark
                                          : (Theme.of(context).brightness ==
                                                  Brightness.dark)
                                              ? Theme.of(context).hintColor
                                              : Theme.of(context)
                                                  .primaryColorDark),
                              maxLines: 6,
                            ),
                            SizedBox(
                              height: size.width * 0.01,
                            ),
                            MyText(
                              text: message.convertedCreatedAt ?? '',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context).disabledColor),
                            ),
                          ],
                        ),
                      ),
                      if (isUser)
                        SizedBox(
                          width: size.width * 0.025,
                        ),
                      if (isUser)
                        SizedBox(
                          height: size.width * 0.075,
                          width: size.width * 0.075,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profilePicture),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Column(
              children: [
                SizedBox(height: size.width * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
