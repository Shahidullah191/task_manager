import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/routes/app_routes.dart';
import 'package:task_manager/routes/routes_location.dart';

final navigationKey = GlobalKey<NavigatorState>();

final routesProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: RouteLocation.getSplashPage(),
      navigatorKey: navigationKey,
      routes: appRoutes,
    );
  },
);
