import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/date_formatter.dart';
import '../../data/repositories/app_routes.dart';
import '../../domain/entities/task.dart';
import 'task_action.dart';

class TaskListBody extends ConsumerWidget {
  final List<Task> tasks;
  final bool isLoading;
  final String title;

  const TaskListBody({
    super.key,
    required this.tasks,
    required this.isLoading,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Obteniendo notas...'),
          ],
        ),
      );
    }

    if (tasks.isEmpty) {
      return _NoTasks(theme: theme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: _TaskGrid(tasks: tasks, theme: theme)),
      ],
    );
  }
}

class _NoTasks extends StatelessWidget {
  final ThemeData theme;
  const _NoTasks({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.note_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay notas aún',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskGrid extends ConsumerWidget {
  final List<Task> tasks;
  final ThemeData theme;

  const _TaskGrid({required this.tasks, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 4 / 3,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final bgColor =
              task.isCompleted ? Colors.green[100] : Colors.yellow[100];

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.addTask,
                arguments: task),
            child: _TaskCard(task: task, bgColor: bgColor, theme: theme),
          );
        },
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final Task task;
  final Color? bgColor;
  final ThemeData theme;

  const _TaskCard({
    required this.task,
    required this.bgColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          _TaskDetails(task: task, theme: theme),
          TaskActions(task: task),
        ],
      ),
    );
  }
}

class _TaskDetails extends StatelessWidget {
  final Task task;
  final ThemeData theme;

  const _TaskDetails({required this.task, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 8),
                if (task.description != null)
                  Text(
                    task.description!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[800],
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          formatDateTime(task.date),
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
