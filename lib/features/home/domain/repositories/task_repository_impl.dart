import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const String boxName = 'tasksBox';

  @override
  Future<List<Task>> getTasks() async {
    final box = await Hive.openBox<Task>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final box = await Hive.openBox<Task>(boxName);
    await box.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final box = await Hive.openBox<Task>(boxName);
    await box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    final box = await Hive.openBox<Task>(boxName);
    await box.delete(id);
  }
}
