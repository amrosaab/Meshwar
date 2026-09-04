// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class WalletTransferMoneyWidget extends StatelessWidget {
  final BuildContext cont;
  const WalletTransferMoneyWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          final accBloc = context.watch<AccBloc>();
          return SafeArea(
            child: Container(
              padding: MediaQuery.viewInsetsOf(context),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * 0.05),
                      topRight: Radius.circular(size.width * 0.05))),
              width: size.width,
              child: Container(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.transferMoney,
                          textStyle:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.02),
                    Text(
                      AppLocalizations.of(context)!.selectRecipentTypeDetails,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: size.width * 0.04),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyHintColor.withOpacity(
                            Theme.of(context).brightness == Brightness.dark
                                ? 0.2
                                : 0.05),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * 0.035,
                          horizontal: size.width * 0.035,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: AppColors.surfaceBorder(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      dropdownColor: AppColors.surfaceStrong(context),
                      value: accBloc.dropdownValue,
                      onChanged: (String? newValue) {
                        context.read<AccBloc>().add(TransferMoneySelectedEvent(
                            selectedTransferAmountMenuItem: newValue!));
                      },
                      items: accBloc.dropdownItems,
                    ),
                    SizedBox(height: size.width * 0.03),
                    TextFormField(
                      controller: accBloc.transferAmount,
                      style: Theme.of(context).textTheme.bodyMedium,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterAmountHere,
                        counterText: '',
                        filled: true,
                        fillColor: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(
                            Theme.of(context).brightness == Brightness.dark
                                ? 0.2
                                : 0.05),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * 0.035,
                          horizontal: size.width * 0.035,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: AppColors.surfaceBorder(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        prefixIcon: Center(
                            child: MyText(
                                text: accBloc.walletResponse!.currencySymbol)),
                        prefixIconConstraints:
                        BoxConstraints(maxWidth: size.width * 0.12),
                      ),
                    ),
                    SizedBox(height: size.width * 0.03),
                    TextFormField(
                      controller: accBloc.transferPhonenumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText:
                        AppLocalizations.of(context)!.enterMobileNumber,
                        counterText: '',
                        filled: true,
                        fillColor: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(
                            Theme.of(context).brightness == Brightness.dark
                                ? 0.2
                                : 0.05),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * 0.035,
                          horizontal: size.width * 0.035,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: AppColors.surfaceBorder(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        prefixIcon: const Center(
                            child: Icon(Icons.phone_android, size: 20)),
                        prefixIconConstraints:
                        BoxConstraints(maxWidth: size.width * 0.12),
                      ),
                    ),
                    SizedBox(height: size.width * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: LiquidGlassContainer(
                            width: size.width * 0.42,
                            height: size.width * 0.12,
                            borderRadius: 8,
                            child: Center(
                              child: MyText(
                                text: AppLocalizations.of(context)!.cancel,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                    color:
                                    Theme.of(context).primaryColorDark),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: accBloc.isLoading
                              ? null
                              : () {
                            if (accBloc.transferAmount.text == '' ||
                                accBloc.transferPhonenumber.text == '') {
                              return;
                            }
                            context.read<AccBloc>().add(
                              MoneyTransferedEvent(
                                transferAmount:
                                accBloc.transferAmount.text,
                                role: accBloc.dropdownValue,
                                transferMobile:
                                accBloc.transferPhonenumber.text,
                              ),
                            );
                            context.read<AccBloc>().add(AccUpdateEvent());
                          },
                          child: Container(
                            height: size.width * 0.12,
                            width: size.width * 0.42,
                            decoration: BoxDecoration(
                                color: accBloc.isLoading
                                    ? AppColors.primary.withOpacity(0.5)
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            child: accBloc.isLoading
                                ? SizedBox(
                              height: size.width * 0.05,
                              width: size.width * 0.05,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white),
                              ),
                            )
                                : MyText(
                              text: AppLocalizations.of(context)!
                                  .transferMoney,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}