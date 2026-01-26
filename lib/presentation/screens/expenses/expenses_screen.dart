import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/blocs/expense/expense_bloc.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/blocs/expense/expense_state.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/add_expense_form_view.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/list/expense_list_view.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
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

  void _showAddExpenseSheet() => showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SizedBox(
      height: context.screenHeight * 0.8,
      child: const AddExpenseFormView(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final expenseState = context.watch<ExpenseBloc>().state;
    final categoryState = context.watch<CategoryBloc>().state;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Expenses'),
        centerTitle: true,
      ),
      body: switch ((expenseState, categoryState)) {
        (ExpenseLoading _, _) || (_, CategoryLoading _) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),

        (ExpenseFailure _, _) => Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: context.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Failed to load expenses', style: context.bodyLarge),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.read<ExpenseBloc>().add(
                  const LoadExpensesRequested(),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        (final ExpenseSuccess success, final CategoriesLoaded catLoaded) =>
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: ExpenseListView(
              expenses: success.filteredExpenses,
              categories: catLoaded.categories,
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
            onPressed: _showAddExpenseSheet,
            icon: Transform.translate(
              offset: _isAtBottom ? Offset.zero : const Offset(6, 0),
              child: const Icon(Icons.add),
            ),
            label: Visibility(
              visible: _isAtBottom,
              child: const Text('Add Expense'),
            ),
            tooltip: _isAtBottom ? '' : 'Add new expense',
          ),
        ),
      ),
    );
  }
}
