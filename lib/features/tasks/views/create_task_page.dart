import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/common/widgets/custom_button.dart';
import 'package:razinsoft_task/common/widgets/custom_text_field.dart';
import 'package:razinsoft_task/features/dashboard/views/dashboard_page.dart';
import 'package:razinsoft_task/features/tasks/models/task.dart';
import 'package:razinsoft_task/features/tasks/viewmodels/task_controller.dart';
import 'package:razinsoft_task/utils/dimensions.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
        title: Text("Create new task", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeEighteen)),
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
              ),
              const SizedBox(height: 10),

              CustomTextField(
                labelText: "Task description",
                hintText: "Description",
                controller: descCtrl,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _dateField(context, "Start Date", (d){ setState(()=> startDate = d); })),
                  const SizedBox(width: 12),
                  Expanded(child: _dateField(context, "End Date", (d){ setState(()=> endDate = d); })),
                ],
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: "Create new tasks",
                onTap: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  await ref.read(taskControllerProvider.notifier).add(Task(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    startDate: startDate,
                    endDate: endDate ?? DateTime.now(),
                    status: 'todo',
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                  );
                },
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeFourteen)),
  );

  Widget _input(TextEditingController c, String hint, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _dateField(BuildContext context, String label, ValueChanged<DateTime?> onPicked) {
    return TextField(
      readOnly: true,
      onTap: () async {
        final now = DateTime.now();
        final d = await showDatePicker(context: context, firstDate: DateTime(now.year-1), lastDate: DateTime(now.year+5), initialDate: now);
        onPicked(d);
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_month),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
