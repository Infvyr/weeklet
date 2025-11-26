import 'package:go_router/go_router.dart' show GoRoute, GoRouter;
import 'package:weeklet/app/router/app_routes.dart';
import 'package:weeklet/presentation/screens/main/main_screen.dart';
import 'package:weeklet/presentation/screens/transaction/add_transaction_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.dashboard.path,
  routes: [
    GoRoute(
      path: AppRoute.dashboard.path,
      name: AppRoute.dashboard.name,
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: AppRoute.addTransaction.path,
      name: AppRoute.addTransaction.name,
      builder: (context, state) => const AddTransactionScreen(),
    ),
  ],
);
