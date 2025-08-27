import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/features/tasks/viewmodels/task_controller.dart';
import 'package:razinsoft_task/features/tasks/views/widgets/task_card.dart';
import 'package:razinsoft_task/helper/date_converter.dart';
import 'package:razinsoft_task/utils/dimensions.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskControllerProvider);
    final tasks = tasksAsync.asData?.value ?? [];

    final assigned = tasks.length;
    final completed = tasks.where((t) => t.status == 'complete').length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good morning Liam!", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Dimensions.fontSizeTwelve)),
            Text(DateConverter.today(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeSixteen)),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeTwenty, right: Dimensions.paddingSizeTwenty, top: Dimensions.paddingSizeTwenty),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Summary", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeTwenty)),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _summaryBox(context, "Assigned tasks", assigned, AppColors.primary),
                      const SizedBox(width: 12),

                      _summaryBox(context, "Completed tasks", completed, AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text("Today tasks", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeTwenty)),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(Dimensions.radiusForty),
                      border: Border.all(color: AppColors.gray.withValues(alpha: 0.33)),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _taskButton(
                          active: tab == 0,
                          text: "All",
                          onTap: () {
                            setState(() {
                              tab = 0;
                            });
                          },
                        )),

                        Expanded(child: _taskButton(
                          active: tab == 1,
                          text: "Completed",
                          onTap: () {
                            setState(() {
                              tab = 1;
                            });
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeTwenty, right: Dimensions.paddingSizeTwenty, top: Dimensions.paddingSizeTen),
            sliver: SliverList.separated(
              itemBuilder: (_, i) => TaskCard(task: tab == 0 ? tasks[i] : tasks.where((t) => t.status == 'complete').toList()[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: tab == 0 ? assigned : completed,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _summaryBox(BuildContext c, String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeTen),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(c).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeFourteen)),
            const SizedBox(height: 10),

            Text("$value", style: Theme.of(c).textTheme.titleMedium?.copyWith(color: color, fontSize: Dimensions.fontSizeTwentyFour)),
          ],
        ),
      ),
    );
  }

  Widget _taskButton({required bool active, required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(Dimensions.radiusForty),
        ),
        child: Text(text, style: TextStyle(color: active ? Colors.white : AppColors.textMuted, fontWeight: active ? FontWeight.w700 : FontWeight.w500), textAlign: TextAlign.center),
      ),
    );
  }
}
