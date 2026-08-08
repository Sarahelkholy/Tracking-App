/*
import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_dialog_test.mocks.dart';

@GenerateMocks([LogoutCubit])
void main() {
  late MockLogoutCubit mockLogoutCubit;

  setUp(() {
    mockLogoutCubit = MockLogoutCubit();
  });

  Widget createWidgetUnderTest(LogoutState state) {
    when(mockLogoutCubit.state).thenReturn(state);

    return MaterialApp(
      routes: {
        Routes.loginRoute: (_) => const Scaffold(body: Text('Login Screen')),
      },
      home: BlocProvider<LogoutCubit>.value(
        value: mockLogoutCubit,
        child: Localizations(
          locale: const Locale('en'),
          delegates: const [AppLocalizations.delegate],
          child: const LogoutDialog(),
        ),
      ),
    );
  }

  testWidgets('renders logout dialog correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(LogoutInitial()));

    await tester.pumpAndSettle();

    expect(find.textContaining('LOGOUT'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('calls logout event when logout button pressed', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(LogoutInitial()));

    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pump();

    verify(mockLogoutCubit.doEvents(any)).called(1);
  });

  testWidgets('shows loading state when LogoutLoading', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(LogoutLoading()));

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('navigates to login screen on success', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        LogoutSuccess(
          logoutResponseEntity: LogoutResponseEntity(message: 'ok'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Login Screen'), findsOneWidget);
  });

  testWidgets('shows snackbar on failure', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(LogoutFailure(errorMessage: 'Error')),
    );

    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });
}
*/
