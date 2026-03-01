import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/domain/utils/income_grouping.dart';
import 'package:weeklet/presentation/blocs/income/income_bloc.dart';
import 'package:weeklet/presentation/blocs/income/income_event.dart';
import 'package:weeklet/presentation/blocs/income/income_state.dart';
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
    context.read<IncomeBloc>().add(const LoadIncomesRequested());

    await Future.doWhile(() async {
      if (!mounted) return false;
      final state = context.read<IncomeBloc>().state;
      return state is! IncomeSuccess && state is! IncomeFailure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final incomeState = context.watch<IncomeBloc>().state;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Venituri'),
        centerTitle: true,
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
                ),
                const SizedBox(height: 16),
                IncomeListView(incomes: success.filteredIncomes),
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
    );
  }
}
