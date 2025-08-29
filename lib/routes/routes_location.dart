import 'dart:convert';

import 'package:flutter/foundation.dart' show immutable;
import 'package:task_manager/features/tasks/models/task.dart';

@immutable
class RouteLocation {
  const RouteLocation._();

  static String get splash => '/';
  static String get dashboard => '/dashboard';
  static String get createTask => '/create-task';
  static String get viewTask => '/view-task';


  static String getSplashPage() => splash;
  static String getDashboardPage() => dashboard;
  static String getCreateTaskPage() => createTask;
  static String getViewTaskPage(Task task) {
    String data = base64Encode(utf8.encode(jsonEncode(task.toMap())));
    return '$viewTask?data=$data';
  }
}
