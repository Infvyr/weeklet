import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/router/app_routes.dart';
import 'package:weeklet/presentation/blocs/settings/settings_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_event.dart';
import 'package:weeklet/presentation/blocs/settings/settings_state.dart';
import 'package:weeklet/presentation/screens/settings/widgets/currency_selection_sheet.dart';
import 'package:weeklet/presentation/screens/settings/widgets/language_selection_sheet.dart';
import 'package:weeklet/presentation/screens/settings/widgets/settings_section_header.dart';
import 'package:weeklet/presentation/screens/settings/widgets/settings_tile.dart';
import 'package:weeklet/presentation/screens/settings/widgets/theme_selection_sheet.dart';
import 'package:weeklet/presentation/widgets/common/deletion_dialog/deletion_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _version = info.version);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _version = '1.0.0');
      }
    }
  }

  Future<void> _showClearPreferencesDialog() async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      icon: Icons.settings_backup_restore,
      iconBackgroundColor: context.colorScheme.primary,
      iconColor: Colors.white,
      title: 'Clear Preferences',
      subtitle1:
          'This will reset your theme, language, and currency to defaults.',
      subtitle2: 'Your expenses, income, and categories will not be affected.',
      confirmButtonColor: context.colorScheme.primary,
      confirmButtonTextColor: context.colorScheme.onPrimary,
      confirmButtonText: 'Clear',
      cancelButtonColor: context.colorScheme.surface,
      cancelButtonTextColor: context.colorScheme.onSurface,
      cancelButtonText: 'Keep Settings',
    );
    if (confirmed == true && mounted) {
      context.read<SettingsBloc>().add(const ClearPreferencesRequested());
    }
  }

  Future<void> _showResetAllDataDialog() async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      icon: Icons.delete_forever,
      iconBackgroundColor: context.colorScheme.error,
      iconColor: Colors.white,
      title: 'Reset All Data',
      subtitle1:
          'This will permanently delete all your expenses, income, and categories.',
      subtitle2: 'This action cannot be undone.',
      confirmButtonColor: context.colorScheme.error,
      confirmButtonTextColor: context.colorScheme.onError,
      confirmButtonText: 'Reset',
      cancelButtonColor: context.colorScheme.surface,
      cancelButtonTextColor: context.colorScheme.onSurface,
      cancelButtonText: 'Keep Data',
    );
    if (confirmed == true && mounted) {
      context.read<SettingsBloc>().add(const ResetAllDataRequested());
    }
  }

  Widget _buildCard(List<Widget> tiles) {
    final children = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      children.add(tiles[i]);
      if (i < tiles.length - 1) {
        children.add(const Divider(height: 1, indent: 56));
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Settings'),
    ),
    body: BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded && state.actionError != null) {
          context.showErrorSnackBar(state.actionError!);
        }
      },
      builder: (context, state) {
        if (state is SettingsInitial || state is SettingsLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is SettingsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Settings could not be loaded.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () => context
                      .read<SettingsBloc>()
                      .add(const LoadSettingsRequested()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! SettingsLoaded) return const SizedBox.shrink();

        final themeLabel = switch (state.themeMode) {
          ThemeMode.system => 'System default',
          ThemeMode.light => 'Light',
          ThemeMode.dark => 'Dark',
        };

        final languageLabel = switch (state.locale?.languageCode) {
          'ro' => 'Romanian',
          'ru' => 'Russian',
          'en' => 'English',
          _ => 'System default',
        };

        return ListView(
          padding: const EdgeInsets.only(bottom: 32.0),
          children: [
            // ─── Security ─────────────────────────────────────────────────
            const SettingsSectionHeader(title: 'Security'),
            _buildCard([
              SettingsTile(
                leading: const Icon(Icons.fingerprint),
                title: 'Biometric Authentication',
                subtitle: state.biometricEnabled
                    ? 'Enabled — Face ID / Touch ID required on resume'
                    : 'Disabled',
                trailing: Switch.adaptive(
                  value: state.biometricEnabled,
                  onChanged: (value) => context
                      .read<SettingsBloc>()
                      .add(BiometricToggled(enabled: value)),
                ),
              ),
            ]),

            // ─── Appearance ───────────────────────────────────────────────
            const SettingsSectionHeader(title: 'Appearance'),
            _buildCard([
              SettingsTile(
                leading: const Icon(Icons.palette_outlined),
                title: 'Theme',
                subtitle: themeLabel,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ThemeSelectionSheet.show(context),
              ),
              SettingsTile(
                leading: const Icon(Icons.language),
                title: 'Language',
                subtitle: languageLabel,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => LanguageSelectionSheet.show(context),
              ),
              SettingsTile(
                leading: const Icon(Icons.attach_money),
                title: 'Currency',
                subtitle: state.currencySymbol,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => CurrencySelectionSheet.show(context),
              ),
            ]),

            // ─── Data ─────────────────────────────────────────────────────
            const SettingsSectionHeader(title: 'Data'),
            _buildCard([
              SettingsTile(
                leading: const Icon(Icons.settings_backup_restore),
                title: 'Clear Preferences',
                subtitle: 'Resets theme, language, and currency to defaults',
                onTap: _showClearPreferencesDialog,
              ),
              SettingsTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: context.colorScheme.error,
                ),
                title: 'Reset All Data',
                subtitle:
                    'Permanently deletes all expenses, income, and categories',
                trailing: Icon(
                  Icons.warning_amber_rounded,
                  color: context.colorScheme.error,
                  size: 18.0,
                ),
                onTap: _showResetAllDataDialog,
              ),
            ]),

            // ─── Legal ────────────────────────────────────────────────────
            const SettingsSectionHeader(title: 'Legal'),
            _buildCard([
              SettingsTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: 'Privacy Policy',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.privacyPolicyScreen),
              ),
              SettingsTile(
                leading: const Icon(Icons.gavel_outlined),
                title: 'Terms & Conditions',
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.termsScreen),
              ),
            ]),

            // ─── About ────────────────────────────────────────────────────
            const SettingsSectionHeader(title: 'About'),
            _buildCard([
              SettingsTile(
                leading: const Icon(Icons.info_outline),
                title: 'App Version',
                trailing: Text(
                  _version.isEmpty ? '...' : _version,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ]),
          ],
        );
      },
    ),
  );
}
