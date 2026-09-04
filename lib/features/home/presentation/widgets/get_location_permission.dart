import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';

class GetLocationPermissionWidget extends StatelessWidget {
  final BuildContext cont;
  const GetLocationPermissionWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: context.read<HomeBloc>().textDirection == 'rtl'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel_outlined,
                            color: Theme.of(context).primaryColor))),
                MyText(
                    text: AppLocalizations.of(context)!.locationAccess,
                    maxLines: 4),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await openAppSettings();
                    },
                    child: MyText(
                        text: AppLocalizations.of(context)!.openSetting,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),
                  InkWell(
                    onTap: () async {
                      PermissionStatus status =
                          await Permission.location.status;
                      if (status.isGranted || status.isLimited) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        context.read<HomeBloc>().add(LocateMeEvent(
                            mapType: context.read<HomeBloc>().mapType));
                      } else {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    child: MyText(
                        text: AppLocalizations.of(context)!.done,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).primaryColor)),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
