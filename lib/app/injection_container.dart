import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Register dependencies here
  // Example:
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  // getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(getIt()));
}
