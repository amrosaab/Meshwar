import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../application/acc_bloc.dart';
import 'sos_content.dart';

class SosDetailWidget extends StatelessWidget {
  const SosDetailWidget({super.key, required this.cont, required this.sosdata});
  final BuildContext cont;
  final List<SOSDatum> sosdata;
  @override
  Widget build(BuildContext context) {
    final contacts =
        sosdata.where((contact) => contact.userType != 'admin').toList();
    final l10n = AppLocalizations.of(context)!;
    if (contacts.isEmpty) {
      return const CustomScrollView(slivers: [
        SliverFillRemaining(hasScrollBody: false, child: SosEmptyContent())
      ]);
    }
    return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: contacts.length,
        separatorBuilder: (_, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return SosContactCard(
              name: contact.name ?? '',
              number: contact.number ?? '',
              onDelete: contact.id == null ||
                      contact.id!.isEmpty ||
                      cont.read<AccBloc>().isLoading
                  ? null
                  : () async {
                      final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                                  title: Text(l10n.deleteSos),
                                  content: Text(l10n.deleteContact),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, false),
                                        child: Text(l10n.no)),
                                    FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, true),
                                        child: Text(l10n.yes)),
                                  ]));
                      if (confirmed == true && cont.mounted) {
                        cont
                            .read<AccBloc>()
                            .add(DeleteContactEvent(id: contact.id));
                      }
                    });
        });
  }
}
