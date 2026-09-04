// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';

class AddInstructionWidget extends StatelessWidget {
  const AddInstructionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return SafeArea(
            child: Padding(
          // 👇 THIS PUSHES CONTENT UP WHEN KEYBOARD OPENS
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .shadowColor
                            .withAlpha((0.08 * 255).toInt()),
                        blurRadius: 25,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.width * 0.04),

                      SizedBox(height: size.width * 0.06),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text:
                                  AppLocalizations.of(context)!.addInstructions,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withAlpha((0.15 * 255).toInt()),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: size.width * 0.03),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.07),
                        child: Text(
                          AppLocalizations.of(context)!.addAnyNotesRideSmoother,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                        ),
                      ),

                      SizedBox(height: size.width * 0.06),

                      /// Elevated Text Field Card
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.07),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withAlpha((0.05 * 255).toInt()),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CustomTextField(
                            controller: context
                                .read<BookingBloc>()
                                .instructionsController,
                            borderRadius: 18,
                            filled: true,
                            hintText:
                                '${AppLocalizations.of(context)!.instructions} '
                                '(${AppLocalizations.of(context)!.optional})',
                            maxLine: 3,
                            keyboardType: TextInputType.text,
                            onChange: (_) {
                              context.read<BookingBloc>().add(UpdateEvent());
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: size.width * 0.08),

                      /// Modern Continue Button (Centered Premium Width)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.07),
                        child: GestureDetector(
                          onTap: () {
                            context.read<BookingBloc>().add(UpdateEvent());
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.85),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.continueN,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.width * 0.1),
                    ],
                  ),
                )),
          ),
        ));
      },
    );
  }
}
