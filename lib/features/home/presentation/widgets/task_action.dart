import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../controllers/task_controller.dart';

class TaskActions extends ConsumerWidget {
  final Task task;

  const TaskActions({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 0,
      right: 0,
      child: PopupMenuButton<String>(
        onSelected: (value) => _handleTaskAction(context, ref, value, task),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'alter',
            child: Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.undo : Icons.check_circle_outline,
                  color: task.isCompleted ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  task.isCompleted
                      ? 'Marcar como pendiente'
                      : 'Marcar como completada',
                ),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('Eliminar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTaskAction(
      BuildContext context, WidgetRef ref, String value, Task task) async {
    if (value == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Eliminar nota'),
          content: const Text('¿Quieres eliminar esta nota?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar')),
          ],
        ),
      );
      if (confirm == true) {
        await ref
            .read(tasksControllerProvider.notifier)
            .deleteTaskFunc(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nota eliminada')),
        );
      }
    } else if (value == 'alter') {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await ref
          .read(tasksControllerProvider.notifier)
          .updateTaskFunc(updatedTask);
    }
  }
}
