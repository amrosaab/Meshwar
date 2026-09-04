import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/common.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';

class EtaListShimmer extends StatelessWidget {
  final Size size;
  const EtaListShimmer({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: context.read<BookingBloc>().isEtaLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.width * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.greyHeader,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 15,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                color: AppColors.greyHeader,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.greyHeader,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 15,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                color: AppColors.greyHeader,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.3,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                              color: AppColors.greyHeader,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Container(
                          width: size.width * 0.3,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                              color: AppColors.greyHeader,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      width: size.width * 0.3,
                      height: size.width * 0.03,
                      decoration: BoxDecoration(
                          color: AppColors.greyHeader,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 2,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: size.width * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: size.width * 0.03),
                            Container(
                              padding: EdgeInsets.all(size.width * 0.025),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.greyHeader,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.025),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 10,
                                            color: AppColors.greyHeader,
                                          ),
                                          SizedBox(height: size.width * 0.02),
                                          Container(
                                            width: 60,
                                            height: 10,
                                            color: AppColors.greyHeader,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 10,
                                        color: AppColors.greyHeader,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        width: 80,
                                        height: 10,
                                        color: AppColors.greyHeader,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 10,
                              color: AppColors.greyHeader,
                            ),
                            Container(
                              width: 100,
                              height: 10,
                              color: AppColors.greyHeader,
                            ),
                          ],
                        ),
                        SizedBox(height: size.width * 0.02),
                        Center(
                          child: Container(
                            width: size.width * 0.6,
                            height: size.width * 0.1,
                            decoration: BoxDecoration(
                                color: AppColors.greyHeader,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.width * 0.1),
                ],
              )
            : context.read<BookingBloc>().isEtaApiCompleted
                ? Text(
                    AppLocalizations.of(context)!
                        .noVehiclesAvailable, // or custom text
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
      ),
    );
  }
}
