import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/home_bloc.dart';

class RecentSearchPlacesWidget extends StatelessWidget {
  final BuildContext cont;
  const RecentSearchPlacesWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: context.read<HomeBloc>().recentSearchPlaces.length > 2
                ? 2
                : context.read<HomeBloc>().recentSearchPlaces.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final recentPlace = context
                  .read<HomeBloc>()
                  .recentSearchPlaces
                  .reversed
                  .elementAt(index);
              return InkWell(
                onTap: () {
                  if (context.read<HomeBloc>().pickupAddressList.isNotEmpty) {
                    context.read<HomeBloc>().add(RecentSearchPlaceSelectEvent(
                        address: recentPlace,
                        isPickupSelect: false,
                        transportType: 'taxi'));
                  }
                  // }
                },
                child: Container(
                  padding: EdgeInsets.only(
                      right: size.width * 0.02, left: size.width * 0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(width: 1, color: AppColors.borderColor)),
                  child: Row(
                    children: [
                      Container(
                        height: size.height * 0.075,
                        width: size.width * 0.075,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .disabledColor
                              .withAlpha((0.1 * 255).toInt()),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.history,
                          size: 18,
                          color: Theme.of(context)
                              .disabledColor
                              .withAlpha((0.75 * 255).toInt()),
                        ),
                      ),
                      SizedBox(width: size.width * 0.025),
                      SizedBox(
                        width: size.width * 0.63,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyText(
                              text: recentPlace.address.split(',')[0],
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                            ),
                            MyText(
                              text: recentPlace.address,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
