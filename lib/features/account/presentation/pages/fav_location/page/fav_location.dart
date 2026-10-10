import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../widgets/account_content.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/stop_address_model.dart';
import '../../../../../home/presentation/pages/confirm_location_page.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/delete_address_widget.dart';
import '../widget/favorite_location_card.dart';
import 'confirm_fav_location.dart';

class FavoriteLocationPage extends StatelessWidget {
  final FavouriteLocationPageArguments arg;
  static const String routeName = '/favoriteLocation';

  const FavoriteLocationPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(GetFavListEvent(
            userData: arg.userData,
            favAddressList: arg.userData.favouriteLocations.data))
        ..add(AccGetUserDetailsEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is SelectFromFavAddressState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                arguments: ConfirmLocationPageArguments(
                  isEditAddress: false,
                  userData: arg.userData,
                  isOutstationRide: false,
                  isPickupEdit: false,
                  mapType: (context.read<AccBloc>().userData ?? arg.userData)
                      .mapType,
                  transportType: '',
                  selectedServiceIndex: arg.selectedServiceIndex,
                )).then(
              (value) {
                if (!context.mounted) return;
                if (value != null) {
                  final address = value as AddressModel;
                  if (state.addressType == 'Home' ||
                      state.addressType == 'Work') {
                    context.read<AccBloc>().add(AddFavAddressEvent(
                        isOther: false,
                        address: address.address,
                        name: state.addressType,
                        lat: address.lat.toString(),
                        lng: address.lng.toString()));
                  } else {
                    if (context.read<AccBloc>().userData != null) {
                      Navigator.pushNamed(context, ConfirmFavLocation.routeName,
                          arguments: ConfirmFavouriteLocationPageArguments(
                            userData: context.read<AccBloc>().userData!,
                            selectedAddress: address,
                            selectedServiceIndex: arg.selectedServiceIndex,
                          )).then(
                        (value) {
                          if (!context.mounted) return;
                          context.read<AccBloc>().add(AccGetUserDetailsEvent());
                        },
                      );
                    }
                  }
                }
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final l10n = AppLocalizations.of(context)!;
          void remove(String id, {bool home = false, bool work = false}) {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.surfaceStrong(context),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28))),
                builder: (_) => DeleteAddressWidget(
                    cont: context,
                    addressId: id,
                    isHome: home,
                    isWork: work,
                    isOthers: !home && !work));
          }

          return Scaffold(
            backgroundColor: RideVisuals.canvas(context),
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.bgAsphaltLight
                  : Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              toolbarHeight:
                  MediaQuery.textScalerOf(context).scale(22) > 32 ? 96 : 64,
              foregroundColor: AccountStyle.ink(context),
              title: Text(l10n.favoriteLocation,
                  maxLines: 2,
                  style: AccountStyle.text(context)
                      .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(l10n.favorites,
                        style: AccountStyle.text(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: AccountStyle.muted(context)))),
                FavoriteLocationCard(
                    title: l10n.home,
                    address: bloc.home.isEmpty
                        ? l10n.tapAddAddress
                        : bloc.home.first.pickAddress,
                    icon: Icons.home_rounded,
                    gradient: RideVisuals.blue,
                    saved: bloc.home.isNotEmpty,
                    actionLabel:
                        bloc.home.isEmpty ? l10n.tapAddAddress : l10n.delete,
                    onAction: () => bloc.home.isEmpty
                        ? bloc
                            .add(SelectFromFavAddressEvent(addressType: 'Home'))
                        : remove(bloc.home.first.id, home: true)),
                const SizedBox(height: 14),
                FavoriteLocationCard(
                    title: l10n.work,
                    address: bloc.work.isEmpty
                        ? l10n.tapAddAddress
                        : bloc.work.first.pickAddress,
                    icon: Icons.work_rounded,
                    gradient: RideVisuals.amber,
                    saved: bloc.work.isNotEmpty,
                    actionLabel:
                        bloc.work.isEmpty ? l10n.tapAddAddress : l10n.delete,
                    onAction: () => bloc.work.isEmpty
                        ? bloc
                            .add(SelectFromFavAddressEvent(addressType: 'Work'))
                        : remove(bloc.work.first.id, work: true)),
                for (final place in bloc.others) ...[
                  const SizedBox(height: 14),
                  FavoriteLocationCard(
                      title: place.addressName,
                      address: place.pickAddress,
                      icon: Icons.bookmark_rounded,
                      gradient: RideVisuals.green,
                      saved: true,
                      actionLabel: l10n.delete,
                      onAction: () => remove(place.id)),
                ],
              ],
            ),
            bottomNavigationBar: bloc.others.length < 2
                ? SafeArea(
                    top: false,
                    minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.meshwarRed,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(58),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () {
                          bloc.newAddressController.clear();
                          bloc.add(SelectFromFavAddressEvent(addressType: ''));
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ExcludeSemantics(
                                  child: Icon(Icons.add_rounded, size: 22)),
                              const SizedBox(width: 10),
                              Flexible(
                                  child: Text(l10n.addMore,
                                      style: AccountStyle.text(context)
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white))),
                            ])))
                : null,
          );
        }),
      ),
    );
  }
}
