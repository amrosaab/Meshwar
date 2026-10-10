import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../core/network/extensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/profile_info_content.dart';
import '../update_phonenumer.dart';
import 'update_details.dart';

class ProfileInfoPage extends StatefulWidget {
  static const String routeName = '/profileInfoPage';
  final ProfileInfoPageArguments arg;
  const ProfileInfoPage({super.key, required this.arg});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<AccBloc>();
      bloc.add(UserDataInitEvent(userDetails: widget.arg.userData));
      bloc.add(AccGetDirectionEvent());
      bloc.add(AccGetUserDetailsEvent());
    });
  }

  @override
  Widget build(BuildContext context) => BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          // The edit pages handle their own messages while this route is covered.
          if (ModalRoute.of(context)?.isCurrent == false) return;
          if (state is UpdateUserDetailsFailureState) {
            context.showSnackBar(
                message: AppLocalizations.of(context)!.failedUpdateDetails);
          } else if (state is UserDetailsButtonSuccess ||
              state is UserDetailsUpdatedState) {
            context.read<AccBloc>().add(AccUpdateEvent());
          } else if (state is UserDetailEditState) {
            final bloc = context.read<AccBloc>();
            final mobileLabel = AppLocalizations.of(context)!.mobile;
            if (state.header == mobileLabel) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UpdatePhoneNumberPage())).then((_) {
                if (context.mounted) bloc.add(AccUpdateEvent());
              });
            } else {
              Navigator.pushNamed(context, UpdateDetails.routeName,
                      arguments: UpdateDetailsArguments(
                          header: state.header,
                          text: state.text,
                          userData: bloc.userData ?? widget.arg.userData))
                  .then((_) {
                if (context.mounted) bloc.add(AccUpdateEvent());
              });
            }
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final user = bloc.userData ?? widget.arg.userData;
          final l10n = AppLocalizations.of(context)!;
          void edit(String label, String value) =>
              bloc.add(UserDetailEditEvent(header: label, text: value));
          return Directionality(
            textDirection: bloc.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: RideVisuals.canvas(context),
              appBar: AppBar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.bgAsphaltLight
                    : Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight:
                    MediaQuery.textScalerOf(context).scale(18) > 27 ? 96 : 64,
                centerTitle: false,
                leading: IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    icon: const BackButtonIcon(),
                    color: AccountStyle.ink(context),
                    onPressed: () => Navigator.pop(context, user)),
                title: Text(l10n.personalInformation,
                    maxLines: 2,
                    style: AccountStyle.text(context).copyWith(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w700)),
              ),
              body: ListView(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, MediaQuery.paddingOf(context).bottom + 20),
                children: [
                  ProfilePhotoCard(
                      name: user.name,
                      imageUrl: user.profilePicture,
                      title: l10n.profilePhoto,
                      editLabel: l10n.changeProfilePhoto,
                      caption: l10n.addProfilePhoto,
                      onEdit: () => _showImageSourceSheet(context)),
                  const SizedBox(height: 24),
                  ProfileFieldsCard(children: [
                    ProfileInfoField(
                        label: l10n.name,
                        value: user.name,
                        editLabel: l10n.edit,
                        icon: Icons.person_outline_rounded,
                        gradient: RideVisuals.blue,
                        onEdit: () => edit(l10n.name, user.name)),
                    ProfileInfoField(
                        label: l10n.mobile,
                        value: user.mobile,
                        editLabel: l10n.edit,
                        icon: Icons.phone_outlined,
                        gradient: RideVisuals.green,
                        ltrValue: true,
                        onEdit: () => edit(l10n.mobile, user.mobile)),
                    ProfileInfoField(
                        label: l10n.email,
                        value: user.email,
                        editLabel: l10n.edit,
                        icon: Icons.mail_outline_rounded,
                        gradient: RideVisuals.amber,
                        ltrValue: true,
                        onEdit: () => edit(l10n.email, user.email)),
                  ]),
                ],
              ),
            ),
          );
        }),
      );

  void _showImageSourceSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceStrong(context),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => SafeArea(
          child: SingleChildScrollView(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Text(l10n.addProfilePhoto,
                  textAlign: TextAlign.center,
                  style: AccountStyle.text(context)
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w700))),
          AccountMenuTile(
              label: l10n.cameraText,
              icon: Icons.camera_alt_outlined,
              gradient: RideVisuals.blue,
              onPressed: () {
                Navigator.pop(context);
                _updateProfileImage(context, ImageSource.camera);
              }),
          AccountMenuTile(
              label: l10n.galleryText,
              icon: Icons.photo_library_outlined,
              gradient: RideVisuals.amber,
              onPressed: () {
                Navigator.pop(context);
                _updateProfileImage(context, ImageSource.gallery);
              }),
          const SizedBox(height: 12),
        ],
      ))),
    );
  }

  void _updateProfileImage(BuildContext context, ImageSource source) {
    final bloc = context.read<AccBloc>();
    final user = bloc.userData ?? widget.arg.userData;
    bloc.add(UpdateImageEvent(
        name: user.name,
        email: user.email,
        gender: user.gender,
        source: source));
    bloc.add(AccUpdateEvent());
  }
}
