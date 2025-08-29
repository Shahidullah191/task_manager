import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/common/widgets/custom_app_bar.dart';
import 'package:task_manager/common/widgets/custom_snackbar.dart';
import 'package:task_manager/utils/dimensions.dart';
import 'package:task_manager/app_theme.dart';
import 'package:task_manager/common/widgets/custom_button.dart';
import 'package:task_manager/common/widgets/custom_date_picker.dart';
import 'package:task_manager/common/widgets/custom_text_field.dart';
import 'package:task_manager/features/tasks/models/task.dart';
import 'package:task_manager/features/tasks/viewmodels/task_controller.dart';

class ViewTaskPage extends ConsumerStatefulWidget {
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
  String? wordCount;

  @override
  void initState() {
    super.initState();
    titleCtrl.text = widget.task.title;
    descCtrl.text = widget.task.description;
    setDescriptionCount(widget.task.description);
    startDate = widget.task.startDate;
    endDate = widget.task.endDate;
  }

  void setDescriptionCount(String desc) {
    final words = desc.trim().split(' ');
    if (words.length > 45) {
      final limited = words.sublist(0, 45).join(' ');
      descCtrl.text = limited;
      wordCount = '45';
      showCustomSnackBar("Description cannot exceed 45 words");
    } else {
      wordCount = '${words.length}';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: "View Task",
        actionWidget: Row(
          children: [
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
                isEnabled: false,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                labelText: "Task description",
                hintText: "Description",
                controller: descCtrl,
                maxLines: 5,
                showCounter: true,
                counterText: wordCount,
                isEnabled: false,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      labelText: "Start Date",
                      selectedDate: startDate,
                      onPicked: (value) {},
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: CustomDatePicker(
                      labelText: "End Date",
                      selectedDate: endDate,
                      onPicked: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: "Complete",
                onTap: () async {
                  final task = widget.task.copyWith(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    startDate: startDate,
                    endDate: endDate,
                    status: 'complete',
                  );
                  await ref.read(taskControllerProvider.notifier).update(task);
                  if (context.mounted) Navigator.pop(context);
                  showCustomSnackBar("Task marked as complete", isError: false);
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
