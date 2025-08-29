import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/app_theme.dart';
import 'package:task_manager/common/widgets/custom_app_bar.dart';
import 'package:task_manager/features/tasks/viewmodels/task_controller.dart';
import 'package:task_manager/routes/routes_location.dart';
import 'package:task_manager/utils/dimensions.dart';
import 'widgets/date_chips_row.dart';
import 'widgets/task_card.dart';

class AllTasksPage extends ConsumerWidget {
  const AllTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskControllerProvider);
    final tasks = tasksAsync.asData?.value ?? [];

    return Scaffold(
      appBar: CustomAppBar(
        title: "All Task",
        automaticallyImplyLeading: false,
        actionWidget: Row(children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeFifteen),
            ),
            onPressed: () async {
              GoRouter.of(context).push(RouteLocation.getCreateTaskPage());
            },
            child: Text("Create New", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: Dimensions.fontSizeTwelve, color: AppColors.primary)),
          ),

          const SizedBox(width: 20),
        ]),
      ),
      body: Column(
        children: [
          SizedBox(height: Dimensions.paddingSizeFifteen),

          const DateChipsRow(),

          Expanded(
            child: tasks.isNotEmpty ? ListView.separated(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeTwenty, right: Dimensions.paddingSizeTwenty, top: Dimensions.paddingSizeTen),
              itemBuilder: (_, i) => TaskCard(task: tasks[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: tasks.length,
            ) : Center(
              child: Text("No tasks available", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
            ),
          ),
        ],
      ),
    );
  }
}
