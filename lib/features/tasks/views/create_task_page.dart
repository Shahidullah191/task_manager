import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/common/widgets/custom_button.dart';
import 'package:razinsoft_task/common/widgets/custom_date_picker.dart';
import 'package:razinsoft_task/common/widgets/custom_snackbar.dart';
import 'package:razinsoft_task/common/widgets/custom_text_field.dart';
import 'package:razinsoft_task/features/tasks/models/task.dart';
import 'package:razinsoft_task/features/tasks/viewmodels/task_controller.dart';
import 'package:razinsoft_task/routes/routes_location.dart';
import 'package:razinsoft_task/utils/dimensions.dart';

class CreateTaskPage extends ConsumerWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(createTaskProvider);
    final taskNotifier = ref.read(createTaskProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
        title: Text(
          "Create new task",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: Dimensions.fontSizeEighteen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeFifteen),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.marginSizeTen),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(Dimensions.radiusFifteen),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: "Task Name",
                hintText: "Enter Your Task Name",
                controller: TextEditingController(text: taskState.title),
                onChanged: taskNotifier.setTitle,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                labelText: "Task description",
                hintText: "Description",
                controller: TextEditingController(text: taskState.description),
                maxLines: 5,
                showCounter: true,
                counterText: "${taskState.wordCount}",
                onChanged: taskNotifier.setDescription,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      labelText: "Start Date",
                      selectedDate: taskState.startDate,
                      onPicked: (date) {
                        if (date != null) taskNotifier.setStartDate(date);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDatePicker(
                      labelText: "End Date",
                      selectedDate: taskState.endDate,
                      onPicked: (date) {
                        if (date != null) taskNotifier.setEndDate(date);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: "Create new tasks",
                onTap: () async {
                  if (taskState.title.isEmpty) {
                    showCustomSnackBar('Enter your task name');
                  } else if (taskState.description.isEmpty) {
                    showCustomSnackBar('Enter your task description');
                  } else if (taskState.startDate == null) {
                    showCustomSnackBar('Select start date');
                  } else if (taskState.endDate == null) {
                    showCustomSnackBar('Select end date');
                  } else if (taskState.endDate!.isBefore(taskState.startDate!)) {
                    showCustomSnackBar('End date must be after start date');
                  } else {
                    final router = GoRouter.of(context);
                    await ref.read(taskControllerProvider.notifier).add(
                      Task(
                        title: taskState.title,
                        description: taskState.description,
                        startDate: taskState.startDate,
                        endDate: taskState.endDate ?? DateTime.now(),
                        status: 'todo',
                      ),
                    );
                    ref.read(createTaskProvider.notifier).reset();
                    router.pushReplacement(RouteLocation.dashboard);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateTaskState {
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;

  const CreateTaskState({
    this.title = '',
    this.description = '',
    this.startDate,
    this.endDate,
  });

  int get wordCount => description.trim().isEmpty
      ? 0
      : description.trim().split(RegExp(r'\s+')).length;

  CreateTaskState copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CreateTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class CreateTaskNotifier extends StateNotifier<CreateTaskState> {
  CreateTaskNotifier() : super(const CreateTaskState());

  void setTitle(String val) {
    state = state.copyWith(title: val);
  }

  void setDescription(String val) {
    // enforce max 45 words
    final words = val.trim().split(RegExp(r'\s+'));
    final truncated = words.length > 45 ? words.sublist(0, 45).join(' ') : val;
    state = state.copyWith(description: truncated);
  }

  void setStartDate(DateTime? date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: date);
  }

  void reset() {
    state = const CreateTaskState();
  }
}

final createTaskProvider =
StateNotifierProvider<CreateTaskNotifier, CreateTaskState>((ref) {
  return CreateTaskNotifier();
});
