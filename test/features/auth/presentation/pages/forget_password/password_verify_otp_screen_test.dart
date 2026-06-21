import 'dart:async';

import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_loading_indicator.dart';
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
import 'package:pin_code_fields/pin_code_fields.dart';

import 'password_verify_otp_screen_test.mocks.dart';

@GenerateMocks([ForgetPasswordCubit])
void main() {
  late MockForgetPasswordCubit mockCubit;
  late StreamController<ForgetPasswordState> stateController;

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    stateController = StreamController<ForgetPasswordState>.broadcast();

    when(mockCubit.state).thenReturn(const ForgetPasswordState());
    when(mockCubit.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() async {
    await stateController.close();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<ForgetPasswordCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          builder: (context, child) {
            AppStrings.current = AppLocalizations.of(context)!;
            return child!;
          },
          home: const PasswordVerifyOtpScreen(),
        ),
      ),
    );
    await tester.pump();
  }

  group('PasswordVerifyOtpScreen Widget Tests', () {
    testWidgets('should render all initial widgets correctly', (tester) async {
      await pumpScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(AppStrings.current.password), findsOneWidget);

      expect(find.byKey(const Key(KeysStrings.verifyOtpTitle)), findsOneWidget);
      expect(find.text(AppStrings.current.emailVerification), findsOneWidget);

      expect(find.byType(CustomOtpField), findsOneWidget);
      expect(find.text(AppStrings.current.didNotReceiveCode), findsOneWidget);
      expect(find.byKey(const Key(KeysStrings.resendText)), findsOneWidget);
    });

    testWidgets('should trigger VerifyOtpEvent when OTP is completed', (
      tester,
    ) async {
      await pumpScreen(tester);

      final CustomOtpField otpField = tester.widget(
        find.byType(CustomOtpField),
      );
      otpField.onCompleted('123456');

      await tester.pump();

      verify(mockCubit.doEvents(argThat(isA<VerifyOtpEvent>()))).called(1);
    });

    testWidgets(
      'should show loading indicator inside OTP field when verifying',
      (tester) async {
        when(mockCubit.state).thenReturn(
          const ForgetPasswordState(verifyOtpState: BaseState(isLoading: true)),
        );

        await pumpScreen(tester);

        final otpField = tester.widget<CustomOtpField>(
          find.byType(CustomOtpField),
        );
        expect(otpField.isLoading, true);

        final pinField = tester.widget<PinCodeTextField>(
          find.byType(PinCodeTextField),
        );
        expect(pinField.enabled, false);
      },
    );

    testWidgets(
      'should show CustomLoadingIndicator instead of resend button when resending email',
      (tester) async {
        when(mockCubit.state).thenReturn(
          const ForgetPasswordState(sendEmailState: BaseState(isLoading: true)),
        );

        await pumpScreen(tester);

        expect(find.byKey(const Key(KeysStrings.resendText)), findsNothing);
        expect(find.byType(CustomLoadingIndicator), findsOneWidget);
      },
    );

    testWidgets('should show timer when resendSeconds is greater than 0', (
      tester,
    ) async {
      const seconds = 45;
      when(
        mockCubit.state,
      ).thenReturn(const ForgetPasswordState(resendSeconds: seconds));

      await pumpScreen(tester);

      expect(find.byKey(const Key(KeysStrings.timerText)), findsOneWidget);
      expect(find.text('00:45'), findsOneWidget);
      expect(find.byKey(const Key(KeysStrings.resendText)), findsNothing);
    });

    testWidgets('should trigger ResendOtpEvent when resend button is tapped', (
      tester,
    ) async {
      const email = 'test@example.com';
      when(
        mockCubit.state,
      ).thenReturn(const ForgetPasswordState(resendSeconds: 0, email: email));

      await pumpScreen(tester);

      await tester.tap(find.byKey(const Key(KeysStrings.resendText)));
      await tester.pump();

      verify(mockCubit.doEvents(argThat(isA<ResendOtpEvent>()))).called(1);
    });

    testWidgets('should shake and clear field on error in verifyOtpState', (
      tester,
    ) async {
      await pumpScreen(tester);

      const errorState = ForgetPasswordState(
        verifyOtpState: BaseState(errorMessage: 'Invalid OTP'),
      );

      stateController.add(errorState);
      await tester.pump();

      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const ValueKey(1)), findsOneWidget);
    });
  });
}
