import 'package:flutter/material.dart';

import '../shared_widgets/svg_wrapper.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    super.key,
    this.initialIndex = 0,
    this.categoryIndex = 0,
  });

  final int initialIndex;
  final int categoryIndex;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    screens = [];
  }

  @override
  Widget build(BuildContext context) {
    // final local = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          if (currentIndex == index) return;
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: false,
            ),

            selectedIcon: _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: true,
            ),

            label: 'home',
          ),

          NavigationDestination(
            icon: const _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: false,
            ),

            selectedIcon: const _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: true,
            ),

            label: 'local.categories',
          ),

          NavigationDestination(
            icon: const _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: false,
            ),

            selectedIcon: const _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: true,
            ),

            label: 'cart',
          ),

          NavigationDestination(
            icon: const _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: false,
            ),

            selectedIcon: const _BottomNavIcon(
              path: AppAssets.appLogo,
              isSelected: true,
            ),

            label: 'profile',
          ),
        ],
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({required this.path, required this.isSelected});

  final String path;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SvgWrapper(
      path: path,
      width: 24,
      height: 24,
      color: isSelected ? AppColors.primaryColor : AppColors.disabledGray,
    );
  }
}
