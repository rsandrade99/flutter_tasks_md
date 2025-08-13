import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/app_routes.dart';
import '../../data/repositories/welcome_repository_impl.dart';
import '../../domain/usecases/get_welcome_message.dart';
import '../controllers/welcome_controller.dart';

class WelcomeScreen extends StatefulWidget {
  // inyectable para tests / DI
  final WelcomeController? controller;

  const WelcomeScreen({super.key, this.controller});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  String message = 'Cargando...';
  late final WelcomeController controller;
  late final AnimationController _animCtrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // permite inyección desde test o creación por defecto
    controller = widget.controller ??
        WelcomeController(GetWelcomeMessage(WelcomeRepositoryImpl()));

    // animación simple de fade-in
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);

    _animCtrl.forward();

    _initSplash();
  }

  Future<void> _initSplash() async {
    try {
      // Si fetch tarda > 3s, cae al timeout
      final welcome =
          await controller.fetchMessage().timeout(const Duration(seconds: 3));

      if (!mounted) return;
      setState(() => message = welcome.message);
    } on TimeoutException {
      if (!mounted) return;
      // Por si falla
      setState(() => message = '¡Bienvenido a FlutterTasks! by Robert Andrade');
    } catch (e) {
      // loggear si hace falta y mostrar mensaje amigable
      if (!mounted) return;
      setState(() => message = 'Error cargando mensaje');
    }

    // Dejar mostrar el mensaje un momento antes de navegar
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bloquear botón atrás mientras se muestra splash
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.task_alt, size: 84, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
