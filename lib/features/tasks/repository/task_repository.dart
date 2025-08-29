import 'package:task_manager/core/db/app_database.dart';
import 'package:task_manager/features/tasks/models/task.dart';

class TaskRepository {
  final AppDatabase _dbProvider = AppDatabase();

  Future<List<Task>> getAll() async {
    final db = await _dbProvider.database;
    final maps = await db.query('tasks', orderBy: 'id DESC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<int> insert(Task task) async {
    final db = await _dbProvider.database;
    return db.insert('tasks', task.toMap());
  }

  Future<int> update(Task task) async {
    final db = await _dbProvider.database;
    return db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> delete(int id) async {
    final db = await _dbProvider.database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
