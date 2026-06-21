import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeklet/core/theme/theme.dart';
import 'package:weeklet/domain/entities/settings.dart';
import 'package:weeklet/presentation/blocs/settings/settings_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_event.dart';
import 'package:weeklet/presentation/blocs/settings/settings_state.dart';
import 'package:weeklet/presentation/blocs/stats/stats_bloc.dart';
import 'package:weeklet/presentation/blocs/stats/stats_event.dart';
import 'package:weeklet/presentation/blocs/stats/stats_state.dart';
import 'package:weeklet/presentation/screens/stats/stats_screen.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/test_data.dart';

// ---------------------------------------------------------------------------
// Mock declarations
// MockBloc<E, S> extends Bloc<E, S> — not the concrete XxxBloc subclass.
// StatsScreen and SettingsScreen are StatelessWidgets with no sl<> calls,
// so GetIt registration is omitted.
// ---------------------------------------------------------------------------

class MockStatsBloc extends MockBloc<StatsEvent, StatsState>
    implements StatsBloc {}

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockStatsBloc mockStatsBloc;
  late MockSettingsBloc mockSettingsBloc;

  setUpAll(() {
    // Use concrete subclasses as fallback values — sealed classes cannot be
    // implemented with Fake outside their defining library.
    registerFallbackValue(const LoadMonthlyStats(year: 2025));
    registerFallbackValue(const StatsInitial());
    registerFallbackValue(const LoadSettingsRequested());
    registerFallbackValue(const SettingsInitial());
  });

  setUp(() {
    mockStatsBloc = MockStatsBloc();
    mockSettingsBloc = MockSettingsBloc();

    when(() => mockStatsBloc.state).thenReturn(const StatsInitial());
    whenListen(
      mockStatsBloc,
      const Stream<StatsState>.empty(),
      initialState: const StatsInitial(),
    );

    when(() => mockSettingsBloc.state)
        .thenReturn(SettingsLoaded(settings: Settings.defaults()));
    whenListen(
      mockSettingsBloc,
      const Stream<SettingsState>.empty(),
      initialState: SettingsLoaded(settings: Settings.defaults()),
    );
  });

  tearDown(() async => GetIt.instance.reset());

  Future<void> pumpStatsScreen(WidgetTester tester) => pumpApp(
    tester,
    const StatsScreen(),
    providers: [
      BlocProvider<StatsBloc>.value(value: mockStatsBloc),
      BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
    ],
    // AppTheme required: StatsTabsSection uses context.theme.appBarTheme
    // .backgroundColor! (with null assertion) which crashes with default theme.
    theme: AppTheme.lightTheme,
  );

  group('StatsScreen', () {
    testWidgets(
      'shows CircularProgressIndicator when state is StatsInitial',
      (tester) async {
        await pumpStatsScreen(tester);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'shows CircularProgressIndicator when state is StatsLoading',
      (tester) async {
        when(() => mockStatsBloc.state).thenReturn(const StatsLoading());
        whenListen(
          mockStatsBloc,
          const Stream<StatsState>.empty(),
          initialState: const StatsLoading(),
        );

        await pumpStatsScreen(tester);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders CustomScrollView when MonthlyStatsLoaded',
      (tester) async {
        when(() => mockStatsBloc.state).thenReturn(fakeMonthlyStatsLoaded());
        whenListen(
          mockStatsBloc,
          const Stream<StatsState>.empty(),
          initialState: fakeMonthlyStatsLoaded(),
        );

        await pumpStatsScreen(tester);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(CustomScrollView), findsOneWidget);
      },
    );

    testWidgets(
      'shows error content when state is StatsFailure',
      (tester) async {
        const errorMessage = 'Failed to load stats';
        when(() => mockStatsBloc.state)
            .thenReturn(const StatsFailure(errorMessage));
        whenListen(
          mockStatsBloc,
          const Stream<StatsState>.empty(),
          initialState: const StatsFailure(errorMessage),
        );

        await pumpStatsScreen(tester);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(CustomScrollView), findsNothing);
        // StatsErrorView is rendered in the Scaffold body
        expect(find.byType(Scaffold), findsOneWidget);
      },
    );
  });
}
