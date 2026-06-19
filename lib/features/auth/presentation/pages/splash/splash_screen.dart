import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/di/di.dart';
import '../../../../../config/driver/manager/driver_cubit.dart';
import '../../../../../config/driver/manager/driver_events.dart';
import '../../../../../config/driver/manager/driver_state.dart';
import '../../../../../config/route_manager/routes.dart';
import '../../../../../config/secure_cache/secure_cache/cache_keys.dart';
import '../../../../../config/secure_cache/secure_cache/secure_cache.dart';
import '../../../../../core/shared_widgets/svg_wrapper.dart';
import '../../../../../core/utils/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final Completer<void> _animationDone = Completer<void>();
  final Completer<bool> _dataResult = Completer<bool>();
  final Completer<bool> _onboardingResult = Completer<bool>();

  bool _stopNavigation = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _checkDriverAndOnboarding();
    _waitAndNavigate();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_animationDone.isCompleted) {
        _animationDone.complete();
      }
    });
  }

  void _checkDriverAndOnboarding() async {
    final cubit = context.read<DriverCubit>();
    final secureCache = getIt<SecureCache>();

    final hasSeenOnboarding = await secureCache.getData(
      key: CacheKeys.hasSeenOnboarding,
    );

    if (hasSeenOnboarding != 'true') {
      _onboardingResult.complete(false);
      _dataResult.complete(false);
      return;
    } else {
      _onboardingResult.complete(true);
    }

    final token = await secureCache.getData(key: CacheKeys.token);
    final rememberMe = await secureCache.getData(key: CacheKeys.rememberMe);

    if (!mounted) return;

    if (token != null && token.isNotEmpty && rememberMe == 'true') {
      cubit.doEvent(GetDriverDataEvent());
    } else {
      if (!_dataResult.isCompleted) {
        _dataResult.complete(false);
      }
    }
  }

  void _waitAndNavigate() async {
    final results = await Future.wait([
      _animationDone.future,
      _dataResult.future,
      _onboardingResult.future,
    ]);

    if (!mounted || _stopNavigation) return;

    final isSuccess = results[1] as bool;
    final hasSeenOnboarding = results[2] as bool;

    if (!hasSeenOnboarding) {
      _replaceTo(Routes.onboardingRoute);
    } else if (isSuccess) {
      _replaceTo(Routes.bottomNavBarRoute);
    } else {
      _replaceTo(Routes.loginRoute);
    }
  }

  void _replaceTo(String routeName) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DriverCubit, DriverState>(
        listener: (context, state) {
          if (state.isUnauthorized) {
            _stopNavigation = true;

            if (!_dataResult.isCompleted) {
              _dataResult.complete(false);
            }
            return;
          }

          if (_dataResult.isCompleted) return;

          if (state.driver != null) {
            _dataResult.complete(true);
          } else if (state.error != null) {
            _dataResult.complete(false);
          }
        },
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: const SvgWrapper(
              path: AppAssets.appLogo,
              width: 240,
              height: 240,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
