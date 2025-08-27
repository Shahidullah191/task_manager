import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razinsoft_task/routes/app_routes.dart';
import 'package:razinsoft_task/routes/routes_location.dart';

final navigationKey = GlobalKey<NavigatorState>();

final routesProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: RouteLocation.splash,
      navigatorKey: navigationKey,
      routes: appRoutes,
    );
  },
);
