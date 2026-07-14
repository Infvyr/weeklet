import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:weeklet/domain/repositories/category_repository.dart';

import 'test_data.dart';
import 'test_hive_env.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerHiveAdaptersOnce();
  });

  group('test_hive_env', () {
    test(
      'initTestDi registers a real CategoryRepository and round-trips a '
      'seeded category',
      () async {
        await initTestDi();

        final repository = GetIt.instance<CategoryRepository>();
        await repository.addCategory(fakeCategory());

        final categories = await repository.getAllCategories();

        expect(categories.map((c) => c.id), contains(fakeCategory().id));

        await teardownTestDi();
      },
    );

    test(
      'teardownTestDi followed by fresh initTestDi leaves no residue '
      '(isolation)',
      () async {
        await initTestDi();

        final firstRepository = GetIt.instance<CategoryRepository>();
        await firstRepository.addCategory(fakeCategory(id: 'leak-check'));

        await teardownTestDi();
        await initTestDi();

        final secondRepository = GetIt.instance<CategoryRepository>();
        final categories = await secondRepository.getAllCategories();

        expect(categories, isEmpty);

        await teardownTestDi();
      },
    );
  });
}
