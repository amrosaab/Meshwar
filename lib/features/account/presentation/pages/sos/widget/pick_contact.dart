import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import 'sos_content.dart';

class PickContact extends StatelessWidget {
  const PickContact({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AccBloc, AccState>(builder: (context, state) {
        final bloc = context.read<AccBloc>();
        final l10n = AppLocalizations.of(context)!;
        final valid = bloc.selectedContact.name.trim().isNotEmpty &&
            bloc.selectedContact.number.trim().isNotEmpty;
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
                  elevation: 0,
                  centerTitle: false,
                  toolbarHeight:
                      MediaQuery.textScalerOf(context).scale(22) > 32 ? 96 : 64,
                  foregroundColor: AccountStyle.ink(context),
                  leading: IconButton(
                      tooltip: l10n.cancel,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded)),
                  title: Text(l10n.selectContact,
                      maxLines: 2,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 22, fontWeight: FontWeight.w700))),
              body: bloc.contactsList.isEmpty
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(l10n.noDataAvailable,
                              textAlign: TextAlign.center)))
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: bloc.contactsList.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final contact = bloc.contactsList[index];
                        return SosContactCard(
                            name: contact.name,
                            number: contact.number,
                            selected: identical(contact, bloc.selectedContact),
                            onSelect: () {
                              bloc.selectedContact = contact;
                              bloc.add(AccUpdateEvent());
                            });
                      }),
              bottomNavigationBar: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: FilledButton(
                      onPressed: valid && !bloc.isLoading
                          ? () {
                              bloc.add(AddContactEvent(
                                  name: bloc.selectedContact.name,
                                  number: bloc.selectedContact.number));
                              Navigator.pop(context);
                            }
                          : null,
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.meshwarRed,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(58),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(l10n.confirm,
                          style: AccountStyle.text(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)))),
            ));
      });
}
