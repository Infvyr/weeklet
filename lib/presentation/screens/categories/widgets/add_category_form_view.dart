// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
// import 'package:weeklet/presentation/blocs/category/category_event.dart';
// import 'package:weeklet/presentation/blocs/category/category_state.dart';

// class AddCategoryForm extends StatefulWidget {
//   const AddCategoryForm({Key? key}) : super(key: key);

//   @override
//   State<AddCategoryForm> createState() => _AddCategoryFormState();
// }

// class _AddCategoryFormState extends State<AddCategoryForm> {
//   late TextEditingController _nameController;
//   String _selectedIcon = '';
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   void _onAddCategory() {
//     if (_formKey.currentState!.validate() && _selectedIcon.isNotEmpty) {
//       context.read<CategoryBloc>().add(
//         AddCategoryEvent(
//           name: _nameController.text.trim(),
//           icon: _selectedIcon,
//         ),
//       );
//     } else if (_selectedIcon.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an icon')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) => BlocBuilder<CategoryBloc, CategoryState>(
//     builder: (context, state) {
//       final isLoading = state is CategoryLoading;

//       return SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Category Name Input
//               TextFormField(
//                 controller: _nameController,
//                 enabled: !isLoading,
//                 decoration: InputDecoration(
//                   labelText: 'Category Name',
//                   hintText: 'e.g., Shopping',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value?.isEmpty ?? true) {
//                     return 'Category name is required';
//                   }
//                   if (value!.length < 2) {
//                     return 'Name must be at least 2 characters';
//                   }
//                   if (value.length > 30) {
//                     return 'Name must be less than 30 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),

//               // Icon Selector
//               CategoryIconSelector(
//                 selectedIcon: _selectedIcon,
//                 onIconSelected: (icon) {
//                   setState(() => _selectedIcon = icon);
//                 },
//                 enabled: !isLoading,
//               ),
//               const SizedBox(height: 32),

//               // Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: isLoading ? null : () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: FilledButton(
//                       onPressed: isLoading ? null : _onAddCategory,
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             )
//                           : const Text('Add Category'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
