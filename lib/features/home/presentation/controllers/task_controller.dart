import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository_impl.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepositoryImpl());

final getTasksProvider =
    Provider((ref) => GetTasks(ref.read(taskRepositoryProvider)));
final addTaskProvider =
    Provider((ref) => AddTask(ref.read(taskRepositoryProvider)));
final updateTaskProvider =
    Provider((ref) => UpdateTask(ref.read(taskRepositoryProvider)));
final deleteTaskProvider =
    Provider((ref) => DeleteTask(ref.read(taskRepositoryProvider)));

final tasksControllerProvider =
    StateNotifierProvider<TasksController, List<Task>>((ref) {
  return TasksController(
    getTasks: ref.read(getTasksProvider),
    addTask: ref.read(addTaskProvider),
    updateTask: ref.read(updateTaskProvider),
    deleteTask: ref.read(deleteTaskProvider),
  );
});

class TasksController extends StateNotifier<List<Task>> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TasksController({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await getTasks();
  }

  Future<void> createTask(
      String title, String? description, bool isCompleted) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
    await addTask(task);
    await loadTasks();
  }

  Future<void> updateTaskFunc(Task task) async {
    await updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTaskFunc(String id) async {
    await deleteTask(id);
    await loadTasks();
  }
}
