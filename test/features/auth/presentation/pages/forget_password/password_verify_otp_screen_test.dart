@GenerateMocks([ForgetPasswordCubit])
import 'package:bloc_test/bloc_test.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'password_verify_otp_screen_test.mocks.dart';

void main() {
  late MockForgetPasswordCubit cubit;

  setUp(() {
    cubit = MockForgetPasswordCubit();

    when(
      cubit.state,
    ).thenReturn(const ForgetPasswordState(email: 'test@test.com'));

    whenListen(
      cubit,
      Stream.value(const ForgetPasswordState(email: 'test@test.com')),
      initialState: const ForgetPasswordState(email: 'test@test.com'),
    );
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<ForgetPasswordCubit>.value(
        value: cubit,
        child: const PasswordVerifyOtpScreen(),
      ),
    );
  }

  group('PasswordVerifyOtpScreen', () {
    testWidgets('should render title and subtitle', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byKey(const Key(KeysStrings.verifyOtpTitle)), findsOneWidget);

      expect(
        find.byKey(const Key(KeysStrings.verifyOtpSubtitle)),
        findsOneWidget,
      );
    });

    testWidgets('should show resend text when timer equals zero', (
      tester,
    ) async {
      const state = ForgetPasswordState(
        email: 'test@test.com',
        resendSeconds: 0,
      );

      when(cubit.state).thenReturn(state);

      whenListen(cubit, Stream.value(state), initialState: state);

      await tester.pumpWidget(buildWidget());

      expect(find.byKey(const Key(KeysStrings.resendText)), findsOneWidget);
    });

    testWidgets('should show timer when resendSeconds greater than zero', (
      tester,
    ) async {
      const state = ForgetPasswordState(
        email: 'test@test.com',
        resendSeconds: 30,
      );

      when(cubit.state).thenReturn(state);

      whenListen(cubit, Stream.value(state), initialState: state);

      await tester.pumpWidget(buildWidget());

      expect(find.byKey(const Key(KeysStrings.timerText)), findsOneWidget);

      expect(find.text('00:30'), findsOneWidget);
    });

    testWidgets('should call resend event when resend tapped', (tester) async {
      const state = ForgetPasswordState(
        email: 'test@test.com',
        resendSeconds: 0,
      );

      when(cubit.state).thenReturn(state);

      await tester.pumpWidget(buildWidget());

      await tester.tap(find.byKey(const Key(KeysStrings.resendText)));

      verify(cubit.doEvents(any)).called(1);
    });
  });
}
