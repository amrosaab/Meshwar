import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../widgets/create_ticket_sheet.dart';
import '../widgets/support_empty_widget.dart';
import '../widgets/ticket_card.dart';


class SupportTicketPage extends StatelessWidget {
  static const String routeName = '/supportTicketPage';
  final SupportTicketPageArguments args;
  const SupportTicketPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetTicketListEvent(isFromAcc: true))
        ..add(GetServiceLocationEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is GetTicketListLoadingState) {
            CustomLoader.loader(context);
          }
          if (state is GetTicketListLoadedState) {
            CustomLoader.dismiss(context);
          }
          if (state is CreateSupportTicketState) {
            if (context.read<AccBloc>().isTicketSheetOpened) return;

            context.read<AccBloc>().isTicketSheetOpened = true;
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              isDismissible: true,
              context: context,
              builder: (cont) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: CreateTicketSheet(
                    requestId: state.requestId,
                    cont: context,
                    ticketNamesList: state.ticketNamesList,
                    isFromReuest: state.isFromRequest,
                  ),
                );
              },
            ).then((value) {
              if (value != null && value == true) {
                if (context.mounted) {
                  CustomLoader.loader(context);
                }
              }
            }).whenComplete(() {
              if (context.mounted) {
                context.read<AccBloc>().isTicketSheetOpened = false;
              }
            });
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar:CustomAppBar(
                  title: AppLocalizations.of(context)!.supportTicket,
                  automaticallyImplyLeading: true,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      if (context.read<AccBloc>().ticketList.isNotEmpty) ...[
                        SizedBox(
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return TicketCard(
                                  size: size,
                                  ticketData:
                                      context.read<AccBloc>().ticketList[index],
                                  isFromViewPage: false,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: size.width * 0.04,
                                );
                              },
                              itemCount:
                                  context.read<AccBloc>().ticketList.length),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        )
                      ],
                      if (context.read<AccBloc>().ticketList.isEmpty &&
                          !context.read<AccBloc>().isLoading)
                        const SupportEmptyWidget()
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    context.read<AccBloc>().add(
                          CreateSupportTicketEvent(
                            requestId: args.requestId,
                            isFromRequest: args.isFromRequest,
                          ),
                        );
                  },
                  child: Icon(
                    Icons.add,
                    size: size.width * 0.09,
                    color: Theme.of(context).scaffoldBackgroundColor,
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
