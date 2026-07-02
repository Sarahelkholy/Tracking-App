import 'dart:async';

import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/driver/manager/driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/driver/manager/driver_events.dart';
import '../../../../../config/route_manager/routes.dart';
import '../../../../../config/secure_cache/secure_cache/cache_keys.dart';
import '../../../../../config/secure_cache/secure_cache/secure_cache.dart';
import '../../../../../core/shared_widgets/svg_wrapper.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../manager/splash_cubit/spalsh_events.dart';
import '../../manager/splash_cubit/splash_cubit.dart';
import '../../manager/splash_cubit/splash_state.dart';

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
  final Completer<void> _acceptedOrderDone = Completer<void>();

  late final SplashCubit splashCubit;

  @override
  void initState() {
    super.initState();
    splashCubit = context.read<SplashCubit>();
    _setupAnimation();
    _checkUser();
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

  void _checkUser() async {
    final cubit = context.read<DriverCubit>();
    final secureCache = getIt<SecureCache>();

    final token = await secureCache.getData(key: CacheKeys.token);
    final rememberMe = await secureCache.getData(key: CacheKeys.rememberMe);

    if (!mounted) return;

    if (token != null && token.isNotEmpty && rememberMe == 'true') {
      cubit.doEvent(GetDriverDataEvent());
    } else {
      if (!_dataResult.isCompleted) {
        _dataResult.complete(false);
      }
      if (!_acceptedOrderDone.isCompleted) {
        _acceptedOrderDone.complete();
      }
    }
  }

  Future<void> _waitAndNavigate() async {
    final results = await Future.wait([
      _animationDone.future,
      _dataResult.future,
      _acceptedOrderDone.future,
    ]);

    if (!mounted) return;

    final isSuccess = results[1] as bool;

    if (isSuccess) {
      if (splashCubit.state.acceptedOrder != null) {
        _replaceTo(Routes.activeOrderDetails);
      } else {
        _replaceTo(Routes.bottomNavBarRoute);
      }
    } else {
      _replaceTo(Routes.onboardingRoute);
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<DriverCubit, DriverState>(
            listener: (context, state) {
              if (state.isUnauthorized) {
                if (!_dataResult.isCompleted) {
                  _dataResult.complete(false);
                }
                if (!_acceptedOrderDone.isCompleted) {
                  _acceptedOrderDone.complete();
                }
                return;
              }

              if (_dataResult.isCompleted) return;

              if (state.driver != null) {
                splashCubit.doIntent(GetAcceptedOrder(state.driver!.id!));
                _dataResult.complete(true);
              } else if (state.error != null) {
                _dataResult.complete(false);
                if (!_acceptedOrderDone.isCompleted) {
                  _acceptedOrderDone.complete();
                }
              }
            },
          ),
          BlocListener<SplashCubit, SplashState>(
            listener: (context, state) {
              if (!state.isLoading && !_acceptedOrderDone.isCompleted) {
                _acceptedOrderDone.complete();
              }
            },
          ),
        ],
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
