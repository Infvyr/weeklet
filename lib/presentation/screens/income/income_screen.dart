import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/utils/income_grouping.dart';
import 'package:weeklet/presentation/blocs/export/export_bloc.dart';
import 'package:weeklet/presentation/blocs/export/export_event.dart';
import 'package:weeklet/presentation/blocs/export/export_state.dart';
import 'package:weeklet/presentation/blocs/income/income_bloc.dart';
import 'package:weeklet/presentation/blocs/income/income_event.dart';
import 'package:weeklet/presentation/blocs/income/income_state.dart';
import 'package:weeklet/core/constants/app_constants.dart';
import 'package:weeklet/presentation/blocs/settings/settings_bloc.dart';
import 'package:weeklet/presentation/blocs/settings/settings_state.dart';
import 'package:weeklet/presentation/screens/income/widgets/add_income_form_view.dart';
import 'package:weeklet/presentation/screens/income/widgets/income_filter_bar.dart';
import 'package:weeklet/presentation/screens/income/widgets/income_total_card.dart';
import 'package:weeklet/presentation/screens/income/widgets/list/income_list_view.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  late ScrollController _scrollController;
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrolled);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrolled);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrolled() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final isAtBottom = currentScroll >= maxScroll - 50;

    if (isAtBottom != _isAtBottom) {
      setState(() => _isAtBottom = isAtBottom);
    }
  }

  void _showAddIncomeSheet() => showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SizedBox(
      height: context.screenHeight * 0.8,
      child: const AddIncomeFormView(),
    ),
  );

  Future<void> _onRefresh() async {
    if (!mounted) return;
    final bloc = context.read<IncomeBloc>();
    bloc.add(const LoadIncomesRequested());

    await bloc.stream
        .firstWhere(
          (s) => s is IncomeSuccess || s is IncomeFailure,
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => bloc.state,
        );
  }

  void _onExportTapped() {
    final incomeState = context.read<IncomeBloc>().state;
    if (incomeState is! IncomeSuccess) return;

    if (incomeState.selectedMonth == null) {
      context.showSnackBar('Please select a specific month to export.');
      return;
    }

    final settingsState = context.read<SettingsBloc>().state;
    final currencySymbol = settingsState is SettingsLoaded
        ? settingsState.currencySymbol
        : 'MDL';

    context.read<ExportBloc>().add(
      ExportIncomeStarted(
        incomes: incomeState.filteredIncomes,
        currencySymbol: currencySymbol,
        year: incomeState.selectedYear,
        month: incomeState.selectedMonth!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final incomeState = context.watch<IncomeBloc>().state;
    final settingsState = context.watch<SettingsBloc>().state;
    final currencySymbol = settingsState is SettingsLoaded
        ? settingsState.currencySymbol
        : AppConstants.DEFAULT_CURRENCY;

    return BlocListener<ExportBloc, ExportState>(
      listenWhen: (_, s) =>
          (s is ExportSuccess &&
              s.exportType == ExportType.income) ||
          s is ExportFailure,
      listener: (context, exportState) {
        if (exportState is ExportSuccess) {
          final exportBloc = context.read<ExportBloc>();
          unawaited(
            SharePlus.instance
                .share(
                  ShareParams(
                    files: [XFile(exportState.filePath)],
                    subject: exportState.subject,
                    sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
                  ),
                )
                .then((_) {
                  if (!mounted) return;
                  exportBloc.add(const ResetExportRequested());
                }),
          );
        } else if (exportState is ExportFailure) {
          context.showErrorSnackBar(
            'Failed to generate PDF. Please try again.',
          );
          context.read<ExportBloc>().add(const ResetExportRequested());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('My Income'),
          centerTitle: true,
          actions: [
            BlocBuilder<ExportBloc, ExportState>(
              builder: (context, exportState) {
                if (exportState is ExportInProgress) {
                  return const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          semanticsLabel: 'Generating PDF\u2026',
                        ),
                      ),
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: 'Export as PDF',
                  onPressed: _onExportTapped,
                );
              },
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: IncomeFilterBar(),
          ),
        ),
        body: switch (incomeState) {
          IncomeLoading _ => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),

          IncomeFailure _ => Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text('Failed to load income', style: context.bodyLarge),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.read<IncomeBloc>().add(
                    const LoadIncomesRequested(),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),

          final IncomeSuccess success => RefreshIndicator.adaptive(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  IncomeTotalCard(
                    total: IncomeGrouping.calculateTotal(
                      success.filteredIncomes,
                    ),
                    selectedMonth: success.selectedMonth,
                    currencySymbol: currencySymbol,
                  ),
                  const SizedBox(height: 16),
                  IncomeListView(
                    incomes: success.filteredIncomes,
                    currencySymbol: currencySymbol,
                  ),
                ],
              ),
            ),
          ),

          _ => const SizedBox.shrink(),
        },
        floatingActionButton: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: _isAtBottom ? context.screenWidth - 32 : 56,
          height: _isAtBottom ? 48 : 56,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 400),
            offset: Offset.zero,
            child: FloatingActionButton.extended(
              onPressed: _showAddIncomeSheet,
              icon: Transform.translate(
                offset: _isAtBottom ? Offset.zero : const Offset(6, 0),
                child: const Icon(Icons.add),
              ),
              label: Visibility(
                visible: _isAtBottom,
                child: const Text('Add Income'),
              ),
              tooltip: _isAtBottom ? '' : 'Add new income',
            ),
          ),
        ),
      ),
    );
  }
}
