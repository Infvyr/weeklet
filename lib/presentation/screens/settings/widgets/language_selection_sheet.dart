import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_event.dart';
import 'package:weeklet/presentation/blocs/settings/settings_state.dart';

/// Bottom sheet for selecting the display language.
/// Options (per D-06): System default, English, Romanian, Russian.
class LanguageSelectionSheet extends StatelessWidget {
  const LanguageSelectionSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    builder: (context) => const ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: LanguageSelectionSheet(),
    ),
  );

  static const List<({String label, Locale? locale})> _options = [
    (label: 'System default', locale: null),
    (label: 'English', locale: Locale('en', 'US')),
    (label: 'Romanian', locale: Locale('ro', 'RO')),
    (label: 'Russian', locale: Locale('ru', 'RU')),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsBloc>().state;
    final currentLocale = state is SettingsLoaded ? state.locale : null;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Language',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1.0),
          RadioGroup<Locale?>(
            groupValue: currentLocale,
            onChanged: (value) {
              context.read<SettingsBloc>().add(LocaleChanged(value));
              Navigator.of(context).pop();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _options
                  .map(
                    (option) => RadioListTile<Locale?>(
                      value: option.locale,
                      title: Text(option.label),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
