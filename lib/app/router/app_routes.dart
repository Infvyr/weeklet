class _AppRoutes {
  static const dashboard = '/';
  static const addTransaction = '/add-transaction';
  static const journal = '/journal';
  static const stats = '/stats';
  static const settings = '/settings';
}

enum AppRoute {
  dashboard(_AppRoutes.dashboard),
  journal(_AppRoutes.journal),
  stats(_AppRoutes.stats),
  settings(_AppRoutes.settings),
  addTransaction(_AppRoutes.addTransaction)
  ;

  const AppRoute(this.path);

  final String path;
}
