import 'package:flower_driver/apply_screen.dart';
import 'package:flower_driver/config/di/di.dart';
import 'package:flower_driver/config/route_manager/route_generator.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/secure_cache.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/features/auth/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:flower_driver/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/annotations.dart';

import 'onboarding_screen_test.mocks.dart';

@GenerateMocks([SecureCache])
void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ar')],
      home: OnboardingScreen(),
      onGenerateRoute: RouteGenerator.getRoute,
    );
  }

  AppLocalizations Local(WidgetTester tester) {
    final context = tester.element(find.byType(OnboardingScreen));
    return AppLocalizations.of(context)!;
  }

  setUp(() {
    getIt.registerSingleton<SecureCache>(MockSecureCache());
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('onboarding screen structure ', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(createWidgetUnderTest());

    final local = Local(tester);

    expect(find.byType(Lottie), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text(local.login), findsOneWidget);

    expect(find.text(local.onboardingText), findsOneWidget);
    expect(find.text(local.applyNow), findsOneWidget);
    expect(find.text('v 6.3.0 - (446)'), findsOneWidget);
  });

  testWidgets('tap login button navigates to login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final local = Local(tester);

    await tester.tap(find.text(local.login));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('tap apply now button navigates to apply screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final local = Local(tester);

    await tester.tap(find.text(local.applyNow));
    await tester.pumpAndSettle();

    expect(find.byType(ApplyScreen), findsOneWidget);
  });
}
