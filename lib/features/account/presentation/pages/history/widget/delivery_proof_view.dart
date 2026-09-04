import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_navigation_icon.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/history_model.dart';

class DeliveryProofViewPage extends StatefulWidget {
  final List<RequestProofsData> images;
  const DeliveryProofViewPage({super.key, required this.images});

  @override
  State<DeliveryProofViewPage> createState() => _DeliveryProofViewPageState();
}

class _DeliveryProofViewPageState extends State<DeliveryProofViewPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AccBloc, AccState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: NavigationIconWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: Theme.of(context).primaryColorDark),
                    isShadowWidget: true,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Center(
                child: CarouselSlider(
                  items: List.generate(
                    widget.images.length,
                    (index) {
                      return CachedNetworkImage(
                        imageUrl: widget.images[index].proofImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  options: CarouselOptions(
                    height: size.height * 0.7,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      currentIndex = index;
                      context.read<AccBloc>().add(AccUpdateEvent());
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: size.width * 0.02,
                        width: size.width * 0.02,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == index
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColorLight),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
