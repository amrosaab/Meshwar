import 'package:flutter/material.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../widgets/account_content.dart';

class NotificationContent extends StatelessWidget {
  const NotificationContent(
      {super.key,
      required this.title,
      required this.body,
      required this.date,
      required this.deleteLabel,
      required this.onDelete,
      this.imageUrl = ''});
  final String title, body, date, deleteLabel, imageUrl;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.bgAsphaltLight
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.surfaceBorder(context))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const ExcludeSemantics(
                child: RideColorBadge(
                    icon: Icons.notifications_active_outlined,
                    gradient: RideVisuals.blue,
                    size: 44,
                    iconSize: 23,
                    radius: 15)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: AccountStyle.text(context)
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(date,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 12, color: AccountStyle.muted(context))),
                ])),
            const SizedBox(width: 4),
            IconButton(
                tooltip: deleteLabel,
                onPressed: onDelete,
                style: IconButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    backgroundColor:
                        AppColors.meshwarRed.withValues(alpha: .07),
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF82A6)
                            : AppColors.meshwarRed),
                icon: const Icon(Icons.close_rounded, size: 20)),
          ]),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(body,
                style: AccountStyle.text(context)
                    .copyWith(color: AccountStyle.muted(context))),
          ],
          if (imageUrl.isNotEmpty) ...[
            const SizedBox(height: 16),
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stack) =>
                            _imagePlaceholder(context),
                        loadingBuilder: (_, child, progress) => progress == null
                            ? child
                            : _imagePlaceholder(context)))),
          ],
        ]),
      );

  Widget _imagePlaceholder(BuildContext context) => ColoredBox(
      color: AppColors.surface(context),
      child: Center(
          child:
              Icon(Icons.image_outlined, color: AccountStyle.muted(context))));
}

class NotificationEmptyContent extends StatelessWidget {
  const NotificationEmptyContent({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const ExcludeSemantics(
              child: RideColorBadge(
                  icon: Icons.notifications_none_rounded,
                  gradient: RideVisuals.amber,
                  size: 88,
                  iconSize: 42,
                  radius: 28)),
          const SizedBox(height: 24),
          Text(label,
              textAlign: TextAlign.center,
              style: AccountStyle.text(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w700)),
        ]),
      );
}
