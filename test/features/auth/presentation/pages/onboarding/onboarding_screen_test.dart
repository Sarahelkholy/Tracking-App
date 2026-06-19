import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/features/auth/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

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
    );
  }

  testWidgets('onboarding screen structure ', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(Lottie), findsOneWidget);
    expect(find.byType(CustomButton), findsNWidgets(2));
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text('Login'), findsOneWidget);

    expect(find.text('Welcome to\nFlowery rider app'), findsOneWidget);
    expect(find.text('Apply now'), findsOneWidget);
    expect(find.text('v 6.3.0 - (446)'), findsOneWidget);
  });
}
