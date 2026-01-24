import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/theme/sizes.dart';
import 'package:weeklet/core/utils/form_helpers.dart';
import 'package:weeklet/domain/entities/category.dart';
import 'package:weeklet/domain/entities/expense.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/blocs/expense/expense_bloc.dart';
import 'package:weeklet/presentation/blocs/expense/expense_event.dart';
import 'package:weeklet/presentation/blocs/expense/expense_state.dart';
import 'package:weeklet/presentation/screens/expenses/widgets/add/export.dart';
import 'package:weeklet/presentation/widgets/common/unsaved_changes_dialog.dart';

class EditExpenseFormView extends StatefulWidget {
  const EditExpenseFormView(this.expense, {super.key});

  final Expense expense;

  @override
  State<EditExpenseFormView> createState() => _EditExpenseFormViewState();
}

class _EditExpenseFormViewState extends State<EditExpenseFormView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  Category? _selectedCategory;
  DateTime? _selectedDate;
  String? _dateError;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.expense.description,
    );
    _selectedDate = widget.expense.createdAt;

    _amountController.addListener(_onFormInteraction);
    _descriptionController.addListener(_onFormInteraction);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onFormInteraction);
    _descriptionController.removeListener(_onFormInteraction);
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onFormInteraction() {
    if (!_hasInteracted) {
      setState(() => _hasInteracted = true);
    }
  }

  bool _hasUnsavedChanges() {
    final amountChanged =
        _amountController.text != widget.expense.amount.toString();
    final descriptionChanged =
        _descriptionController.text.trim() != widget.expense.description;
    final categoryChanged = _selectedCategory?.id != widget.expense.categoryId;
    final dateChanged = _selectedDate != widget.expense.createdAt;
    return amountChanged ||
        descriptionChanged ||
        categoryChanged ||
        dateChanged;
  }

  Future<void> _handleClose() async {
    if (_hasUnsavedChanges()) {
      final shouldDiscard = await UnsavedChangesDialog.show(context);
      if (shouldDiscard && mounted) {
        context.pop();
      }
    } else {
      context.pop();
    }
  }

  bool _validateDate() {
    if (_selectedDate == null) {
      setState(() => _dateError = 'Please select a date');
      return false;
    }
    setState(() => _dateError = null);
    return true;
  }

  void _onSave() {
    final isValid = FormHelpers.validateForm(
      _formKey,
      [_validateDate],
    );

    if (!isValid) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    context.read<ExpenseBloc>().add(
      UpdateExpenseStarted(
        Expense(
          id: widget.expense.id,
          amount: double.parse(_amountController.text),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategory!.id,
          createdAt: _selectedDate!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocListener<ExpenseBloc, ExpenseState>(
    listener: (context, state) {
      if (state is ExpenseSuccess && state.actionError == null) {
        context.pop();
      }
    },
    child: BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        if (categoryState is CategoriesLoaded && _selectedCategory == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              final category = categoryState.categories.firstWhere(
                (cat) => cat.id == widget.expense.categoryId,
                orElse: () => categoryState.categories.first,
              );
              setState(() => _selectedCategory = category);
            }
          });
        }

        return CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.escape): _handleClose,
          },
          child: Focus(
            autofocus: true,
            child: GestureDetector(
              onTap: context.unfocus,
              child: Scaffold(
                body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 24,
              ),
              child: Form(
                autovalidateMode: _autovalidateMode,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    ExpenseFormHeaderView(
                      title: 'Edit Expense',
                      onClose: _handleClose,
                    ),
                    ExpenseFormAmountView(controller: _amountController),
                    ExpenseFormDescriptionView(
                      controller: _descriptionController,
                    ),
                    ExpenseFormCategoryView(
                      selectedCategory: _selectedCategory,
                      onChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                          _hasInteracted = true;
                        });
                      },
                    ),
                    ExpenseFormDateView(
                      selectedDate: _selectedDate,
                      errorText: _dateError,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                          _dateError = null;
                          _hasInteracted = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _FormFooter(
              onSave: _onSave,
              onCancel: _handleClose,
              isEnabled: _hasInteracted,
            ),
          ),
        ),
      ),
    );
      },
    ),
  );
}

class _FormFooter extends StatelessWidget {
  const _FormFooter({
    required this.onSave,
    required this.onCancel,
    required this.isEnabled,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) => BlocBuilder<ExpenseBloc, ExpenseState>(
    builder: (context, state) {
      final isLoading = state is ExpenseLoading;
      final canSubmit = isEnabled && !isLoading;

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isLoading ? 0.6 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading ? null : onCancel,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(kButtonHeight),
                    backgroundColor: context.colorScheme.outline,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: canSubmit ? onSave : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Visibility(
                      visible: isLoading,
                      replacement: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
