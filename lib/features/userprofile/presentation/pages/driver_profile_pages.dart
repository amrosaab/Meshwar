import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import 'package:restart_tagxi/core/utils/custom_text.dart';



import '../../../../common/app_arguments.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../common/custom_header.dart';
import '../../../../core/network/extensions.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/driver_profile_bloc.dart';
import '../widgets/document_view_widget.dart';
import '../widgets/edit_document_widget.dart';
import '../widgets/needed_documents_shimmer.dart';
import '../widgets/needed_documents_widget.dart';

class DriverProfilePage extends StatefulWidget {
  static const String routeName = '/driverProfilePage';

  const DriverProfilePage({super.key});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}
//
class _DriverProfilePageState extends State<DriverProfilePage> {
  bool _isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_isLoaderShowing) {
      CustomLoader.dismiss(context);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final from = (ModalRoute.of(context)?.settings.arguments
                as DriverProfilePageArguments?)
            ?.from ??
        'onboarding';
    return BlocProvider(
      create: (context) => DriverProfileBloc()
        ..add(DriverGetUserDetailsEvent())
        ..add(GetNeededDocumentsEvent(initialCall: true))
        ..add(StartApprovalWatchEvent()),
      child: BlocListener<DriverProfileBloc, DriverProfileState>(
        listener: (context, state) async {
          final bloc = context.read<DriverProfileBloc>();
          if (state is LoadingStartState) {
            if (!_isLoaderShowing && bloc.neededDocuments.isNotEmpty) {
              _isLoaderShowing = true;
              CustomLoader.loader(context).then((value) {
                _isLoaderShowing = false;
              });
            }
          } else if (state is LoadingStopState) {
            if (_isLoaderShowing) {
              _isLoaderShowing = false;
              CustomLoader.dismiss(context);
            }
          } else if (state is ShowErrorState) {
            context.showSnackBar(color: AppColors.red, message: state.message);
          }

          // final bloc = context.read<DriverProfileBloc>();
          if (bloc.approved && context.mounted) {
            bloc.approvalStream?.cancel();
            bloc.approvalStream = null;
            if (from != 'account') {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          }
        },
        child: BlocBuilder<DriverProfileBloc, DriverProfileState>(
          builder: (context, state) {
            final bloc = context.read<DriverProfileBloc>();

            if (bloc.choosenDocument != null) {
              return SafeArea(
                child: Scaffold(
                  body: bloc.isEditable
                      ? EditDocumentWidget(cont: context)
                      : DocumentViewWidget(cont: context),
                ),
              );
            }

            return SafeArea(
              child: Scaffold(
                appBar: CustomHeader(
                  title: AppLocalizations.of(context)!.uploadDocument,
                  automaticallyImplyLeading: true,
                  titleFontSize: 16,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: size.width * 0.04),
                    child: (bloc.neededDocuments.isEmpty &&
                            state is LoadingStartState)
                        ? neededDocumentsShimmer(size, context)
                        : bloc.neededDocuments.every((doc) =>
                                doc.document != null &&
                                (doc.document!['data']
                                            ['document_status_string'] ==
                                        'waiting_for_approval' ||
                                    doc.document!['data']
                                            ['document_status_string'] ==
                                        'reuploaded_and_waiting_for_approval'))
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: size.height * 0.15),
                                      Container(
                                        padding: const EdgeInsets.all(40),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          AppImages.circleClock,
                                          height: size.width * 0.35,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: size.width * 0.1),
                                      MyText(
                                        text: AppLocalizations.of(context)!.waitingForApprovelText,
                                        textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: size.width * 0.04),
                                      MyText(
                                        text: 'Your documents are being reviewed by our team. We will notify you as soon as your account is verified.',
                                        textAlign: TextAlign.center,
                                        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).hintColor,
                                          height: 1.5,
                                        ),
                                      ),
                                      SizedBox(height: size.width * 0.15),
                                    ],
                                  ),
                                ),
                              )
                            : NeededDocumentsWidget(cont: context),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
