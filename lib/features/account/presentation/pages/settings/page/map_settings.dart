import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class MapSettingsPage extends StatelessWidget {
  static const String routeName = '/mapSettings';

  const MapSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();
          if (state is AccInitialState || state is AccDataLoadingStartState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.mapSettings,
                automaticallyImplyLeading: true,
                titleFontSize: 18,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider(
                    key: ValueKey(accBloc.choosenMapIndex),
                    items: [
                      _buildMapCard(
                        context: context,
                        size: size,
                        index: 0,
                        title: AppLocalizations.of(context)!.googleMap,
                        imagePath: 'assets/images/googlemap.jpeg',
                        isSelected: accBloc.choosenMapIndex == 0,
                        onTap: () =>
                            accBloc.add(ChooseMapOnTapEvent(chooseMapIndex: 0)),
                      ),
                      _buildMapCard(
                        context: context,
                        size: size,
                        index: 1,
                        title: AppLocalizations.of(context)!.openStreet,
                        imagePath: 'assets/images/fluttermap.jpg',
                        isSelected: accBloc.choosenMapIndex == 1,
                        onTap: () =>
                            accBloc.add(ChooseMapOnTapEvent(chooseMapIndex: 1)),
                      ),
                    ],
                    options: CarouselOptions(
                      initialPage: accBloc.choosenMapIndex,
                      height: size.width * 1.5,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: false,
                      autoPlayAnimationDuration:
                      const Duration(milliseconds: 800),
                      viewportFraction: 0.75,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMapCard({
    required BuildContext context,
    required Size size,
    required int index,
    required String title,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.surfaceStrong(context),
          boxShadow: AppColors.surfaceShadow(context),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(size.width * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? AppColors.surfaceShadow(context)
                      : null,
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.surfaceStrong(context)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: title,
                        textStyle:
                        Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  if (isSelected) ...[
                    SizedBox(height: size.width * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: size.width * 0.02,
                        horizontal: size.width * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.done, color: Colors.white, size: 16),
                          SizedBox(width: size.width * 0.02),
                          MyText(
                            text: AppLocalizations.of(context)!.selectedText,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}