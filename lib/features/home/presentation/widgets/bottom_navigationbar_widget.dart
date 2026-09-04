import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/user_details_model.dart';

class BottomNavigationbarWidget extends StatefulWidget {
  final int index;
  final UserDetail userData;
  final Function(int) onTap;

  const BottomNavigationbarWidget({
    super.key,
    required this.index,
    required this.userData,
    required this.onTap,
  });

  @override
  State<BottomNavigationbarWidget> createState() =>
      _BottomNavigationbarWidgetState();
}

class _BottomNavigationbarWidgetState extends State<BottomNavigationbarWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomNavigationbarWidget oldWidget) {
    if (oldWidget.index != widget.index) {
      setState(() {
        _selectedIndex = widget.index;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(42),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                index: 0,
                svgPath: 'assets/svg/Home.svg',
                label: AppLocalizations.of(context)!.home,
                isDark: isDark,
              ),
              _buildNavItem(
                index: 1,
                svgPath: 'assets/svg/Hostory.svg',
                label: AppLocalizations.of(context)!.history,
                isDark: isDark,
              ),
              if (widget.userData.showWalletFeatureOnMobileApp == '1')
                _buildNavItem(
                  index: 2,
                  svgPath: 'assets/svg/Wallet.svg',
                  label: AppLocalizations.of(context)!.wallet,
                  isDark: isDark,
                  size: 22, // Slightly smaller to balance visually
                ),
              _buildNavItem(
                index: 3,
                svgPath: 'assets/svg/account.svg',
                label: AppLocalizations.of(context)!.myAccount,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String svgPath,
    required String label,
    required bool isDark,
    double size = 26,
  }) {
    final isSelected = _selectedIndex == index;

    final selectedColor = isDark
        ? AppColors.bottomNavigationBarSelectedColorDark
        : AppColors.primary;
    final unselectedColor = Colors.grey.shade500;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_selectedIndex == index) return;
        widget.onTap(index);
        if (index == 0) {
          context.read<HomeBloc>().add(GetDirectionEvent());
          context.read<HomeBloc>().add(GetUserDetailsEvent());
        }
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(
                isSelected ? selectedColor : unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 6),
            MyText(
              text: label,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
