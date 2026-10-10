import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../application/booking_bloc.dart';
import 'rental_package_content.dart';

Widget packageList(BuildContext context) =>
    BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
      final bloc = context.read<BookingBloc>();
      return SizedBox(
          height: MediaQuery.sizeOf(context).height * .90,
          child: Directionality(
              textDirection: bloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: RentalPackageSheet(
                packages: bloc.rentalPackagesList,
                selectedIndex: bloc.selectedPackageIndex,
                onSelect: (index) => bloc.add(BookingRentalPackageSelectEvent(
                    selectedPackageIndex: index)),
                onClose: () => Navigator.pop(context),
                onContinue: bloc.pickUpAddressList.isEmpty ||
                        bloc.selectedPackageIndex < 0 ||
                        bloc.selectedPackageIndex >=
                            bloc.rentalPackagesList.length
                    ? null
                    : () => bloc.add(RentalPackageConfirmEvent(
                        picklat: bloc.pickUpAddressList.first.lat.toString(),
                        picklng: bloc.pickUpAddressList.first.lng.toString())),
              )));
    });
