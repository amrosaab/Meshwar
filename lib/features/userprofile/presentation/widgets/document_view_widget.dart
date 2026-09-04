import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/driver_profile_bloc.dart';


class DocumentViewWidget extends StatelessWidget {
  final BuildContext cont;
  const DocumentViewWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<DriverProfileBloc>(),
      child: BlocBuilder<DriverProfileBloc, DriverProfileState>(
        builder: (context, state) {
          return context.read<DriverProfileBloc>().neededDocuments.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.paddingOf(context).top +
                              size.width * 0.05),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: size.width * 0.025,
                            left: size.width * 0.025,
                            right: size.width * 0.025), // space above border
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors
                                  .borderColors, // your underline color
                              width: 1, // thickness
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  context
                                      .read<DriverProfileBloc>()
                                      .add(ChooseDocumentEvent(id: null));
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: size.width * 0.07,
                                  color: Theme.of(context).hintColor,
                                )),
                            SizedBox(width: size.width * 0.05),
                            Expanded(
                              child: Center(
                                child: MyText(
                                  text: context
                                      .read<DriverProfileBloc>()
                                      .neededDocuments
                                      .firstWhere((e) =>
                                          e.id ==
                                          context
                                              .read<DriverProfileBloc>()
                                              .choosenDocument)
                                      .name,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 20,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Opacity(
                              opacity: 0,
                              child: Icon(
                                Icons.arrow_back,
                                size: size.width * 0.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: size.width * 0.1),
                              Container(
                                height: size.width * 0.5,
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppColors.darkGrey),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        context
                                            .read<DriverProfileBloc>()
                                            .neededDocuments
                                            .firstWhere((e) =>
                                                e.id ==
                                                context
                                                    .read<DriverProfileBloc>()
                                                    .choosenDocument)
                                            .document!['data']['document'],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(
                                height: context
                                            .read<DriverProfileBloc>()
                                            .neededDocuments
                                            .firstWhere((e) =>
                                                e.id ==
                                                context
                                                    .read<DriverProfileBloc>()
                                                    .choosenDocument)
                                            .isFrontAndBack ==
                                        true
                                    ? size.width * 0.05
                                    : size.width * 0,
                              ),
                              (context
                                              .read<DriverProfileBloc>()
                                              .neededDocuments
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  context
                                                      .read<DriverProfileBloc>()
                                                      .choosenDocument)
                                              .isFrontAndBack ==
                                          true &&
                                      context
                                              .read<DriverProfileBloc>()
                                              .neededDocuments
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  context
                                                      .read<DriverProfileBloc>()
                                                      .choosenDocument)
                                              .document!['data']['back_document'] !=
                                          null)
                                  ? Container(
                                      height: size.width * 0.5,
                                      width: size.width * 0.9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppColors.darkGrey),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              context
                                                      .read<DriverProfileBloc>()
                                                      .neededDocuments
                                                      .firstWhere((e) =>
                                                          e.id ==
                                                          context
                                                              .read<
                                                                  DriverProfileBloc>()
                                                              .choosenDocument)
                                                      .document!['data']
                                                  ['back_document'],
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : const SizedBox(),
                              if (context
                                  .read<DriverProfileBloc>()
                                  .neededDocuments
                                  .firstWhere((e) =>
                                      e.id ==
                                      context
                                          .read<DriverProfileBloc>()
                                          .choosenDocument)
                                  .hasIdNumer)
                                Column(
                                  children: [
                                    SizedBox(height: size.width * 0.07),
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: MyText(
                                        text: AppLocalizations.of(context)!
                                            .yourId,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: size.width * 0.025),
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: CustomTextField(
                                        readOnly: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                        hintTextStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 16,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                        contentPadding:
                                            EdgeInsets.all(size.width * 0.025),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.borderColors,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.borderColors,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.borderColors,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: context
                                            .read<DriverProfileBloc>()
                                            .neededDocuments
                                            .firstWhere((e) =>
                                                e.id ==
                                                context
                                                    .read<DriverProfileBloc>()
                                                    .choosenDocument)
                                            .document!['data']
                                                ['identify_number']
                                            .toString(),
                                        controller: context
                                            .read<DriverProfileBloc>()
                                            .documentId,
                                      ),
                                    )
                                  ],
                                ),
                              if (context
                                  .read<DriverProfileBloc>()
                                  .neededDocuments
                                  .firstWhere((e) =>
                                      e.id ==
                                      context
                                          .read<DriverProfileBloc>()
                                          .choosenDocument)
                                  .hasExpiryDate)
                                Column(
                                  children: [
                                    SizedBox(height: size.width * 0.07),
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: MyText(
                                        text: AppLocalizations.of(context)!
                                            .expiryDate,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: size.width * 0.025),
                                    InkWell(
                                      child: SizedBox(
                                        width: size.width * 0.9,
                                        child: CustomTextField(
                                          readOnly: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              ),
                                          hintTextStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 16,
                                                color: AppColors.black,
                                              ),
                                          enabled: false,
                                          contentPadding: EdgeInsets.all(
                                              size.width * 0.025),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.borderColors,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.borderColors,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.borderColors,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: context
                                              .read<DriverProfileBloc>()
                                              .neededDocuments
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  context
                                                      .read<DriverProfileBloc>()
                                                      .choosenDocument)
                                              .document!['data']['expiry_date']
                                              .toString(),
                                          controller: context
                                              .read<DriverProfileBloc>()
                                              .documentId,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              SizedBox(
                                height: size.width * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (context
                          .read<DriverProfileBloc>()
                          .neededDocuments
                          .firstWhere((e) =>
                              e.id ==
                              context.read<DriverProfileBloc>().choosenDocument)
                          .isEditable)
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.025),
                          child: CustomButton(
                              buttonName: AppLocalizations.of(context)!.edit,
                              width: size.width,
                              textSize: 18,
                              onTap: () {
                                context
                                    .read<DriverProfileBloc>()
                                    .add(EnableEditEvent(isEditable: true));
                              }),
                        )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
