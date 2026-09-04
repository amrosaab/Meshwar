// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';

class SelectGoodsType extends StatelessWidget {
  final BuildContext cont;
  const SelectGoodsType({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.width * 0.15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                              text:
                                  AppLocalizations.of(context)!.selectGoodsType,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: MyText(
                                text: AppLocalizations.of(context)!.cancel,
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.03),
                      SizedBox(
                        height: size.height * 0.73,
                        child: ListView.builder(
                          itemCount:
                              context.read<BookingBloc>().goodsTypeList.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          itemBuilder: (context, index) {
                            final type = context
                                .read<BookingBloc>()
                                .goodsTypeList
                                .elementAt(index);
                            return Theme(
                              data: ThemeData(
                                  unselectedWidgetColor:
                                      Theme.of(context).primaryColorDark),
                              child: RadioListTile(
                                value: type.id,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: Theme.of(context).primaryColorDark,
                                groupValue: context
                                    .read<BookingBloc>()
                                    .selectedGoodsTypeId,
                                onChanged: (int? value) {
                                  debugPrint(value.toString());
                                  context
                                      .read<BookingBloc>()
                                      .selectedGoodsTypeId = value!;
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                },
                                title: MyText(
                                  text: type.goodsTypeName,
                                  maxLines: 2,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: size.width * 0.03),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        spreadRadius: 2,
                        blurRadius: 2,
                        color: Theme.of(context).shadowColor,
                      )
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if ((!context.read<BookingBloc>().isRentalRide)
                          ? context.read<BookingBloc>().isMultiTypeVechiles
                              ? context
                                      .read<BookingBloc>()
                                      .sortedEtaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .iconType
                                      .toLowerCase() !=
                                  'bike'
                              : context
                                      .read<BookingBloc>()
                                      .etaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .iconType
                                      .toLowerCase() !=
                                  'bike'
                          : context
                                  .read<BookingBloc>()
                                  .rentalEtaDetailsList[context
                                      .read<BookingBloc>()
                                      .selectedVehicleIndex]
                                  .icon
                                  .toLowerCase() !=
                              'bike') ...[
                        Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor:
                                        Theme.of(context).primaryColorDark),
                                child: RadioListTile(
                                  value: 'Loose',
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  activeColor:
                                      Theme.of(context).primaryColorDark,
                                  groupValue: context
                                      .read<BookingBloc>()
                                      .goodsTypeQtyOrLoose,
                                  onChanged: (value) {
                                    context
                                        .read<BookingBloc>()
                                        .goodsQtyController
                                        .clear();
                                    context
                                        .read<BookingBloc>()
                                        .goodsTypeQtyOrLoose = value!;
                                    context
                                        .read<BookingBloc>()
                                        .add(UpdateEvent());
                                  },
                                  title: MyText(
                                      text: AppLocalizations.of(context)!.loose,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor:
                                        Theme.of(context).primaryColorDark),
                                child: RadioListTile(
                                  value: 'Qty',
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  activeColor:
                                      Theme.of(context).primaryColorDark,
                                  groupValue: context
                                      .read<BookingBloc>()
                                      .goodsTypeQtyOrLoose,
                                  onChanged: (value) {
                                    context
                                        .read<BookingBloc>()
                                        .goodsTypeQtyOrLoose = value!;
                                    context
                                        .read<BookingBloc>()
                                        .add(UpdateEvent());
                                  },
                                  title: Row(
                                    children: [
                                      MyText(
                                          text:
                                              AppLocalizations.of(context)!.qty,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      SizedBox(width: size.width * 0.02),
                                      Expanded(
                                        child: CustomTextField(
                                          controller: context
                                              .read<BookingBloc>()
                                              .goodsQtyController,
                                          enabled: context
                                                      .read<BookingBloc>()
                                                      .goodsTypeQtyOrLoose ==
                                                  'Qty'
                                              ? true
                                              : false,
                                          filled: true,
                                          hintText: '',
                                          maxLine: 1,
                                          keyboardType: TextInputType.number,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                      SizedBox(height: size.width * 0.03),
                      CustomButton(
                        width: size.width,
                        buttonColor: Theme.of(context).primaryColor,
                        buttonName: AppLocalizations.of(context)!.confirm,
                        onTap: () {
                          if (context.read<BookingBloc>().goodsTypeQtyOrLoose ==
                              'Qty') {
                            if (context
                                .read<BookingBloc>()
                                .goodsQtyController
                                .text
                                .isNotEmpty) {
                              Navigator.pop(context);
                            } else {
                              showToast(
                                  message: AppLocalizations.of(context)!
                                      .pleaseEnterQuantity);
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(height: size.width * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
