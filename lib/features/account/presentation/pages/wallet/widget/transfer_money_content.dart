import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';

class TransferMoneySheet extends StatefulWidget {
  const TransferMoneySheet(
      {super.key,
      required this.amountController,
      required this.phoneController,
      required this.currency,
      required this.role,
      required this.busy,
      required this.onRole,
      required this.onClose,
      required this.onTransfer});
  final TextEditingController amountController, phoneController;
  final String currency, role;
  final bool busy;
  final ValueChanged<String> onRole;
  final VoidCallback onClose, onTransfer;
  @override
  State<TransferMoneySheet> createState() => _TransferMoneySheetState();
}

class _TransferMoneySheetState extends State<TransferMoneySheet> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? const Color(0xFFFF82A6) : AppColors.meshwarRed;
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.surfaceBorder(context)));
    InputDecoration decoration(String? label, {String? prefix, Widget? icon}) =>
        InputDecoration(
          labelText: label,
          prefixText: prefix,
          prefixIcon: icon,
          labelStyle: AccountStyle.text(context)
              .copyWith(color: AccountStyle.muted(context)),
          prefixStyle: AccountStyle.text(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          filled: true,
          fillColor: dark ? AppColors.bgVoid : const Color(0xFFF8F6F9),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border.copyWith(
              borderSide: BorderSide(color: accent, width: 1.5)),
          errorMaxLines: 4,
        );
    return AnimatedPadding(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: (MediaQuery.sizeOf(context).height -
                    MediaQuery.paddingOf(context).top -
                    MediaQuery.viewInsetsOf(context).bottom) *
                .92),
        child: Material(
          color: RideVisuals.canvas(context),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.surfaceBorder(context),
                        borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ExcludeSemantics(
                          child: RideColorBadge(
                              icon: Icons.swap_horiz_rounded,
                              gradient: RideVisuals.blue,
                              size: 48,
                              iconSize: 26,
                              radius: 16)),
                      IconButton(
                          onPressed: widget.busy ? null : widget.onClose,
                          tooltip: MaterialLocalizations.of(context)
                              .closeButtonTooltip,
                          icon: const Icon(Icons.close_rounded)),
                    ]),
                const SizedBox(height: 16),
                Flexible(
                    child: SingleChildScrollView(
                        child: Form(
                            key: _form,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(l10n.transferMoney,
                                      style: AccountStyle.text(context)
                                          .copyWith(
                                              fontSize: 24,
                                              height: 1.25,
                                              fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 10),
                                  Text(l10n.selectRecipentTypeDetails,
                                      style: AccountStyle.text(context)
                                          .copyWith(
                                              color:
                                                  AccountStyle.muted(context))),
                                  const SizedBox(height: 24),
                                  Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                          color: AppColors.surface(context),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          border: Border.all(
                                              color: AppColors.surfaceBorder(
                                                  context))),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            DropdownButtonFormField<String>(
                                                key: ValueKey(widget.role),
                                                initialValue: widget.role,
                                                isExpanded: true,
                                                isDense: false,
                                                itemHeight: null,
                                                selectedItemBuilder:
                                                    (context) => [
                                                          for (final label in [
                                                            l10n.user,
                                                            l10n.driver
                                                          ])
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .centerStart,
                                                              child: Text(label,
                                                                  style: AccountStyle
                                                                          .text(
                                                                              context)
                                                                      .copyWith(
                                                                          fontSize:
                                                                              16)),
                                                            ),
                                                        ],
                                                style:
                                                    AccountStyle.text(context)
                                                        .copyWith(fontSize: 16),
                                                dropdownColor:
                                                    AppColors.surface(context),
                                                decoration: decoration(null),
                                                items: [
                                                  for (final item in [
                                                    ('user', l10n.user),
                                                    ('driver', l10n.driver)
                                                  ])
                                                    DropdownMenuItem(
                                                        value: item.$1,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8),
                                                            child:
                                                                Text(item.$2)))
                                                ],
                                                onChanged: widget.busy
                                                    ? null
                                                    : (value) {
                                                        if (value != null) {
                                                          widget.onRole(value);
                                                        }
                                                      }),
                                            const SizedBox(height: 18),
                                            TextFormField(
                                                controller:
                                                    widget.phoneController,
                                                enabled: !widget.busy,
                                                textDirection:
                                                    TextDirection.ltr,
                                                textAlign: rtl
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                                keyboardType:
                                                    TextInputType.phone,
                                                textInputAction:
                                                    TextInputAction.next,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9+]'))
                                                ],
                                                style:
                                                    AccountStyle.text(context)
                                                        .copyWith(fontSize: 16),
                                                decoration: decoration(
                                                    l10n.enterMobileNumber,
                                                    icon: const Icon(
                                                        Icons
                                                            .phone_iphone_rounded,
                                                        size: 20)),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return l10n
                                                        .enterMobileNumber;
                                                  }
                                                  if (!RegExp(
                                                          r'^\+?[0-9]{1,15}$')
                                                      .hasMatch(value)) {
                                                    return l10n.validMobile;
                                                  }
                                                  return null;
                                                }),
                                            const SizedBox(height: 18),
                                            TextFormField(
                                                controller:
                                                    widget.amountController,
                                                enabled: !widget.busy,
                                                textDirection:
                                                    TextDirection.ltr,
                                                textAlign: rtl
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                textInputAction:
                                                    TextInputAction.done,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9.]'))
                                                ],
                                                style:
                                                    AccountStyle.text(context)
                                                        .copyWith(fontSize: 16),
                                                decoration: decoration(
                                                    l10n.enterAmountHere,
                                                    prefix:
                                                        '${widget.currency} '),
                                                validator: (value) {
                                                  final amount =
                                                      double.tryParse(
                                                          value ?? '');
                                                  return amount == null ||
                                                          !amount.isFinite ||
                                                          amount <= 0
                                                      ? l10n.enterAmountHere
                                                      : null;
                                                }),
                                          ])),
                                  const SizedBox(height: 16),
                                ])))),
                const SizedBox(height: 12),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: widget.busy
                            ? null
                            : () {
                                if (_form.currentState?.validate() ?? false) {
                                  FocusScope.of(context).unfocus();
                                  widget.onTransfer();
                                }
                              },
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.meshwarRed,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.meshwarRed,
                            disabledForegroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(58),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.busy) ...[
                                const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2)),
                                const SizedBox(width: 10)
                              ],
                              Flexible(
                                  child: Text(l10n.transferMoney,
                                      textAlign: TextAlign.center,
                                      style: AccountStyle.text(context)
                                          .copyWith(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700))),
                            ]))),
                TextButton(
                    onPressed: widget.busy ? null : widget.onClose,
                    style: TextButton.styleFrom(
                        foregroundColor: AccountStyle.muted(context)),
                    child: Text(l10n.cancel,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
