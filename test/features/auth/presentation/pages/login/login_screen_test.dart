import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/driver/manager/driver_state.dart';
import 'package:flower_driver/core/helpers/show_session_expired_dialog.dart';
import 'package:flower_driver/core/local_cubit/locale_cubit.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/theme/app_theme.dart';
import 'package:flower_driver/core/utils/app_constants.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/auth/presentation/manager/login/login_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/login/login_state.dart';
import 'package:flower_driver/features/auth/presentation/pages/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([LoginCubit, DriverCubit, LocaleCubit])
late MockLoginCubit mockLoginCubit;
late MockDriverCubit mockDriverCubit;
late MockLocaleCubit mockLocaleCubit;

void main() {
  setUp(() {
    mockLoginCubit = MockLoginCubit();
    mockDriverCubit = MockDriverCubit();
    mockLocaleCubit = MockLocaleCubit();
   when(mockDriverCubit.state).thenReturn(DriverState());
    when(
      mockDriverCubit.stream,
    ).thenAnswer((_) => Stream<DriverState>.value(DriverState()));

    when(mockLocaleCubit.state).thenReturn(const Locale('en'));
    when(
      mockLocaleCubit.stream,
    ).thenAnswer((_) => Stream<Locale>.value(const Locale('en')));
  });

  testWidgets('test LoginInitialState', (WidgetTester tester) async {
    /// Arrange
    when(mockLoginCubit.state).thenReturn(const LoginInitial());
    when(mockLoginCubit.stream).thenAnswer((_) {
      return Stream<LoginState>.value(const LoginInitial());
    });

    ///ACT
    await tester.pumpWidget(
      intiView(mockLoginCubit, mockDriverCubit, mockLocaleCubit),
    );

    ///Assert
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

Widget intiView(
  MockLoginCubit mockLoginCubit,
  MockDriverCubit mockDriverCubit,
  MockLocaleCubit mockLocaleCubit,
) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<DriverCubit>(create: (context) => mockDriverCubit),
      BlocProvider<LocaleCubit>(create: (context) => mockLocaleCubit),
      BlocProvider<LoginCubit>(create: (context) => mockLoginCubit),
    ],
    child: BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          home: const LoginScreen(),
          navigatorKey: AppConstants.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Flower Driver APP',

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
