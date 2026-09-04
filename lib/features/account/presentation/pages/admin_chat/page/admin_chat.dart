import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/chat_history_widget.dart';

class AdminChat extends StatelessWidget {
  static const String routeName = '/adminchat';
  final AdminChatPageArguments arg;

  const AdminChat({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(AdminChatInitEvent(arg: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is SendAdminMessageSuccessState) {
            context.read<AccBloc>().add(GetAdminChatHistoryListEvent());
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.adminChat,
              automaticallyImplyLeading: true,
              onBackTap: () {
                Navigator.of(context).pop();
                context.read<AccBloc>().chatStream?.cancel();
              },
            ),
            body: SingleChildScrollView(
              controller: context.read<AccBloc>().scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ChatHistoryWidget(
                        cont: context,
                        adminChatList: context.read<AccBloc>().adminChatList),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB(
                  10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
              child: SafeArea(
                child: Container(
                  width: size.width * 0.9,
                  margin: EdgeInsets.only(bottom: size.width * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkGrey, width: 1.2),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.7,
                          child: TextField(
                            controller: context.read<AccBloc>().adminchatText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.typeMessage,
                            ),
                            minLines: 1,
                            maxLines: 4,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (context
                                .read<AccBloc>()
                                .adminchatText
                                .text
                                .isNotEmpty) {
                              context.read<AccBloc>().add(
                                    SendAdminMessageEvent(
                                      newChat: context
                                              .read<AccBloc>()
                                              .adminChatList
                                              .isEmpty
                                          ? '0'
                                          : '1',
                                      message: context
                                          .read<AccBloc>()
                                          .adminchatText
                                          .text,
                                      chatId: context
                                              .read<AccBloc>()
                                              .adminChatList
                                              .isEmpty
                                          ? ""
                                          : context
                                              .read<AccBloc>()
                                              .adminChatList[0]
                                              .conversationId,
                                    ),
                                  );
                              context.read<AccBloc>().adminchatText.clear();
                            }
                          },
                          child: const Icon(
                            Icons.send,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
