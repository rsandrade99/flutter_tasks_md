import 'package:hive/hive.dart';

part 'task.g.dart'; // necesario para el adapter

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime date;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    DateTime? date,
  }) : date = date ??
            DateTime.now().toLocal(); // Si no viene, se usa la fecha actual

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
