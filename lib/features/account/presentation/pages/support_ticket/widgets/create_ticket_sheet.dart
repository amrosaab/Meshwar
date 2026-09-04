// ignore_for_file: deprecated_member_use

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/app_images.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../userprofile/domain/models/service_location_model.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/ticket_names_model.dart';


class CreateTicketSheet extends StatelessWidget {
  final BuildContext cont;
  final List<TicketNamesList> ticketNamesList;
  final String requestId;
  final bool isFromReuest;
  final int? index;
  final int? historyPagenumber;

  const CreateTicketSheet(
      {super.key,
      required this.cont,
      required this.ticketNamesList,
      required this.requestId,
      required this.isFromReuest,
      this.index,
      this.historyPagenumber});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          final accBloc = context.read<AccBloc>();
          ServiceLocationData? selectedValue;
          TicketNamesList? selectedTitle;
          try {
            selectedValue = accBloc.serviceLocations.firstWhere(
              (e) => e.name == accBloc.selectedTicketArea,
            );
          } catch (_) {
            selectedValue = null;
          }

          try {
            selectedTitle = ticketNamesList
                .firstWhere((e) => e.title == accBloc.selectedTicketTitle);
          } catch (_) {
            selectedTitle = null;
          }
          return SafeArea(
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: size.width * 0.04,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: SizedBox(
                        width: size.width * 0.8,
                        child: MyText(
                          text: AppLocalizations.of(context)!.createTicket,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w600),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Container(
                      height: size.width * 0.005,
                      width: size.width,
                      color: AppColors.borderColors,
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: Column(
                        children: [
                          Row(children: [
                            MyText(
                              text: AppLocalizations.of(context)!.title,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold),
                            ),
                            MyText(
                              text: '*',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold),
                            ),
                          ]),
                          SizedBox(height: size.width * 0.01),
                          DropdownButtonFormField<TicketNamesList>(
                            focusColor: AppColors.borderColors,
                            dropdownColor: AppColors.borderColors,
                            value: selectedTitle,
                            items: ticketNamesList
                                .map((e) => DropdownMenuItem<TicketNamesList>(
                                      value: e,
                                      child: SizedBox(
                                        width: size.width * 0.75,
                                        child: MyText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: e.title,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (selected) {
                              if (selected != null) {
                                context.read<AccBloc>().add(
                                      TicketTitleChangeEvent(
                                        changedTitle: selected.title,
                                        id: selected.id,
                                      ),
                                    );
                              }
                            },
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.selectTitle,
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: AppColors.borderColors,
                                width: 1.2,
                                style: BorderStyle.solid,
                              )),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: AppColors.borderColors,
                                width: 1.2,
                                style: BorderStyle.solid,
                              )),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          Row(children: [
                            MyText(
                              text: AppLocalizations.of(context)!.selectArea,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold),
                            ),
                            MyText(
                              text: '*',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold),
                            ),
                          ]),
                          SizedBox(
                            height: size.width * 0.01,
                          ),
                          DropdownButtonFormField<ServiceLocationData>(
                            focusColor: AppColors.borderColors,
                            dropdownColor: AppColors.borderColors,
                            value: selectedValue,
                            items: context.read<AccBloc>().serviceLocations.map(
                              (e) {
                                return DropdownMenuItem<ServiceLocationData>(
                                  value: e,
                                  child: MyText(text: e.name),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<AccBloc>().add(
                                      TicketAreaChangeEvent(
                                        changedArea: value.name,
                                        id: value.id,
                                      ),
                                    );
                              }
                            },
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.selectArea,
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderColors,
                                  width: 1.2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderColors,
                                  width: 1.2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.width * 0.05,
                          ),
                          Row(children: [
                            MyText(
                              text: AppLocalizations.of(context)!.description,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold),
                            ),
                            MyText(
                              text: '*',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold),
                            ),
                          ]),
                          SizedBox(
                            height: size.width * 0.01,
                          ),
                          CustomTextField(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            controller: context
                                .read<AccBloc>()
                                .supportDescriptionController,
                            hintText:
                                AppLocalizations.of(context)!.enterDescription,
                            maxLine: 4,
                            hintTextStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColorDark),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.borderColors, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.borderColors, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.borderColors, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          SizedBox(
                            height: size.width * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: AppLocalizations.of(context)!.attachments,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold),
                              ),
                              if (context
                                  .read<AccBloc>()
                                  .ticketAttachments
                                  .isNotEmpty)
                                InkWell(
                                  onTap: () {
                                    context.read<AccBloc>().add(
                                        AddAttachmentTicketEvent(
                                            context: context));
                                  },
                                  child: MyText(
                                    text:
                                        "+ ${AppLocalizations.of(context)!.addMore}",
                                    textStyle: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            height: size.width * 0.025,
                          ),
                          InkWell(
                            onTap: context
                                        .read<AccBloc>()
                                        .ticketAttachments
                                        .length ==
                                    1
                                ? null
                                : () {
                                    context.read<AccBloc>().add(
                                        AddAttachmentTicketEvent(
                                            context: context));
                                  },
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: size.width,
                                  child: DottedBorder(
                                   options: RectDottedBorderOptions(
                                     color: AppColors.borderColors,
                                     strokeWidth: 2,
                                     dashPattern: const [6, 3],

                                   ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(size.width * 0.025),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppImages.upload,
                                              fit: BoxFit.contain,
                                              width: size.width * 0.05,
                                            ),
                                            const SizedBox(width: 10),
                                            context
                                                    .read<AccBloc>()
                                                    .ticketAttachments
                                                    .isEmpty
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      MyText(
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .uploadMaxFile,
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark),
                                                      ),
                                                      MyText(
                                                        text:
                                                            "(png,jpg,jpeg,pdf,doc)",
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor),
                                                      ),
                                                    ],
                                                  )
                                                : MyText(
                                                    text:
                                                        '${context.read<AccBloc>().ticketAttachments.length} ${AppLocalizations.of(context)!.filesUploaded}',
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (context
                                    .read<AccBloc>()
                                    .ticketAttachments
                                    .isNotEmpty)
                                  Positioned(
                                    right: 8,
                                    top: 12,
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<AccBloc>()
                                            .add(ClearAttachmentEvent());
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          Center(
                            child: CustomButton(
                              buttonName:
                                  AppLocalizations.of(context)!.createTicket,
                              width: size.width,
                              textSize: 18,
                              onTap: () {
                                if ((context
                                                .read<AccBloc>()
                                                .selectedTicketTitleId !=
                                            null &&
                                        context
                                            .read<AccBloc>()
                                            .selectedTicketTitleId!
                                            .isNotEmpty) &&
                                    (context
                                                .read<AccBloc>()
                                                .selectedTicketAreaId !=
                                            null &&
                                        context
                                            .read<AccBloc>()
                                            .selectedTicketAreaId!
                                            .isNotEmpty) &&
                                    context
                                        .read<AccBloc>()
                                        .supportDescriptionController
                                        .text
                                        .isNotEmpty) {
                                  context.read<AccBloc>().add(
                                        MakeTicketSubmitEvent(
                                            description: context
                                                .read<AccBloc>()
                                                .supportDescriptionController
                                                .text,
                                            titleId: context
                                                .read<AccBloc>()
                                                .selectedTicketTitleId!,
                                            serviceLocationId: context
                                                .read<AccBloc>()
                                                .selectedTicketAreaId!,
                                            attachement: context
                                                .read<AccBloc>()
                                                .ticketAttachments,
                                            requestId: requestId,
                                            isFromRequest: isFromReuest,
                                            index: index,
                                            pageNumber: historyPagenumber),
                                      );
                                  Navigator.pop(context, true);
                                } else {
                                  showToast(
                                      message: AppLocalizations.of(context)!
                                          .fillTheRequiredField);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
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
