import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/payment_received_stream.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';

class AddTipWidget extends StatefulWidget {
  final BuildContext cont;
  final String requestId;
  final String currencySymbol;
  final String totalAmount;
  final String minimumTipAmount;
  final RideRepository rideRepository;
  const AddTipWidget(
      {super.key,
      required this.cont,
      required this.requestId,
      required this.currencySymbol,
      required this.totalAmount,
      required this.minimumTipAmount,
      required this.rideRepository});

  @override
  State<AddTipWidget> createState() => _AddTipWidgetState();
}

class _AddTipWidgetState extends State<AddTipWidget> {
  late final StreamSubscription<bool> _paymentSubscription;

  @override
  void initState() {
    super.initState();
    _paymentSubscription =
        widget.rideRepository.paymentReceivedStream.listen((isReceived) {
      if (isReceived && mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _paymentSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder<bool>(
        stream: widget.rideRepository.paymentReceivedStream,
        builder: (context, snapshot) {
          bool isPaymentReceived = snapshot.data ?? false;

          if (isPaymentReceived) {
            Future.microtask(() {
              if (context.mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          }
          return BlocProvider.value(
              value: widget.cont.read<BookingBloc>(),
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: size.width * 0.9,
                            height: size.width * 0.8,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withAlpha((0.13 * 255).toInt()),
                                      spreadRadius: 25,
                                      blurRadius: 50)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyText(
                                      text:
                                          '${AppLocalizations.of(context)!.tripFare}  ${widget.currencySymbol}${widget.totalAmount}',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  SizedBox(height: size.width * 0.02),
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .showAppreciationTip,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Container(
                                    height: size.width * 0.128,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1.2,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: size.width * 0.15,
                                          height: size.width * 0.128,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withAlpha((0.1 * 255).toInt()),
                                          ),
                                          alignment: Alignment.center,
                                          child: MyText(
                                              text: widget.currencySymbol),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.05,
                                        ),
                                        Container(
                                          height: size.width * 0.128,
                                          width: size.width * 0.6,
                                          alignment: Alignment.center,
                                          child: TextField(
                                            controller: context
                                                .read<BookingBloc>()
                                                .addTIPController,
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                context
                                                        .read<BookingBloc>()
                                                        .addTip =
                                                    double.parse(value);
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .enterAmountHere,
                                              hintStyle:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            maxLines: 1,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          context
                                              .read<BookingBloc>()
                                              .addTIPController
                                              .text = double.parse(
                                                  widget.minimumTipAmount)
                                              .toString();
                                          context.read<BookingBloc>().addTip =
                                              double.parse(
                                                  widget.minimumTipAmount);
                                        },
                                        child: Container(
                                          height: size.width * 0.08,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  width: 1.2),
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: MyText(
                                                text:
                                                    '${widget.currencySymbol} ${widget.minimumTipAmount}'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.05),
                                      InkWell(
                                        onTap: () {
                                          context
                                              .read<BookingBloc>()
                                              .addTIPController
                                              .text = (double.parse(
                                                      widget.minimumTipAmount) *
                                                  2)
                                              .toString();
                                          context.read<BookingBloc>().addTip =
                                              double.parse(
                                                      widget.minimumTipAmount) *
                                                  2;
                                        },
                                        child: Container(
                                          height: size.width * 0.08,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  width: 1.2),
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: MyText(
                                                text:
                                                    '${widget.currencySymbol} ${double.parse(widget.minimumTipAmount) * 2}'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.05),
                                      InkWell(
                                        onTap: () {
                                          context
                                              .read<BookingBloc>()
                                              .addTIPController
                                              .text = (double.parse(
                                                      widget.minimumTipAmount) *
                                                  3)
                                              .toString();
                                          context.read<BookingBloc>().addTip =
                                              double.parse(
                                                      widget.minimumTipAmount) *
                                                  3;
                                        },
                                        child: Container(
                                          height: size.width * 0.08,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  width: 1.2),
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: MyText(
                                                text:
                                                    '${widget.currencySymbol} ${double.parse(widget.minimumTipAmount) * 3}'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButton(
                                        width: size.width * 0.38,
                                        height: size.width * 0.12,
                                        buttonName:
                                            AppLocalizations.of(context)!.skip,
                                        isBorder: true,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        textSize: 14,
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        buttonColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      CustomButton(
                                        width: size.width * 0.38,
                                        height: size.width * 0.12,
                                        textSize: 14,
                                        buttonName:
                                            AppLocalizations.of(context)!
                                                .addTip,
                                        onTap: () {
                                          if (context
                                              .read<BookingBloc>()
                                              .addTIPController
                                              .text
                                              .isNotEmpty) {
                                            Navigator.pop(context);
                                            context.read<BookingBloc>().add(
                                                AddTipsEvent(
                                                    requestId: widget.requestId,
                                                    amount: context
                                                        .read<BookingBloc>()
                                                        .addTIPController
                                                        .text));
                                          } else {
                                            showToast(
                                                message: AppLocalizations.of(
                                                        context)!
                                                    .addTipError);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
        });
  }
}
