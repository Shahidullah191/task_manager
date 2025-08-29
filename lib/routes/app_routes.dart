import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/dashboard/views/dashboard_page.dart';
import 'package:task_manager/features/splash/views/splash_page.dart';
import 'package:task_manager/features/tasks/models/task.dart';
import 'package:task_manager/features/tasks/views/create_task_page.dart';
import 'package:task_manager/features/tasks/views/view_task_page.dart';
import 'package:task_manager/routes/routes_location.dart';
import 'package:task_manager/routes/routes_provider.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.splash,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: RouteLocation.dashboard,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => DashboardPage(),
  ),
  GoRoute(
    path: RouteLocation.createTask,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const CreateTaskPage(),
  ),
  GoRoute(
    path: RouteLocation.viewTask,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      Task data = Task.fromMap(jsonDecode(utf8.decode(base64Decode(state.uri.queryParameters['data']!.replaceAll(' ', '+')))));
      return ViewTaskPage(task: data);
    }
  ),
];
