import 'dart:ui';
import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double topPadding;

  const BottomNav({super.key, required this.currentIndex, required this.onTap, this.topPadding = 12});

  @override
  Widget build(BuildContext context) {
    const selectedColor = primaryColor;
    final unselectedColor = Colors.white.withValues(alpha: 0.78);

    final noRippleTheme = Theme.of(context).copyWith(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
          ),
          child: SafeArea(
            top: false,
            child: Theme(
              data: noRippleTheme,
              child: Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  currentIndex: currentIndex,
                  onTap: onTap,
                  selectedLabelStyle: defaultWhiteTextStyle,
                  unselectedLabelStyle: defaultWhiteTextStyle,
                  selectedItemColor: selectedColor,
                  unselectedItemColor: unselectedColor,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedFontSize: 15.sp,
                  unselectedFontSize: 15.sp,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_rounded),
                      label: context.t('home'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore_outlined),
                      activeIcon: Icon(Icons.explore),
                      label: context.t('explore'),
                    ),

                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border_outlined),
                      activeIcon: Icon(Icons.favorite_rounded),
                      label: context.t('favorites'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: context.t('profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
