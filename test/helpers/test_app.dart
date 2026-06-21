import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeklet/l10n/app_localizations.dart';

/// Pumps [child] inside a [MultiBlocProvider] + [MaterialApp] + localization
/// wrapper so all screen tests get [AppLocalizations] without boilerplate.
///
/// [providers] are passed directly to [MultiBlocProvider]; supply one
/// `BlocProvider<XxxBloc>.value(value: mockBloc)` per BLoC the screen reads.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<BlocProvider> providers = const [],
}) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child,
      ),
    ),
  );
}
