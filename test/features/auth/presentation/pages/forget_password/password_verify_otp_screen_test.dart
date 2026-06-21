import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/core/helpers/app_snack_bar.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_event.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_verify_otp_screen.dart';
import 'package:flower_driver/features/auth/presentation/widgets/forget_password/custom_otp_field.dart';
import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'password_verify_otp_screen_test.mocks.dart';

@GenerateMocks([ForgetPasswordCubit])
void main() {
  late MockForgetPasswordCubit mockCubit;
  late StreamController<ForgetPasswordState> stateController;
  late StreamController<BaseEvent> eventController;

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    stateController = StreamController<ForgetPasswordState>.broadcast();
    eventController = StreamController<BaseEvent>.broadcast();

    when(mockCubit.state).thenReturn(const ForgetPasswordState());
    when(mockCubit.stream).thenAnswer((_) => stateController.stream);
    when(mockCubit.eventStream).thenAnswer((_) => eventController.stream);
  });

  tearDown(() async {
    await stateController.close();
    await eventController.close();
  });

  // A local wrapper to handle events exactly like the app does
  // This makes the test look professional and avoids stream subscription errors
  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<ForgetPasswordCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => Scaffold(body: Text(settings.name ?? '')),
          ),
          builder: (context, child) {
            AppStrings.current = AppLocalizations.of(context)!;
            return child!;
          },
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Subscription for testing side effects like SnackBars and Navigation
                mockCubit.eventStream.listen((event) {
                  if (event is DisplayErrorEvent) {
                    AppSnackBar.error(context, event.errorMsg);
                  } else if (event is NavigationEvent) {
                    Navigator.pushNamed(context, event.routeName);
                  }
                });
                return const PasswordVerifyOtpScreen();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('PasswordVerifyOtpScreen Widget Tests', () {
    testWidgets('Initial UI should render correctly with styles', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.text(AppStrings.current.password), findsOneWidget);
      expect(find.text(AppStrings.current.emailVerification), findsOneWidget);
      expect(find.byType(CustomOtpField), findsOneWidget);
      expect(find.text(AppStrings.current.resend), findsOneWidget);

      expect(
        tester
            .widget<Text>(find.byKey(const Key(KeysStrings.verifyOtpSubtitle)))
            .style
            ?.color,
        AppColors.grayDark,
      );
    });

    testWidgets('Entering OTP should trigger VerifyOtpEvent', (tester) async {
      await pumpScreen(tester);

      tester
          .widget<CustomOtpField>(find.byType(CustomOtpField))
          .onCompleted('123456');

      await tester.pump();
      verify(mockCubit.doEvents(argThat(isA<VerifyOtpEvent>()))).called(1);
    });

    testWidgets('Should handle loading state correctly', (tester) async {
      when(mockCubit.state).thenReturn(
        const ForgetPasswordState(verifyOtpState: BaseState(isLoading: true)),
      );

      await pumpScreen(tester);

      expect(
        tester.widget<CustomOtpField>(find.byType(CustomOtpField)).isLoading,
        true,
      );
      expect(
        tester.widget<PinCodeTextField>(find.byType(PinCodeTextField)).enabled,
        false,
      );
    });

    testWidgets('Should show SnackBar on error event', (tester) async {
      await pumpScreen(tester);

      const errorMessage = 'Invalid Code';
      eventController.add(const DisplayErrorEvent(errorMsg: errorMessage));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('Should navigate to next screen on navigation event', (
      tester,
    ) async {
      await pumpScreen(tester);

      eventController.add(
        const NavigationEvent(
          routeName: Routes.resetPasswordRoute,
          type: NavigationType.push,
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(Routes.resetPasswordRoute), findsOneWidget);
    });

    testWidgets('Timer logic should work correctly', (tester) async {
      when(
        mockCubit.state,
      ).thenReturn(const ForgetPasswordState(resendSeconds: 30));

      await pumpScreen(tester);

      expect(find.text('00:30'), findsOneWidget);
      expect(find.byKey(const Key(KeysStrings.resendText)), findsNothing);

      expect(
        tester
            .widget<Text>(find.byKey(const Key(KeysStrings.timerText)))
            .style
            ?.color,
        AppColors.primaryColor,
      );
    });

    testWidgets('Should trigger ResendOtpEvent on button click', (
      tester,
    ) async {
      const email = 'user@test.com';
      when(
        mockCubit.state,
      ).thenReturn(const ForgetPasswordState(resendSeconds: 0, email: email));

      await pumpScreen(tester);

      await tester.tap(find.byKey(const Key(KeysStrings.resendText)));
      await tester.pump();

      verify(mockCubit.doEvents(argThat(isA<ResendOtpEvent>()))).called(1);
    });

    testWidgets('OTP field should reset on state error', (tester) async {
      await pumpScreen(tester);

      stateController.add(
        const ForgetPasswordState(
          verifyOtpState: BaseState(errorMessage: 'Error'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const ValueKey(1)), findsOneWidget);
    });
  });
}
