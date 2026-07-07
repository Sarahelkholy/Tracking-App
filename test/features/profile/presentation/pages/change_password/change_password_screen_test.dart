import 'dart:async';
import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/profile/presentation/manager/change_password_cubit/change_password_cubit.dart';
import 'package:flower_driver/features/profile/presentation/manager/change_password_cubit/change_password_state.dart';
import 'package:flower_driver/features/profile/presentation/pages/change_password/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_screen_test.mocks.dart';

@GenerateMocks([ChangePasswordCubit])
void main() {
  late MockChangePasswordCubit mockCubit;
  late StreamController<BaseEvent> eventController;

  setUp(() {
    mockCubit = MockChangePasswordCubit();
    eventController = StreamController<BaseEvent>();

    when(mockCubit.state)
        .thenReturn(const ChangePasswordState());

    when(mockCubit.stream)
        .thenAnswer((_) => const Stream<ChangePasswordState>.empty());

    when(mockCubit.eventStream)
        .thenAnswer((_) => eventController.stream);
  });

  tearDown(() async {
    await eventController.close();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<ChangePasswordCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          localizationsDelegates:
          AppLocalizations.localizationsDelegates,
          supportedLocales:
          AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          builder: (context, child) {
            final localizations = AppLocalizations.of(context);
            if (localizations != null) {
              AppStrings.current = localizations;
            }
            return child ?? const SizedBox();
          },
          home: const ChangePasswordScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('Change Password Screen Widget Tests', () {
    testWidgets('should render initial widgets', (tester) async {
      await pumpScreen(tester);

      ///? Check Text resetPassword
      expect(find.text(AppStrings.current.resetPassword), findsOneWidget,);

      ///? Check Text currentPassword
      expect(find.text(AppStrings.current.currentPassword), findsNWidgets(2),);

      ///? Check Text newPassword
      expect(find.text(AppStrings.current.newPassword), findsNWidgets(2),);

      ///? Check Text Update
      expect(find.text(AppStrings.current.update), findsOneWidget,);

      ///? Check Number of text form fields
      expect(find.byType(TextFormField), findsNWidgets(2),);

      ///? Check Number of text
      expect(find.byType(Text), findsNWidgets(6),);

      ///? Check form
      expect(find.byType(Form), findsOneWidget);

      ///? Password is required
      expect(find.text(AppStrings.current.passwordRequired), findsNothing,);

      ///? Password must be at least 6 characters
      expect(find.text(AppStrings.current.passwordTooShort), findsNothing,);

      ///? "Password must contain uppercase, lowercase, number, and special character
      expect(find.text(AppStrings.current.passwordValid), findsNothing,);

      ///? 
      expect(
        find.byWidgetPredicate((widget) =>
          widget is Text && widget.data ==AppStrings.current.update
        )
            ,findsOneWidget
      );
    });
  });
}