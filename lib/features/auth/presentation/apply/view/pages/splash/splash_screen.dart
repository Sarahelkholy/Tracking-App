import 'package:flutter/material.dart';
import '../../../../../../../config/route_manager/routes.dart';
import '../../../../../../../core/shared_widgets/svg_wrapper.dart';
import '../../../../../../../core/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.applyRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Hero(
          tag: 'app_logo',
          child: SvgWrapper(
            path: 'assets/icons/app_logo.svg',
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}
