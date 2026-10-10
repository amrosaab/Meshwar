import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../widgets/account_content.dart';

class ProfilePhotoCard extends StatelessWidget {
  const ProfilePhotoCard(
      {super.key,
      required this.name,
      required this.title,
      required this.caption,
      required this.editLabel,
      required this.onEdit,
      this.imageUrl = ''});
  final String name, title, caption, editLabel, imageUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: RideVisuals.wash(context, AppColors.meshwarRed),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.surfaceBorder(context))),
        child: LayoutBuilder(builder: (context, constraints) {
          final stacked = constraints.maxWidth < 290 ||
              MediaQuery.textScalerOf(context).scale(13) > 19;
          final portrait = Semantics(
            image: true,
            label: '$title, $name',
            child: ExcludeSemantics(
                child: Container(
              width: 84,
              height: 84,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  gradient: RideVisuals.rose,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: RideVisuals.glow(AppColors.meshwarRed)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: imageUrl.isEmpty
                    ? _fallback()
                    : Image.network(imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stackTrace) => _fallback(),
                        loadingBuilder: (_, child, progress) =>
                            progress == null ? child : _fallback()),
              ),
            )),
          );
          final details =
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: AccountStyle.text(context)
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(caption,
                style: AccountStyle.text(context).copyWith(
                    fontSize: 13, color: AccountStyle.muted(context))),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onEdit,
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.meshwarRed,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const ExcludeSemantics(
                    child: Icon(Icons.camera_alt_outlined, size: 18)),
                const SizedBox(width: 8),
                Flexible(
                    child: Text(editLabel,
                        textAlign: TextAlign.center,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
              ]),
            ),
          ]);
          return stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [portrait, const SizedBox(height: 18), details])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  portrait,
                  const SizedBox(width: 18),
                  Expanded(child: details)
                ]);
        }),
      );

  Widget _fallback() =>
      const Icon(Icons.person_rounded, size: 40, color: Colors.white);
}

class ProfileInfoField extends StatelessWidget {
  const ProfileInfoField(
      {super.key,
      required this.label,
      required this.value,
      required this.editLabel,
      required this.icon,
      required this.gradient,
      required this.onEdit,
      this.ltrValue = false});
  final String label, value, editLabel;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onEdit;
  final bool ltrValue;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: LayoutBuilder(builder: (context, constraints) {
            final stacked = constraints.maxWidth < 280 ||
                MediaQuery.textScalerOf(context).scale(14) > 20;
            final edit = Row(mainAxisSize: MainAxisSize.min, children: [
              ExcludeSemantics(
                  child: Icon(Icons.edit_outlined,
                      size: 15,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF7DA5)
                          : AppColors.meshwarRed)),
              const SizedBox(width: 5),
              Flexible(
                  child: Text(editLabel,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF7DA5)
                              : AppColors.meshwarRed))),
            ]);
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ExcludeSemantics(
                  child: RideColorBadge(
                      icon: icon,
                      gradient: gradient,
                      size: 40,
                      iconSize: 20,
                      radius: 14)),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(label,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 12, color: AccountStyle.muted(context))),
                    const SizedBox(height: 5),
                    Text(value.isEmpty ? '—' : value,
                        textDirection: ltrValue ? TextDirection.ltr : null,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    if (stacked) ...[const SizedBox(height: 12), edit],
                  ])),
              if (!stacked) ...[const SizedBox(width: 12), edit],
            ]);
          }),
        ),
      );
}

class ProfileFieldsCard extends StatelessWidget {
  const ProfileFieldsCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.bgAsphaltLight
            : Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppColors.surfaceBorder(context))),
        child: Column(children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Padding(
                  padding: const EdgeInsetsDirectional.only(start: 72, end: 18),
                  child: Divider(
                      height: 1, color: AppColors.surfaceBorder(context))),
            children[i],
          ],
        ]),
      );
}
