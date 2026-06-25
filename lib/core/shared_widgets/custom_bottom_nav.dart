import 'package:flower_driver/config/di/di.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/orders/presentation/pages/home_screen.dart';
import '../../features/orders/presentation/pages/orders_screen.dart';
import '../../features/orders/presentation/pages/profile_screen.dart';
import '../shared_widgets/svg_wrapper.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key, this.initialIndex = 0});

  final int initialIndex;

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

    screens = [
      BlocProvider(
        create: (context) => getIt<HomeCubit>(),
        child: const HomeScreen(),
      ),
      const OrdersScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

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

        destinations: [
          NavigationDestination(
            icon: const _BottomNavIcon(
              path: AppAssets.homeIcon,
              isSelected: false,
            ),

            selectedIcon: const _BottomNavIcon(
              path: AppAssets.homeIcon,
              isSelected: true,
            ),

            label: local.home,
          ),

          NavigationDestination(
            icon: const _BottomNavIcon(
              path: AppAssets.orders,
              isSelected: false,
            ),

            selectedIcon: const _BottomNavIcon(
              path: AppAssets.orders,
              isSelected: true,
            ),

            label: local.orders,
          ),

          NavigationDestination(
            icon: const _BottomNavIcon(
              path: AppAssets.personIcon,
              isSelected: false,
            ),

            selectedIcon: const _BottomNavIcon(
              path: AppAssets.personIcon,
              isSelected: true,
            ),

            label: local.profile,
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
