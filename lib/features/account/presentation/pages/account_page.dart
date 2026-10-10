import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../common/liquid_glass_container.dart';
import '../../../../common/ride_visuals.dart';
import '../../../../core/utils/custom_dialoges.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../../home/application/home_bloc.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../../userprofile/presentation/pages/driver_profile_pages.dart';
import '../../application/acc_bloc.dart';
import '../widgets/account_content.dart';
import 'coupon_list/page/coupon_list_page.dart';
import 'fav_location/page/fav_location.dart';
import 'help/help.dart';
import 'notification/page/notification_page.dart';
import 'outstation/page/outstation_page.dart';
import 'profile/page/profile_info_page.dart';
import 'refferal/page/referral_page.dart';
import 'settings/page/settings_page.dart';
import 'sos/page/sos_page.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/accountPage';
  final AccountPageArguments arg;
  const AccountPage({super.key, required this.arg});

  Future<void> _openProfile(
      BuildContext context, AccBloc bloc, UserDetail user) async {
    final value = await Navigator.pushNamed(context, ProfileInfoPage.routeName,
        arguments: ProfileInfoPageArguments(userData: user));
    if (!context.mounted) return;
    if (value is UserDetail) {
      bloc.userData = value;
      bloc.add(AccUpdateEvent());
    } else {
      bloc.add(AccGetUserDetailsEvent());
    }
  }

  Future<void> _openFavorites(
      BuildContext context, AccBloc bloc, UserDetail user) async {
    final value = await Navigator.pushNamed(
        context, FavoriteLocationPage.routeName,
        arguments: FavouriteLocationPageArguments(
            userData: user, selectedServiceIndex: arg.selectedServiceIndex));
    if (!context.mounted) return;
    if (value is UserDetail) {
      bloc.userData = value;
      bloc.add(AccUpdateEvent());
    }
  }

  Future<void> _openSos(
      BuildContext context, AccBloc bloc, UserDetail user) async {
    final value = await Navigator.pushNamed(context, SosPage.routeName,
        arguments: SOSPageArguments(sosData: user.sos.data));
    if (!context.mounted) return;
    if (value is List<SOSDatum>) {
      bloc.sosdata = value;
      user.sos.data = value;
      bloc.add(AccUpdateEvent());
    }
  }

  Future<void> _openLanguage(BuildContext context, AccBloc bloc) async {
    await Navigator.pushNamed(context, ChooseLanguagePage.routeName,
        arguments: ChooseLanguageArguments(isInitialLanguageChange: false));
    if (!context.mounted) return;
    bloc.add(AccGetDirectionEvent());
    context.read<HomeBloc>().add(GetDirectionEvent());
  }

  void _confirmLogout(BuildContext context, AccBloc bloc) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (_) => BlocProvider.value(
            value: bloc,
            child: CustomDoubleButtonDialoge(
              title: l10n.comeBackSoon,
              content: l10n.logoutText,
              noBtnName: l10n.no,
              yesBtnName: l10n.yes,
              yesBtnFunc: () => bloc.add(LogoutEvent()),
            )));
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(AccGetDirectionEvent())
          ..add(UserDataInitEvent(userDetails: arg.userData)),
        child: BlocListener<AccBloc, AccState>(
          listener: (context, state) async {
            if (state is LogoutLoadingState) {
              Navigator.of(context).pop();
              CustomLoader.loader(context);
            } else if (state is LogoutFailureState) {
              CustomLoader.dismiss(context);
              if (context.mounted) showToast(message: state.errorMessage);
            } else if (state is LogoutSuccess) {
              CustomLoader.dismiss(context);
              await AppSharedPreference.setLoginStatus(false);
              await AppSharedPreference.setToken('');
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginPage.routeName, (route) => false);
              }
            }
          },
          child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
            final bloc = context.read<AccBloc>();
            final user = bloc.userData ?? arg.userData;
            final l10n = AppLocalizations.of(context)!;
            final compactHeader = MediaQuery.sizeOf(context).width < 340 ||
                MediaQuery.textScalerOf(context).scale(14) > 20;
            void openProfile() => _openProfile(context, bloc, user);
            return Directionality(
              textDirection: bloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: RideVisuals.canvas(context),
                appBar: AppBar(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.bgAsphaltLight
                          : Colors.white,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  toolbarHeight: 72,
                  titleSpacing: 20,
                  centerTitle: false,
                  title: Row(children: [
                    const ExcludeSemantics(
                        child: RideColorBadge(
                            icon: Icons.person_rounded,
                            gradient: RideVisuals.rose,
                            size: 40,
                            iconSize: 22,
                            radius: 14)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(l10n.myAccount,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AccountStyle.text(context).copyWith(
                                fontSize: 22, fontWeight: FontWeight.w700))),
                  ]),
                  actions: [
                    Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        child: compactHeader
                            ? IconButton(
                                tooltip: l10n.help,
                                onPressed: () => Navigator.pushNamed(
                                    context, HelpPage.routeName),
                                icon: const Icon(Icons.help_outline_rounded,
                                    color: AppColors.routeGreen))
                            : TextButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                    context, HelpPage.routeName),
                                icon: const Icon(Icons.help_outline_rounded,
                                    size: 20),
                                label: Text(l10n.help,
                                    style: AccountStyle.text(context).copyWith(
                                        color: AppColors.routeGreen,
                                        fontWeight: FontWeight.w600)),
                                style: TextButton.styleFrom(
                                    foregroundColor: AppColors.routeGreen))),
                  ],
                ),
                body: ListView(
                  padding: EdgeInsets.fromLTRB(
                      20, 18, 20, MediaQuery.paddingOf(context).bottom + 20),
                  children: [
                    AccountProfileCard(
                        name: user.name,
                        phone: user.mobile,
                        imageUrl: user.profilePicture,
                        editLabel: l10n.edit,
                        onPressed: openProfile),
                    const SizedBox(height: 28),
                    AccountMenuSection(title: l10n.yourAccount, children: [
                      AccountMenuTile(
                          label: l10n.personalInformation,
                          icon: Icons.person_outline_rounded,
                          gradient: RideVisuals.blue,
                          onPressed: openProfile),
                      AccountMenuTile(
                          label: l10n.favoriteLocation,
                          icon: Icons.favorite_border_rounded,
                          gradient: RideVisuals.rose,
                          onPressed: () => _openFavorites(context, bloc, user)),
                      if (user.enableUserDocument == '1')
                        AccountMenuTile(
                            label: l10n.document,
                            icon: Icons.description_outlined,
                            gradient: RideVisuals.blue,
                            onPressed: () => Navigator.pushNamed(
                                context, DriverProfilePage.routeName,
                                arguments: const DriverProfilePageArguments(
                                    from: 'account'))),
                    ]),
                    const SizedBox(height: 28),
                    AccountMenuSection(title: l10n.activity, children: [
                      AccountMenuTile(
                          label: l10n.notifications,
                          icon: Icons.notifications_none_rounded,
                          gradient: RideVisuals.amber,
                          onPressed: () => Navigator.pushNamed(
                              context, NotificationPage.routeName)),
                      if (user.showOutstationRideFeature == '1')
                        AccountMenuTile(
                            label: l10n.outStation,
                            icon: Icons.route_outlined,
                            gradient: RideVisuals.green,
                            onPressed: () => Navigator.pushNamed(
                                context, OutstationHistoryPage.routeName,
                                arguments: OutstationHistoryPageArguments(
                                    isFromBooking: false))),
                    ]),
                    const SizedBox(height: 28),
                    AccountMenuSection(title: l10n.benefits, children: [
                      AccountMenuTile(
                          label: l10n.referEarn,
                          icon: Icons.card_giftcard_rounded,
                          gradient: RideVisuals.amber,
                          onPressed: () => Navigator.pushNamed(
                              context, ReferralPage.routeName,
                              arguments: ReferralArguments(
                                  title: l10n.referEarn, userData: user))),
                      AccountMenuTile(
                          label: l10n.coupon,
                          icon: Icons.local_offer_outlined,
                          gradient: RideVisuals.blue,
                          onPressed: () => Navigator.pushNamed(
                              context, CouponsListPage.routeName,
                              arguments:
                                  CouponListPageArguments(userData: user))),
                      AccountMenuTile(
                          label: l10n.sos,
                          icon: Icons.shield_outlined,
                          gradient: RideVisuals.rose,
                          onPressed: () => _openSos(context, bloc, user)),
                    ]),
                    const SizedBox(height: 28),
                    AccountMenuSection(title: l10n.settings, children: [
                      AccountMenuTile(
                          label: l10n.changeLanguage,
                          icon: Icons.language_rounded,
                          gradient: RideVisuals.blue,
                          onPressed: () => _openLanguage(context, bloc)),
                      AccountMenuTile(
                          label: l10n.settings,
                          icon: Icons.settings_outlined,
                          gradient: RideVisuals.green,
                          onPressed: () => Navigator.pushNamed(
                              context, SettingsPage.routeName,
                              arguments:
                                  SettingsPageArguments(userData: user))),
                      AccountMenuTile(
                          label: l10n.logout,
                          icon: Icons.logout_rounded,
                          gradient: RideVisuals.rose,
                          onPressed: () => _confirmLogout(context, bloc)),
                    ]),
                  ],
                ),
              ),
            );
          }),
        ),
      );
}

// Menu Group Card Widget ---------------------------------------------------
class MenuSectionCard extends StatelessWidget {
  final List<Widget> children;

  const MenuSectionCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: children),
    );
  }
}

Widget customDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Divider(
      height: 1,
      thickness: 0.4,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
    ),
  );
}
