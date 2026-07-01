import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/driver/manager/driver_state.dart';
import 'package:flower_driver/core/helpers/app_snack_bar.dart';
import 'package:flower_driver/core/helpers/show_session_expired_dialog.dart';
import 'package:flower_driver/core/local_cubit/locale_cubit.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_bottom_nav.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/theme/app_theme.dart';
import 'package:flower_driver/core/utils/app_constants.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/presentation/manager/login/login_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/login/login_state.dart';
import 'package:flower_driver/features/auth/presentation/pages/login/login_screen.dart';
import 'package:flower_driver/features/auth/presentation/widgets/login_form.dart';
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
    ///assign the mocks

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
    expect(find.byType(LoginForm), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) {
        return widget is Checkbox && widget.value == false;
      }),
      findsOneWidget,
    );
    expect(find.byType(CustomButton), findsOneWidget);

    expect(
      find.byWidgetPredicate((widget) {
        return widget is CustomButton &&
            widget.title == AppStrings.current.login &&
            widget.isLoading == false;
      }),
      findsOneWidget,
    );
  });
  testWidgets('test LoginLoadingState', (WidgetTester tester) async {
    /// Arrange
    when(mockLoginCubit.state).thenReturn(const LoginLoading());
    when(mockLoginCubit.stream).thenAnswer((_) {
      return Stream<LoginState>.value(const LoginLoading());
    });

    /// Act
    await tester.pumpWidget(
      intiView(mockLoginCubit, mockDriverCubit, mockLocaleCubit),
    );

    /// Assert
    expect(
      find.byWidgetPredicate((widget) {
        return widget is CustomButton &&
            widget.title == AppStrings.current.login &&
            widget.isLoading == true;
      }),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
            (widget) =>
        widget is ElevatedButton &&
            widget.child is SizedBox &&
            (widget.child as SizedBox).child is CircularProgressIndicator,
      ),
      findsOneWidget,
    );
  });
  testWidgets('test LoginSuccessState', (WidgetTester tester) async {
    /// Arrange
    const msg = 'Success';
    when(
      mockLoginCubit.state,
    ).thenReturn(LoginSuccess(authResponse: AuthResponse(message: msg)));
    when(mockLoginCubit.stream).thenAnswer((_) {
      return Stream<LoginState>.value(
        LoginSuccess(authResponse: AuthResponse(message: msg)),
      );
    });

    /// Act
    await tester.pumpWidget(
      intiView(mockLoginCubit, mockDriverCubit, mockLocaleCubit),
    );
    await tester.pumpAndSettle();

    /// Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(CustomBottomNavBar), findsOneWidget);
  });
  testWidgets('test LoginFailureState', (widgetTester) async {
    final errorMsg = "error";

    ///Arrange
    when(mockLoginCubit.state).thenReturn(LoginFailure(errorMessage: errorMsg));
    when(mockLoginCubit.stream).thenAnswer((_) =>
    Stream<LoginState>.value(LoginFailure(errorMessage: errorMsg)));

    /// Act
    await  widgetTester.pumpWidget(intiView(mockLoginCubit, mockDriverCubit, mockLocaleCubit));
    await widgetTester.pumpAndSettle();
    ///Assert

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });



  testWidgets('test validation', (tester) async {
    /// Arrange

    when(mockLoginCubit.state).thenReturn(const LoginInitial());
    when(mockLoginCubit.stream).thenAnswer((_) {
      return Stream<LoginState>.value(const LoginInitial());
    });

    /// Act
    await tester.pumpWidget(
      intiView(mockLoginCubit, mockDriverCubit, mockLocaleCubit),
    );

    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}

Widget intiView(MockLoginCubit mockLoginCubit,
    MockDriverCubit mockDriverCubit,
    MockLocaleCubit mockLocaleCubit,) {
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

          onGenerateRoute: (settings) {
            final args = settings.arguments as Map<String, dynamic>?;

            return MaterialPageRoute(
              builder: (_) =>
                  CustomBottomNavBar(initialIndex: args?['initialIndex'] ?? 0),
            );
          },
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
