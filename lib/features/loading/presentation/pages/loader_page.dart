import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../../app/localization.dart';
import '../../../landing/presentation/page/landing_page.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../../userprofile/presentation/pages/driver_profile_pages.dart';
import '../../application/loader_bloc.dart';

class LoaderPage extends StatefulWidget {
  static const String routeName = '/loaderPage';

  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  // The splash GIF (and the wait for it to finish playing) has been
  // disabled — the app now moves on as soon as LoaderSuccessState arrives,
  // right after the native splash hands off, instead of holding on this
  // screen for a full GIF playthrough. See _PlayOnceGif below (now unused)
  // to restore it.
  LoaderSuccessState? _loaderSuccessState;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Safety net: if LoaderSuccessState never arrives for any reason,
    // don't leave the splash screen stuck forever.
    Future.delayed(const Duration(seconds: 8), () {
      if (_navigated) return;
      debugPrint(
          '[LoaderPage] 8s safety timeout reached — '
              'loaderSuccessState=${_loaderSuccessState != null}. Forcing navigation check.');
      if (_loaderSuccessState == null) {
        debugPrint(
            '[LoaderPage] LoaderSuccessState never arrived — bloc is likely stuck or erroring silently.');
      }
    });
  }

  void _maybeNavigate() {
    if (_navigated) return;
    final state = _loaderSuccessState;
    if (state == null) {
      debugPrint(
          '[LoaderPage] _maybeNavigate: GIF done, waiting on LoaderSuccessState.');
      return;
    }

    debugPrint('[LoaderPage] Both conditions met — navigating.');
    _navigated = true;
    debugPrint('[LoaderPage] Calling navigation directly (no postFrameCallback).');
    if (!mounted) {
      debugPrint('[LoaderPage] Aborting navigation — widget unmounted.');
      return;
    }
    try {
      debugPrint(
          '[LoaderPage] selectedLanguage="${state.selectedLanguage}", '
              'loginStatus=${state.loginStatus}, '
              'landingStatus=${state.landingStatus}, '
              'userData=${state.userData != null}');
      if (state.selectedLanguage.isNotEmpty) {
        debugPrint('[LoaderPage] Dispatching LocalizationInitialEvent...');
        context.read<LocalizationBloc>().add(LocalizationInitialEvent(
            isDark: Theme.of(context).brightness == Brightness.dark,
            locale: Locale(state.selectedLanguage)));
        debugPrint('[LoaderPage] LocalizationInitialEvent dispatched OK.');
        if (!state.loginStatus) {
          if (!state.landingStatus) {
            debugPrint('[LoaderPage] Navigating to LandingPage...');
            Navigator.pushNamedAndRemoveUntil(
                context, LandingPage.routeName, (route) => false);
          } else {
            debugPrint('[LoaderPage] Navigating to LoginPage...');
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
          }
        } else {
          if (state.userData != null &&
              state.userData!.enableUserDocument == '1' &&
              state.userData!.approve == 0) {
            debugPrint('[LoaderPage] Navigating to DriverProfilePage...');
            Navigator.pushNamedAndRemoveUntil(
              context,
              DriverProfilePage.routeName,
                  (route) => false,
              arguments:
              const DriverProfilePageArguments(from: 'onboarding'),
            );
          } else {
            debugPrint('[LoaderPage] Navigating to HomePage...');
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }
        }
      } else {
        debugPrint('[LoaderPage] Navigating to ChooseLanguagePage...');
        Navigator.pushNamedAndRemoveUntil(
          context,
          ChooseLanguagePage.routeName,
              (route) => false,
          arguments: ChooseLanguageArguments(isInitialLanguageChange: true),
        );
      }
      debugPrint('[LoaderPage] Navigation call completed without throwing.');
    } catch (e, stack) {
      debugPrint('[LoaderPage] EXCEPTION during navigation: $e');
      debugPrint('[LoaderPage] Stack trace: $stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoaderBloc()..add(LoaderGetLocalDataEvent()),
      child: BlocListener<LoaderBloc, LoaderState>(
        listener: (context, state) {
          debugPrint('[LoaderPage] LoaderBloc state: $state');
          if (state is LoaderSuccessState) {
            _loaderSuccessState = state;
            _maybeNavigate();
          }
        },
        child: PopScope(
          canPop: false,
          // Same brand-red background as the native splash (see
          // flutter_native_splash config in pubspec.yaml) and nothing else —
          // this frame is only visible for however long LoaderSuccessState
          // takes to arrive, so it should look like a continuation of the
          // native splash, not a distinct screen.
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }
}

/// Renders a GIF by decoding and stepping through its frames manually,
/// stopping (freezing on the last frame) after exactly one loop instead
/// of continuing to loop indefinitely — Image.asset has no built-in way
/// to override a GIF's own encoded loop count, so this is the reliable
/// way to guarantee a single playthrough.
class _PlayOnceGif extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;
  final VoidCallback? onComplete;

  const _PlayOnceGif({
    required this.assetPath,
    required this.width,
    required this.height,
    this.onComplete,
  });

  @override
  State<_PlayOnceGif> createState() => _PlayOnceGifState();
}

class _PlayOnceGifState extends State<_PlayOnceGif> {
  ui.Image? _currentFrame;

  @override
  void initState() {
    super.initState();
    _playFrames();
  }

  Future<void> _playFrames() async {
    try {
      final bytes = await rootBundle.load(widget.assetPath);
      final codec = await ui.instantiateImageCodec(
        bytes.buffer.asUint8List(),
      );

      for (int i = 0; i < codec.frameCount; i++) {
        final frameInfo = await codec.getNextFrame();
        if (!mounted) {
          codec.dispose();
          return;
        }
        setState(() {
          _currentFrame = frameInfo.image;
        });
        await Future.delayed(frameInfo.duration);
      }
      codec.dispose();

      if (mounted) {
        widget.onComplete?.call();
      }
    } catch (_) {
      // If decoding fails for any reason, don't block navigation
      // indefinitely waiting on a GIF that will never complete.
      if (mounted) {
        widget.onComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentFrame == null) {
      return SizedBox(width: widget.width, height: widget.height);
    }
    return RawImage(
      image: _currentFrame,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.contain,
    );
  }
}