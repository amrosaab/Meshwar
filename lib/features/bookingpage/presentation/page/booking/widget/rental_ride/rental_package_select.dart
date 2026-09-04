// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_divider.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';

Widget packageList(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).cardColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).toInt()),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(child: CustomDivider()),
                  SizedBox(height: size.width * 0.05),
                  Row(
                    children: [
                      Icon(
                        Icons.local_taxi,
                        color: Theme.of(context).primaryColor,
                        size: size.width * 0.06,
                      ),
                      SizedBox(width: size.width * 0.02),
                      MyText(
                        text: AppLocalizations.of(context)!.selectPackage,
                        textStyle:
                            Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * 0.04),
                  if (context
                      .read<BookingBloc>()
                      .rentalPackagesList
                      .isNotEmpty) ...[
                    Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.5,
                          child: ListView.separated(
                            itemCount: context
                                .read<BookingBloc>()
                                .rentalPackagesList
                                .length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final package = context
                                  .read<BookingBloc>()
                                  .rentalPackagesList
                                  .elementAt(index);
                              final isSelected = index ==
                                  context
                                      .read<BookingBloc>()
                                      .selectedPackageIndex;

                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  context.read<BookingBloc>().add(
                                      BookingRentalPackageSelectEvent(
                                          selectedPackageIndex: index));
                                },
                                child: Container(
                                  width: size.width * 0.99,
                                  height: size.width * 0.28,
                                  padding: EdgeInsets.all(size.width * 0.03),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isSelected
                                          ? [
                                              Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.07),
                                              Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.02),
                                            ]
                                          : [
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor
                                                  .withOpacity(0.07),
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor
                                                  .withOpacity(0.02),
                                            ],
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                      width: isSelected ? 2 : 0,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withAlpha((0.03 * 255).toInt()),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: size.width * 0.12,
                                            height: size.width * 0.12,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.directions_car,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: size.width * 0.06,
                                            ),
                                          ),
                                          SizedBox(width: size.width * 0.03),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.45,
                                                child: MyText(
                                                  text: package.packageName,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              SizedBox(
                                                  height: size.width * 0.01),
                                              SizedBox(
                                                width: size.width * 0.45,
                                                child: MyText(
                                                  text:
                                                      package.shortDescription,
                                                  maxLines: 2,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Min Price Column
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  MyText(
                                                    text: package.currency
                                                        .toString(),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  MyText(
                                                    text: package.minPrice!
                                                        .toStringAsFixed(1),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          // Vertical Separator Line
                                          Container(
                                            width: 2,
                                            height: 9,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.2),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),

                                          // Max Price Column
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  MyText(
                                                    text: package.currency
                                                        .toString(),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  MyText(
                                                    text: package.maxPrice!
                                                        .toStringAsFixed(1),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: size.width * 0.03);
                            },
                          ),
                        ),
                        SizedBox(height: size.width * 0.2)
                      ],
                    ),
                  ],
                  if (context.read<BookingBloc>().rentalPackagesList.isEmpty)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: size.width * 0.4,
                            child: Icon(
                              Icons.info_outline,
                              size: size.width * 0.2,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          MyText(
                            text: AppLocalizations.of(context)!.noDataAvailable,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 16,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              height: size.width * 0.22,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: size.width * 0.8,
                      height: size.width * 0.12,
                      buttonName: (context
                              .read<BookingBloc>()
                              .rentalPackagesList
                              .isNotEmpty)
                          ? AppLocalizations.of(context)!.continueN
                          : AppLocalizations.of(context)!.backToHome,
                      borderRadius: 12,
                      buttonColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      textSize: 16,
                      onTap: () {
                        if (context
                            .read<BookingBloc>()
                            .rentalPackagesList
                            .isNotEmpty) {
                          context
                              .read<BookingBloc>()
                              .add(RentalPackageConfirmEvent(
                                picklat: context
                                    .read<BookingBloc>()
                                    .pickUpAddressList
                                    .first
                                    .lat
                                    .toString(),
                                picklng: context
                                    .read<BookingBloc>()
                                    .pickUpAddressList
                                    .first
                                    .lng
                                    .toString(),
                              ));
                        } else {
                          context
                              .read<BookingBloc>()
                              .add(BookingNavigatorPopEvent());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  });
}
