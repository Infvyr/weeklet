import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_event.dart';
import 'package:weeklet/presentation/blocs/settings/settings_state.dart';

/// Bottom sheet for selecting the display currency.
/// Options (per D-03): MDL, RON, EUR, USD, RUB.
class CurrencySelectionSheet extends StatelessWidget {
  const CurrencySelectionSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    builder: (context) => const ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: CurrencySelectionSheet(),
    ),
  );

  static const List<({String symbol, String label})> _options = [
    (symbol: 'MDL', label: 'Moldovan Leu (MDL)'),
    (symbol: 'RON', label: 'Romanian Leu (RON)'),
    (symbol: 'EUR', label: 'Euro (EUR)'),
    (symbol: 'USD', label: 'US Dollar (USD)'),
    (symbol: 'RUB', label: 'Russian Ruble (RUB)'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsBloc>().state;
    final currentSymbol =
        state is SettingsLoaded ? state.currencySymbol : 'MDL';

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Currency',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1.0),
          RadioGroup<String>(
            groupValue: currentSymbol,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(CurrencyChanged(value));
                Navigator.of(context).pop();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _options
                  .map(
                    (option) => RadioListTile<String>(
                      value: option.symbol,
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
