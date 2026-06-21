import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weeklet/domain/entities/settings.dart';
import 'package:weeklet/presentation/blocs/settings/settings_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_event.dart';
import 'package:weeklet/presentation/blocs/settings/settings_state.dart';
import 'package:weeklet/presentation/screens/settings/settings_screen.dart';
import '../../../helpers/test_app.dart';

// ---------------------------------------------------------------------------
// Mock declarations
// MockBloc<E, S> from bloc_test does not extend the concrete BLoC subclass.
// Using `implements SettingsBloc` allows BlocProvider<SettingsBloc>.value().
// ---------------------------------------------------------------------------

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockSettingsBloc mockSettingsBloc;

  setUpAll(() {
    // Concrete subclasses used as fallback values — sealed classes cannot be
    // implemented with Fake outside their defining library.
    registerFallbackValue(const LoadSettingsRequested());
    registerFallbackValue(const SettingsInitial());

    // PackageInfo stub — prevents MissingPluginException when
    // SettingsScreen's initState calls PackageInfo.fromPlatform().
    PackageInfo.setMockInitialValues(
      appName: 'Weeklet',
      packageName: 'com.weeklet.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();

    when(() => mockSettingsBloc.state)
        .thenReturn(SettingsLoaded(settings: Settings.defaults()));
    whenListen(
      mockSettingsBloc,
      const Stream<SettingsState>.empty(),
      initialState: SettingsLoaded(settings: Settings.defaults()),
    );

    GetIt.instance.registerSingleton<SettingsBloc>(mockSettingsBloc);
  });

  tearDown(() async => GetIt.instance.reset());

  Future<void> pumpSettingsScreen(WidgetTester tester) => pumpApp(
    tester,
    const SettingsScreen(),
    providers: [
      BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
    ],
  );

  group('SettingsScreen', () {
    testWidgets(
      'shows CircularProgressIndicator when state is SettingsInitial',
      (tester) async {
        when(() => mockSettingsBloc.state).thenReturn(const SettingsInitial());
        whenListen(
          mockSettingsBloc,
          const Stream<SettingsState>.empty(),
          initialState: const SettingsInitial(),
        );

        await pumpSettingsScreen(tester);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'shows CircularProgressIndicator when state is SettingsLoading',
      (tester) async {
        when(() => mockSettingsBloc.state)
            .thenReturn(const SettingsLoading());
        whenListen(
          mockSettingsBloc,
          const Stream<SettingsState>.empty(),
          initialState: const SettingsLoading(),
        );

        await pumpSettingsScreen(tester);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders settings list when SettingsLoaded',
      (tester) async {
        await pumpSettingsScreen(tester);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
        // Biometric switch is visible in the Security section
        expect(find.byType(Switch), findsOneWidget);
      },
    );

    testWidgets(
      'dispatches BiometricToggled when biometric switch is tapped',
      (tester) async {
        await pumpSettingsScreen(tester);
        await tester.pump();

        await tester.tap(find.byType(Switch).first);
        await tester.pump();

        verify(
          () => mockSettingsBloc.add(any(that: isA<BiometricToggled>())),
        ).called(1);
      },
    );
  });
}
