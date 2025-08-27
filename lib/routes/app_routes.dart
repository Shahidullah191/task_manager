import 'package:go_router/go_router.dart';
import 'package:razinsoft_task/features/dashboard/views/dashboard_page.dart';
import 'package:razinsoft_task/features/splash/views/splash_page.dart';
import 'package:razinsoft_task/features/tasks/views/view_task_page.dart';
import 'package:razinsoft_task/routes/routes_location.dart';
import 'package:razinsoft_task/routes/routes_provider.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.splash,
    parentNavigatorKey: navigationKey,
    builder: SplashPage.builder,
  ),
  GoRoute(
    path: RouteLocation.dashboard,
    parentNavigatorKey: navigationKey,
    builder: DashboardPage.builder,
  ),
  GoRoute(
    path: RouteLocation.viewTask,
    parentNavigatorKey: navigationKey,
    builder: ViewTaskPage.builder,
  ),
];
