import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../widgets/reply_ticket_widget.dart';
import '../widgets/support_reply_message_list.dart';
import '../widgets/view_ticket_card.dart';


class ViewTicketPage extends StatelessWidget {
  static const String routeName = '/viewTicketPage';
  final ViewTicketPageArguments args;
  const ViewTicketPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(ViewTicketEvent(id: args.id)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: CustomAppBar(
                  title:
                      "${AppLocalizations.of(context)!.viewTicket} ${args.ticketId}",
                  automaticallyImplyLeading: true,
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (context.read<AccBloc>().supportTicketData !=
                            null) ...[
                          SizedBox(
                            height: size.width * 0.05,
                          ),
                          ViewTicketCard(
                            size: size,
                            ticketData:
                                context.read<AccBloc>().supportTicketData!,
                          ),
                          if (context.read<AccBloc>().replyMessages.isNotEmpty)
                            SizedBox(
                              height: size.width * 0.05,
                            ),
                          SupportReplyMessageList(
                            size: size,
                          ),
                          if (context.read<AccBloc>().replyMessages.isNotEmpty)
                            SizedBox(
                              height: size.width * 0.05,
                            ),
                          ReplyContainer(
                            id: args.id,
                            size: size,
                          ),
                          SizedBox(
                            height: size.width * 0.05,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
