import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshwar_user/features/userprofile/application/usecases/driver_profile_usecase.dart';

import '../../../common/common.dart';
import '../../../core/utils/crop_image_custom.dart';
import '../../../di/locator.dart';
import '../../home/application/usecase/home_usecases.dart';
import '../../home/domain/models/user_details_model.dart';
import '../domain/models/needed_documents_model.dart';

part 'driver_profile_event.dart';
part 'driver_profile_state.dart';

/// User-app document verification flow (needed documents + upload).
/// Note: file names still say "driver" due to legacy copy; driver-specific
/// paths/logic have been removed.
class DriverProfileBloc extends Bloc<DriverProfileEvent, DriverProfileState> {
  DriverProfileBloc() : super(DriverProfileInitialState()) {
    on<DriverUpdateEvent>((event, emit) => emit(DriverUpdateState()));
    on<GetNeededDocumentsEvent>(getDocuments);
    on<ChooseDocumentEvent>(chooseDocument);
    on<PickImageEvent>(getDocImage);
    on<ChooseDateEvent>(pickDate);
    on<UploadDocumentEvent>(uploadDocument);
    on<EnableEditEvent>(enableEditingDocument);
    on<DriverGetUserDetailsEvent>(getUserDetails);
    on<StartApprovalWatchEvent>(startApprovalWatch);
  }

  final ImagePicker picker = ImagePicker();

  List<NeededDocumentsData> neededDocuments = [];
  bool showSubmitButton = false;

  String? choosenDocument;
  bool isEditable = false;

  final TextEditingController documentId = TextEditingController();
  final TextEditingController documentExpiry = TextEditingController();

  String? docImage;
  String? docImageBack;

  bool approved = false;
  StreamSubscription? approvalStream;

  bool uploadDocs = false;

  FutureOr<void> getDocuments(
      GetNeededDocumentsEvent event, Emitter<DriverProfileState> emit) async {
    emit(LoadingStartState());
    final result = await serviceLocator<DriverProfileUsecase>().getDocuments();
    result.fold(
      (error) => emit(ShowErrorState(message: error.message.toString())),
      (success) {
        neededDocuments = success.data;
        showSubmitButton = success.enableSubmitButton;
      },
    );
    emit(LoadingStopState());
  }

  Future<void> chooseDocument(
      ChooseDocumentEvent event, Emitter<DriverProfileState> emit) async {
    documentId.clear();
    documentExpiry.clear();
    docImage = null;
    docImageBack = null;

    if (event.id == null) {
      isEditable = false;
      choosenDocument = null;
    } else {
      choosenDocument = event.id;
    }
    emit(PageChangeState());
  }

  Future<void> uploadDocument(
      UploadDocumentEvent event, Emitter<DriverProfileState> emit) async {
    if (docImage == null || docImage!.isEmpty) {
      emit(ShowErrorState(message: 'Please select a document image'));
      return;
    }

    emit(LoadingStartState());
    final result = await serviceLocator<DriverProfileUsecase>().uploadDocuments(
      id: event.id,
      identifyNumber: documentId.text.isNotEmpty ? documentId.text : null,
      expiryDate: documentExpiry.text.isNotEmpty
          ? "${documentExpiry.text} 00:00:00"
          : null,
      document: docImage!,
      documentBack: docImageBack,
    );

    result.fold(
      (error) => emit(ShowErrorState(message: error.message.toString())),
      (success) {
        choosenDocument = null;
        docImage = null;
        docImageBack = null;
        documentId.clear();
        documentExpiry.clear();

        add(GetNeededDocumentsEvent(initialCall: false));
        add(DriverGetUserDetailsEvent());
      },
    );

    emit(LoadingStopState());
  }

  Future<void> getDocImage(
      PickImageEvent event, Emitter<DriverProfileState> emit) async {
    final XFile? image = await picker.pickImage(source: event.source);
    if (image == null) return;

    CroppedFile? croppedImage;
    try {
      croppedImage =
          await ImageCropper().cropImage(sourcePath: image.path, uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.primary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          minimumAspectRatio: 1.0,
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
      ]);
    } catch (e) {
      if (event.isFront) {
        docImage = image.path;
      } else {
        docImageBack = image.path;
      }
      emit(ShowErrorState(message: e.toString()));
      emit(DriverUpdateState());
      return;
    }

    if (croppedImage == null) return;
    if (event.isFront) {
      docImage = croppedImage.path;
    } else {
      docImageBack = croppedImage.path;
    }
    emit(DriverUpdateState());
  }

  FutureOr<void> pickDate(
      ChooseDateEvent event, Emitter<DriverProfileState> emit) async {
    final DateTime? picked = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    documentExpiry.text = picked != null ? picked.toString().split(' ')[0] : '';
    emit(DriverUpdateState());
  }

  FutureOr<void> enableEditingDocument(
      EnableEditEvent event, Emitter<DriverProfileState> emit) {
    isEditable = event.isEditable;
    emit(EnableEditState(isEditable: isEditable));
  }

  FutureOr<void> getUserDetails(
      DriverGetUserDetailsEvent event, Emitter<DriverProfileState> emit) async {
    final result = await serviceLocator<HomeUsecase>().userDetails();
    await result.fold(
      (error) {
        if (error.statusCode == 401) {
          AppSharedPreference.clear();
        } else {
          emit(ShowErrorState(message: error.message.toString()));
        }
      },
      (success) async {
        userData = success.data;
        approved = (userData?.approve ?? 0) != 0;
        emit(DriverUpdateState());
      },
    );
  }

  FutureOr<void> startApprovalWatch(
      StartApprovalWatchEvent event, Emitter<DriverProfileState> emit) {
    if (approvalStream != null) {
      return Future.value();
    }

    approvalStream = Stream<void>.periodic(event.interval).listen((_) {
      if (isClosed) return;
      add(DriverGetUserDetailsEvent());
      if (approved) {
        approvalStream?.cancel();
        approvalStream = null;
      }
    });
  }

  @override
  Future<void> close() {
    approvalStream?.cancel();
    documentId.dispose();
    documentExpiry.dispose();
    return super.close();
  }
}
