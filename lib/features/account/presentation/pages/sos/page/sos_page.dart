import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/contact_model.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/pick_contact.dart';
import '../widget/sos_add_contact_sheet.dart';
import '../widget/sos_content.dart';
import '../widget/sos_detail_widget.dart';

class SosPage extends StatelessWidget {
  const SosPage({super.key, required this.arg});
  static const String routeName = '/sosPage';
  final SOSPageArguments arg;
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(AccGetDirectionEvent())
          ..add(SosInitEvent(arg: arg)),
        child: BlocListener<AccBloc, AccState>(listener: (context, state) {
          final bloc = context.read<AccBloc>();
          final l10n = AppLocalizations.of(context)!;
          if (state is SelectContactDetailsState) {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                useRootNavigator: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28))),
                clipBehavior: Clip.antiAlias,
                builder: (_) => BlocProvider.value(
                    value: bloc, child: const PickContact()));
          } else if (state is GetContactPermissionState ||
              state is GetContactPermissionPermanentlyDeniedState) {
            final permanent =
                state is GetContactPermissionPermanentlyDeniedState;
            showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                        title: Text(l10n.permissionRequired),
                        content: Text(permanent
                            ? l10n.contactsPermissionSettingsContent
                            : l10n.contactsPermissionContent),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: Text(l10n.cancel)),
                          FilledButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                if (permanent) {
                                  openAppSettings();
                                } else {
                                  bloc.add(SelectContactDetailsEvent());
                                }
                              },
                              child: Text(permanent
                                  ? l10n.openSettings
                                  : l10n.tryAgain)),
                        ]));
          } else if (state is AddContactFailureState ||
              state is SosFailureState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.tryAgain)));
          }
        }, child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final l10n = AppLocalizations.of(context)!;
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
                centerTitle: false,
                toolbarHeight:
                    MediaQuery.textScalerOf(context).scale(22) > 32 ? 96 : 64,
                foregroundColor: AccountStyle.ink(context),
                title: Text(l10n.sos,
                    style: AccountStyle.text(context)
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
                leading: IconButton(
                    icon: const BackButtonIcon(),
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () => Navigator.pop(context, bloc.sosdata)),
              ),
              body: SosDetailWidget(sosdata: bloc.sosdata, cont: context),
              bottomNavigationBar: bloc.sosdata.length < 5
                  ? SosAddActions(
                      busy: bloc.isLoading,
                      onContacts: () {
                        bloc.selectedContact =
                            ContactsModel(name: '', number: '');
                        bloc.add(SelectContactDetailsEvent());
                      },
                      onManual: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(28))),
                          builder: (_) => SosAddContactSheet(accBloc: bloc)))
                  : null,
            ),
          );
        })),
      );
}
