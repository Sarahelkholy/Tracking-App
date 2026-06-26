import 'package:flower_driver/features/auth/presentation/manager/apply_cubit/apply_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/apply_cubit/apply_intents.dart';
import 'package:flower_driver/features/auth/presentation/widgets/apply/apply_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations_en.dart';


class MockApplyCubit extends MockCubit<ApplyState> implements ApplyCubit {}

void main() {
  late MockApplyCubit mockApplyCubit;

  setUpAll(() {
    // Use a concrete intent as fallback since ApplyIntents is sealed
    registerFallbackValue(SelectCountryIntent('US'));
    AppStrings.current = AppLocalizationsEn();
  });

  setUp(() {
    mockApplyCubit = MockApplyCubit();
    when(() => mockApplyCubit.state).thenReturn(ApplyState.initial());
    // Stub async handleIntent to avoid Null returned error
    when(() => mockApplyCubit.handleIntent(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ApplyCubit>.value(
        value: mockApplyCubit,
        child: const ApplyScreen(),
      ),
    );
  }

  group('ApplyScreen Widget Tests', () {
    testWidgets('renders ApplyScreen form correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.current.apply), findsOneWidget);
      expect(find.text(AppStrings.current.welcome), findsOneWidget);
      expect(find.text(AppStrings.current.firstLegalName), findsOneWidget);
      expect(find.text(AppStrings.current.email), findsOneWidget);
      expect(find.text(AppStrings.current.continueText), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submission', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final continueButton = find.text(AppStrings.current.continueText);
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.current.emptyField), findsWidgets);
      expect(find.text(AppStrings.current.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.current.passwordRequired), findsOneWidget);
      expect(
        find.text(AppStrings.current.confirmPasswordRequired),
        findsOneWidget,
      );
    });

    testWidgets('shows success view when state isSuccess is true', (
      tester,
    ) async {
      when(
        () => mockApplyCubit.state,
      ).thenReturn(ApplyState.initial().copyWith(isSuccess: true));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(
        find.text(AppStrings.current.applicationSubmitted),
        findsOneWidget,
      );
      expect(find.text(AppStrings.current.reviewApplication), findsOneWidget);
      expect(find.text(AppStrings.current.login), findsOneWidget);
    });
  });
}
