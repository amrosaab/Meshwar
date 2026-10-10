import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';
import 'ride_chat_content.dart';

class ChatWithDriverWidget extends StatelessWidget {
  static const String routeName = '/driverChat';

  const ChatWithDriverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
      final bloc = context.read<BookingBloc>();
      final driver = bloc.driverData;
      return RideChatContent(
        driverName: driver?.name ?? AppLocalizations.of(context)!.driver,
        avatarUrl: driver?.profilePicture ?? '',
        vehicleName: driver == null
            ? ''
            : '${driver.carMakeName} ${driver.carModelName}'.trim(),
        vehiclePlate: driver?.carNumber ?? '',
        messages: [
          for (final message in bloc.chatHistoryList)
            RideChatMessage(
              id: message.id,
              text: message.message,
              timestamp: message.convertedCreatedAt,
              isMine:
                  bloc.userData != null && message.userId == bloc.userData!.id,
              delivered: message.delivered == 1,
              seen: message.seen == 1,
            ),
        ],
        inputController: bloc.chatController,
        scrollController: bloc.chatScrollController,
        onBack: () => Navigator.of(context).pop(),
        onCall: driver == null || driver.mobile.isEmpty
            ? null
            : () => launchUrl(Uri(scheme: 'tel', path: driver.mobile)),
        onSend: bloc.requestData == null
            ? null
            : (message) {
                bloc.add(SendChatMessageEvent(
                  message: message,
                  requestId: bloc.requestData!.id,
                ));
              },
      );
    });
  }
}
