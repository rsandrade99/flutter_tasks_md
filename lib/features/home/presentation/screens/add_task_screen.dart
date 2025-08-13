import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import '../controllers/task_controller.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final Task? task;
  const AddTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController =
        TextEditingController(text: widget.task?.description ?? '');
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final theme = Theme.of(context);

    // Color de fondo del card, dependiendo si está completada
    final cardColor = _isCompleted ? Colors.green[100] : Colors.yellow[100];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Nota' : 'Nueva Nota',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Edita tu nota' : 'Agrega una nueva nota',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Título
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Título...',
                    prefixIcon: const Icon(Icons.title_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Escribe una descripción...',
                    prefixIcon: const Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Checkbox de completado
                Row(
                  children: [
                    Checkbox(
                      value: _isCompleted,
                      onChanged: (val) {
                        setState(() {
                          _isCompleted = val ?? false;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                    const Text('Marcar como completada'),
                  ],
                ),
                const SizedBox(height: 24),

                // Botón guardar
                ElevatedButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final title = _titleController.text;
                    final description = _descController.text.isEmpty
                        ? null
                        : _descController.text;
                    final isCompleted = _isCompleted;

                    final controller =
                        ref.read(tasksControllerProvider.notifier);
                    if (isEditing) {
                      final updatedTask = widget.task!.copyWith(
                        title: title,
                        description: description,
                        isCompleted: isCompleted,
                      );
                      await controller.updateTaskFunc(updatedTask);
                    } else {
                      await controller.createTask(
                          title, description, isCompleted);
                    }

                    if (mounted) Navigator.pop(context);
                  },
                  icon: Icon(isEditing ? Icons.save_outlined : Icons.check),
                  label: Text(isEditing ? 'Guardar cambios' : 'Crear nota'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
