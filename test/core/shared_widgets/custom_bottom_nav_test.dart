import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_cubit.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_cubit.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_state.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockHomeCubit extends Mock implements HomeCubit {}
class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    getIt.registerFactory<HomeCubit>(() => MockHomeCubit());
    getIt.registerFactory<ProfileCubit>(() => MockProfileCubit());
  });

  tearDown(() {
    getIt.reset();
  });
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ar')],
      home: Scaffold(body: CustomBottomNavBar()),
    );
  }

  testWidgets('test navbar structure', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final NavigationBar navBar = tester.widget(find.byType(NavigationBar));
    expect(navBar.selectedIndex, equals(0));
    expect(find.byType(NavigationDestination), findsNWidgets(3));
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text('Home'), findsOneWidget);

    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('test when click on orders icon ', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is NavigationDestination && widget.label == 'Orders',
      ),
    );

    await tester.pump();

    final NavigationBar navBar = tester.widget(find.byType(NavigationBar));
    expect(navBar.selectedIndex, equals(1));

    expect(find.byType(NavigationDestination), findsNWidgets(3));
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Orders Screen'), findsOneWidget);
  });

  testWidgets('test when click on profile icon ', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is NavigationDestination && widget.label == 'Profile',
      ),
    );

    await tester.pump();

    final NavigationBar navBar = tester.widget(find.byType(NavigationBar));
    expect(navBar.selectedIndex, equals(2));

    expect(find.byType(NavigationDestination), findsNWidgets(3));
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Profile Screen'), findsOneWidget);
  });
}
