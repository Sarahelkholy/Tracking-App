import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_enter_email_screen.dart';
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
    eventController = StreamController<BaseEvent>();

    when(mockCubit.state).thenReturn(const ForgetPasswordState());

    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockCubit.eventStream).thenAnswer((_) => eventController.stream);
  });

  tearDown(() async {
    await eventController.close();
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
          home: const PasswordEnterEmailScreen(),
        ),
      ),
    );
  }

  group('PasswordEnterEmailScreen Widget Tests', () {
    testWidgets('should render initial widgets', (tester) async {
      await pumpScreen(tester);

      expect(
        find.byKey(const Key(KeysStrings.enterEmailAppBar)),
        findsOneWidget,
      );

      expect(find.byKey(const Key(KeysStrings.titleText)), findsOneWidget);

      expect(find.byKey(const Key(KeysStrings.subtitleText)), findsOneWidget);

      expect(find.byKey(const Key(KeysStrings.emailTextField)), findsOneWidget);

      expect(find.byKey(const Key(KeysStrings.confirmButtonEnterEmail)), findsOneWidget);
    });

    testWidgets('should not show loading indicator initially', (tester) async {
      await pumpScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should enable email field initially', (tester) async {
      await pumpScreen(tester);

      final textField = tester.widget<TextFormField>(
        find.byKey(const Key(KeysStrings.emailTextField)),
      );

      expect(textField.enabled, true);
    });

    testWidgets('should show email required validation', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.byKey(const Key(KeysStrings.confirmButtonEnterEmail)));

      await tester.pump();

      expect(find.text(AppStrings.current.emailRequired), findsOneWidget);
    });

    testWidgets('should show invalid email validation', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key(KeysStrings.emailTextField)),
        'invalid-email',
      );

      await tester.tap(find.byKey(const Key(KeysStrings.confirmButtonEnterEmail)));

      await tester.pump();

      expect(find.text(AppStrings.current.emailInvalid), findsOneWidget);
    });

    testWidgets('should remove validation error when email becomes valid', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(find.byKey(const Key(KeysStrings.confirmButtonEnterEmail)));

      await tester.pump();

      expect(find.text(AppStrings.current.emailRequired), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key(KeysStrings.emailTextField)),
        'test@test.com',
      );

      await tester.pump();

      expect(find.text(AppStrings.current.emailRequired), findsNothing);
    });

    testWidgets('should show loading indicator', (tester) async {
      when(mockCubit.state).thenReturn(
        const ForgetPasswordState(sendEmailState: BaseState(isLoading: true)),
      );

      await pumpScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable email field while loading', (tester) async {
      when(mockCubit.state).thenReturn(
        const ForgetPasswordState(sendEmailState: BaseState(isLoading: true)),
      );

      await pumpScreen(tester);

      final textField = tester.widget<TextFormField>(
        find.byKey(const Key(KeysStrings.emailTextField)),
      );

      expect(textField.enabled, false);
    });

    testWidgets(
      'should show loading indicator and disable interactions while loading',
      (tester) async {
        when(mockCubit.state).thenReturn(
          const ForgetPasswordState(sendEmailState: BaseState(isLoading: true)),
        );

        await pumpScreen(tester);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        final textField = tester.widget<TextFormField>(
          find.byKey(const Key(KeysStrings.emailTextField)),
        );

        expect(textField.enabled, false);
      },
    );

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
