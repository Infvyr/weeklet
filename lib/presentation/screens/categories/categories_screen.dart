import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weeklet/core/di/service_locator.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/router/app_routes.dart';
import 'package:weeklet/presentation/blocs/category/category_bloc.dart';
import 'package:weeklet/presentation/blocs/category/category_event.dart';
import 'package:weeklet/presentation/blocs/category/category_state.dart';
import 'package:weeklet/presentation/screens/categories/widgets/categories_empty_view.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    sl<CategoryBloc>().add(const GetAllCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) => BlocProvider<CategoryBloc>.value(
    value: sl<CategoryBloc>(),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is CategoriesLoaded) {
              if (state.categories.isEmpty) {
                return const CategoriesEmptyView();
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(category.icon),
                      ),
                      title: Text(category.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<CategoryBloc>().add(
                            DeleteCategoryEvent(id: category.id),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }

            if (state is CategoryError) {
              return Center(
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              );
            }

            return const CategoriesEmptyView();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create new category',
        onPressed: () => context.pushNamed(AppRoutes.addCategoryScreen),
        child: const Icon(Icons.add),
      ),
    ),
  );
}
