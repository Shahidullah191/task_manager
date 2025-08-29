import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/app_theme.dart';
import 'package:task_manager/common/widgets/custom_app_bar.dart';
import 'package:task_manager/common/widgets/custom_button.dart';
import 'package:task_manager/common/widgets/custom_date_picker.dart';
import 'package:task_manager/common/widgets/custom_snackbar.dart';
import 'package:task_manager/common/widgets/custom_text_field.dart';
import 'package:task_manager/features/tasks/models/task.dart';
import 'package:task_manager/features/tasks/viewmodels/task_controller.dart';
import 'package:task_manager/utils/dimensions.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {

  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final taskState = ref.watch(createTaskProvider);
    final taskNotifier = ref.read(createTaskProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Create new task",
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
                controller: titleCtrl,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                labelText: "Task description",
                hintText: "Description",
                controller: descCtrl,
                maxLines: 5,
                showCounter: true,
                counterText: "${taskState.wordCount}",
                onChanged: taskNotifier.setDescription,
                inputAction: TextInputAction.done,
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

                  String title = titleCtrl.text.trim();
                  String description = descCtrl.text.trim();

                  if (title.isEmpty) {
                    showCustomSnackBar('Enter your task name');
                  } else if (description.isEmpty) {
                    showCustomSnackBar('Enter your task description');
                  } else if (taskState.startDate == null) {
                    showCustomSnackBar('Select start date');
                  } else if (taskState.endDate == null) {
                    showCustomSnackBar('Select end date');
                  } else if (taskState.endDate!.isBefore(taskState.startDate!)) {
                    showCustomSnackBar('End date must be after start date');
                  } else {
                    await ref.read(taskControllerProvider.notifier).add(
                      Task(
                        title: title,
                        description: taskState.description,
                        startDate: taskState.startDate,
                        endDate: taskState.endDate ?? DateTime.now(),
                        status: 'todo',
                      ),
                    ).then((value) {
                      titleCtrl.clear();
                      descCtrl.clear();
                      ref.read(createTaskProvider.notifier).reset();
                      showCustomSnackBar('Task created successfully', isError: false);
                    });
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

  int get wordCount => description.trim().isEmpty ? 0 : description.trim().split(RegExp(r'\s+')).length;

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

  void setDescription(String val) {
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
