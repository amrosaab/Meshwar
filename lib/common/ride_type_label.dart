import 'package:flutter/material.dart';

import '../features/account/domain/models/history_model.dart';
import '../l10n/app_localizations.dart';

String rideTypeLabel(BuildContext context, HistoryData history) {
  if (history.isOutStation == 0 &&
      history.isRental == false &&
      history.goodsType == '-') {
    return AppLocalizations.of(context)!.regular;
  }
  if (history.isOutStation == 0 &&
      history.isRental == false &&
      history.goodsType != '-') {
    return AppLocalizations.of(context)!.delivery;
  }
  if (history.isOutStation == 0 &&
      history.isRental == true &&
      history.goodsType == '-') {
    return '${AppLocalizations.of(context)!.rental} - ${history.rentalPackageName}';
  }
  if (history.isOutStation == 0 &&
      history.isRental == true &&
      history.goodsType != '-') {
    return '${AppLocalizations.of(context)!.deliveryRental} - ${history.rentalPackageName}';
  }
  if (history.isOutStation == 1 &&
      history.isRental == false &&
      history.goodsType == '-') {
    return AppLocalizations.of(context)!.outStation;
  }
  if (history.isOutStation == 1 &&
      history.isRental == false &&
      history.goodsType != '-') {
    return AppLocalizations.of(context)!.deliveryOutStation;
  }
  return '';
}

String outstationTripTypeLabel(BuildContext context, HistoryData history) {
  if (history.isOutStation == 1) {
    return (history.isRoundTrip != '')
        ? AppLocalizations.of(context)!.roundTrip
        : AppLocalizations.of(context)!.oneWayTrip;
  }
  return '';
}
