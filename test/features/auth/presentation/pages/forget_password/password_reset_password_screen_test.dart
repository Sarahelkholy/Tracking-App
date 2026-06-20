import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_event.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_reset_password_screen.dart';
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

            return child!;
          },
          home: const PasswordResetPasswordScreen(),
        ),
      ),
    );
  }

  group('PasswordResetPasswordScreen Widget Tests', () {
    testWidgets('should render initial widgets', (tester) async {
      await pumpScreen(tester);

      expect(
        find.byKey(const Key(KeysStrings.resetPasswordTitle)),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key(KeysStrings.resetPasswordSubtitle)),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key(KeysStrings.newPasswordField)),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key(KeysStrings.confirmPasswordField)),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key(KeysStrings.confirmButtonResetPassword)),
        findsOneWidget,
      );
    });

    testWidgets('should show validation messages when fields are empty', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(
        find.byKey(const Key(KeysStrings.confirmButtonResetPassword)),
      );

      await tester.pump();

      expect(find.text(AppStrings.current.passwordRequired), findsOneWidget);

      expect(
        find.text(AppStrings.current.confirmPasswordRequired),
        findsOneWidget,
      );
    });

    testWidgets('should show password mismatch validation', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key(KeysStrings.newPasswordField)),
        'Aa@12345',
      );

      await tester.enterText(
        find.byKey(const Key(KeysStrings.confirmPasswordField)),
        'Aa@99999',
      );

      await tester.tap(
        find.byKey(const Key(KeysStrings.confirmButtonResetPassword)),
      );

      await tester.pump();

      expect(find.text(AppStrings.current.passwordsNotMatch), findsOneWidget);
    });

    testWidgets('should trigger ResetPasswordEvent when form is valid', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key(KeysStrings.newPasswordField)),
        'Aa@12345',
      );

      await tester.enterText(
        find.byKey(const Key(KeysStrings.confirmPasswordField)),
        'Aa@12345',
      );

      await tester.tap(
        find.byKey(const Key(KeysStrings.confirmButtonResetPassword)),
      );

      await tester.pump();

      verify(mockCubit.doEvents(argThat(isA<ResetPasswordEvent>()))).called(1);
    });

    testWidgets('should show loading indicator', (tester) async {
      await pumpScreen(
        tester,
        state: const ForgetPasswordState(
          email: 'test@test.com',
          resetPasswordState: BaseState(isLoading: true),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable text fields while loading', (tester) async {
      await pumpScreen(
        tester,
        state: const ForgetPasswordState(
          email: 'test@test.com',
          resetPasswordState: BaseState(isLoading: true),
        ),
      );

      final fields = tester.widgetList<TextFormField>(
        find.byType(TextFormField),
      );

      for (final field in fields) {
        expect(field.enabled, false);
      }
    });

    testWidgets('should toggle new password visibility', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.visibility), findsNWidgets(2));

      await tester.tap(
        find.byKey(const Key(KeysStrings.newPasswordVisibility)),
      );

      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should toggle confirm password visibility', (tester) async {
      await pumpScreen(tester);

      await tester.tap(
        find.byKey(const Key(KeysStrings.confirmPasswordVisibility)),
      );

      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
