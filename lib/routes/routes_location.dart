import 'package:flutter/foundation.dart' show immutable;

@immutable
class RouteLocation {
  const RouteLocation._();

  static String get splash => '/';
  static String get dashboard => '/dashboard';
  static String get viewTask => '/view-task';
}
