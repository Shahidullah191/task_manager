import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_theme.dart';
import '../models/task.dart';
import '../viewmodels/task_controller.dart';

class ViewTaskPage extends ConsumerStatefulWidget {
  final Task task;
  const ViewTaskPage({super.key, required this.task});

  @override
  ConsumerState<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends ConsumerState<ViewTaskPage> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.task.title);
    descCtrl = TextEditingController(text: widget.task.description);
    startDate = widget.task.startDate;
    endDate = widget.task.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Task"),
        actions: [
          TextButton(
            onPressed: () async {
              if (widget.task.id != null) {
                await ref.read(taskControllerProvider.notifier).remove(widget.task.id!);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text("Delete", style: TextStyle(color: AppColors.danger)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Task Name"),
            _input(titleCtrl, "Task Title"),
            const SizedBox(height: 16),
            _label("Task description"),
            _input(descCtrl, "Description", maxLines: 5),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _dateField(context, "Start Date", (d){ setState(()=> startDate = d); })),
                const SizedBox(width: 12),
                Expanded(child: _dateField(context, "End Date", (d){ setState(()=> endDate = d); })),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: () async {
                      final t = widget.task.copyWith(
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        startDate: startDate,
                        endDate: endDate,
                        status: 'complete',
                      );
                      await ref.read(taskControllerProvider.notifier).update(t);
                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text("Complete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t, style: Theme.of(context).textTheme.titleMedium),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}
