import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/core/helpers/app_snack_bar.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_event.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_verify_otp_screen.dart';
import 'package:flower_driver/features/auth/presentation/widgets/forget_password/custom_otp_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'password_enter_email_screen_test.mocks.dart';

@GenerateMocks([ForgetPasswordCubit])
void main() {
  late MockForgetPasswordCubit mockCubit;
  late StreamController<BaseEvent> eventController;

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    eventController = StreamController<BaseEvent>.broadcast();

    when(
      mockCubit.state,
    ).thenReturn(const ForgetPasswordState(email: 'test@test.com'));

    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockCubit.eventStream).thenAnswer((_) => eventController.stream);
  });

  tearDown(() async {
    await eventController.close();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    ForgetPasswordState state = const ForgetPasswordState(
      email: 'test@test.com',
    ),
  }) async {
    when(mockCubit.state).thenReturn(state);

    await tester.pumpWidget(
      BlocProvider<ForgetPasswordCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          builder: (context, child) {
            AppStrings.current = AppLocalizations.of(context)!;

            return Scaffold(
              body: Builder(
                builder: (context) {
                  mockCubit.eventStream.listen((event) {
                    if (event is DisplayErrorEvent) {
                      AppSnackBar.error(context, event.errorMsg);
                    } else if (event is DisplaySuccessEvent) {
                      AppSnackBar.success(context, event.successMsg);
                    }
                  });
                  return child!;
                },
              ),
            );
          },
          home: const PasswordVerifyOtpScreen(),
        ),
      ),
    );
  }

  group('PasswordVerifyOtpScreen Widget Tests', () {
    testWidgets('should render initial widgets', (tester) async {
      await pumpScreen(tester);

      expect(find.byKey(const Key(KeysStrings.verifyOtpTitle)), findsOneWidget);

      expect(
        find.byKey(const Key(KeysStrings.verifyOtpSubtitle)),
        findsOneWidget,
      );

      expect(find.byType(CustomOtpField), findsOneWidget);

      expect(find.text(AppStrings.current.didNotReceiveCode), findsOneWidget);
    });

    testWidgets('should trigger VerifyOtpEvent when OTP is completed', (
      tester,
    ) async {
      await pumpScreen(tester);

      final otpField = tester.widget<CustomOtpField>(
        find.byType(CustomOtpField),
      );
      otpField.onCompleted('123456');

      await tester.pump();

      verify(mockCubit.doEvents(argThat(isA<VerifyOtpEvent>()))).called(1);
    });

    testWidgets('should show loading state', (tester) async {
      await pumpScreen(
        tester,
        state: const ForgetPasswordState(
          email: 'test@test.com',
          verifyOtpState: BaseState(isLoading: true),
        ),
      );

      final otpField = tester.widget<CustomOtpField>(
        find.byType(CustomOtpField),
      );
      expect(otpField.isLoading, isTrue);
    });

    testWidgets('should show timer when resendSeconds > 0', (tester) async {
      await pumpScreen(
        tester,
        state: const ForgetPasswordState(
          email: 'test@test.com',
          resendSeconds: 30,
        ),
      );

      expect(find.byKey(const Key(KeysStrings.timerText)), findsOneWidget);
      expect(find.text('00:30'), findsOneWidget);
    });

    testWidgets('should show resend button when resendSeconds is 0', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        state: const ForgetPasswordState(
          email: 'test@test.com',
          resendSeconds: 0,
        ),
      );

      expect(find.byKey(const Key(KeysStrings.resendText)), findsOneWidget);
    });

    testWidgets('should trigger ResendOtpEvent when resend is tapped', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        state: const ForgetPasswordState(
          email: 'test@test.com',
          resendSeconds: 0,
        ),
      );

      await tester.tap(find.byKey(const Key(KeysStrings.resendText)));
      await tester.pump();

      verify(mockCubit.doEvents(argThat(isA<ResendOtpEvent>()))).called(1);
    });

    testWidgets('should show error snackbar', (tester) async {
      await pumpScreen(tester);

      eventController.add(
        const DisplayErrorEvent(errorMsg: 'Something went wrong'),
      );

      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('should show success snackbar', (tester) async {
      await pumpScreen(tester);

      eventController.add(const DisplaySuccessEvent(successMsg: 'Success'));

      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Success'), findsOneWidget);
    });
  });
}
