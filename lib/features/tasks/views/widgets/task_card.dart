import 'package:flutter/material.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/features/tasks/models/task.dart';
import 'package:razinsoft_task/features/tasks/views/view_task_page.dart';
import 'package:razinsoft_task/utils/date_utils.dart' as du;
import 'package:razinsoft_task/utils/dimensions.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final statusColor = task.status == 'complete' ? AppColors.success : AppColors.primary;
    final statusText = task.status == 'complete' ? 'Complete' : 'Todo';

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewTaskPage(task: task)));
      },
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeTen),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(Dimensions.radiusTen),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0,6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeSixteen),
              maxLines: 2, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),

            Text(
              task.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Dimensions.fontSizeTwelve),
              maxLines: 2, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: AppColors.text),
                const SizedBox(width: 8),

                Text(du.formatDate(task.endDate), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Dimensions.fontSizeTwelve)),
                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimensions.radiusForty),
                  ),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
