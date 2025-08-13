import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/app_routes.dart';
import '../controllers/task_controller.dart';
import '../../data/repositories/welcome_repository_impl.dart';
import '../../domain/usecases/get_welcome_message.dart';
import '../controllers/welcome_controller.dart';
import '../widgets/task_list_body.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String title = 'Cargando...';
  late final WelcomeController welcomeController;
  bool _isLoadingTasks = true;

  @override
  void initState() {
    super.initState();
    welcomeController = WelcomeController(
      GetWelcomeMessage(WelcomeRepositoryImpl()),
    );
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadTitle();
    // Esperar medio segundo para evitar parpadeo si es muy rápido
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _isLoadingTasks = false;
    });
  }

  Future<void> _loadTitle() async {
    final welcome = await welcomeController.fetchMessage();
    setState(() {
      title = welcome.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FlutterTask',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: TaskListBody(
        tasks: tasks,
        isLoading: _isLoadingTasks,
        title: title,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
        icon: const Icon(Icons.add),
        label: const Text('Nueva nota'),
        tooltip: 'Agregar nota',
      ),
    );
  }
}
