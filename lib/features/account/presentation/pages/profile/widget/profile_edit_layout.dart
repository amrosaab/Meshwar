import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../widgets/account_content.dart';

class ProfileEditLayout extends StatelessWidget {
  const ProfileEditLayout(
      {super.key,
      required this.title,
      required this.label,
      required this.description,
      required this.field,
      required this.saveLabel,
      required this.onSave,
      required this.onBack,
      required this.icon,
      this.gradient = RideVisuals.blue,
      this.saving = false});
  final String title, label, description, saveLabel;
  final Widget field;
  final VoidCallback onSave, onBack;
  final IconData icon;
  final LinearGradient gradient;
  final bool saving;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: RideVisuals.canvas(context),
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.bgAsphaltLight
              : Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          toolbarHeight:
              MediaQuery.textScalerOf(context).scale(18) > 27 ? 96 : 64,
          centerTitle: false,
          leading: IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack,
              icon: const BackButtonIcon(),
              color: AccountStyle.ink(context)),
          title: Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AccountStyle.text(context).copyWith(
                  fontSize: 18, height: 1.2, fontWeight: FontWeight.w700)),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: RideVisuals.wash(context, gradient.colors.last),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.surfaceBorder(context))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      ExcludeSemantics(
                          child: RideColorBadge(
                              icon: icon,
                              gradient: gradient,
                              size: 44,
                              iconSize: 23,
                              radius: 15)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Text(label,
                              style: AccountStyle.text(context).copyWith(
                                  fontSize: 22, fontWeight: FontWeight.w700))),
                    ]),
                    const SizedBox(height: 18),
                    Text(description,
                        style: AccountStyle.text(context)
                            .copyWith(color: AccountStyle.muted(context))),
                    const SizedBox(height: 24),
                    field,
                  ]),
            )
          ],
        ),
        bottomNavigationBar: AnimatedPadding(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: FilledButton(
              onPressed: saving ? null : onSave,
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.meshwarRed,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.meshwarRed,
                  disabledForegroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (saving)
                  const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                else
                  const ExcludeSemantics(
                      child: Icon(Icons.check_rounded, size: 20)),
                const SizedBox(width: 10),
                Flexible(
                    child: Text(saveLabel.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .4))),
              ]),
            ),
          ),
        ),
      );
}
