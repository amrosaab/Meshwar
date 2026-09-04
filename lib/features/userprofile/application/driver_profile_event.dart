part of 'driver_profile_bloc.dart';

abstract class DriverProfileEvent {}

class DriverUpdateEvent extends DriverProfileEvent {}

class GetNeededDocumentsEvent extends DriverProfileEvent {
  final bool initialCall;
  GetNeededDocumentsEvent({required this.initialCall});
}

class ChooseDocumentEvent extends DriverProfileEvent {
  final String? id;
  ChooseDocumentEvent({required this.id});
}

class PickImageEvent extends DriverProfileEvent {
  final ImageSource source;
  final bool isFront;
  PickImageEvent({required this.source, required this.isFront});
}

class ChooseDateEvent extends DriverProfileEvent {
  final BuildContext context;
  ChooseDateEvent({required this.context});
}

class UploadDocumentEvent extends DriverProfileEvent {
  final String id;
  UploadDocumentEvent({required this.id});
}

class EnableEditEvent extends DriverProfileEvent {
  final bool isEditable;

  EnableEditEvent({required this.isEditable});
}

class DriverGetUserDetailsEvent extends DriverProfileEvent {
  DriverGetUserDetailsEvent();
}

class StartApprovalWatchEvent extends DriverProfileEvent {
  final Duration interval;

  StartApprovalWatchEvent({this.interval = const Duration(seconds: 10)});
}
