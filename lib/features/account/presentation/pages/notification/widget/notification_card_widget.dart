import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/notifications_model.dart';
import 'notification_content.dart';

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget(
      {super.key, required this.cont, required this.notificationData});
  final BuildContext cont;
  final NotificationData notificationData;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return NotificationContent(
      title: notificationData.title,
      body: notificationData.body,
      date: notificationData.convertedCreatedAt
          .trim()
          .split(RegExp(r'\s+'))
          .take(2)
          .join(' '),
      imageUrl: notificationData.image is String
          ? notificationData.image as String
          : '',
      deleteLabel: l10n.deleteNotification,
      onDelete: () async {
        final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
                    title: Text(l10n.deleteNotification),
                    content: Text(l10n.deleteNotificationText),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: Text(l10n.cancel)),
                      FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: Text(l10n.confirm)),
                    ]));
        if (confirmed == true && cont.mounted) {
          cont
              .read<AccBloc>()
              .add(DeleteNotificationEvent(id: notificationData.id));
        }
      },
    );
  }
}
