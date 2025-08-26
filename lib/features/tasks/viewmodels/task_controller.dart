import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../repository/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository());

class TaskController extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository repo;
  TaskController(this.repo) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final data = await repo.getAll();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Task task) async {
    await repo.insert(task);
    await load();
  }

  Future<void> update(Task task) async {
    await repo.update(task);
    await load();
  }

  Future<void> remove(int id) async {
    await repo.delete(id);
    await load();
  }
}

final taskControllerProvider = StateNotifierProvider<TaskController, AsyncValue<List<Task>>>((ref) {
  final repo = ref.read(taskRepositoryProvider);
  return TaskController(repo);
});
