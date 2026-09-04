import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/network/extensions.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/edit_options.dart';
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
      final accBloc = context.read<AccBloc>();
      accBloc.add(AccGetDirectionEvent());
      accBloc.add(AccGetUserDetailsEvent());
      accBloc.add(UserDataInitEvent(userDetails: widget.arg.userData));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<AccBloc, AccState>(
      listener: (context, state) {
        if (state is UserProfileDetailsLoadingState) {
          CustomLoader.loader(context);
        } else if (state is UpdateUserDetailsFailureState) {
          context.showSnackBar(
              message: AppLocalizations.of(context)!.failedUpdateDetails);
        } else if (state is UserDetailsButtonSuccess ||
            state is UserDetailsUpdatedState) {
          context.read<AccBloc>().add(AccUpdateEvent());
        } else if (state is UserDetailEditState) {
          final mobileLabel = AppLocalizations.of(context)!.mobile;
          if (state.header == mobileLabel) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UpdatePhoneNumberPage(),
              ),
            ).then((_) {
              if (!context.mounted) return;
              context.read<AccBloc>().add(AccUpdateEvent());
            });
          } else {
            Navigator.pushNamed(
              context,
              UpdateDetails.routeName,
              arguments: UpdateDetailsArguments(
                  header: state.header,
                  text: state.text,
                  userData: context.read<AccBloc>().userData!),
            ).then(
                  (_) {
                if (!context.mounted) return;
                context.read<AccBloc>().add(AccUpdateEvent());
              },
            );
          }
        }
      },
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return (context.read<AccBloc>().userData != null)
              ? Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                appBar: CustomAppBar(
                  title:
                  AppLocalizations.of(context)!.personalInformation,
                  automaticallyImplyLeading: true,
                  titleFontSize: 18,
                  onBackTap: () {
                    final accBloc = context.read<AccBloc>();
                    Navigator.pop(
                        context, accBloc.userData ?? widget.arg.userData);
                  },
                ),
                body: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      // Main content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.width * 0.1),
                                LiquidGlassContainer(
                                  borderRadius: 10,
                                  padding:
                                  EdgeInsets.all(size.width * 0.05),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                          radius: size.width * 0.1,
                                          backgroundColor:
                                          Theme.of(context)
                                              .dividerColor,
                                          backgroundImage: context
                                              .read<AccBloc>()
                                              .userData!
                                              .profilePicture
                                              .isNotEmpty
                                              ? NetworkImage(context
                                              .read<AccBloc>()
                                              .userData!
                                              .profilePicture)
                                              : null,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () =>
                                                        _showImageSourceSheet(
                                                            context),
                                                    child: Container(
                                                      height: size.width *
                                                          0.085,
                                                      width: size.width *
                                                          0.085,
                                                      decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        color: AppColors
                                                            .white,
                                                      ),
                                                      alignment: Alignment
                                                          .center,
                                                      child: Container(
                                                        height:
                                                        size.width *
                                                            0.075,
                                                        width:
                                                        size.width *
                                                            0.075,
                                                        decoration:
                                                        const BoxDecoration(
                                                          shape: BoxShape
                                                              .circle,
                                                          color: AppColors
                                                              .primary,
                                                        ),
                                                        child:
                                                        const Center(
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 18,
                                                            color:
                                                            AppColors
                                                                .white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.width * 0.05),
                                      SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                            text: AppLocalizations.of(
                                                context)!
                                                .addProfilePhoto,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                fontSize: 16,
                                                color: Theme.of(
                                                    context)
                                                    .primaryColorDark),
                                            maxLines: 4,
                                            textAlign: TextAlign.center,
                                          ))
                                    ],
                                  ),
                                ),

                                SizedBox(height: size.width * 0.05),

                                // Personal information section
                                LiquidGlassContainer(
                                  borderRadius: 10,
                                  padding: EdgeInsets.all(
                                      size.width * 0.025),
                                  child: Column(
                                    children: [
                                      // Name
                                      EditOptions(
                                        text: context
                                            .read<AccBloc>()
                                            .userData!
                                            .name,
                                        header:
                                        AppLocalizations.of(context)!
                                            .name,
                                        imagePath: AppImages.user,
                                        showEditIcon: true,
                                        showUnderLine: true,
                                        onTap: () {
                                          context.read<AccBloc>().add(
                                              UserDetailEditEvent(
                                                  header:
                                                  AppLocalizations.of(
                                                      context)!
                                                      .name,
                                                  text: context
                                                      .read<AccBloc>()
                                                      .userData!
                                                      .name));
                                        },
                                      ),
                                      // Mobile
                                      EditOptions(
                                        text: context
                                            .read<AccBloc>()
                                            .userData!
                                            .mobile,
                                        header:
                                        AppLocalizations.of(context)!
                                            .mobile,
                                        imagePath: AppImages.phone,
                                        showEditIcon: true,
                                        showUnderLine: true,
                                        onTap: () {
                                          final accBloc =
                                          context.read<AccBloc>();
                                          accBloc.add(
                                            UserDetailEditEvent(
                                              header: AppLocalizations.of(
                                                  context)!
                                                  .mobile,
                                              text: accBloc
                                                  .userData!.mobile,
                                            ),
                                          );
                                        },
                                      ),

                                      // Email
                                      EditOptions(
                                        text: context
                                            .read<AccBloc>()
                                            .userData!
                                            .email,
                                        header:
                                        AppLocalizations.of(context)!
                                            .email,
                                        imagePath: AppImages.gmail,
                                        showEditIcon: true,
                                        showUnderLine: true,
                                        onTap: () {
                                          final accBloc =
                                          context.read<AccBloc>();
                                          accBloc.add(
                                            UserDetailEditEvent(
                                              header: AppLocalizations.of(
                                                  context)!
                                                  .email,
                                              text:
                                              accBloc.userData!.email,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: size.width * 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : const Scaffold(
            body: Loader(),
          );
        },
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceStrong(context),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                size: 20,
                color: Theme.of(context)
                    .primaryColorDark
                    .withAlpha((0.5 * 255).toInt()),
              ),
              title: MyText(
                text: AppLocalizations.of(context)!.cameraText,
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context)
                        .primaryColorDark
                        .withAlpha((0.5 * 255).toInt())),
              ),
              onTap: () {
                Navigator.pop(context);
                _updateProfileImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                size: 20,
                color: Theme.of(context)
                    .primaryColorDark
                    .withAlpha((0.5 * 255).toInt()),
              ),
              title: MyText(
                text: AppLocalizations.of(context)!.galleryText,
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context)
                        .primaryColorDark
                        .withAlpha((0.5 * 255).toInt())),
              ),
              onTap: () {
                Navigator.pop(context);
                _updateProfileImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfileImage(
      BuildContext context, ImageSource source) async {
    final AccBloc accBloc = context.read<AccBloc>();

    accBloc.add(UpdateImageEvent(
      name: accBloc.userData!.name,
      email: accBloc.userData!.email,
      gender: accBloc.userData!.gender,
      source: source,
    ));
    accBloc.add(AccUpdateEvent());
  }
}