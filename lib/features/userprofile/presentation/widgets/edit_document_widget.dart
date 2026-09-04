import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/app_colors.dart';
import '../../../../core/network/extensions.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/driver_profile_bloc.dart';
import 'image_picker_dialog.dart';


class EditDocumentWidget extends StatelessWidget {
  final BuildContext cont;
  const EditDocumentWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<DriverProfileBloc>(),
      child: BlocBuilder<DriverProfileBloc, DriverProfileState>(
        builder: (context, state) {
          final driverBloc = context.read<DriverProfileBloc>();
          return driverBloc.neededDocuments.isEmpty
              ? const SizedBox()
              : SafeArea(
                  child: Container(
                    padding: EdgeInsets.only(bottom: size.width * 0.05),
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
                                    final upload = driverBloc.neededDocuments
                                        .firstWhere((e) =>
                                            e.id == driverBloc.choosenDocument)
                                        .isUploaded;

                                    if ((upload)) {
                                      driverBloc.add(
                                          EnableEditEvent(isEditable: false));
                                    } else {
                                      driverBloc
                                          .add(ChooseDocumentEvent(id: null));
                                    }
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: size.width * 0.07,
                                    color: Theme.of(context).primaryColorDark,
                                  )),
                              MyText(
                                text:
                                    'Upload ${driverBloc.neededDocuments.firstWhere((e) => e.id == driverBloc.choosenDocument).name}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                              ),
                              const MyText(text: '')
                            ],
                          ),
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(size.width * 0.05),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (driverBloc.neededDocuments
                                                .firstWhere((e) =>
                                                    e.id ==
                                                    driverBloc.choosenDocument)
                                                .isEditable ==
                                            true ||
                                        driverBloc.isEditable) {
                                      showModalBottomSheet(
                                          isScrollControlled: false,
                                          context: context,
                                          useSafeArea: true,
                                          builder: (_) {
                                            return SafeArea(
                                              child: ImagePickerDialog(
                                                size: size.width,
                                                onImageSelected:
                                                    (ImageSource source) {
                                                  driverBloc.add(
                                                    PickImageEvent(
                                                        source: source,
                                                        isFront: true),
                                                  );
                                                },
                                              ),
                                            );
                                          });
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        text: driverBloc.neededDocuments
                                                    .firstWhere((e) =>
                                                        e.id ==
                                                        driverBloc
                                                            .choosenDocument)
                                                    .isFrontAndBack ==
                                                true
                                            ? '${driverBloc.neededDocuments.firstWhere((e) => e.id == driverBloc.choosenDocument).name} Front'
                                            : driverBloc.neededDocuments
                                                .firstWhere((e) =>
                                                    e.id ==
                                                    driverBloc.choosenDocument)
                                                .name,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                      ),
                                      SizedBox(height: size.width * 0.025),
                                      SizedBox(
                                        height: size.width * 0.5,
                                        width: size.width * 0.9,
                                        child: DottedBorder(
                                          options: const RectDottedBorderOptions(
                                            color: AppColors.darkGrey,
                                            strokeWidth: 2,
                                            dashPattern: [6, 3],
                                            // radius: const Radius.circular(5),
                                          ),

                                          child: (driverBloc.docImage == null)
                                              ? Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        size: size.width * 0.07,
                                                      ),
                                                      SizedBox(
                                                          height: size.width *
                                                              0.025),
                                                      MyText(
                                                        text: AppLocalizations
                                                                .of(context)!
                                                            .tapToUploadImage,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontSize: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  height: size.width * 0.5,
                                                  width: size.width * 0.9,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        File(driverBloc
                                                            .docImage!),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5), // Matching borderRadius
                                                  ),
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.025,
                                ),
                                SizedBox(
                                  height: driverBloc.neededDocuments
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  driverBloc.choosenDocument)
                                              .isFrontAndBack ==
                                          true
                                      ? size.width * 0.05
                                      : size.width * 0,
                                ),
                                driverBloc.neededDocuments
                                            .firstWhere((e) =>
                                                e.id ==
                                                driverBloc.choosenDocument)
                                            .isFrontAndBack ==
                                        true
                                    ? InkWell(
                                        onTap: () {
                                          if (driverBloc.neededDocuments
                                                      .firstWhere((e) =>
                                                          e.id ==
                                                          driverBloc
                                                              .choosenDocument)
                                                      .isEditable ==
                                                  true ||
                                              driverBloc.isEditable) {
                                            showModalBottomSheet(
                                                isScrollControlled: false,
                                                context: context,
                                                useSafeArea: true,
                                                builder: (builder) {
                                                  return ImagePickerDialog(
                                                    size: size.width,
                                                    onImageSelected:
                                                        (ImageSource source) {
                                                      driverBloc.add(
                                                        PickImageEvent(
                                                            source: source,
                                                            isFront: false),
                                                      );
                                                    },
                                                  );
                                                });
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text:
                                                  '${driverBloc.neededDocuments.firstWhere((e) => e.id == driverBloc.choosenDocument).name} Back',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                  ),
                                            ),
                                            SizedBox(
                                                height: size.width * 0.025),
                                            SizedBox(
                                              height: size.width * 0.5,
                                              width: size.width * 0.9,
                                              child: DottedBorder(
                                              options: RectDottedBorderOptions(
                                                color: AppColors.darkGrey,
                                                strokeWidth: 2,
                                                dashPattern: const [6, 3],

                                              ),
                                                child: (driverBloc
                                                            .docImageBack ==
                                                        null)
                                                    ? Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.camera_alt,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                              size: size.width *
                                                                  0.07,
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    size.width *
                                                                        0.025),
                                                            MyText(
                                                              text: AppLocalizations
                                                                      .of(context)!
                                                                  .tapToUploadImage,
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        15,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .hintColor,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        height:
                                                            size.width * 0.5,
                                                        width: size.width * 0.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: FileImage(
                                                              File(driverBloc
                                                                  .docImageBack!),
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                if (driverBloc.neededDocuments
                                    .firstWhere((e) =>
                                        e.id == driverBloc.choosenDocument)
                                    .hasIdNumer)
                                  Column(
                                    children: [
                                      SizedBox(height: size.width * 0.07),
                                      SizedBox(
                                        width: size.width * 0.9,
                                        child: MyText(
                                          text: driverBloc.neededDocuments
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  driverBloc.choosenDocument)
                                              .idKey,
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
                                      CustomTextField(
                                        controller: driverBloc.documentId,
                                        contentPadding:
                                            EdgeInsets.all(size.width * 0.025),
                                        filled: true,
                                        borderRadius: 10,
                                        hintText: driverBloc.neededDocuments
                                            .firstWhere((e) =>
                                                e.id ==
                                                driverBloc.choosenDocument)
                                            .idKey,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.borderColors,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.borderColors,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ],
                                  ),
                                if (driverBloc.neededDocuments
                                    .firstWhere((e) =>
                                        e.id == driverBloc.choosenDocument)
                                    .hasExpiryDate)
                                  Column(
                                    children: [
                                      SizedBox(height: size.width * 0.07),
                                      SizedBox(
                                        width: size.width * 0.9,
                                        child: MyText(
                                          text: 'Choose expiry date',
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
                                        onTap: () {
                                          driverBloc.add(ChooseDateEvent(
                                              context: context));
                                        },
                                        child: CustomTextField(
                                          controller: driverBloc.documentExpiry,
                                          contentPadding: EdgeInsets.all(
                                              size.width * 0.025),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              ),
                                          filled: true,
                                          borderRadius: 10,
                                          hintText:
                                              '${driverBloc.neededDocuments.firstWhere((e) => e.id == driverBloc.choosenDocument).name} ${AppLocalizations.of(context)!.expiryDate}',
                                          enabled: false,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.borderColors,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.borderColors,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.borderColors,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                SizedBox(height: size.width * 0.05),
                              ],
                            ),
                          ),
                        )),
                        CustomButton(
                            buttonName: AppLocalizations.of(context)!.submit,
                            width: size.width * 0.9,
                            textSize: 18,
                            onTap: () {
                              if (driverBloc.docImage != null &&
                                  (driverBloc.neededDocuments
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  driverBloc.choosenDocument)
                                              .hasExpiryDate ==
                                          false ||
                                      driverBloc
                                          .documentExpiry.text.isNotEmpty) &&
                                  (driverBloc.neededDocuments
                                              .firstWhere((e) =>
                                                  e.id ==
                                                  driverBloc.choosenDocument)
                                              .hasIdNumer ==
                                          false ||
                                      driverBloc.documentId.text.isNotEmpty)) {
                                driverBloc.uploadDocs = true;
                                driverBloc.add(UploadDocumentEvent(
                                    id: driverBloc.choosenDocument!));
                              } else {
                                context.showSnackBar(
                                    color: AppColors.red,
                                    message: 'Enter required field');
                              }
                            })
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
