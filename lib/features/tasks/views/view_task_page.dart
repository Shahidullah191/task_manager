import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razinsoft_task/utils/dimensions.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/common/widgets/custom_button.dart';
import 'package:razinsoft_task/common/widgets/custom_date_picker.dart';
import 'package:razinsoft_task/common/widgets/custom_text_field.dart';
import 'package:razinsoft_task/features/tasks/models/task.dart';
import 'package:razinsoft_task/features/tasks/viewmodels/task_controller.dart';

class ViewTaskPage extends ConsumerStatefulWidget {
  static ViewTaskPage builder(BuildContext context, GoRouterState state) {
    final task = state.extra as Task;
    return ViewTaskPage(task: task);
  }
  final Task task;
  const ViewTaskPage({super.key, required this.task});

  @override
  ConsumerState<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends ConsumerState<ViewTaskPage> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    titleCtrl.text = widget.task.title;
    descCtrl.text = widget.task.description;
    startDate = widget.task.startDate;
    endDate = widget.task.endDate;
  }

  @override
  Widget build(BuildContext context) {

    final taskState = ref.watch(taskViewProvider(widget.task));
    final taskNotifier = ref.read(taskViewProvider(widget.task).notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
        title: Text("View Task", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeEighteen)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeFifteen),
            ),
            onPressed: () async {
              showDialog(context: context, builder: (context) {
                return DeleteConfirmDialog(
                  onDelete: () async {
                    if (widget.task.id != null) {
                      await ref.read(taskControllerProvider.notifier).remove(widget.task.id!);
                      if (context.mounted) Navigator.pop(context);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                );
              });
            },
            child: Text("Delete", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: Dimensions.fontSizeTwelve, color: AppColors.error)),
          ),

          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeFifteen),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.marginSizeTen),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(Dimensions.radiusFifteen),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0,6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomTextField(
                labelText: "Task Name",
                hintText: "Enter Your Task Name",
                controller: titleCtrl,
                onChanged: taskNotifier.setTitle,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                labelText: "Task description",
                hintText: "Description",
                controller: descCtrl,
                maxLines: 5,
                showCounter: true,
                onChanged: taskNotifier.setDescription,
                counterText: '${taskState.wordCount}',
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      labelText: "Start Date",
                      selectedDate: startDate,
                      onPicked: taskNotifier.setStartDate,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: CustomDatePicker(
                      labelText: "End Date",
                      selectedDate: endDate,
                      onPicked: taskNotifier.setEndDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: "Complete",
                onTap: () async {
                  final t = widget.task.copyWith(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    startDate: startDate,
                    endDate: endDate,
                    status: 'complete',
                  );
                  await ref.read(taskControllerProvider.notifier).update(t);
                  if (context.mounted) Navigator.pop(context);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class DeleteConfirmDialog extends StatelessWidget {
  final VoidCallback onDelete;
  const DeleteConfirmDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Task"),
      content: const Text("Are you sure you want to delete this task? This action cannot be undone."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Cancel"),
        ),

        TextButton(
          onPressed: onDelete,
          style: TextButton.styleFrom(
            backgroundColor: AppColors.error.withValues(alpha: 0.1),
            foregroundColor: AppColors.error,
          ),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}

class TaskViewState {
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final int wordCount;

  const TaskViewState({
    this.title = '',
    this.description = '',
    this.startDate,
    this.endDate,
    this.wordCount = 0,
  });

  TaskViewState copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? wordCount,
  }) {
    return TaskViewState(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      wordCount: wordCount ?? this.wordCount,
    );
  }
}

class TaskViewNotifier extends StateNotifier<TaskViewState> {
  TaskViewNotifier(Task task)
      : super(TaskViewState(
    title: task.title,
    description: task.description,
    startDate: task.startDate,
    endDate: task.endDate,
    wordCount: task.description.trim().isEmpty
        ? 0
        : task.description.trim().split(' ').length,
  ));

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String desc) {
    final words = desc.trim().split(' ');
    if (words.length > 45) {
      final limited = words.sublist(0, 45).join(' ');
      state = state.copyWith(description: limited, wordCount: 45);
    } else {
      state = state.copyWith(description: desc, wordCount: words.length);
    }
  }

  void setStartDate(DateTime? date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: date);
  }
}

final taskViewProvider =
StateNotifierProvider.family<TaskViewNotifier, TaskViewState, Task>(
      (ref, task) => TaskViewNotifier(task),
);

