part of 'loader_bloc.dart';

abstract class LoaderEvent {}

class LoaderInitEvent extends LoaderEvent {}

class LoaderGetLocalDataEvent extends LoaderEvent {}

class UpdateUserLocationEvent extends LoaderEvent {}

class GoogleUpdateUserLocationEvent extends LoaderEvent {}
