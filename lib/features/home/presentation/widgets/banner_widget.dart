// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/app_colors.dart';
import '../../application/home_bloc.dart';

class BannerWidget extends StatelessWidget {
  final BuildContext cont;
  const BannerWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
        value: cont.read<HomeBloc>(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bannerData =
                context.read<HomeBloc>().userData?.bannerImage.data ?? [];
            if (bannerData.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.width * 0.02),
                CarouselSlider(
                  items: List.generate(
                    bannerData.length,
                    (index) {
                      return InkWell(
                        onTap: () async {
                          final String url = bannerData[index].imageUrl;

                          if (url.isNotEmpty) {
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedNetworkImage(
                              imageUrl: bannerData[index].image,
                              width: size.width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.withOpacity(0.1),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.withOpacity(0.1),
                                child: const Center(
                                  child: Icon(Icons.error_outline,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  options: CarouselOptions(
                    height: size.width * 0.35,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: bannerData.length > 1,
                    reverse: false,
                    autoPlay: bannerData.length > 1,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 600),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.15,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      context.read<HomeBloc>().bannerIndex = index;
                      context.read<HomeBloc>().add(UpdateEvent());
                    },
                  ),
                ),
                if (bannerData.length > 1) ...[
                  SizedBox(height: size.width * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      bannerData.length,
                      (index) {
                        final isSelected =
                            context.read<HomeBloc>().bannerIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          height: 6,
                          width: isSelected ? 20 : 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : AppColors.greyHeader.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ],
            );
          },
        ));
  }
}
