# flutter_tasks_md

Proyecto Flutter para gestionar tareas personales, con arquitectura limpia y uso de Hive para almacenamiento local.

## Comenzando

Este proyecto es un punto de partida para una aplicación Flutter enfocada en la gestión de tareas.

## 🛠️ Tecnologías y Funcionalidades Implementadas

- **Flutter 3.29.3** como base del proyecto para aprovechar las últimas mejoras y estabilidad.
- **Hive + Hive Flutter** para almacenamiento local rápido y sencillo, con generación de adapters automáticos.
- **Riverpod** para manejo de estado y inyección de dependencias, manteniendo el código modular y testable.
- Implementación completa para **crear, editar y eliminar tareas** con persistencia local.
- Personalización del mensaje de bienvenida en la pantalla splash.
- Navegación estructurada con rutas nombradas y manejo dinámico de argumentos.
- Diseño UI limpio y responsivo, siguiendo buenas prácticas de Material Design.
- Tests básicos para widgets clave y validación de funcionalidades.
- Commits frecuentes y descriptivos, siguiendo buenas prácticas de Git para mantener historial claro.

---

Este proyecto refleja una arquitectura limpia y escalable, lista para seguir creciendo y adaptarse a nuevas funcionalidades.

### Instalación

Entra al directorio del proyecto:
```bash
cd flutter_tasks_md
```

Instala las dependencias:
```bash
flutter pub get
```

Genera los adapters de Hive:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Estructura del proyecto
- features/home/data: Implementaciones de repositorios y fuentes de datos.
- features/home/domain: Entidades, repositorios abstractos y casos de uso.
- features/home/presentation: UI, controladores y widgets reutilizables.
- main.dart: Punto de entrada de la app con configuración de rutas y tema.


## Autor

**Robert Andrade**  
Ingeniero en Tecnologías de Información  
Desarrollador Flutter especializado en arquitectura escalable, diseño profesional y experiencia de usuario.
- [GitHub](https://github.com/rsandrade99) 
- [LinkedIn](https://www.linkedin.com/in/rsandradea99/) 
- rsandradea@gmail.com
- [Instagram](https://www.instagram.com/robert_0899/)
