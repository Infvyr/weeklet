import 'package:flutter/material.dart';
import 'package:weeklet/core/extensions/context_extensions.dart';
import 'package:weeklet/core/mixins/category_search_mixin.dart';
import 'package:weeklet/presentation/screens/categories/widgets/add_category_empty_view.dart';
import 'package:weeklet/presentation/screens/categories/widgets/category_icon_view.dart';
import 'package:weeklet/presentation/screens/categories/widgets/clear_icon_view.dart';
import 'package:weeklet/presentation/widgets/input_view.dart';
import 'package:weeklet/presentation/widgets/label_view.dart';

class CategoryIconsView extends StatefulWidget {
  const CategoryIconsView({super.key});

  @override
  State<CategoryIconsView> createState() => _CategoryIconsViewState();
}

class _CategoryIconsViewState extends State<CategoryIconsView>
    with CategorySearchMixin<CategoryIconsView> {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      const LabelView(text: 'Pick an icon *'),
      InputView(
        controller: searchController,
        hintText: 'Search icons, like "shopping" or "travel"',
        onChanged: (text) => searchNotifier.value = text,
        prefixIcon: Icon(
          Icons.search,
          size: 22,
          color: context.colorScheme.surfaceContainerHighest,
        ),
        suffixIcon: searchNotifier.value.isNotEmpty
            ? ClearSearchButton(
                onClearNotifier: () => searchNotifier.value = '',
                onClearController: searchController.clear,
              )
            : null,
      ),
      const SizedBox(),
      Card(
        margin: EdgeInsets.zero,
        semanticContainer: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: context.colorScheme.outline,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: filteredIcons.isEmpty
                ? NoIconsFoundView(searchTerm: searchNotifier.value)
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: context.screenHeight * 0.35,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredIcons.length,
                      itemBuilder: (_, index) {
                        final categoryKey = filteredIcons.keys.elementAt(index);
                        final iconString = filteredIcons[categoryKey];
                        final isSelected = categoryKey == selectedIconKey;
                        return CategoryIconView(
                          iconString: iconString!,
                          isSelected: isSelected,
                          onSelected: () => setState(() => selectedIconKey = categoryKey),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    ],
  );
}
