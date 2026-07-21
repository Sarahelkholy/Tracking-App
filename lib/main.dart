import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/di/di.dart';
import 'config/driver/manager/driver_state.dart';
import 'config/route_manager/route_generator.dart';
import 'config/route_manager/routes.dart';
import 'core/helpers/custom_bloc_observer.dart';
import 'core/helpers/show_session_expired_dialog.dart';
import 'core/local_cubit/locale_cubit.dart';
import 'core/localization/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_constants.dart';
import 'core/values/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  configureDependencies();

  Bloc.observer = CustomBlocObserver();
  GoogleFonts.config.allowRuntimeFetching = false;

  // GetAllPendingOrdersUseCase useCase = getIt<GetAllPendingOrdersUseCase>()..call();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DriverCubit>()),

        BlocProvider(create: (_) => getIt<LocaleCubit>()..loadSavedLanguage()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            navigatorKey: AppConstants.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flower Driver APP',

            initialRoute: Routes.splashRoute,
            onGenerateRoute: RouteGenerator.getRoute,

            locale: locale,

            theme: AppTheme.appTheme(context),

            localizationsDelegates: AppLocalizations.localizationsDelegates,

            supportedLocales: AppLocalizations.supportedLocales,

            builder: (context, child) {
              AppStrings.current = AppLocalizations.of(context)!;

              return BlocListener<DriverCubit, DriverState>(
                listener: (context, state) {
                  if (state.isUnauthorized) {
                    showSessionExpiredDialog();
                  }
                },
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
